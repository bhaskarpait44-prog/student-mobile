import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/api_client.dart';
import '../../../core/repositories/student_repositories.dart';
import '../domain/history_models.dart';

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepository(ref.watch(apiClientProvider));
});

final academicHistoryProvider = FutureProvider.autoDispose<AcademicHistoryData>((ref) async {
  final data = await ref.watch(profileRepositoryProvider).getAcademicHistory();
  return AcademicHistoryData.fromJson(data);
});
