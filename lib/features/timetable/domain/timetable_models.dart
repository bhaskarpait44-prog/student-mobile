class TimetableSlot {
  final int id;
  final int periodNumber;
  final String subjectName;
  final String teacherName;
  final String startTime;
  final String endTime;
  final String? roomNumber;
  final String dayOfWeek;

  TimetableSlot({
    required this.id,
    required this.periodNumber,
    required this.subjectName,
    required this.teacherName,
    required this.startTime,
    required this.endTime,
    this.roomNumber,
    required this.dayOfWeek,
  });

  factory TimetableSlot.fromJson(Map<String, dynamic> json) {
    return TimetableSlot(
      id: json['id'],
      periodNumber: json['period_number'] ?? json['periodNumber'],
      subjectName: json['subject_name'] ?? json['subjectName'],
      teacherName: json['teacher_name'] ?? json['teacherName'],
      startTime: json['start_time'] ?? json['startTime'],
      endTime: json['end_time'] ?? json['endTime'],
      roomNumber: json['room_number'] ?? json['roomNumber'],
      dayOfWeek: json['day_of_week'] ?? json['dayOfWeek'] ?? '',
    );
  }
}

class ExamScheduleItem {
  final String subjectName;
  final String date;
  final String startTime;
  final String endTime;
  final String? roomNumber;

  ExamScheduleItem({
    required this.subjectName,
    required this.date,
    required this.startTime,
    required this.endTime,
    this.roomNumber,
  });

  factory ExamScheduleItem.fromJson(Map<String, dynamic> json) {
    return ExamScheduleItem(
      subjectName: json['subject_name'] ?? json['subjectName'] ?? '',
      date: json['exam_date'] ?? json['date'] ?? '',
      startTime: json['start_time'] ?? json['startTime'] ?? '',
      endTime: json['end_time'] ?? json['endTime'] ?? '',
      roomNumber: json['room_number'] ?? json['roomNumber'],
    );
  }
}
