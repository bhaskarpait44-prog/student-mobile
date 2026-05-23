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
    double toDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is double) return value;
      if (value is int) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? 0.0;
      return 0.0;
    }

    return ExamResult(
      examId: json['id'] ?? json['exam_id'] ?? json['examId'] ?? 0,
      examName: json['name'] ?? json['exam_name'] ?? json['examName'] ?? '',
      examType: json['exam_type'] ?? json['examType'] ?? 'Regular',
      date: json['exam_date'] ?? json['date'] ?? '',
      percentage: toDouble(json['percentage']),
      grade: json['grade'] ?? 'N/A',
      resultStatus: json['result_status'] ?? json['resultStatus'] ?? '',
      isWithheld: json['is_withheld'] ?? json['isWithheld'] ?? false,
      totalPending: json['total_pending'] != null ? toDouble(json['total_pending']) : null,
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
    double toDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is double) return value;
      if (value is int) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? 0.0;
      return 0.0;
    }

    final exam = json['exam'] ?? {};
    final summary = json['summary'] ?? {};
    final subjectList = (json['subjects'] as List? ?? [])
        .map((e) => SubjectResult.fromJson(e))
        .toList();

    // Calculate totals if missing from summary
    double calcTotal = 0;
    double calcObtained = 0;
    for (var s in subjectList) {
      calcTotal += s.maxMarks;
      calcObtained += s.obtainedMarks;
    }

    return ExamResultDetail(
      examId: exam['id'] ?? json['exam_id'] ?? json['examId'] ?? 0,
      examName: exam['name'] ?? json['exam_name'] ?? json['examName'] ?? '',
      examType: exam['exam_type'] ?? json['exam_type'] ?? json['examType'] ?? '',
      subjects: subjectList,
      totalMarks: toDouble(summary['total_marks'] ?? json['total_marks'] ?? json['totalMarks'] ?? calcTotal),
      obtainedMarks: toDouble(summary['obtained_marks'] ?? json['obtained_marks'] ?? json['obtainedMarks'] ?? calcObtained),
      percentage: toDouble(summary['percentage'] ?? json['percentage'] ?? 0),
      grade: summary['grade'] ?? json['grade'] ?? '',
      resultStatus: summary['result_status'] ?? json['result_status'] ?? json['resultStatus'] ?? '',
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
    double toDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is double) return value;
      if (value is int) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? 0.0;
      return 0.0;
    }

    return SubjectResult(
      subjectName: json['subject_name'] ?? json['subjectName'] ?? '',
      maxMarks: toDouble(json['total_marks'] ?? json['maxMarks']),
      obtainedMarks: toDouble(json['total_obtained'] ?? json['marks_obtained'] ?? json['obtainedMarks']),
      grade: json['grade'] ?? 'N/A',
      isPassed: json['is_pass'] ?? json['isPassed'] ?? true,
    );
  }
}
