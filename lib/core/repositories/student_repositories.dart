import 'dart:typed_data';
import 'package:dio/dio.dart';

class AttendanceRepository {
  final Dio _dio;

  AttendanceRepository(this._dio);

  Future<Map<String, dynamic>> getAttendanceSummary() async {
    final response = await _dio.get('/student/attendance/summary');
    return response.data['data'] ?? {};
  }

  Future<List<dynamic>> getAttendanceList({int? month, int? year}) async {
    final response = await _dio.get('/student/attendance', queryParameters: {
      if (month != null) 'month': month,
      if (year != null) 'year': year,
    });
    return response.data['data']['records'] ?? [];
  }

  Future<List<dynamic>> getAttendanceTrend() async {
    final response = await _dio.get('/student/attendance/trend');
    return response.data['data']['trend'] ?? [];
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

  ResultsRepository(this._dio);

  Future<List<dynamic>> getResults() async {
    final response = await _dio.get('/student/results');
    return response.data['data']['exams'] ?? [];
  }

  Future<Map<String, dynamic>> getResultDetail(int examId) async {
    final response = await _dio.get('/student/results/$examId');
    return response.data['data'] ?? {};
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

  ProfileRepository(this._dio);

  Future<Map<String, dynamic>> getProfile() async {
    final response = await _dio.get('/student/profile');
    return response.data['data'] ?? {};
  }

  Future<Map<String, dynamic>> getAcademicHistory() async {
    final response = await _dio.get('/student/history');
    return response.data['data'] ?? {};
  }

  Future<List<dynamic>> getAchievements() async {
    final response = await _dio.get('/student/achievements');
    return response.data['data']['achievements'] ?? [];
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
