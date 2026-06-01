import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/api_client.dart';
import '../../../core/repositories/extra_repositories.dart';
import '../../../core/storage/cache_service.dart';
import '../domain/timetable_models.dart';

final timetableRepositoryProvider = Provider<TimetableRepository>((ref) {
  return TimetableRepository(ref.watch(apiClientProvider), ref.watch(cacheServiceProvider));
});

final weeklyTimetableProvider = FutureProvider.autoDispose<Map<String, List<TimetableSlot>>>((ref) async {
  final data = await ref.watch(timetableRepositoryProvider).getWeeklyTimetable();
  final list = (data['timetable'] as List? ?? []);
  
  final result = <String, List<TimetableSlot>>{};
  for (var item in list) {
    final slot = TimetableSlot.fromJson(item);
    final day = _capitalize(slot.dayOfWeek);
    if (!result.containsKey(day)) {
      result[day] = [];
    }
    result[day]!.add(slot);
  }
  return result;
});

String _capitalize(String s) => s.isEmpty ? '' : s[0].toUpperCase() + s.substring(1).toLowerCase();

final examScheduleProvider = FutureProvider.autoDispose<List<ExamScheduleItem>>((ref) async {
  final data = await ref.watch(timetableRepositoryProvider).getExamSchedule();
  final exams = (data['exams'] as List? ?? []);
  
  final List<ExamScheduleItem> flattened = [];
  for (var exam in exams) {
    final timetable = (exam['timetable'] as List? ?? []);
    for (var slot in timetable) {
      flattened.add(ExamScheduleItem.fromJson(slot));
    }
  }
  return flattened;
});
