import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/api_client.dart';
import '../../../core/repositories/student_repositories.dart';
import '../domain/results_models.dart';

final resultsRepositoryProvider = Provider<ResultsRepository>((ref) {
  return ResultsRepository(ref.watch(apiClientProvider));
});

final examResultsProvider = FutureProvider<List<ExamResult>>((ref) async {
  final data = await ref.watch(resultsRepositoryProvider).getResults();
  return data.map((e) => ExamResult.fromJson(e)).toList();
});

final examResultDetailProvider = FutureProvider.family<ExamResultDetail, int>((ref, examId) async {
  final data = await ref.watch(resultsRepositoryProvider).getResultDetail(examId);
  return ExamResultDetail.fromJson(data);
});
