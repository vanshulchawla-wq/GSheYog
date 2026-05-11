import 'package:flutter/material.dart';
import '../theme.dart';
import '../services/storage_service.dart';

class BadgesScreen extends StatelessWidget {
  const BadgesScreen({super.key});

  static const _allBadges = [
    {'id': 'first_session', 'icon': '🌱', 'title': 'First Step', 'desc': 'Complete your first session', 'req': '1 session'},
    {'id': '7_day_warrior', 'icon': '⚔️', 'title': '7-Day Warrior', 'desc': 'Maintain a 7-day streak', 'req': '7 day streak'},
    {'id': '30_day_lotus', 'icon': '🪷', 'title': '30-Day Lotus', 'desc': 'Maintain a 30-day streak', 'req': '30 day streak'},
    {'id': 'century', 'icon': '💯', 'title': 'Century', 'desc': 'Practice for 100 days total', 'req': '100 days'},
    {'id': 'hour_power', 'icon': '⏰', 'title': 'Hour Power', 'desc': 'Accumulate 60 minutes of practice', 'req': '60 min total'},
    {'id': 'dedicated_10h', 'icon': '🏆', 'title': 'Dedicated', 'desc': 'Accumulate 10 hours of practice', 'req': '600 min total'},
    {'id': 'level_5', 'icon': '⭐', 'title': 'Rising Star', 'desc': 'Reach Level 5', 'req': 'Level 5'},
    {'id': 'level_10', 'icon': '👑', 'title': 'Yoga Queen', 'desc': 'Reach Level 10', 'req': 'Level 10'},
    {'id': 'early_bird', 'icon': '🐦', 'title': 'Early Bird', 'desc': 'Practice in the morning', 'req': 'Morning session'},
    {'id': 'face_yoga_fan', 'icon': '😊', 'title': 'Face Yoga Fan', 'desc': 'Complete 10 face yoga sessions', 'req': '10 face sessions'},
  ];

  @override
  Widget build(BuildContext context) {
    final unlocked = StorageService.unlockedBadges;

    return Scaffold(
      appBar: AppBar(title: const Text('Achievements')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLevelCard(context),
            const SizedBox(height: 20),
            Text('${unlocked.length}/${_allBadges.length} Unlocked',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.3,
              ),
              itemCount: _allBadges.length,
              itemBuilder: (_, i) {
                final badge = _allBadges[i];
                final isUnlocked = unlocked.contains(badge['id']);
                return Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isUnlocked
                        ? AppTheme.primary.withValues(alpha: 0.08)
                        : AppTheme.cardBg,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isUnlocked ? AppTheme.primary : AppTheme.divider,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        isUnlocked ? badge['icon']! : '🔒',
                        style: TextStyle(fontSize: 28, color: isUnlocked ? null : Colors.grey),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        badge['title']!,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isUnlocked ? AppTheme.textDark : AppTheme.textMuted,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        isUnlocked ? badge['desc']! : badge['req']!,
                        style: TextStyle(
                          fontSize: 10,
                          color: isUnlocked ? AppTheme.textMuted : AppTheme.divider,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            _buildWeeklyChallenges(context),
          ],
        ),
      ),
    );
  }

  Widget _buildLevelCard(BuildContext context) {
    final level = StorageService.level;
    final xp = StorageService.xp;
    final nextXp = StorageService.xpForNextLevel;
    final levelTitles = [
      'Seedling', 'Sprout', 'Sapling', 'Blooming', 'Practitioner',
      'Devoted', 'Yogi', 'Master', 'Guru', 'Enlightened'
    ];
    final title = level <= levelTitles.length ? levelTitles[level - 1] : 'Enlightened';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.primary, Color(0xFF6B4E0A)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(14),
            ),
            alignment: Alignment.center,
            child: Text('$level', style: const TextStyle(
              color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white)),
                const SizedBox(height: 4),
                Text('$xp / $nextXp XP',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white70)),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: (xp / nextXp).clamp(0.0, 1.0),
                    minHeight: 6,
                    backgroundColor: Colors.white24,
                    valueColor: const AlwaysStoppedAnimation(Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyChallenges(BuildContext context) {
    final challenges = [
      {'title': 'Try 3 new poses', 'progress': '1/3', 'done': false},
      {'title': 'Practice 5 days this week', 'progress': '${_weekDays()}/5', 'done': _weekDays() >= 5},
      {'title': 'Complete a breathing session', 'progress': _hasBreathing() ? '✓' : '0/1', 'done': _hasBreathing()},
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Weekly Challenges', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          ...challenges.map((c) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              children: [
                Icon(
                  c['done'] as bool ? Icons.check_circle : Icons.radio_button_unchecked,
                  color: c['done'] as bool ? AppTheme.secondary : AppTheme.textMuted,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Expanded(child: Text(c['title'] as String,
                    style: Theme.of(context).textTheme.bodyLarge)),
                Text(c['progress'] as String,
                    style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          )),
        ],
      ),
    );
  }

  int _weekDays() {
    final history = StorageService.getPracticeHistory();
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    return history.where((e) {
      final date = DateTime.tryParse(e['date'] ?? '');
      return date != null && date.isAfter(weekStart.subtract(const Duration(days: 1)));
    }).map((e) => e['date']).toSet().length;
  }

  bool _hasBreathing() {
    final history = StorageService.getPracticeHistory();
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    return history.any((e) {
      final date = DateTime.tryParse(e['date'] ?? '');
      return date != null &&
          date.isAfter(weekStart.subtract(const Duration(days: 1))) &&
          e['type'] == 'breathing';
    });
  }
}
