import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/api_client.dart';
import '../../../core/repositories/homework_notice_repositories.dart';
import '../domain/homework_models.dart';

final homeworkRepositoryProvider = Provider<HomeworkRepository>((ref) {
  return HomeworkRepository(ref.watch(apiClientProvider));
});

final homeworkListProvider = FutureProvider.autoDispose.family<List<HomeworkItem>, String?>((ref, status) async {
  final data = await ref.watch(homeworkRepositoryProvider).getHomework(status: status);
  return data.map((e) => HomeworkItem.fromJson(e)).toList();
});

final homeworkDetailProvider = FutureProvider.autoDispose.family<HomeworkItem, int>((ref, id) async {
  final data = await ref.watch(homeworkRepositoryProvider).getHomeworkDetail(id);
  return HomeworkItem.fromJson(data);
});

final noticeRepositoryProvider = Provider<NoticeRepository>((ref) {
  return NoticeRepository(ref.watch(apiClientProvider));
});

final noticesProvider = StateNotifierProvider.autoDispose<NoticesNotifier, AsyncValue<List<Notice>>>((ref) {
  return NoticesNotifier(ref.watch(noticeRepositoryProvider));
});

class NoticesNotifier extends StateNotifier<AsyncValue<List<Notice>>> {
  final NoticeRepository _repository;

  NoticesNotifier(this._repository) : super(const AsyncValue.loading()) {
    fetchNotices();
  }

  Future<void> fetchNotices() async {
    state = const AsyncValue.loading();
    try {
      final data = await _repository.getNotices();
      final list = data.map((e) => Notice.fromJson(e)).toList();
      state = AsyncValue.data(list);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> markAsRead(Notice notice) async {
    final currentList = state.value;
    if (currentList == null || notice.isRead) return;

    // Optimistic update
    final newList = currentList.map((n) {
      if (n.id == notice.id && n.source == notice.source) {
        return n.copyWith(isRead: true);
      }
      return n;
    }).toList();
    state = AsyncValue.data(newList);

    try {
      await _repository.markAsRead(notice.id, source: notice.source);
    } catch (e) {
      // Rollback on failure
      state = AsyncValue.data(currentList);
      debugPrint('Error marking notice as read: $e');
    }
  }

  Future<void> markAllAsRead() async {
    final currentList = state.value;
    if (currentList == null) return;

    final unread = currentList.where((n) => !n.isRead).toList();
    if (unread.isEmpty) return;

    // Optimistic update
    final newList = currentList.map((n) => n.copyWith(isRead: true)).toList();
    state = AsyncValue.data(newList);

    try {
      await Future.wait(unread.map((n) => _repository.markAsRead(n.id, source: n.source)));
    } catch (e) {
      // Rollback
      state = AsyncValue.data(currentList);
      debugPrint('Error marking all as read: $e');
    }
  }
}
