import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../domain/homework_models.dart';
import 'homework_provider.dart';

class HomeworkScreen extends ConsumerStatefulWidget {
  const HomeworkScreen({super.key});

  @override
  ConsumerState<HomeworkScreen> createState() => _HomeworkScreenState();
}

class _HomeworkScreenState extends ConsumerState<HomeworkScreen> {
  String? _selectedStatus;

  @override
  Widget build(BuildContext context) {
    final homeworkAsync = ref.watch(homeworkListProvider(_selectedStatus));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Homework'),
      ),
      body: Column(
        children: [
          _buildFilterChips(),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => ref.refresh(homeworkListProvider(_selectedStatus).future),
              child: homeworkAsync.when(
                data: (list) => _buildHomeworkList(list),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, _) => Center(child: Text('Error: $err')),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _statusChip('All', null),
          _statusChip('Pending', 'pending'),
          _statusChip('Submitted', 'submitted'),
          _statusChip('Overdue', 'overdue'),
        ],
      ),
    );
  }

  Widget _statusChip(String label, String? status) {
    final isSelected = _selectedStatus == status;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          if (selected) setState(() => _selectedStatus = status);
        },
      ),
    );
  }

  Widget _buildHomeworkList(List<HomeworkItem> list) {
    if (list.isEmpty) {
      return const Center(child: Text('No homework found.'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final item = list[index];
        return _HomeworkCard(item: item);
      },
    );
  }
}

class _HomeworkCard extends StatelessWidget {
  final HomeworkItem item;

  const _HomeworkCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final isOverdue = DateTime.parse(item.dueDate).isBefore(DateTime.now()) && item.submissionStatus != 'submitted';
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                item.title,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            _buildStatusBadge(),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text('${item.subjectName} • ${item.teacherName}'),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 14, color: isOverdue ? AppColors.danger : AppColors.textSecondary),
                const SizedBox(width: 4),
                Text(
                  'Due: ${item.dueDate}',
                  style: TextStyle(
                    color: isOverdue ? AppColors.danger : AppColors.textSecondary,
                    fontWeight: isOverdue ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          // TODO: Open detail screen
        },
      ),
    );
  }

  Widget _buildStatusBadge() {
    final status = item.submissionStatus?.toLowerCase() ?? 'pending';
    final color = status == 'submitted' ? AppColors.success : AppColors.warning;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }
}
