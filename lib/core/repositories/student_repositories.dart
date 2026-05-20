import 'package:dio/dio.dart';

class AttendanceRepository {
  final Dio _dio;

  AttendanceRepository(this._dio);

  Future<Map<String, dynamic>> getAttendanceSummary() async {
    final response = await _dio.get('/student/attendance/summary');
    return response.data['data'];
  }

  Future<List<dynamic>> getAttendanceList({int? month, int? year}) async {
    final response = await _dio.get('/student/attendance', queryParameters: {
      if (month != null) 'month': month,
      if (year != null) 'year': year,
    });
    return response.data['data'];
  }

  Future<List<dynamic>> getAttendanceTrend() async {
    final response = await _dio.get('/student/attendance/trend');
    return response.data['data']['monthly'];
  }
}

class ResultsRepository {
  final Dio _dio;

  ResultsRepository(this._dio);

  Future<List<dynamic>> getResults() async {
    final response = await _dio.get('/student/results');
    return response.data['data'];
  }

  Future<Map<String, dynamic>> getResultDetail(int examId) async {
    final response = await _dio.get('/student/results/$examId');
    return response.data['data'];
  }
}
