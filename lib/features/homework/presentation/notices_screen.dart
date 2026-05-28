import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../domain/homework_models.dart';
import 'homework_provider.dart';

import 'notice_detail_screen.dart';

class NoticesScreen extends ConsumerStatefulWidget {
  const NoticesScreen({super.key});

  @override
  ConsumerState<NoticesScreen> createState() => _NoticesScreenState();
}

class _NoticesScreenState extends ConsumerState<NoticesScreen> {
  String _filter = 'all'; // all, unread, read, recent

  @override
  Widget build(BuildContext context) {
    final noticesAsync = ref.watch(noticesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notices'),
        actions: [
          IconButton(
            tooltip: 'Mark all as read',
            icon: const Icon(Icons.done_all),
            onPressed: () => ref.read(noticesProvider.notifier).markAllAsRead(),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFilterBar(),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => ref.read(noticesProvider.notifier).fetchNotices(),
              child: noticesAsync.when(
                data: (notices) {
                  final filtered = _applyFilter(notices);
                  return _buildNoticesList(context, filtered);
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, _) => Center(child: Text('Error: $err')),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar() {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _filterChip('All', 'all'),
          _filterChip('Unread', 'unread'),
          _filterChip('Read', 'read'),
          _filterChip('Recent', 'recent'),
        ],
      ),
    );
  }

  Widget _filterChip(String label, String value) {
    final isSelected = _filter == value;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          if (selected) setState(() => _filter = value);
        },
      ),
    );
  }

  List<Notice> _applyFilter(List<Notice> notices) {
    switch (_filter) {
      case 'unread':
        return notices.where((n) => !n.isRead).toList();
      case 'read':
        return notices.where((n) => n.isRead).toList();
      case 'recent':
        final sevenDaysAgo = DateTime.now().subtract(const Duration(days: 7));
        return notices.where((n) {
          final date = DateTime.tryParse(n.publishedAt);
          return date != null && date.isAfter(sevenDaysAgo);
        }).toList();
      default:
        return notices;
    }
  }

  Widget _buildNoticesList(BuildContext context, List<Notice> notices) {
    if (notices.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.notifications_off_outlined, size: 64, color: AppColors.textMuted.withValues(alpha: 0.5)),
            const SizedBox(height: 16),
            const Text(
              'No notices found for this filter.',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
            ),
          ],
        ),
      );
    }

    // Separate pinned and unpinned
    final pinned = notices.where((n) => n.isPinned).toList();
    final others = notices.where((n) => !n.isPinned).toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      children: [
        if (pinned.isNotEmpty) ...[
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Row(
              children: [
                Icon(Icons.push_pin, size: 16, color: AppColors.primary),
                SizedBox(width: 8),
                Text('Pinned Notices', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              ],
            ),
          ),
          ...pinned.map((n) => _NoticeCard(notice: n)),
          const SizedBox(height: 12),
        ],
        if (others.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(
              _filter == 'all' ? 'Recent Notices' : '${_filter[0].toUpperCase()}${_filter.substring(1)} Notices',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
          ...others.map((n) => _NoticeCard(notice: n)),
        ],
      ],
    );
  }
}

class _NoticeCard extends StatelessWidget {
  final Notice notice;

  const _NoticeCard({required this.notice});

  @override
  Widget build(BuildContext context) {
    final date = DateTime.tryParse(notice.publishedAt);
    final color = _getTypeColor(notice.noticeType);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NoticeDetailScreen(notice: notice),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            border: !notice.isRead 
              ? Border(left: BorderSide(color: color, width: 4))
              : null,
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      notice.noticeType.toUpperCase(),
                      style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text(
                    date != null ? DateFormat('dd MMM').format(date) : 'N/A',
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      notice.title,
                      style: TextStyle(
                        fontWeight: !notice.isRead ? FontWeight.bold : FontWeight.w500,
                        fontSize: 16,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  if (notice.attachmentPath != null && notice.attachmentPath!.isNotEmpty)
                    const Icon(Icons.picture_as_pdf, color: Colors.red, size: 20),
                ],
              ),
              if (notice.content != null) ...[
                const SizedBox(height: 8),
                Text(
                  notice.content!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Color _getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'academic':
      case 'general':
      case 'normal': return AppColors.primary;
      case 'event':
      case 'info': return AppColors.info;
      case 'holiday': return AppColors.success;
      case 'urgent':
      case 'warning': return AppColors.danger;
      default: return AppColors.textSecondary;
    }
  }
}
