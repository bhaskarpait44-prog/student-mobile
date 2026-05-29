import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import 'profile_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
      ),
      body: profileAsync.when(
        data: (data) => _buildProfile(context, data['profile']),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildProfile(BuildContext context, dynamic student) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _buildProfileHeader(student),
          const SizedBox(height: 24),
          _buildInfoSection('Academic Information', [
            _buildInfoRow('Admission No', student['admission_no'] ?? 'N/A'),
            _buildInfoRow('Class', student['class_name'] ?? 'N/A'),
            _buildInfoRow('Section', student['section_name'] ?? 'N/A'),
            _buildInfoRow('Roll Number', student['roll_number']?.toString() ?? 'N/A'),
            _buildInfoRow('Session', student['session_name'] ?? 'N/A'),
          ]),
          const SizedBox(height: 20),
          _buildInfoSection('Personal Information', [
            _buildInfoRow('Full Name', student['full_name'] ?? 'N/A'),
            _buildInfoRow('Gender', student['gender'] ?? 'N/A'),
            _buildInfoRow('Date of Birth', student['date_of_birth'] ?? 'N/A'),
            _buildInfoRow('Blood Group', student['blood_group'] ?? 'N/A'),
          ]),
          const SizedBox(height: 20),
          _buildInfoSection('Parent Information', [
            _buildInfoRow('Father\'s Name', student['father_name'] ?? 'N/A'),
            _buildInfoRow('Mother\'s Name', student['mother_name'] ?? 'N/A'),
            _buildInfoRow('Contact', student['father_phone'] ?? student['mother_phone'] ?? 'N/A'),
          ]),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(dynamic student) {
    return Column(
      children: [
        CircleAvatar(
          radius: 60,
          backgroundColor: AppColors.primary.withValues(alpha: 0.1),
          backgroundImage: student['photo_path'] != null ? NetworkImage(student['photo_path']) : null,
          child: student['photo_path'] == null 
            ? const Icon(Icons.person, size: 60, color: AppColors.primary) 
            : null,
        ),
        const SizedBox(height: 16),
        Text(
          student['full_name'] ?? 'N/A',
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        Text(
          'Class ${student['class_name']} • ${student['admission_no']}',
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildInfoSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            title,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primary),
          ),
        ),
        Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              children: children,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 14)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        ],
      ),
    );
  }
}
