import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/api_client.dart';
import '../../../core/repositories/student_repositories.dart';
import '../domain/attendance_models.dart';

final attendanceRepositoryProvider = Provider<AttendanceRepository>((ref) {
  return AttendanceRepository(ref.watch(apiClientProvider));
});

final attendanceSummaryProvider = FutureProvider<AttendanceSummary>((ref) async {
  final data = await ref.watch(attendanceRepositoryProvider).getAttendanceSummary();
  return AttendanceSummary.fromJson(data);
});

final attendanceTrendProvider = FutureProvider<List<MonthlyAttendance>>((ref) async {
  final data = await ref.watch(attendanceRepositoryProvider).getAttendanceTrend();
  return data.map((e) => MonthlyAttendance.fromJson(e)).toList();
});

final attendanceListProvider = FutureProvider.family<List<AttendanceDay>, ({int? month, int? year})>((ref, params) async {
  final data = await ref.watch(attendanceRepositoryProvider).getAttendanceList(
    month: params.month,
    year: params.year,
  );
  return data.map((e) => AttendanceDay.fromJson(e)).toList();
});
