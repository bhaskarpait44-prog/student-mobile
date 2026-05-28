import 'package:dio/dio.dart';

class HomeworkRepository {
  final Dio _dio;
  HomeworkRepository(this._dio);

  Future<List<dynamic>> getHomework({String? status}) async {
    final response = await _dio.get('/student/homework', queryParameters: {
      if (status != null) 'status': status,
    });
    return response.data['data']['homework'] ?? response.data['data']['items'] ?? response.data['data'] ?? [];
  }

  Future<Map<String, dynamic>> getHomeworkDetail(int id) async {
    final response = await _dio.get('/student/homework/$id');
    return response.data['data'];
  }

  Future<void> submitHomework(int id, {String? content, String? attachmentPath}) async {
    final formData = FormData();
    if (content != null) {
      formData.fields.add(MapEntry('submission_content', content));
    }
    if (attachmentPath != null) {
      formData.files.add(MapEntry(
        'attachment',
        await MultipartFile.fromFile(attachmentPath),
      ));
    }
    
    await _dio.post('/student/homework/$id/submit', data: formData);
  }
}

class NoticeRepository {
  final Dio _dio;
  NoticeRepository(this._dio);

  Future<List<dynamic>> getNotices() async {
    final response = await _dio.get('/notices/student');
    return response.data['data']['notices'] ?? response.data['data'] ?? [];
  }

  Future<void> markAsRead(int id, {String source = 'unified'}) async {
    await _dio.post('/notices/student/$id/read', queryParameters: {
      'source': source,
    });
  }

  Future<List<dynamic>> getMaterials() async {
    final response = await _dio.get('/student/materials');
    return response.data['data']['materials'] ?? response.data['data'] ?? [];
  }
}
