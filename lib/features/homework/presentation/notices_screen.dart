import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../domain/homework_models.dart';
import 'homework_provider.dart';

class NoticesScreen extends ConsumerWidget {
  const NoticesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final noticesAsync = ref.watch(noticesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notices'),
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(noticesProvider.future),
        child: noticesAsync.when(
          data: (notices) => _buildNoticesList(context, notices),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Center(child: Text('Error: $err')),
        ),
      ),
    );
  }

  Widget _buildNoticesList(BuildContext context, List<Notice> notices) {
    if (notices.isEmpty) {
      return const Center(child: Text('No notices found.'));
    }

    // Separate pinned and unpinned
    final pinned = notices.where((n) => n.isPinned).toList();
    final others = notices.where((n) => !n.isPinned).toList();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (pinned.isNotEmpty) ...[
          const Row(
            children: [
              Icon(Icons.push_pin, size: 16, color: AppColors.primary),
              SizedBox(width: 8),
              Text('Pinned Notices', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            ],
          ),
          const SizedBox(height: 12),
          ...pinned.map((n) => _NoticeCard(notice: n)),
          const SizedBox(height: 24),
        ],
        if (others.isNotEmpty) ...[
          const Text('Recent Notices', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 12),
          ...others.map((n) => _NoticeCard(notice: n)),
        ],
      ],
    );
  }
}

class _NoticeCard extends StatelessWidget {
  final Notice notice;

  const _NoticeCard({required this.notice});

  @override
  Widget build(BuildContext context) {
    final date = DateTime.tryParse(notice.publishedAt);
    final color = _getTypeColor(notice.noticeType);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          // TODO: Open detail screen
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            border: !notice.isRead 
              ? Border(left: BorderSide(color: color, width: 4))
              : null,
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      notice.noticeType.toUpperCase(),
                      style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text(
                    date != null ? DateFormat('dd MMM').format(date) : 'N/A',
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                notice.title,
                style: TextStyle(
                  fontWeight: !notice.isRead ? FontWeight.bold : FontWeight.w500,
                  fontSize: 16,
                  color: AppColors.textPrimary,
                ),
              ),
              if (notice.content != null) ...[
                const SizedBox(height: 8),
                Text(
                  notice.content!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Color _getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'academic': return AppColors.primary;
      case 'event': return AppColors.info;
      case 'holiday': return AppColors.success;
      case 'urgent': return AppColors.danger;
      default: return AppColors.textSecondary;
    }
  }
}
