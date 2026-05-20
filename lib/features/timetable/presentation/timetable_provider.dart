import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/api/api_client.dart';
import '../../core/repositories/extra_repositories.dart';
import '../domain/timetable_models.dart';

final timetableRepositoryProvider = Provider<TimetableRepository>((ref) {
  return TimetableRepository(ref.watch(apiClientProvider));
});

final weeklyTimetableProvider = FutureProvider<Map<String, List<TimetableSlot>>>((ref) async {
  final data = await ref.watch(timetableRepositoryProvider).getWeeklyTimetable();
  final result = <String, List<TimetableSlot>>{};
  data.forEach((key, value) {
    result[key] = (value as List).map((e) => TimetableSlot.fromJson(e)).toList();
  });
  return result;
});

final examScheduleProvider = FutureProvider<List<ExamScheduleItem>>((ref) async {
  final data = await ref.watch(timetableRepositoryProvider).getExamSchedule();
  return data.map((e) => ExamScheduleItem.fromJson(e)).toList();
});
