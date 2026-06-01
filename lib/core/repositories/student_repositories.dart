import 'dart:typed_data';
import 'package:dio/dio.dart';
import '../storage/cache_service.dart';

class AttendanceRepository {
  final Dio _dio;
  final CacheService _cache;

  AttendanceRepository(this._dio, this._cache);

  Future<Map<String, dynamic>> getAttendanceSummary() async {
    const cacheKey = 'attendance_summary';
    try {
      final response = await _dio.get('/student/attendance/summary');
      final data = response.data['data'] ?? {};
      await _cache.set(cacheKey, data);
      return data;
    } catch (e) {
      final cachedData = await _cache.get(cacheKey);
      if (cachedData != null) return cachedData;
      rethrow;
    }
  }

  Future<List<dynamic>> getAttendanceList({int? month, int? year}) async {
    final cacheKey = 'attendance_list_${month}_$year';
    try {
      final response = await _dio.get('/student/attendance', queryParameters: {
        if (month != null) 'month': month,
        if (year != null) 'year': year,
      });
      final data = response.data['data']['records'] ?? [];
      await _cache.set(cacheKey, data);
      return data;
    } catch (e) {
      final cachedData = await _cache.get(cacheKey);
      if (cachedData != null) return cachedData;
      rethrow;
    }
  }

  Future<List<dynamic>> getAttendanceTrend() async {
    const cacheKey = 'attendance_trend';
    try {
      final response = await _dio.get('/student/attendance/trend');
      final data = response.data['data']['trend'] ?? [];
      await _cache.set(cacheKey, data);
      return data;
    } catch (e) {
      final cachedData = await _cache.get(cacheKey);
      if (cachedData != null) return cachedData;
      rethrow;
    }
  }

  Future<Uint8List> downloadAttendancePdf({String? fromDate, String? toDate}) async {
    final response = await _dio.get(
      '/student/attendance/export',
      queryParameters: {
        if (fromDate != null) 'from_date': fromDate,
        if (toDate != null) 'to_date': toDate,
      },
      options: Options(responseType: ResponseType.bytes),
    );
    return Uint8List.fromList(response.data);
  }
}

class ResultsRepository {
  final Dio _dio;
  final CacheService _cache;

  ResultsRepository(this._dio, this._cache);

  Future<List<dynamic>> getResults() async {
    const cacheKey = 'results_list';
    try {
      final response = await _dio.get('/student/results');
      final data = response.data['data']['exams'] ?? [];
      await _cache.set(cacheKey, data);
      return data;
    } catch (e) {
      final cachedData = await _cache.get(cacheKey);
      if (cachedData != null) return cachedData;
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getResultDetail(int examId) async {
    final cacheKey = 'result_detail_$examId';
    try {
      final response = await _dio.get('/student/results/$examId');
      final data = response.data['data'] ?? {};
      await _cache.set(cacheKey, data);
      return data;
    } catch (e) {
      final cachedData = await _cache.get(cacheKey);
      if (cachedData != null) return cachedData;
      rethrow;
    }
  }

  Future<Uint8List> downloadResultPdf(int examId) async {
    final response = await _dio.get(
      '/student/results/export/$examId',
      options: Options(responseType: ResponseType.bytes),
    );
    return Uint8List.fromList(response.data);
  }
}

class ProfileRepository {
  final Dio _dio;
  final CacheService _cache;

  ProfileRepository(this._dio, this._cache);

  Future<Map<String, dynamic>> getProfile() async {
    const cacheKey = 'profile_data';
    try {
      final response = await _dio.get('/student/profile');
      final data = response.data['data'] ?? {};
      await _cache.set(cacheKey, data);
      return data;
    } catch (e) {
      final cachedData = await _cache.get(cacheKey);
      if (cachedData != null) return cachedData;
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getAcademicHistory() async {
    const cacheKey = 'academic_history';
    try {
      final response = await _dio.get('/student/history');
      final data = response.data['data'] ?? {};
      await _cache.set(cacheKey, data);
      return data;
    } catch (e) {
      final cachedData = await _cache.get(cacheKey);
      if (cachedData != null) return cachedData;
      rethrow;
    }
  }

  Future<List<dynamic>> getAchievements() async {
    const cacheKey = 'achievements_list';
    try {
      final response = await _dio.get('/student/achievements');
      final data = response.data['data']['achievements'] ?? [];
      await _cache.set(cacheKey, data);
      return data;
    } catch (e) {
      final cachedData = await _cache.get(cacheKey);
      if (cachedData != null) return cachedData;
      rethrow;
    }
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    await _dio.post('/student/profile/change-password', data: {
      'current_password': currentPassword,
      'new_password': newPassword,
    });
  }
}
