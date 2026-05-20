import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../domain/results_models.dart';
import 'results_provider.dart';

class ResultsScreen extends ConsumerWidget {
  const ResultsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resultsAsync = ref.watch(examResultsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Exam Results'),
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(examResultsProvider.future),
        child: resultsAsync.when(
          data: (results) => _buildResultsList(context, results),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Center(child: Text('Error: $err')),
        ),
      ),
    );
  }

  Widget _buildResultsList(BuildContext context, List<ExamResult> results) {
    if (results.isEmpty) {
      return const Center(child: Text('No results available yet.'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: results.length,
      itemBuilder: (context, index) {
        final result = results[index];
        return _buildResultCard(context, result);
      },
    );
  }

  Widget _buildResultCard(BuildContext context, ExamResult result) {
    final gradeColor = _getGradeColor(result.grade);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () => context.push('/results/${result.examId}'),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          result.examName,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Text(
                          result.examType,
                          style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  _buildResultStatusBadge(result.resultStatus),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(height: 1),
              const SizedBox(height: 16),
              Row(
                children: [
                  _buildStatItem('Percentage', '${result.percentage}%', AppColors.primary),
                  _buildStatItem('Grade', result.grade, gradeColor),
                  if (result.isWithheld)
                    _buildStatItem('Status', 'WITHHELD', AppColors.danger),
                ],
              ),
              if (result.isWithheld) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.danger.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline, color: AppColors.danger, size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Dues of ₹${result.totalPending} must be cleared to view details.',
                          style: const TextStyle(color: AppColors.danger, fontSize: 11),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildResultStatusBadge(String status) {
    final color = status.toLowerCase() == 'pass' ? AppColors.success : AppColors.danger;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }

  Color _getGradeColor(String grade) {
    if (grade.startsWith('A')) return AppColors.success;
    if (grade.startsWith('B')) return const Color(0xFF0D9488);
    if (grade.startsWith('C')) return AppColors.info;
    if (grade.startsWith('D')) return AppColors.warning;
    return AppColors.danger;
  }
}
