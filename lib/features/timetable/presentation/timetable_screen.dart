import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../domain/timetable_models.dart';
import 'timetable_provider.dart';

class TimetableScreen extends ConsumerStatefulWidget {
  const TimetableScreen({super.key});

  @override
  ConsumerState<TimetableScreen> createState() => _TimetableScreenState();
}

class _TimetableScreenState extends ConsumerState<TimetableScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Timetable'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Weekly Schedule'),
            Tab(text: 'Exam Schedule'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildWeeklySchedule(),
          _buildExamSchedule(),
        ],
      ),
    );
  }

  Widget _buildWeeklySchedule() {
    final timetableAsync = ref.watch(weeklyTimetableProvider);

    return timetableAsync.when(
      data: (timetable) => _WeeklyTimetableWidget(timetable: timetable),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text('Error: $err')),
    );
  }

  Widget _buildExamSchedule() {
    final examScheduleAsync = ref.watch(examScheduleProvider);

    return examScheduleAsync.when(
      data: (schedule) => _ExamScheduleList(schedule: schedule),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text('Error: $err')),
    );
  }
}

class _WeeklyTimetableWidget extends StatefulWidget {
  final Map<String, List<TimetableSlot>> timetable;

  const _WeeklyTimetableWidget({required this.timetable});

  @override
  State<_WeeklyTimetableWidget> createState() => _WeeklyTimetableWidgetState();
}

class _WeeklyTimetableWidgetState extends State<_WeeklyTimetableWidget> {
  late String _selectedDay;
  final List<String> _days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];

  @override
  void initState() {
    super.initState();
    final today = DateFormat('EEEE').format(DateTime.now());
    _selectedDay = _days.contains(today) ? today : _days.first;
  }

  @override
  Widget build(BuildContext context) {
    final slots = widget.timetable[_selectedDay] ?? [];

    return Column(
      children: [
        Container(
          height: 60,
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _days.length,
            itemBuilder: (context, index) {
              final day = _days[index];
              final isSelected = day == _selectedDay;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(day.substring(0, 3)),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) setState(() => _selectedDay = day);
                  },
                ),
              );
            },
          ),
        ),
        Expanded(
          child: slots.isEmpty
              ? const Center(child: Text('No classes scheduled for this day.'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: slots.length,
                  itemBuilder: (context, index) {
                    final slot = slots[index];
                    return _TimetableSlotCard(slot: slot);
                  },
                ),
        ),
      ],
    );
  }
}

class _TimetableSlotCard extends StatelessWidget {
  final TimetableSlot slot;

  const _TimetableSlotCard({required this.slot});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  '${slot.periodNumber}',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    slot.subjectName,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    slot.teacherName,
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${slot.startTime} - ${slot.endTime}',
                  style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
                ),
                if (slot.roomNumber != null)
                  Text(
                    'Room: ${slot.roomNumber}',
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ExamScheduleList extends StatelessWidget {
  final List<ExamScheduleItem> schedule;

  const _ExamScheduleList({required this.schedule});

  @override
  Widget build(BuildContext context) {
    if (schedule.isEmpty) {
      return const Center(child: Text('No upcoming exams scheduled.'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: schedule.length,
      itemBuilder: (context, index) {
        final item = schedule[index];
        final date = DateTime.parse(item.date);
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppColors.info.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.edit_document, color: AppColors.info),
            ),
            title: Text(item.subjectName, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(DateFormat('dd MMM yyyy').format(date)),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('${item.startTime} - ${item.endTime}', style: const TextStyle(fontWeight: FontWeight.w500)),
                if (item.roomNumber != null)
                  Text('Room: ${item.roomNumber}', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              ],
            ),
          ),
        );
      },
    );
  }
}
