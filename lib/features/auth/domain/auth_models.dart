class AuthUser {
  final int id;
  final String name;
  final String role; // always "student"
  final int studentId;
  final int schoolId;
  final String? email;
  final String admissionNo;

  AuthUser({
    required this.id,
    required this.name,
    required this.role,
    required this.studentId,
    required this.schoolId,
    this.email,
    required this.admissionNo,
  });

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      id: json['id'],
      name: json['name'],
      role: json['role'] ?? 'student',
      studentId: json['student_id'] ?? json['id'],
      schoolId: json['school_id'] ?? 0,
      email: json['email'],
      admissionNo: json['admission_no'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'role': role,
    'student_id': studentId,
    'school_id': schoolId,
    'email': email,
    'admission_no': admissionNo,
  };
}

class AuthState {
  final AuthUser? user;
  final String? token;
  final bool isLoading;
  final String? error;
  final String? storedPin;
  final bool isPinAuthenticated;

  AuthState({
    this.user,
    this.token,
    this.isLoading = false,
    this.error,
    this.storedPin,
    this.isPinAuthenticated = false,
  });

  bool get isAuthenticated => user != null && token != null;
  bool get hasPin => storedPin != null && storedPin!.isNotEmpty;

  AuthState copyWith({
    AuthUser? user,
    String? token,
    bool? isLoading,
    String? error,
    String? storedPin,
    bool? isPinAuthenticated,
  }) {
    return AuthState(
      user: user ?? this.user,
      token: token ?? this.token,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      storedPin: storedPin ?? this.storedPin,
      isPinAuthenticated: isPinAuthenticated ?? this.isPinAuthenticated,
    );
  }
}
