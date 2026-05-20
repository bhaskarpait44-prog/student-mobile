import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../dashboard/domain/dashboard_models.dart';
import 'achievement_provider.dart';

class AchievementsScreen extends ConsumerWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final achievementsAsync = ref.watch(achievementsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Achievements'),
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(achievementsProvider.future),
        child: achievementsAsync.when(
          data: (list) => _buildAchievementList(list),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Center(child: Text('Error: $err')),
        ),
      ),
    );
  }

  Widget _buildAchievementList(List<Achievement> list) {
    if (list.isEmpty) {
      return const Center(child: Text('No achievements earned yet. Keep it up!'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final achievement = list[index];
        return _AchievementCard(achievement: achievement);
      },
    );
  }
}

class _AchievementCard extends StatelessWidget {
  final Achievement achievement;

  const _AchievementCard({required this.achievement});

  @override
  Widget build(BuildContext context) {
    final date = DateTime.tryParse(achievement.earnedAt);
    final type = achievement.achievementType.toLowerCase();
    
    IconData icon;
    Color color;

    if (type.contains('academic') || type.contains('exam')) {
      icon = Icons.school;
      color = AppColors.primary;
    } else if (type.contains('attendance')) {
      icon = Icons.calendar_check;
      color = AppColors.success;
    } else if (type.contains('sports') || type.contains('activity')) {
      icon = Icons.emoji_events;
      color = AppColors.warning;
    } else {
      icon = Icons.stars;
      color = AppColors.info;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: color, size: 32),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    achievement.achievementType.toUpperCase(),
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    achievement.earnedFor ?? 'Excellence in activities',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  if (date != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Earned on ${DateFormat('dd MMM yyyy').format(date)}',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
