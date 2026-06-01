import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/dashboard_repository.dart';
import '../domain/dashboard_models.dart';
import '../../../core/api/api_client.dart';
import '../../../core/storage/cache_service.dart';

final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  return DashboardRepository(ref.watch(apiClientProvider), ref.watch(cacheServiceProvider));
});

final dashboardProvider = FutureProvider.autoDispose<DashboardData>((ref) async {
  return ref.watch(dashboardRepositoryProvider).getDashboard();
});

final upcomingEventsProvider = FutureProvider.autoDispose<List<UpcomingEvent>>((ref) async {
  return ref.watch(dashboardRepositoryProvider).getUpcomingEvents();
});
