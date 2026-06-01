import 'package:dio/dio.dart';
import '../storage/cache_service.dart';

class HomeworkRepository {
  final Dio _dio;
  final CacheService _cache;
  HomeworkRepository(this._dio, this._cache);

  Future<List<dynamic>> getHomework({String? status}) async {
    final cacheKey = 'homework_list_$status';
    try {
      final response = await _dio.get('/student/homework', queryParameters: {
        if (status != null) 'status': status,
      });
      final data = response.data['data']['homework'] ?? response.data['data']['items'] ?? response.data['data'] ?? [];
      await _cache.set(cacheKey, data);
      return data;
    } catch (e) {
      final cachedData = await _cache.get(cacheKey);
      if (cachedData != null) return cachedData;
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getHomeworkDetail(int id) async {
    final cacheKey = 'homework_detail_$id';
    try {
      final response = await _dio.get('/student/homework/$id');
      final data = response.data['data'];
      await _cache.set(cacheKey, data);
      return data;
    } catch (e) {
      final cachedData = await _cache.get(cacheKey);
      if (cachedData != null) return cachedData;
      rethrow;
    }
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
  final CacheService _cache;
  NoticeRepository(this._dio, this._cache);

  Future<List<dynamic>> getNotices() async {
    const cacheKey = 'notices_list';
    try {
      final response = await _dio.get('/notices/student');
      final data = response.data['data']['notices'] ?? response.data['data'] ?? [];
      await _cache.set(cacheKey, data);
      return data;
    } catch (e) {
      final cachedData = await _cache.get(cacheKey);
      if (cachedData != null) return cachedData;
      rethrow;
    }
  }

  Future<void> markAsRead(int id, {String source = 'unified'}) async {
    await _dio.post('/notices/student/$id/read', queryParameters: {
      'source': source,
    });
  }

  Future<List<dynamic>> getMaterials() async {
    const cacheKey = 'materials_list';
    try {
      final response = await _dio.get('/student/materials');
      final data = response.data['data']['materials'] ?? response.data['data'] ?? [];
      await _cache.set(cacheKey, data);
      return data;
    } catch (e) {
      final cachedData = await _cache.get(cacheKey);
      if (cachedData != null) return cachedData;
      rethrow;
    }
  }
}
