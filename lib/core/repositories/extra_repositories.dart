import 'package:dio/dio.dart';

class TimetableRepository {
  final Dio _dio;
  TimetableRepository(this._dio);

  Future<Map<String, dynamic>> getWeeklyTimetable() async {
    final response = await _dio.get('/student/timetable');
    return response.data['data'];
  }

  Future<Map<String, dynamic>> getTodaySchedule() async {
    final response = await _dio.get('/student/timetable/today');
    return response.data['data'];
  }

  Future<Map<String, dynamic>> getExamSchedule() async {
    final response = await _dio.get('/student/timetable/exam-schedule');
    return response.data['data'];
  }
}

class FeesRepository {
  final Dio _dio;
  FeesRepository(this._dio);

  Future<Map<String, dynamic>> getInvoices() async {
    final response = await _dio.get('/student/fees');
    return response.data['data'];
  }

  Future<Map<String, dynamic>> getFeeSummary() async {
    final response = await _dio.get('/student/fees/summary');
    return response.data['data'];
  }

  Future<Map<String, dynamic>> getPayments() async {
    final response = await _dio.get('/student/fees/payments');
    return response.data['data'];
  }

  Future<Map<String, dynamic>> getSchoolUpiInfo() async {
    final response = await _dio.get('/student/fees/school-upi');
    return response.data['data'];
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
    final response = await _dio.get('/student/fees/upi-payment-requests');
    return response.data['data']['requests'];
  }
}
