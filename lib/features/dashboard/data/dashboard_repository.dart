import 'package:dio/dio.dart';
import '../domain/dashboard_models.dart';

class DashboardRepository {
  final Dio _dio;

  DashboardRepository(this._dio);

  Future<DashboardData> getDashboard() async {
    final response = await _dio.get('/student/dashboard');
    if (response.data['success'] == true) {
      return DashboardData.fromJson(response.data['data']);
    } else {
      throw Exception(response.data['message'] ?? 'Failed to load dashboard');
    }
  }

  Future<List<SchedulePeriod>> getTodaySchedule() async {
    final response = await _dio.get('/student/dashboard/today-schedule');
    if (response.data['success'] == true) {
      return (response.data['data'] as List)
          .map((e) => SchedulePeriod.fromJson(e))
          .toList();
    } else {
      throw Exception(response.data['message'] ?? 'Failed to load schedule');
    }
  }

  Future<List<UpcomingEvent>> getUpcomingEvents() async {
    final response = await _dio.get('/student/dashboard/upcoming-events');
    if (response.data['success'] == true) {
      return (response.data['data'] as List)
          .map((e) => UpcomingEvent.fromJson(e))
          .toList();
    } else {
      throw Exception(response.data['message'] ?? 'Failed to load events');
    }
  }
}
