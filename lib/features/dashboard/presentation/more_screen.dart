import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('More'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildMenuSection('Academic', [
            _buildMenuItem(context, Icons.assignment, 'Homework', '/homework'),
            _buildMenuItem(context, Icons.notifications, 'Notices', '/notices'),
            _buildMenuItem(context, Icons.book, 'Study Materials', '/materials'),
            _buildMenuItem(context, Icons.chat, 'Chat', '/chat'),
          ]),
          const SizedBox(height: 24),
          _buildMenuSection('Personal', [
            _buildMenuItem(context, Icons.person, 'My Profile', '/profile'),
            _buildMenuItem(context, Icons.history_edu, 'Academic History', '/history'),
            _buildMenuItem(context, Icons.emoji_events, 'Achievements', '/achievements'),
          ]),
          const SizedBox(height: 24),
          _buildMenuSection('Settings', [
            _buildMenuItem(context, Icons.lock_reset, 'Change Password', '/change-password'),
            _buildMenuItem(context, Icons.help_outline, 'Help & Support', '/support'),
          ]),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () {
              // TODO: Implement logout
            },
            icon: const Icon(Icons.logout),
            label: const Text('Logout'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.danger,
              foregroundColor: Colors.white,
            ),
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildMenuSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 8),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.textSecondary,
              letterSpacing: 1,
            ),
          ),
        ),
        Card(
          child: Column(
            children: items,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem(BuildContext context, IconData icon, String title, String route) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.chevron_right, size: 20),
      onTap: () => context.push(route),
    );
  }
}
