import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/theme/app_colors.dart';
import '../domain/history_models.dart';
import 'history_provider.dart';

class AcademicHistoryScreen extends ConsumerWidget {
  const AcademicHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(academicHistoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Academic History'),
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(academicHistoryProvider.future),
        child: historyAsync.when(
          data: (data) => _buildHistoryView(context, data),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Center(child: Text('Error: $err')),
        ),
      ),
    );
  }

  Widget _buildHistoryView(BuildContext context, AcademicHistoryData data) {
    if (data.history.isEmpty) {
      return const Center(child: Text('No academic history found.'));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Performance Trend',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildPerformanceChart(data.performanceTrend),
          const SizedBox(height: 32),
          const Text(
            'Academic Journey',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildTimeline(data.history),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildPerformanceChart(List<PerformanceTrend> trend) {
    if (trend.isEmpty) return const SizedBox();

    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index < 0 || index >= trend.length) return const SizedBox();
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      trend[index].sessionName.split('-').last,
                      style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
                    ),
                  );
                },
              ),
            ),
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: trend.asMap().entries.map((entry) {
                return FlSpot(entry.key.toDouble(), entry.value.percentage);
              }).toList(),
              isCurved: true,
              color: AppColors.primary,
              barWidth: 4,
              dotData: const FlDotData(show: true),
              belowBarData: BarAreaData(
                show: true,
                color: AppColors.primary.withValues(alpha: 0.1),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeline(List<HistoryRecord> history) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: history.length,
      itemBuilder: (context, index) {
        final record = history[index];
        final isLast = index == history.length - 1;

        return IntrinsicHeight(
          child: Row(
            children: [
              Column(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  if (!isLast)
                    Expanded(
                      child: Container(
                        width: 2,
                        color: AppColors.primary.withValues(alpha: 0.3),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                record.sessionName,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              _buildStatusBadge(record.isPromoted),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Class ${record.className} • Section ${record.sectionName}',
                            style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildMiniStat('Percentage', '${record.percentage ?? 0}%'),
                              _buildMiniStat('Grade', record.grade ?? 'N/A'),
                              _buildMiniStat('Attendance', '${record.attendancePercentage}%'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMiniStat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 10)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
      ],
    );
  }

  Widget _buildStatusBadge(bool promoted) {
    final color = promoted ? AppColors.success : AppColors.danger;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        promoted ? 'PROMOTED' : 'FAILED',
        style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }
}
