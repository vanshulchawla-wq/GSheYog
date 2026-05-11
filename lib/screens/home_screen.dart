import 'package:flutter/material.dart';
import '../theme.dart';
import '../data/yoga_data.dart';
import '../services/storage_service.dart';
import 'pose_detail_screen.dart';
import 'video_player_screen.dart';
import 'routine_screen.dart';
import 'breathing_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: 20),
            _buildStreakBanner(context),
            const SizedBox(height: 24),
            _buildQuickActions(context),
            const SizedBox(height: 24),
            _buildDailyRecommendation(context),
            const SizedBox(height: 24),
            _buildSectionTitle(context, 'Today\'s Pick'),
            const SizedBox(height: 12),
            _buildFeaturedVideo(context),
            const SizedBox(height: 24),
            _buildSectionTitle(context, 'Popular Poses'),
            const SizedBox(height: 12),
            _buildPopularPoses(context),
            const SizedBox(height: 24),
            _buildDailyTip(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final hour = DateTime.now().hour;
    String greeting;
    if (hour < 12) {
      greeting = 'Good Morning 🌅';
    } else if (hour < 17) {
      greeting = 'Good Afternoon ☀️';
    } else {
      greeting = 'Good Evening 🌙';
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(greeting, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 4),
            Text('Yoga By Gargi', style: Theme.of(context).textTheme.headlineLarge),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: AppTheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              const Text('🔥', style: TextStyle(fontSize: 16)),
              const SizedBox(width: 4),
              Text(
                '${StorageService.currentStreak}',
                style: const TextStyle(
                    color: AppTheme.primary, fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStreakBanner(BuildContext context) {
    final practiced = StorageService.practicedToday;
    final streak = StorageService.currentStreak;
    final level = StorageService.level;
    final levelTitles = [
      'Seedling', 'Sprout', 'Sapling', 'Blooming', 'Practitioner',
      'Devoted', 'Yogi', 'Master', 'Guru', 'Enlightened'
    ];
    final title = level <= levelTitles.length ? levelTitles[level - 1] : 'Enlightened';

    if (practiced) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.secondary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppTheme.secondary.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            const Text('✅', style: TextStyle(fontSize: 24)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Done for today!', style: Theme.of(context).textTheme.titleMedium),
                  Text('$streak day streak • Lv.$level $title',
                      style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.primary, Color(0xFF6B4E0A)],
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const Text('🧘', style: TextStyle(fontSize: 28)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  streak > 0 ? 'Keep your $streak-day streak!' : 'Start your journey today!',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white),
                ),
                Text(
                  '${StorageService.dailyGoalMinutes} min goal • Lv.$level $title',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white70),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    final actions = [
      {'icon': Icons.timer, 'label': 'Guided\nRoutine', 'color': AppTheme.primary, 'screen': 'routine'},
      {'icon': Icons.air, 'label': 'Breathing\nExercise', 'color': AppTheme.secondary, 'screen': 'breathing'},
      {'icon': Icons.face, 'label': 'Face\nYoga', 'color': AppTheme.accent, 'screen': 'face'},
      {'icon': Icons.play_circle, 'label': 'Video\nClass', 'color': const Color(0xFF8B4513), 'screen': 'video'},
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: actions.map((a) {
        return GestureDetector(
          onTap: () => _handleQuickAction(context, a['screen'] as String),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: (a['color'] as Color).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(a['icon'] as IconData, color: a['color'] as Color, size: 28),
              ),
              const SizedBox(height: 8),
              Text(
                a['label'] as String,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 12),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  void _handleQuickAction(BuildContext context, String screen) {
    switch (screen) {
      case 'routine':
        Navigator.push(context, MaterialPageRoute(builder: (_) => const RoutineScreen()));
        break;
      case 'breathing':
        Navigator.push(context, MaterialPageRoute(builder: (_) => const BreathingScreen()));
        break;
      case 'face':
        Navigator.push(context, MaterialPageRoute(
          builder: (_) => PoseDetailScreen(pose: YogaData.facePoses[0]),
        ));
        break;
      case 'video':
        Navigator.push(context, MaterialPageRoute(
          builder: (_) => VideoPlayerScreen(video: YogaData.videos[0]),
        ));
        break;
    }
  }

  Widget _buildDailyRecommendation(BuildContext context) {
    final goal = StorageService.userGoal;
    String recTitle;
    String recSub;
    int videoIdx;

    switch (goal) {
      case 'stress':
        recTitle = 'Yin Yoga for Deep Relaxation';
        recSub = 'Perfect for calming your mind';
        videoIdx = 3;
        break;
      case 'weight':
        recTitle = 'Yoga for Weight Loss';
        recSub = 'Burn calories with this flow';
        videoIdx = 8;
        break;
      case 'skin':
        recTitle = 'Face Yoga Daily Routine';
        recSub = 'Glow from within';
        videoIdx = 6;
        break;
      case 'strength':
        recTitle = 'Power Yoga - Strength';
        recSub = 'Build functional strength';
        videoIdx = 2;
        break;
      case 'sleep':
        recTitle = 'Bedtime Yoga - Wind Down';
        recSub = 'Prepare for restful sleep';
        videoIdx = 5;
        break;
      default:
        recTitle = 'Vinyasa Flow - Full Body';
        recSub = 'Improve flexibility & flow';
        videoIdx = 4;
    }

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => VideoPlayerScreen(video: YogaData.videos[videoIdx])),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.cardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppTheme.divider),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppTheme.accent.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.auto_awesome, color: AppTheme.accent),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Recommended for You',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 11)),
                  Text(recTitle, style: Theme.of(context).textTheme.titleMedium),
                  Text(recSub, style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ),
            const Icon(Icons.play_circle_filled, color: AppTheme.primary, size: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(title, style: Theme.of(context).textTheme.titleLarge);
  }

  Widget _buildFeaturedVideo(BuildContext context) {
    final video = YogaData.videos[0];
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => VideoPlayerScreen(video: video)),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: AppTheme.cardBg,
          border: Border.all(color: AppTheme.divider),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Stack(
                children: [
                  Image.network(
                    video.thumbnail,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 180,
                      color: AppTheme.divider,
                      child: const Center(child: Icon(Icons.play_circle, size: 48)),
                    ),
                  ),
                  Positioned.fill(
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: const BoxDecoration(
                          color: Colors.white70,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.play_arrow, color: AppTheme.primary, size: 32),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(video.title, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text('${video.instructor} • ${video.duration} • ${video.level}',
                      style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPopularPoses(BuildContext context) {
    final poses = YogaData.bodyPoses.take(4).toList();
    return SizedBox(
      height: 160,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: poses.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, i) {
          final pose = poses[i];
          return GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => PoseDetailScreen(pose: pose)),
            ),
            child: Container(
              width: 130,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: AppTheme.cardBg,
                border: Border.all(color: AppTheme.divider),
              ),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
                    child: Image.network(
                      pose.imageUrl,
                      height: 100,
                      width: 130,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        height: 100,
                        width: 130,
                        color: AppTheme.divider,
                        child: const Icon(Icons.self_improvement),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      pose.name,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                      maxLines: 2,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDailyTip(BuildContext context) {
    final tips = [
      'Practice on an empty stomach. Morning is the best time for yoga.',
      'Focus on your breath — it\'s the bridge between body and mind.',
      'Consistency beats intensity. 10 minutes daily > 1 hour weekly.',
      'Listen to your body. Pain is not gain in yoga.',
      'Hydrate well before and after your practice.',
      'Face yoga works best when done with clean, moisturized skin.',
      'End every session with 2 minutes of stillness.',
    ];
    final tip = tips[DateTime.now().day % tips.length];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.accent.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.accent.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          const Text('💡', style: TextStyle(fontSize: 28)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Daily Tip', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 4),
                Text(tip, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
