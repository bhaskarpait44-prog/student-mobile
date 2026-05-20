import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/dashboard_models.dart';

class AttendanceBubbleStrip extends StatelessWidget {
  final List<AttendanceDay> recentAttendance;

  const AttendanceBubbleStrip({super.key, required this.recentAttendance});

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'present':
        return AppColors.success;
      case 'absent':
        return AppColors.danger;
      case 'late':
        return AppColors.warning;
      case 'half_day':
        return AppColors.info;
      case 'holiday':
        return AppColors.textMuted;
      default:
        return AppColors.border;
    }
  }

  String _getStatusInitial(String status) {
    switch (status.toLowerCase()) {
      case 'present':
        return 'P';
      case 'absent':
        return 'A';
      case 'late':
        return 'L';
      case 'half_day':
        return 'H';
      case 'holiday':
        return 'H';
      default:
        return '•';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recent Attendance',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: recentAttendance.map((day) {
              final date = DateTime.parse(day.date);
              final color = _getStatusColor(day.status);
              return Column(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      shape: BoxShape.circle,
                      border: Border.all(color: color, width: 1.5),
                    ),
                    child: Center(
                      child: Text(
                        _getStatusInitial(day.status),
                        style: TextStyle(
                          color: color,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    DateFormat('E').format(date),
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
