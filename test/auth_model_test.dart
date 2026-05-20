import 'package:flutter_test/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:student_mobile/features/auth/domain/auth_models.dart';

void main() {
  group('AuthUser Model Tests', () {
    test('AuthUser.fromJson should create a valid user object', () {
      final json = {
        'id': 1,
        'name': 'Test Student',
        'role': 'student',
        'school_id': 101,
        'email': 'student@example.com',
        'admission_no': 'ADM001'
      };

      final user = AuthUser.fromJson(json);

      expect(user.id, 1);
      expect(user.name, 'Test Student');
      expect(user.role, 'student');
      expect(user.schoolId, 101);
      expect(user.admissionNo, 'ADM001');
    });

    test('AuthUser.toJson should return a valid Map', () {
      final user = AuthUser(
        id: 1,
        name: 'Test Student',
        role: 'student',
        studentId: 1,
        schoolId: 101,
        admissionNo: 'ADM001',
      );

      final json = user.toJson();

      expect(json['id'], 1);
      expect(json['name'], 'Test Student');
      expect(json['admissionNo'], 'ADM001');
    });
  });
}
