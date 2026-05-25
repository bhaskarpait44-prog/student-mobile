import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../homework/presentation/homework_provider.dart';
import 'dashboard_provider.dart';
import 'widgets/stat_card.dart';
import 'widgets/schedule_item.dart';
import 'widgets/attendance_bubble_strip.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsync = ref.watch(dashboardProvider);

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(dashboardProvider.future),
        child: dashboardAsync.when(
          data: (data) => _buildDashboard(context, ref, data),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text('Error: $err')),
        ),
      ),
    );
  }

  Widget _buildDashboard(BuildContext context, WidgetRef ref, dynamic data) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(context, ref, data),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (data.birthdayBanner != null) _buildBirthdayBanner(data.birthdayBanner),
                if (data.homeworkDueToday.isNotEmpty) _buildHomeworkAlert(data.homeworkDueToday),
                const SizedBox(height: 20),
                _buildStatsGrid(context, data),
                const SizedBox(height: 24),
                const Text(
                  'Today\'s Schedule',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                ...data.todaySchedule.map((p) => ScheduleItem(period: p)),
                const SizedBox(height: 24),
                AttendanceBubbleStrip(recentAttendance: data.recentAttendance),
                const SizedBox(height: 100), // Space for bottom nav
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref, dynamic data) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 32),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.primaryDark],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${_getGreeting()},',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    data.student.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  _buildNotificationIcon(context, ref),
                  const SizedBox(width: 12),
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.white24,
                    backgroundImage: data.student.photoPath != null 
                      ? NetworkImage(data.student.photoPath!) 
                      : null,
                    child: data.student.photoPath == null 
                      ? const Icon(Icons.person, color: Colors.white, size: 32) 
                      : null,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              _buildHeaderInfoChip(Icons.class_, 'Class ${data.student.className}'),
              const SizedBox(width: 12),
              _buildHeaderInfoChip(Icons.calendar_today, data.student.sessionName),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationIcon(BuildContext context, WidgetRef ref) {
    final noticesAsync = ref.watch(noticesProvider);
    final unreadCount = noticesAsync.when(
      data: (notices) => notices.where((n) => !n.isRead).length,
      loading: () => 0,
      error: (_, __) => 0,
    );

    return Stack(
      clipBehavior: Clip.none,
      children: [
        IconButton(
          onPressed: () => context.push('/notices'),
          icon: const Icon(Icons.notifications_outlined, color: Colors.white, size: 28),
        ),
        if (unreadCount > 0)
          Positioned(
            right: 8,
            top: 8,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: AppColors.danger,
                shape: BoxShape.circle,
              ),
              constraints: const BoxConstraints(
                minWidth: 16,
                minHeight: 16,
              ),
              child: Text(
                '$unreadCount',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildHeaderInfoChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white24,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 14),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(BuildContext context, dynamic data) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.4,
      children: [
        StatCard(
          title: 'Attendance',
          value: '${data.attendance.percentage}%',
          subtitle: '${data.attendance.presentDays}/${data.attendance.workingDays} Days',
          icon: Icons.calendar_month,
          iconColor: _getAttendanceColor(data.attendance.percentage),
          extra: CircularProgressIndicator(
            value: data.attendance.percentage / 100,
            strokeWidth: 3,
            backgroundColor: Colors.grey[200],
            color: _getAttendanceColor(data.attendance.percentage),
          ),
          onTap: () => context.go('/attendance'),
        ),
        StatCard(
          title: 'Latest Result',
          value: data.latestResult?.grade ?? 'N/A',
          subtitle: data.latestResult?.examName ?? 'No exams yet',
          icon: Icons.assessment,
          iconColor: AppColors.info,
          extra: data.latestResult?.isWithheld == true 
            ? _buildBadge('WITHHELD', AppColors.danger) 
            : null,
          onTap: () => context.go('/results'),
        ),
        StatCard(
          title: 'Fee Status',
          value: '₹${data.fee.totalPending.toStringAsFixed(0)}',
          subtitle: data.fee.totalPending > 0 ? 'Next: ${data.fee.nextDueDate}' : 'No dues',
          icon: Icons.account_balance_wallet,
          iconColor: data.fee.totalPending > 0 ? AppColors.danger : AppColors.success,
          onTap: () => context.push('/fees'),
        ),
        StatCard(
          title: 'Classes Today',
          value: '${data.classesToday.total}',
          subtitle: data.classesToday.next != null ? 'Next: ${data.classesToday.next}' : 'All done',
          icon: Icons.schedule,
          iconColor: AppColors.primary,
          onTap: () => context.go('/timetable'),
        ),
      ],
    );
  }

  Widget _buildBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 8,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Color _getAttendanceColor(double percentage) {
    if (percentage >= 85) return AppColors.success;
    if (percentage >= 75) return AppColors.warning;
    return AppColors.danger;
  }

  Widget _buildBirthdayBanner(dynamic banner) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFEC4899), Color(0xFF8B5CF6)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.cake, color: Colors.white, size: 32),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              banner.message,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHomeworkAlert(List<dynamic> homework) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.danger.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.danger.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.assignment_late, color: AppColors.danger, size: 20),
              SizedBox(width: 8),
              Text(
                'Homework Due Today',
                style: TextStyle(
                  color: AppColors.danger,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...homework.map((h) => Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              '• ${h.subjectName}: ${h.title}',
              style: const TextStyle(fontSize: 13, color: AppColors.textPrimary),
            ),
          )),
        ],
      ),
    );
  }
}
