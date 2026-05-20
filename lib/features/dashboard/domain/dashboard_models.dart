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
      latestResult: json['latestResult'] != null ? ExamResult.fromJson(json['latestResult']) : null,
      fee: FeeSummary.fromJson(json['fee']),
      classesToday: ClassesToday.fromJson(json['classesToday']),
      todaySchedule: (json['todaySchedule'] as List).map((e) => SchedulePeriod.fromJson(e)).toList(),
      recentAttendance: (json['recentAttendance'] as List).map((e) => AttendanceDay.fromJson(e)).toList(),
      homeworkDueToday: (json['homeworkDueToday'] as List).map((e) => HomeworkItem.fromJson(e)).toList(),
      motivational: json['motivational'] != null ? MotivationalMessage.fromJson(json['motivational']) : null,
      birthdayBanner: json['birthdayBanner'] != null ? BirthdayBanner.fromJson(json['birthdayBanner']) : null,
      today: json['today'],
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
      name: json['name'],
      className: json['className'],
      sectionName: json['sectionName'],
      rollNumber: json['rollNumber'],
      sessionName: json['sessionName'],
      admissionNo: json['admissionNo'],
      photoPath: json['photoPath'],
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
    return AttendanceSummary(
      percentage: (json['percentage'] as num).toDouble(),
      presentDays: json['presentDays'],
      workingDays: json['workingDays'],
      absentDays: json['absentDays'],
      daysNeededForMinimum: json['daysNeededForMinimum'] ?? 0,
    );
  }
}

class ExamResult {
  final int examId;
  final String examName;
  final double percentage;
  final String grade;
  final String resultStatus;
  final bool isWithheld;
  final double? totalPending;

  ExamResult({
    required this.examId,
    required this.examName,
    required this.percentage,
    required this.grade,
    required this.resultStatus,
    required this.isWithheld,
    this.totalPending,
  });

  factory ExamResult.fromJson(Map<String, dynamic> json) {
    return ExamResult(
      examId: json['examId'],
      examName: json['examName'],
      percentage: (json['percentage'] as num).toDouble(),
      grade: json['grade'],
      resultStatus: json['resultStatus'],
      isWithheld: json['isWithheld'] ?? false,
      totalPending: json['totalPending'] != null ? (json['totalPending'] as num).toDouble() : null,
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
    return FeeSummary(
      totalPending: (json['totalPending'] as num).toDouble(),
      totalPaid: (json['totalPaid'] as num).toDouble(),
      nextDueDate: json['nextDueDate'],
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
      total: json['total'],
      current: json['current'],
      next: json['next'],
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
      periodNumber: json['periodNumber'],
      subjectName: json['subjectName'],
      teacherName: json['teacherName'],
      startTime: json['startTime'],
      endTime: json['endTime'],
      roomNumber: json['roomNumber'],
      status: json['status'],
      countdownMinutes: json['countdownMinutes'],
    );
  }
}

class AttendanceDay {
  final String date;
  final String status;

  AttendanceDay({required this.date, required this.status});

  factory AttendanceDay.fromJson(Map<String, dynamic> json) {
    return AttendanceDay(
      date: json['date'],
      status: json['status'],
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
      title: json['title'],
      subjectName: json['subjectName'],
      teacherName: json['teacherName'],
      dueDate: json['dueDate'],
      submissionType: json['submissionType'],
      submissionStatus: json['submissionStatus'],
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
      type: json['type'],
      message: json['message'],
    );
  }
}

class BirthdayBanner {
  final String message;
  final String? image;

  BirthdayBanner({required this.message, this.image});

  factory BirthdayBanner.fromJson(Map<String, dynamic> json) {
    return BirthdayBanner(
      message: json['message'],
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
      eventType: json['eventType'],
      title: json['title'],
      eventDate: json['eventDate'],
      daysRemaining: json['daysRemaining'],
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
      achievementType: json['achievementType'],
      earnedFor: json['earnedFor'],
      earnedAt: json['earnedAt'],
    );
  }
}
