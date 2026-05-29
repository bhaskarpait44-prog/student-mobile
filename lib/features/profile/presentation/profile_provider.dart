import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/api_client.dart';
import '../../../core/repositories/student_repositories.dart';

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepository(ref.watch(apiClientProvider));
});

final profileProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final repository = ref.watch(profileRepositoryProvider);
  return await repository.getProfile();
});
