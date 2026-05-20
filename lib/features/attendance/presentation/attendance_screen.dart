import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../domain/attendance_models.dart';
import 'attendance_provider.dart';

class AttendanceScreen extends ConsumerStatefulWidget {
  const AttendanceScreen({super.key});

  @override
  ConsumerState<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends ConsumerState<AttendanceScreen> {
  DateTime _selectedMonth = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final summaryAsync = ref.watch(attendanceSummaryProvider);
    final trendAsync = ref.watch(attendanceTrendProvider);
    final listAsync = ref.watch(attendanceListProvider((
      month: _selectedMonth.month,
      year: _selectedMonth.year,
    )));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance'),
        actions: [
          IconButton(
            icon: const Icon(Icons.file_download_outlined),
            onPressed: () {
              // TODO: Implement export
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(attendanceSummaryProvider);
          ref.invalidate(attendanceTrendProvider);
          ref.invalidate(attendanceListProvider);
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              summaryAsync.when(
                data: (summary) => _buildSummarySection(summary),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, _) => Text('Error: $err'),
              ),
              const SizedBox(height: 24),
              const Text(
                'Attendance Trend',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              trendAsync.when(
                data: (trend) => _buildTrendChart(trend),
                loading: () => const SizedBox(height: 200, child: Center(child: CircularProgressIndicator())),
                error: (err, _) => Text('Error: $err'),
              ),
              const SizedBox(height: 24),
              _buildMonthPicker(),
              const SizedBox(height: 16),
              listAsync.when(
                data: (list) => _buildAttendanceList(list),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, _) => Text('Error: $err'),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummarySection(AttendanceSummary summary) {
    final color = _getAttendanceColor(summary.percentage);
    return Column(
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 80,
                      height: 80,
                      child: CircularProgressIndicator(
                        value: summary.percentage / 100,
                        strokeWidth: 8,
                        backgroundColor: AppColors.border,
                        color: color,
                      ),
                    ),
                    Text(
                      '${summary.percentage.toStringAsFixed(0)}%',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSummaryRow('Present', '${summary.presentDays} days', AppColors.success),
                      const SizedBox(height: 8),
                      _buildSummaryRow('Absent', '${summary.absentDays} days', AppColors.danger),
                      const SizedBox(height: 8),
                      _buildSummaryRow('Working', '${summary.workingDays} days', AppColors.textSecondary),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        if (summary.daysNeededForMinimum > 0) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.warning.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.warning.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.warning_amber_rounded, color: AppColors.warning, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Need ${summary.daysNeededForMinimum} more days for 75% attendance.',
                    style: const TextStyle(color: AppColors.warning, fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildSummaryRow(String label, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 14)),
        Text(value, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 14)),
      ],
    );
  }

  Widget _buildTrendChart(List<MonthlyAttendance> trend) {
    if (trend.isEmpty) return const Center(child: Text('No data available'));

    return Container(
      height: 220,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: 100,
          barTouchData: BarTouchData(enabled: true),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index < 0 || index >= trend.length) return const SizedBox();
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      trend[index].month.substring(0, 3),
                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 10),
                    ),
                  );
                },
              ),
            ),
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          barGroups: trend.asMap().entries.map((entry) {
            return BarChartGroupData(
              x: entry.key,
              barRods: [
                BarChartRodData(
                  toY: entry.value.percentage,
                  color: _getAttendanceColor(entry.value.percentage),
                  width: 16,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildMonthPicker() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'History',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        TextButton.icon(
          onPressed: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: _selectedMonth,
              firstDate: DateTime(2020),
              lastDate: DateTime.now(),
              initialDatePickerMode: DatePickerMode.year,
            );
            if (date != null) {
              setState(() => _selectedMonth = DateTime(date.year, date.month));
            }
          },
          icon: const Icon(Icons.calendar_month),
          label: Text(DateFormat('MMMM yyyy').format(_selectedMonth)),
        ),
      ],
    );
  }

  Widget _buildAttendanceList(List<AttendanceDay> list) {
    if (list.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 40),
          child: Text('No records found for this month.'),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: list.length,
      separatorBuilder: (context, index) => const Divider(height: 1, color: AppColors.border),
      itemBuilder: (context, index) {
        final day = list[index];
        final date = day.date.isNotEmpty ? DateTime.tryParse(day.date) : null;
        if (date == null) return const SizedBox();
        final color = _getStatusColor(day.status);

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      DateFormat('dd').format(date),
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      DateFormat('E').format(date),
                      style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      day.status.toUpperCase(),
                      style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        letterSpacing: 0.5,
                      ),
                    ),
                    if (day.remarks != null)
                      Text(
                        day.remarks!,
                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                      ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: AppColors.textMuted),
            ],
          ),
        );
      },
    );
  }

  Color _getAttendanceColor(double percentage) {
    if (percentage >= 85) return AppColors.success;
    if (percentage >= 75) return AppColors.warning;
    return AppColors.danger;
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'present': return AppColors.success;
      case 'absent': return AppColors.danger;
      case 'late': return AppColors.warning;
      case 'half_day': return AppColors.info;
      case 'holiday': return AppColors.textMuted;
      default: return AppColors.border;
    }
  }
}
