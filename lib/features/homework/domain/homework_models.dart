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
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      subjectName: json['subject_name'] ?? json['subjectName'] ?? '',
      teacherName: json['teacher_name'] ?? json['teacherName'] ?? '',
      dueDate: json['due_date'] ?? json['dueDate'] ?? '',
      submissionType: json['submission_type'] ?? json['submissionType'] ?? 'online',
      submissionStatus: json['submission_status'] ?? json['submissionStatus'],
      description: json['description'],
    );
  }
}

class Notice {
  final int id;
  final String title;
  final String? content;
  final String noticeType;
  final String publishedAt;
  final bool isPinned;
  final bool isRead;

  Notice({
    required this.id,
    required this.title,
    this.content,
    required this.noticeType,
    required this.publishedAt,
    required this.isPinned,
    required this.isRead,
  });

  factory Notice.fromJson(Map<String, dynamic> json) {
    return Notice(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      content: json['content'],
      noticeType: json['notice_type'] ?? json['noticeType'] ?? 'general',
      publishedAt: json['published_at'] ?? json['publishedAt'] ?? '',
      isPinned: json['is_pinned'] ?? json['isPinned'] ?? false,
      isRead: json['is_read'] ?? json['isRead'] ?? false,
    );
  }
}
