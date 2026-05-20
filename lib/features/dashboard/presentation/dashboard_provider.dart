import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/dashboard_repository.dart';
import '../domain/dashboard_models.dart';
import '../../../core/api/api_client.dart';

final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  return DashboardRepository(ref.watch(apiClientProvider));
});

final dashboardProvider = FutureProvider<DashboardData>((ref) async {
  return ref.watch(dashboardRepositoryProvider).getDashboard();
});

final upcomingEventsProvider = FutureProvider<List<UpcomingEvent>>((ref) async {
  return ref.watch(dashboardRepositoryProvider).getUpcomingEvents();
});
