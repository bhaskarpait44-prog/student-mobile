class DashboardData {
  final StudentInfo student;
  final AttendanceSummary attendance;
  final ExamResult? latestResult;
  final FeeSummary fee;
  final ClassesToday classesToday;
  final List<SchedulePeriod> todaySchedule;
  final List<AttendanceDay> recentAttendance;
  final List<HomeworkItem> homeworkDueToday;
  final MotivationalMessage? motivational;
  final BirthdayBanner? birthdayBanner;
  final String today;

  DashboardData({
    required this.student,
    required this.attendance,
    this.latestResult,
    required this.fee,
    required this.classesToday,
    required this.todaySchedule,
    required this.recentAttendance,
    required this.homeworkDueToday,
    this.motivational,
    this.birthdayBanner,
    required this.today,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    return DashboardData(
      student: StudentInfo.fromJson(json['student']),
      attendance: AttendanceSummary.fromJson(json['attendance']),
      latestResult: json['latest_result'] != null ? ExamResult.fromJson(json['latest_result']) : null,
      fee: FeeSummary.fromJson(json['fee']),
      classesToday: ClassesToday.fromJson(json['classes_today']),
      todaySchedule: (json['today_schedule'] as List? ?? [])
          .map((e) => SchedulePeriod.fromJson(e))
          .toList(),
      recentAttendance: (json['recent_attendance'] as List? ?? [])
          .map((e) => AttendanceDay.fromJson(e))
          .toList(),
      homeworkDueToday: json['homework_due_today'] != null 
          ? (json['homework_due_today']['items'] as List? ?? [])
              .map((e) => HomeworkItem.fromJson(e))
              .toList()
          : [],
      motivational: json['motivational'] != null ? MotivationalMessage.fromJson(json['motivational']) : null,
      birthdayBanner: json['birthday_banner'] != null ? BirthdayBanner.fromJson(json['birthday_banner']) : null,
      today: json['today'] ?? '',
    );
  }
}

class StudentInfo {
  final String name;
  final String className;
  final String? sectionName;
  final String? rollNumber;
  final String sessionName;
  final String admissionNo;
  final String? photoPath;

  StudentInfo({
    required this.name,
    required this.className,
    this.sectionName,
    this.rollNumber,
    required this.sessionName,
    required this.admissionNo,
    this.photoPath,
  });

  factory StudentInfo.fromJson(Map<String, dynamic> json) {
    return StudentInfo(
      name: json['name'] ?? '',
      className: json['class_name'] ?? '',
      sectionName: json['section_name'],
      rollNumber: json['roll_number']?.toString(),
      sessionName: json['session_name'] ?? '',
      admissionNo: json['admission_no'] ?? '',
      photoPath: json['photo_path'],
    );
  }
}

class AttendanceSummary {
  final double percentage;
  final int presentDays;
  final int workingDays;
  final int absentDays;
  final int daysNeededForMinimum;

  AttendanceSummary({
    required this.percentage,
    required this.presentDays,
    required this.workingDays,
    required this.absentDays,
    required this.daysNeededForMinimum,
  });

  factory AttendanceSummary.fromJson(Map<String, dynamic> json) {
    double toDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is double) return value;
      if (value is int) return value.toDouble();
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
      daysNeededForMinimum: toInt(json['days_needed_for_minimum']),
    );
  }
}

class ExamResult {
  final int? examId;
  final String examName;
  final double percentage;
  final String grade;
  final String resultStatus;
  final bool isWithheld;
  final double? totalPending;

  ExamResult({
    this.examId,
    required this.examName,
    required this.percentage,
    required this.grade,
    required this.resultStatus,
    required this.isWithheld,
    this.totalPending,
  });

  factory ExamResult.fromJson(Map<String, dynamic> json) {
    double toDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is double) return value;
      if (value is int) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? 0.0;
      return 0.0;
    }

    return ExamResult(
      examId: json['exam_id'],
      examName: json['exam_name'] ?? '',
      percentage: toDouble(json['percentage']),
      grade: json['grade'] ?? '',
      resultStatus: json['result_status'] ?? '',
      isWithheld: json['is_withheld'] ?? false,
      totalPending: json['total_pending'] != null ? toDouble(json['total_pending']) : null,
    );
  }
}

class FeeSummary {
  final double totalPending;
  final double totalPaid;
  final String? nextDueDate;

  FeeSummary({
    required this.totalPending,
    required this.totalPaid,
    this.nextDueDate,
  });

  factory FeeSummary.fromJson(Map<String, dynamic> json) {
    double toDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is double) return value;
      if (value is int) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? 0.0;
      return 0.0;
    }

    return FeeSummary(
      totalPending: toDouble(json['total_pending']),
      totalPaid: toDouble(json['total_paid']),
      nextDueDate: json['next_due_date'],
    );
  }
}

class ClassesToday {
  final int total;
  final String? current;
  final String? next;

  ClassesToday({required this.total, this.current, this.next});

  factory ClassesToday.fromJson(Map<String, dynamic> json) {
    return ClassesToday(
      total: json['total_periods'] ?? 0,
      current: json['current_period']?['subject_name'],
      next: json['next_period']?['subject_name'],
    );
  }
}

class SchedulePeriod {
  final int id;
  final int periodNumber;
  final String subjectName;
  final String teacherName;
  final String startTime;
  final String endTime;
  final String? roomNumber;
  final String status;
  final int? countdownMinutes;

  SchedulePeriod({
    required this.id,
    required this.periodNumber,
    required this.subjectName,
    required this.teacherName,
    required this.startTime,
    required this.endTime,
    this.roomNumber,
    required this.status,
    this.countdownMinutes,
  });

  factory SchedulePeriod.fromJson(Map<String, dynamic> json) {
    return SchedulePeriod(
      id: json['id'],
      periodNumber: json['period_number'],
      subjectName: json['subject_name'] ?? '',
      teacherName: json['teacher_name'] ?? '',
      startTime: json['start_time'] ?? '',
      endTime: json['end_time'] ?? '',
      roomNumber: json['room_number'],
      status: json['status'] ?? '',
      countdownMinutes: json['countdown_minutes'],
    );
  }
}

class AttendanceDay {
  final String date;
  final String status;

  AttendanceDay({required this.date, required this.status});

  factory AttendanceDay.fromJson(Map<String, dynamic> json) {
    return AttendanceDay(
      date: json['date'] ?? '',
      status: json['status'] ?? '',
    );
  }
}

class HomeworkItem {
  final int id;
  final String title;
  final String subjectName;
  final String teacherName;
  final String dueDate;
  final String submissionType;
  final String? submissionStatus;
  final String? description;

  HomeworkItem({
    required this.id,
    required this.title,
    required this.subjectName,
    required this.teacherName,
    required this.dueDate,
    required this.submissionType,
    this.submissionStatus,
    this.description,
  });

  factory HomeworkItem.fromJson(Map<String, dynamic> json) {
    return HomeworkItem(
      id: json['id'],
      title: json['title'] ?? '',
      subjectName: json['subject_name'] ?? '',
      teacherName: json['teacher_name'] ?? '',
      dueDate: json['due_date'] ?? '',
      submissionType: json['submission_type'] ?? '',
      submissionStatus: json['submission_status'],
      description: json['description'],
    );
  }
}

class MotivationalMessage {
  final String type;
  final String message;

  MotivationalMessage({required this.type, required this.message});

  factory MotivationalMessage.fromJson(Map<String, dynamic> json) {
    return MotivationalMessage(
      type: json['type'] ?? '',
      message: json['message'] ?? '',
    );
  }
}

class BirthdayBanner {
  final String message;
  final String? image;

  BirthdayBanner({required this.message, this.image});

  factory BirthdayBanner.fromJson(Map<String, dynamic> json) {
    return BirthdayBanner(
      message: json['title'] ?? json['message'] ?? '',
      image: json['image'],
    );
  }
}

class UpcomingEvent {
  final int id;
  final String eventType;
  final String title;
  final String eventDate;
  final int daysRemaining;

  UpcomingEvent({
    required this.id,
    required this.eventType,
    required this.title,
    required this.eventDate,
    required this.daysRemaining,
  });

  factory UpcomingEvent.fromJson(Map<String, dynamic> json) {
    return UpcomingEvent(
      id: json['id'],
      eventType: json['event_type'] ?? '',
      title: json['title'] ?? '',
      eventDate: json['event_date'] ?? '',
      daysRemaining: json['days_remaining'] ?? 0,
    );
  }
}

class Achievement {
  final int id;
  final String achievementType;
  final String? earnedFor;
  final String earnedAt;

  Achievement({
    required this.id,
    required this.achievementType,
    this.earnedFor,
    required this.earnedAt,
  });

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      id: json['id'],
      achievementType: json['achievement_type'] ?? '',
      earnedFor: json['earned_for'],
      earnedAt: json['earned_at'] ?? '',
    );
  }
}
