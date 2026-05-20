import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../dashboard/presentation/dashboard_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsync = ref.watch(dashboardProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
      ),
      body: dashboardAsync.when(
        data: (data) => _buildProfile(context, data),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildProfile(BuildContext context, dynamic data) {
    final student = data.student;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _buildProfileHeader(student),
          const SizedBox(height: 24),
          _buildInfoSection('Academic Information', [
            _buildInfoRow('Admission No', student.admissionNo),
            _buildInfoRow('Class', student.className),
            _buildInfoRow('Section', student.sectionName ?? 'N/A'),
            _buildInfoRow('Roll Number', student.rollNumber ?? 'N/A'),
            _buildInfoRow('Session', student.sessionName),
          ]),
          const SizedBox(height: 20),
          _buildInfoSection('Personal Information', [
            _buildInfoRow('Full Name', student.name),
            _buildInfoRow('Gender', 'Male'), // Static or from API
            _buildInfoRow('Date of Birth', '15 May 2012'), // Static or from API
            _buildInfoRow('Blood Group', 'O+'), // Static or from API
          ]),
          const SizedBox(height: 20),
          _buildInfoSection('Parent Information', [
            _buildInfoRow('Father\'s Name', 'Mr. John Doe'),
            _buildInfoRow('Mother\'s Name', 'Mrs. Jane Doe'),
            _buildInfoRow('Contact', '+91 9876543210'),
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
          backgroundImage: student.photoPath != null ? NetworkImage(student.photoPath!) : null,
          child: student.photoPath == null 
            ? const Icon(Icons.person, size: 60, color: AppColors.primary) 
            : null,
        ),
        const SizedBox(height: 16),
        Text(
          student.name,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        Text(
          'Class ${student.className} • ${student.admissionNo}',
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
