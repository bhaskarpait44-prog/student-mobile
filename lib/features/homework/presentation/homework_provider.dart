import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/api/api_client.dart';
import '../../core/repositories/homework_notice_repositories.dart';
import '../domain/homework_models.dart';

final homeworkRepositoryProvider = Provider<HomeworkRepository>((ref) {
  return HomeworkRepository(ref.watch(apiClientProvider));
});

final homeworkListProvider = FutureProvider.family<List<HomeworkItem>, String?>((ref, status) async {
  final data = await ref.watch(homeworkRepositoryProvider).getHomework(status: status);
  return data.map((e) => HomeworkItem.fromJson(e)).toList();
});

final homeworkDetailProvider = FutureProvider.family<HomeworkItem, int>((ref, id) async {
  final data = await ref.watch(homeworkRepositoryProvider).getHomeworkDetail(id);
  return HomeworkItem.fromJson(data);
});

final noticeRepositoryProvider = Provider<NoticeRepository>((ref) {
  return NoticeRepository(ref.watch(apiClientProvider));
});

final noticesProvider = FutureProvider<List<Notice>>((ref) async {
  final data = await ref.watch(noticeRepositoryProvider).getNotices();
  return data.map((e) => Notice.fromJson(e)).toList();
});
