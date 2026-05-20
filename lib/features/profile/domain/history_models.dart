class AcademicHistoryData {
  final List<HistoryRecord> history;
  final List<TimelineItem> timeline;
  final List<PerformanceTrend> performanceTrend;

  AcademicHistoryData({
    required this.history,
    required this.timeline,
    required this.performanceTrend,
  });

  factory AcademicHistoryData.fromJson(Map<String, dynamic> json) {
    return AcademicHistoryData(
      history: (json['history'] as List? ?? [])
          .map((e) => HistoryRecord.fromJson(e))
          .toList(),
      timeline: (json['timeline'] as List? ?? [])
          .map((e) => TimelineItem.fromJson(e))
          .toList(),
      performanceTrend: (json['performance_trend'] as List? ?? [])
          .map((e) => PerformanceTrend.fromJson(e))
          .toList(),
    );
  }
}

class HistoryRecord {
  final int enrollmentId;
  final String sessionName;
  final String className;
  final String sectionName;
  final String? rollNumber;
  final String enrollmentStatus;
  final String? joinedDate;
  final String? leftDate;
  final String? result;
  final double? percentage;
  final String? grade;
  final bool isPromoted;
  final double attendancePercentage;

  HistoryRecord({
    required this.enrollmentId,
    required this.sessionName,
    required this.className,
    required this.sectionName,
    this.rollNumber,
    required this.enrollmentStatus,
    this.joinedDate,
    this.leftDate,
    this.result,
    this.percentage,
    this.grade,
    required this.isPromoted,
    required this.attendancePercentage,
  });

  factory HistoryRecord.fromJson(Map<String, dynamic> json) {
    return HistoryRecord(
      enrollmentId: json['enrollment_id'] ?? 0,
      sessionName: json['session_name'] ?? '',
      className: json['class_name'] ?? '',
      sectionName: json['section_name'] ?? '',
      rollNumber: json['roll_number']?.toString(),
      enrollmentStatus: json['enrollment_status'] ?? '',
      joinedDate: json['joined_date'],
      leftDate: json['left_date'],
      result: json['result'],
      percentage: json['percentage'] != null ? (json['percentage'] as num).toDouble() : null,
      grade: json['grade'],
      isPromoted: json['is_promoted'] ?? false,
      attendancePercentage: (json['attendance_percentage'] as num? ?? 0).toDouble(),
    );
  }
}

class TimelineItem {
  final String sessionName;
  final String className;
  final String sectionName;
  final String? result;
  final double attendancePercentage;
  final bool promoted;

  TimelineItem({
    required this.sessionName,
    required this.className,
    required this.sectionName,
    this.result,
    required this.attendancePercentage,
    required this.promoted,
  });

  factory TimelineItem.fromJson(Map<String, dynamic> json) {
    return TimelineItem(
      sessionName: json['session_name'] ?? '',
      className: json['class_name'] ?? '',
      sectionName: json['section_name'] ?? '',
      result: json['result'],
      attendancePercentage: (json['attendance_percentage'] as num? ?? 0).toDouble(),
      promoted: json['promoted'] ?? false,
    );
  }
}

class PerformanceTrend {
  final String sessionName;
  final double percentage;

  PerformanceTrend({
    required this.sessionName,
    required this.percentage,
  });

  factory PerformanceTrend.fromJson(Map<String, dynamic> json) {
    return PerformanceTrend(
      sessionName: json['session_name'] ?? '',
      percentage: (json['percentage'] as num? ?? 0).toDouble(),
    );
  }
}
