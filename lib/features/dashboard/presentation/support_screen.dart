import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildHeader(),
          const SizedBox(height: 32),
          _buildSupportSection('Contact School', [
            _buildSupportItem(
              Icons.phone_outlined,
              'Call Us',
              '+91 12345 67890',
              onTap: () {
                // TODO: Launch dialer
              },
            ),
            _buildSupportItem(
              Icons.email_outlined,
              'Email Us',
              'support@educore.com',
              onTap: () {
                // TODO: Launch email client
              },
            ),
            _buildSupportItem(
              Icons.location_on_outlined,
              'Visit Us',
              '123 Education Lane, Knowledge City',
            ),
          ]),
          const SizedBox(height: 24),
          _buildSupportSection('Technical Support', [
            _buildSupportItem(
              Icons.bug_report_outlined,
              'Report an Issue',
              'Found a bug? Let us know.',
              onTap: () {
                // TODO: Open feedback form
              },
            ),
            _buildSupportItem(
              Icons.help_outline,
              'FAQs',
              'Find answers to common questions.',
              onTap: () {
                // TODO: Open FAQ page
              },
            ),
          ]),
          const SizedBox(height: 32),
          const Center(
            child: Text(
              'App Version 1.0.0 (Build 1)',
              style: TextStyle(color: AppColors.textMuted, fontSize: 12),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.headset_mic_outlined, size: 40, color: AppColors.primary),
        ),
        const SizedBox(height: 16),
        const Text(
          'How can we help you?',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        ),
        const SizedBox(height: 8),
        const Text(
          'Our team is here to assist you with any questions or concerns.',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildSupportSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
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

  Widget _buildSupportItem(IconData icon, String title, String subtitle, {VoidCallback? onTap}) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: AppColors.primary, size: 20),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
      subtitle: Text(subtitle, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
      trailing: onTap != null ? const Icon(Icons.chevron_right, size: 20) : null,
      onTap: onTap,
    );
  }
}
