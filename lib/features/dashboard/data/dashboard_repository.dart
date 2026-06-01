import 'package:dio/dio.dart';
import '../domain/dashboard_models.dart';
import '../../../core/storage/cache_service.dart';

class DashboardRepository {
  final Dio _dio;
  final CacheService _cache;

  DashboardRepository(this._dio, this._cache);

  Future<DashboardData> getDashboard() async {
    const cacheKey = 'dashboard_data';
    try {
      final response = await _dio.get('/student/dashboard');
      if (response.data['success'] == true) {
        final data = response.data['data'];
        await _cache.set(cacheKey, data);
        return DashboardData.fromJson(data);
      } else {
        throw Exception(response.data['message'] ?? 'Failed to load dashboard');
      }
    } catch (e) {
      final cachedData = await _cache.get(cacheKey);
      if (cachedData != null) return DashboardData.fromJson(cachedData);
      rethrow;
    }
  }

  Future<List<SchedulePeriod>> getTodaySchedule() async {
    const cacheKey = 'today_schedule';
    try {
      final response = await _dio.get('/student/dashboard/today-schedule');
      if (response.data['success'] == true) {
        final data = response.data['data'];
        await _cache.set(cacheKey, data);
        return (data as List).map((e) => SchedulePeriod.fromJson(e)).toList();
      } else {
        throw Exception(response.data['message'] ?? 'Failed to load schedule');
      }
    } catch (e) {
      final cachedData = await _cache.get(cacheKey);
      if (cachedData != null) return (cachedData as List).map((e) => SchedulePeriod.fromJson(e)).toList();
      rethrow;
    }
  }

  Future<List<UpcomingEvent>> getUpcomingEvents() async {
    const cacheKey = 'upcoming_events';
    try {
      final response = await _dio.get('/student/dashboard/upcoming-events');
      if (response.data['success'] == true) {
        final data = response.data['data'];
        await _cache.set(cacheKey, data);
        return (data as List).map((e) => UpcomingEvent.fromJson(e)).toList();
      } else {
        throw Exception(response.data['message'] ?? 'Failed to load events');
      }
    } catch (e) {
      final cachedData = await _cache.get(cacheKey);
      if (cachedData != null) return (cachedData as List).map((e) => UpcomingEvent.fromJson(e)).toList();
      rethrow;
    }
  }
}
