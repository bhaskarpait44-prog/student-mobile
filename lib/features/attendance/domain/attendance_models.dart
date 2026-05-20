class AttendanceSummary {
  final double percentage;
  final int presentDays;
  final int workingDays;
  final int absentDays;
  final int lateDays;
  final int halfDays;
  final int holidays;
  final int daysNeededForMinimum;

  AttendanceSummary({
    required this.percentage,
    required this.presentDays,
    required this.workingDays,
    required this.absentDays,
    required this.lateDays,
    required this.halfDays,
    required this.holidays,
    required this.daysNeededForMinimum,
  });

  factory AttendanceSummary.fromJson(Map<String, dynamic> json) {
    return AttendanceSummary(
      percentage: (json['percentage'] as num? ?? 0).toDouble(),
      presentDays: json['present_days'] ?? 0,
      workingDays: json['working_days'] ?? 0,
      absentDays: json['absent_days'] ?? 0,
      lateDays: json['late_days'] ?? 0,
      halfDays: json['half_days'] ?? 0,
      holidays: json['holidays'] ?? 0,
      daysNeededForMinimum: json['days_needed_for_minimum'] ?? 0,
    );
  }
}

class MonthlyAttendance {
  final String month;
  final double percentage;
  final int present;
  final int total;

  MonthlyAttendance({
    required this.month,
    required this.percentage,
    required this.present,
    required this.total,
  });

  factory MonthlyAttendance.fromJson(Map<String, dynamic> json) {
    return MonthlyAttendance(
      month: json['month'],
      percentage: (json['percentage'] as num).toDouble(),
      present: json['present'],
      total: json['total'],
    );
  }
}

class AttendanceDay {
  final String date;
  final String status;
  final String? remarks;

  AttendanceDay({required this.date, required this.status, this.remarks});

  factory AttendanceDay.fromJson(Map<String, dynamic> json) {
    return AttendanceDay(
      date: json['date'],
      status: json['status'],
      remarks: json['remarks'],
    );
  }
}
