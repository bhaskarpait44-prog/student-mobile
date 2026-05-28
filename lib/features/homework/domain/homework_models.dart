class HomeworkItem {
  final int id;
  final String title;
  final String subjectName;
  final String teacherName;
  final String dueDate;
  final String submissionType;
  final String? submissionStatus;
  final String? description;
  final String? attachmentPath;

  HomeworkItem({
    required this.id,
    required this.title,
    required this.subjectName,
    required this.teacherName,
    required this.dueDate,
    required this.submissionType,
    this.submissionStatus,
    this.description,
    this.attachmentPath,
  });

  factory HomeworkItem.fromJson(Map<String, dynamic> json) {
    int toInt(dynamic value) {
      if (value == null) return 0;
      if (value is int) return value;
      if (value is String) return int.tryParse(value) ?? 0;
      if (value is num) return value.toInt();
      return 0;
    }

    return HomeworkItem(
      id: toInt(json['id']),
      title: json['title'] ?? '',
      subjectName: json['subject_name'] ?? json['subjectName'] ?? '',
      teacherName: json['teacher_name'] ?? json['teacherName'] ?? '',
      dueDate: json['due_date'] ?? json['dueDate'] ?? '',
      submissionType: json['submission_type'] ?? json['submissionType'] ?? 'online',
      submissionStatus: json['submission_status'] ?? json['submissionStatus'],
      description: json['description'],
      attachmentPath: json['attachment_path'] ?? json['attachmentPath'],
    );
  }
}

class Notice {
  final int id;
  final String title;
  final String? content;
  final String noticeType;
  final String publishedAt;
  final String? postedBy;
  final bool isPinned;
  final bool isRead;
  final String source;
  final String? attachmentPath;

  Notice({
    required this.id,
    required this.title,
    this.content,
    required this.noticeType,
    required this.publishedAt,
    this.postedBy,
    required this.isPinned,
    required this.isRead,
    required this.source,
    this.attachmentPath,
  });

  Notice copyWith({
    int? id,
    String? title,
    String? content,
    String? noticeType,
    String? publishedAt,
    String? postedBy,
    bool? isPinned,
    bool? isRead,
    String? source,
    String? attachmentPath,
  }) {
    return Notice(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      noticeType: noticeType ?? this.noticeType,
      publishedAt: publishedAt ?? this.publishedAt,
      postedBy: postedBy ?? this.postedBy,
      isPinned: isPinned ?? this.isPinned,
      isRead: isRead ?? this.isRead,
      source: source ?? this.source,
      attachmentPath: attachmentPath ?? this.attachmentPath,
    );
  }

  factory Notice.fromJson(Map<String, dynamic> json) {
    int toInt(dynamic value) {
      if (value == null) return 0;
      if (value is int) return value;
      if (value is String) return int.tryParse(value) ?? 0;
      if (value is num) return value.toInt();
      return 0;
    }

    bool toBool(dynamic value) {
      if (value == null) return false;
      if (value is bool) return value;
      if (value is int) return value != 0;
      if (value is String) {
        final s = value.toLowerCase();
        return s == 'true' || s == '1' || s == 't' || s == 'yes';
      }
      return false;
    }

    return Notice(
      id: toInt(json['id']),
      title: json['title'] ?? '',
      content: json['body'] ?? json['content'],
      noticeType: json['priority'] ?? json['notice_type'] ?? json['noticeType'] ?? 'general',
      publishedAt: json['created_at'] ?? json['published_at'] ?? json['publishedAt'] ?? '',
      postedBy: json['posted_by_name'] ?? json['postedBy'],
      isPinned: toBool(json['is_pinned'] ?? json['isPinned']),
      isRead: toBool(json['is_read'] ?? json['isRead']),
      source: json['source'] ?? 'unified',
      attachmentPath: json['attachment_path'] ?? json['attachmentPath'],
    );
  }
}

class StudyMaterial {
  final int id;
  final String title;
  final String? description;
  final String filePath;
  final String fileType;
  final int fileSize;
  final String subjectName;
  final String teacherName;
  final String createdAt;

  StudyMaterial({
    required this.id,
    required this.title,
    this.description,
    required this.filePath,
    required this.fileType,
    required this.fileSize,
    required this.subjectName,
    required this.teacherName,
    required this.createdAt,
  });

  factory StudyMaterial.fromJson(Map<String, dynamic> json) {
    int toInt(dynamic value) {
      if (value == null) return 0;
      if (value is int) return value;
      if (value is String) return int.tryParse(value) ?? 0;
      if (value is num) return value.toInt();
      return 0;
    }

    return StudyMaterial(
      id: toInt(json['id']),
      title: json['title'] ?? '',
      description: json['description'],
      filePath: json['file_path'] ?? '',
      fileType: json['file_type'] ?? 'application/pdf',
      fileSize: toInt(json['file_size']),
      subjectName: json['subject_name'] ?? '',
      teacherName: json['teacher_name'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }
}
