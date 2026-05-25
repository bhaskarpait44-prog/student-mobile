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
    double toDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is num) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? 0.0;
      return 0.0;
    }

    int toInt(dynamic value) {
      if (value == null) return 0;
      if (value is int) return value;
      if (value is String) return int.tryParse(value) ?? 0;
      if (value is num) return value.toInt();
      return 0;
    }

    return AttendanceSummary(
      percentage: toDouble(json['percentage']),
      presentDays: toInt(json['present_days']),
      workingDays: toInt(json['working_days']),
      absentDays: toInt(json['absent_days']),
      lateDays: toInt(json['late_days']),
      halfDays: toInt(json['half_days']),
      holidays: toInt(json['holidays']),
      daysNeededForMinimum: toInt(json['days_needed_for_minimum']),
    );
  }
}

class MonthlyAttendance {
  final String month;
  final double percentage;
  final int? present;
  final int? total;

  MonthlyAttendance({
    required this.month,
    required this.percentage,
    this.present,
    this.total,
  });

  factory MonthlyAttendance.fromJson(Map<String, dynamic> json) {
    double toDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is num) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? 0.0;
      return 0.0;
    }

    int? toInt(dynamic value) {
      if (value == null) return null;
      if (value is int) return value;
      if (value is String) return int.tryParse(value);
      if (value is num) return value.toInt();
      return null;
    }

    return MonthlyAttendance(
      month: json['month_label']?.toString() ?? json['month']?.toString() ?? '',
      percentage: toDouble(json['percentage']),
      present: toInt(json['present_days'] ?? json['present']),
      total: toInt(json['working_days'] ?? json['total']),
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
      date: json['date'] ?? '',
      status: json['status'] ?? '',
      remarks: json['override_reason'] ?? json['remarks'],
    );
  }
}
