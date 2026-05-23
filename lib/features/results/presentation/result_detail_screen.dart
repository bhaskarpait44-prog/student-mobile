import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/screens/pdf_viewer_screen.dart';
import '../domain/results_models.dart';
import 'results_provider.dart';

class ResultDetailScreen extends ConsumerWidget {
  final int examId;

  const ResultDetailScreen({super.key, required this.examId});

  Future<void> _exportResult(BuildContext context, WidgetRef ref) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      final bytes = await ref.read(resultsRepositoryProvider).downloadResultPdf(examId);
      
      if (context.mounted) {
        Navigator.pop(context); // Pop loading
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PdfViewerScreen(
              title: 'Report Card',
              pdfBytes: bytes,
            ),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context); // Pop loading
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to export PDF: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(examResultDetailProvider(examId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Result Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf_outlined),
            onPressed: () => _exportResult(context, ref),
          ),
        ],
      ),
      body: detailAsync.when(
        data: (detail) => _buildDetailView(context, detail),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildDetailView(BuildContext context, ExamResultDetail detail) {
    if (detail.isWithheld) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock_outline, size: 80, color: AppColors.danger),
              const SizedBox(height: 24),
              const Text(
                'Result Withheld',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const Text(
                'Please clear your outstanding dues to view detailed subject marks and download the report card.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeaderCard(detail),
          const SizedBox(height: 24),
          const Text(
            'Subject Analysis',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildSubjectChart(detail.subjects),
          const SizedBox(height: 24),
          const Text(
            'Mark Sheet',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _buildMarkSheet(detail.subjects),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildHeaderCard(ExamResultDetail detail) {
    return Card(
      color: AppColors.primary,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text(
              detail.examName,
              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              detail.examType,
              style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 13),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildHeaderStat('Obtained', '${detail.obtainedMarks.toInt()}/${detail.totalMarks.toInt()}'),
                _buildHeaderStat('Percentage', '${detail.percentage}%'),
                _buildHeaderStat('Grade', detail.grade),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 11),
        ),
      ],
    );
  }

  Widget _buildSubjectChart(List<SubjectResult> subjects) {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: BarChart(
        BarChartData(
          maxY: 100,
          barGroups: subjects.asMap().entries.map((entry) {
            final percent = (entry.value.obtainedMarks / entry.value.maxMarks) * 100;
            return BarChartGroupData(
              x: entry.key,
              barRods: [
                BarChartRodData(
                  toY: percent,
                  color: entry.value.isPassed ? AppColors.primary : AppColors.danger,
                  width: 20,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            );
          }).toList(),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index < 0 || index >= subjects.length) return const SizedBox();
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      subjects[index].subjectName.substring(0, 3),
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
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
        ),
      ),
    );
  }

  Widget _buildMarkSheet(List<SubjectResult> subjects) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          _buildMarkHeader(),
          const Divider(height: 1),
          ...subjects.map((s) => _buildMarkRow(s)),
        ],
      ),
    );
  }

  Widget _buildMarkHeader() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(flex: 3, child: Text('Subject', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13))),
          Expanded(child: Text('Max', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13), textAlign: TextAlign.center)),
          Expanded(child: Text('Obt.', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13), textAlign: TextAlign.center)),
          Expanded(child: Text('Grade', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13), textAlign: TextAlign.center)),
        ],
      ),
    );
  }

  Widget _buildMarkRow(SubjectResult subject) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              subject.subjectName,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(
              '${subject.maxMarks.toInt()}',
              style: const TextStyle(fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Text(
              '${subject.obtainedMarks.toInt()}',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: subject.isPassed ? AppColors.textPrimary : AppColors.danger,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Text(
              subject.grade,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
