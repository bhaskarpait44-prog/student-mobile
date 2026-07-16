import 'package:dio/dio.dart';

class ApiErrorHandler {
  static String getErrorMessage(Object error) {
    if (error is DioException) {
      final response = error.response;
      if (response != null && response.data != null) {
        if (response.data is Map) {
          final data = response.data as Map;
          if (data.containsKey('message') && data['message'] != null) {
            return data['message'].toString();
          }
        } else if (response.data is String) {
          // Sometimes backend might return a raw string or HTML response (e.g. 502/504 Bad Gateway)
          final dataStr = response.data.toString();
          if (dataStr.contains('<html>') || dataStr.contains('<!DOCTYPE html>')) {
            return 'Server error (status ${response.statusCode}). Please try again later.';
          }
          return dataStr;
        }
      }

      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return 'Connection timed out. Please check your network connection and try again.';
        case DioExceptionType.connectionError:
          return 'Unable to connect to the server. Please check your internet connection or server address settings.';
        case DioExceptionType.cancel:
          return 'Request was cancelled.';
        case DioExceptionType.badResponse:
          final status = response?.statusCode;
          if (status == 401) {
            return 'Incorrect email/admission number or password.';
          } else if (status == 403) {
            return 'Access denied. You do not have permission.';
          } else if (status == 404) {
            return 'Requested service or API endpoint not found.';
          } else if (status != null && status >= 500) {
            return 'Internal server error (status $status). Please try again later.';
          }
          return 'Server returned an invalid response ($status).';
        default:
          return 'A network error occurred (${error.message ?? 'unknown error'}). Please check your connection and try again.';
      }
    }

    final errStr = error.toString();
    if (errStr.startsWith('Exception: ')) {
      return errStr.substring(11);
    }
    return errStr;
  }
}
