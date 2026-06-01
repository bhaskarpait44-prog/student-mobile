import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/api_client.dart';
import '../../../core/repositories/student_repositories.dart';
import '../../../core/storage/cache_service.dart';
import '../../dashboard/domain/dashboard_models.dart';

final achievementRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepository(ref.watch(apiClientProvider), ref.watch(cacheServiceProvider));
});

final achievementsProvider = FutureProvider.autoDispose<List<Achievement>>((ref) async {
  final data = await ref.watch(achievementRepositoryProvider).getAchievements();
  return data.map((e) => Achievement.fromJson(e)).toList();
});
