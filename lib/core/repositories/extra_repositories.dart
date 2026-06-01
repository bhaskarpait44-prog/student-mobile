import 'package:dio/dio.dart';
import '../storage/cache_service.dart';

class TimetableRepository {
  final Dio _dio;
  final CacheService _cache;
  TimetableRepository(this._dio, this._cache);

  Future<Map<String, dynamic>> getWeeklyTimetable() async {
    const cacheKey = 'timetable_weekly';
    try {
      final response = await _dio.get('/student/timetable');
      final data = response.data['data'] ?? {};
      await _cache.set(cacheKey, data);
      return data;
    } catch (e) {
      final cachedData = await _cache.get(cacheKey);
      if (cachedData != null) return cachedData;
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getTodaySchedule() async {
    const cacheKey = 'timetable_today';
    try {
      final response = await _dio.get('/student/timetable/today');
      final data = response.data['data'] ?? {};
      await _cache.set(cacheKey, data);
      return data;
    } catch (e) {
      final cachedData = await _cache.get(cacheKey);
      if (cachedData != null) return cachedData;
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getExamSchedule() async {
    const cacheKey = 'timetable_exam';
    try {
      final response = await _dio.get('/student/timetable/exam-schedule');
      final data = response.data['data'] ?? {};
      await _cache.set(cacheKey, data);
      return data;
    } catch (e) {
      final cachedData = await _cache.get(cacheKey);
      if (cachedData != null) return cachedData;
      rethrow;
    }
  }
}

class FeesRepository {
  final Dio _dio;
  final CacheService _cache;
  FeesRepository(this._dio, this._cache);

  Future<Map<String, dynamic>> getInvoices() async {
    const cacheKey = 'fees_invoices';
    try {
      final response = await _dio.get('/student/fees');
      final data = response.data['data'] ?? {};
      await _cache.set(cacheKey, data);
      return data;
    } catch (e) {
      final cachedData = await _cache.get(cacheKey);
      if (cachedData != null) return cachedData;
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getFeeSummary() async {
    const cacheKey = 'fees_summary';
    try {
      final response = await _dio.get('/student/fees/summary');
      final data = response.data['data'] ?? {};
      await _cache.set(cacheKey, data);
      return data;
    } catch (e) {
      final cachedData = await _cache.get(cacheKey);
      if (cachedData != null) return cachedData;
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getPayments() async {
    const cacheKey = 'fees_payments';
    try {
      final response = await _dio.get('/student/fees/payments');
      final data = response.data['data'] ?? {};
      await _cache.set(cacheKey, data);
      return data;
    } catch (e) {
      final cachedData = await _cache.get(cacheKey);
      if (cachedData != null) return cachedData;
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getSchoolUpiInfo() async {
    const cacheKey = 'fees_upi_info';
    try {
      final response = await _dio.get('/student/fees/school-upi');
      final data = response.data['data'] ?? {};
      await _cache.set(cacheKey, data);
      return data;
    } catch (e) {
      final cachedData = await _cache.get(cacheKey);
      if (cachedData != null) return cachedData;
      rethrow;
    }
  }

  Future<void> submitUpiPaymentRequest({
    required int invoiceId,
    required double amount,
    required String upiTransactionId,
    String? note,
  }) async {
    await _dio.post('/student/fees/upi-payment-request', data: {
      'invoice_id': invoiceId,
      'amount': amount,
      'upi_transaction_id': upiTransactionId,
      'student_note': note,
    });
  }

  Future<List<dynamic>> getMyUpiRequests() async {
    const cacheKey = 'fees_upi_requests';
    try {
      final response = await _dio.get('/student/fees/upi-payment-requests');
      final data = response.data['data']['requests'] ?? [];
      await _cache.set(cacheKey, data);
      return data;
    } catch (e) {
      final cachedData = await _cache.get(cacheKey);
      if (cachedData != null) return cachedData;
      rethrow;
    }
  }
}
