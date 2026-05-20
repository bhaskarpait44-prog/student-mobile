class ExamResult {
  final int examId;
  final String examName;
  final String examType;
  final String date;
  final double percentage;
  final String grade;
  final String resultStatus;
  final bool isWithheld;
  final double? totalPending;

  ExamResult({
    required this.examId,
    required this.examName,
    required this.examType,
    required this.date,
    required this.percentage,
    required this.grade,
    required this.resultStatus,
    required this.isWithheld,
    this.totalPending,
  });

  factory ExamResult.fromJson(Map<String, dynamic> json) {
    return ExamResult(
      examId: json['exam_id'] ?? json['examId'],
      examName: json['exam_name'] ?? json['examName'],
      examType: json['exam_type'] ?? json['examType'] ?? 'Regular',
      date: json['exam_date'] ?? json['date'] ?? '',
      percentage: (json['percentage'] as num).toDouble(),
      grade: json['grade'],
      resultStatus: json['result_status'] ?? json['resultStatus'],
      isWithheld: json['is_withheld'] ?? json['isWithheld'] ?? false,
      totalPending: json['total_pending'] != null ? (json['total_pending'] as num).toDouble() : null,
    );
  }
}

class ExamResultDetail {
  final int examId;
  final String examName;
  final String examType;
  final List<SubjectResult> subjects;
  final double totalMarks;
  final double obtainedMarks;
  final double percentage;
  final String grade;
  final String resultStatus;
  final bool isWithheld;

  ExamResultDetail({
    required this.examId,
    required this.examName,
    required this.examType,
    required this.subjects,
    required this.totalMarks,
    required this.obtainedMarks,
    required this.percentage,
    required this.grade,
    required this.resultStatus,
    required this.isWithheld,
  });

  factory ExamResultDetail.fromJson(Map<String, dynamic> json) {
    return ExamResultDetail(
      examId: json['exam_id'] ?? json['examId'],
      examName: json['exam_name'] ?? json['examName'],
      examType: json['exam_type'] ?? json['examType'],
      subjects: (json['subjects'] as List).map((e) => SubjectResult.fromJson(e)).toList(),
      totalMarks: (json['total_marks'] as num? ?? json['totalMarks'] as num? ?? 0).toDouble(),
      obtainedMarks: (json['obtained_marks'] as num? ?? json['obtainedMarks'] as num? ?? 0).toDouble(),
      percentage: (json['percentage'] as num? ?? 0).toDouble(),
      grade: json['grade'] ?? '',
      resultStatus: json['result_status'] ?? json['resultStatus'] ?? '',
      isWithheld: json['is_withheld'] ?? json['isWithheld'] ?? false,
    );
  }
}

class SubjectResult {
  final String subjectName;
  final double maxMarks;
  final double obtainedMarks;
  final String grade;
  final bool isPassed;

  SubjectResult({
    required this.subjectName,
    required this.maxMarks,
    required this.obtainedMarks,
    required this.grade,
    required this.isPassed,
  });

  factory SubjectResult.fromJson(Map<String, dynamic> json) {
    return SubjectResult(
      subjectName: json['subject_name'] ?? json['subjectName'] ?? '',
      maxMarks: (json['total_marks'] as num? ?? json['maxMarks'] as num? ?? 0).toDouble(),
      obtainedMarks: (json['marks_obtained'] as num? ?? json['obtainedMarks'] as num? ?? 0).toDouble(),
      grade: json['grade'] ?? '',
      isPassed: json['is_pass'] ?? json['isPassed'] ?? true,
    );
  }
}
