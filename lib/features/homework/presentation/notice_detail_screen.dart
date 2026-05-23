import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../domain/homework_models.dart';
import 'homework_provider.dart';

class NoticeDetailScreen extends ConsumerStatefulWidget {
  final Notice notice;
  const NoticeDetailScreen({super.key, required this.notice});

  @override
  ConsumerState<NoticeDetailScreen> createState() => _NoticeDetailScreenState();
}

class _NoticeDetailScreenState extends ConsumerState<NoticeDetailScreen> {
  @override
  void initState() {
    super.initState();
    _markAsRead();
  }

  Future<void> _markAsRead() async {
    if (!widget.notice.isRead) {
      await ref.read(noticesProvider.notifier).markAsRead(widget.notice);
    }
  }

  @override
  Widget build(BuildContext context) {
    final date = DateTime.tryParse(widget.notice.publishedAt);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notice Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                widget.notice.noticeType.toUpperCase(),
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              widget.notice.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16, color: AppColors.textSecondary),
                const SizedBox(width: 8),
                Text(
                  date != null ? DateFormat('MMMM dd, yyyy • hh:mm a').format(date) : 'N/A',
                  style: const TextStyle(color: AppColors.textSecondary),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 24),
            Text(
              widget.notice.content ?? '',
              style: const TextStyle(
                fontSize: 16,
                height: 1.6,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 40),
            if (widget.notice.postedBy != null)
              Text(
                'Posted by: ${widget.notice.postedBy}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  color: AppColors.textSecondary,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
