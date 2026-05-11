import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../theme.dart';
import '../services/storage_service.dart';
import 'badges_screen.dart';
import 'settings_screen.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Your Progress', style: Theme.of(context).textTheme.headlineMedium),
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BadgesScreen())),
                      icon: const Icon(Icons.emoji_events, color: AppTheme.primary),
                    ),
                    IconButton(
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen())),
                      icon: const Icon(Icons.settings, color: AppTheme.textMuted),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text('Keep showing up — you\'re doing great',
                style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 24),
            _buildStreakCard(context),
            const SizedBox(height: 16),
            _buildXpCard(context),
            const SizedBox(height: 20),
            _buildStatsRow(context),
            const SizedBox(height: 24),
            Text('This Week', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            _buildWeeklyChart(context),
            const SizedBox(height: 24),
            Text('Practice Calendar', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            _buildCalendarHeatmap(context),
          ],
        ),
      ),
    );
  }

  Widget _buildStreakCard(BuildContext context) {
    final streak = StorageService.currentStreak;
    final longest = StorageService.longestStreak;
    final practicedToday = StorageService.practicedToday;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: practicedToday
              ? [AppTheme.secondary, const Color(0xFF3D4A28)]
              : [AppTheme.accent, const Color(0xFF8B4513)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('🔥', style: const TextStyle(fontSize: 36)),
              const SizedBox(width: 10),
              Text(
                '$streak',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: Colors.white,
                      fontSize: 48,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            streak == 1 ? 'Day Streak' : 'Day Streak',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white70),
          ),
          const SizedBox(height: 8),
          Text(
            practicedToday ? '✓ Practiced today!' : 'Practice today to keep your streak!',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white60),
          ),
          const SizedBox(height: 12),
          Text(
            'Longest: $longest days',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white54),
          ),
        ],
      ),
    );
  }

  Widget _buildXpCard(BuildContext context) {
    final xp = StorageService.xp;
    final level = StorageService.level;
    final nextLevelXp = StorageService.xpForNextLevel;
    final thresholds = [0, 500, 1500, 3000, 5000, 8000, 12000, 17000, 23000, 30000];
    final currentLevelXp = level <= thresholds.length ? thresholds[level - 1] : 0;
    final progress = nextLevelXp > currentLevelXp
        ? (xp - currentLevelXp) / (nextLevelXp - currentLevelXp)
        : 1.0;

    final levelTitles = [
      'Seedling', 'Sprout', 'Sapling', 'Blooming', 'Practitioner',
      'Devoted', 'Yogi', 'Master', 'Guru', 'Enlightened'
    ];
    final title = level <= levelTitles.length ? levelTitles[level - 1] : 'Enlightened';

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
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text('Lv.$level',
                    style: const TextStyle(
                        color: AppTheme.primary, fontWeight: FontWeight.bold, fontSize: 14)),
              ),
              const SizedBox(width: 10),
              Text(title, style: Theme.of(context).textTheme.titleMedium),
              const Spacer(),
              Text('$xp XP', style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              minHeight: 8,
              backgroundColor: AppTheme.divider,
              valueColor: const AlwaysStoppedAnimation(AppTheme.primary),
            ),
          ),
          const SizedBox(height: 6),
          Text('${nextLevelXp - xp} XP to next level',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildStatsRow(BuildContext context) {
    return Row(
      children: [
        _buildStatCard(context, '${StorageService.totalDays}', 'Days', Icons.calendar_today),
        const SizedBox(width: 12),
        _buildStatCard(context, '${StorageService.totalMinutes}', 'Minutes', Icons.timer),
        const SizedBox(width: 12),
        _buildStatCard(
            context, '${StorageService.unlockedBadges.length}', 'Badges', Icons.emoji_events),
      ],
    );
  }

  Widget _buildStatCard(BuildContext context, String value, String label, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppTheme.cardBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.divider),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppTheme.primary, size: 20),
            const SizedBox(height: 6),
            Text(value,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontSize: 20)),
            Text(label, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 11)),
          ],
        ),
      ),
    );
  }

  Widget _buildWeeklyChart(BuildContext context) {
    final weekly = StorageService.getWeeklyMinutes();
    final entries = weekly.entries.toList();
    final maxVal = entries.map((e) => e.value).fold(0, (a, b) => a > b ? a : b);
    final goal = StorageService.dailyGoalMinutes;

    return Container(
      height: 180,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.divider),
      ),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: (maxVal > goal ? maxVal : goal).toDouble() + 5,
          barTouchData: BarTouchData(enabled: false),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, _) {
                  final idx = value.toInt();
                  if (idx >= 0 && idx < entries.length) {
                    final date = DateTime.parse(entries[idx].key);
                    return Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        DateFormat('E').format(date).substring(0, 2),
                        style: const TextStyle(fontSize: 11, color: AppTheme.textMuted),
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          gridData: const FlGridData(show: false),
          extraLinesData: ExtraLinesData(
            horizontalLines: [
              HorizontalLine(
                y: goal.toDouble(),
                color: AppTheme.accent.withValues(alpha: 0.4),
                strokeWidth: 1,
                dashArray: [5, 5],
              ),
            ],
          ),
          barGroups: entries.asMap().entries.map((e) {
            final mins = e.value.value.toDouble();
            return BarChartGroupData(
              x: e.key,
              barRods: [
                BarChartRodData(
                  toY: mins,
                  color: mins >= goal ? AppTheme.secondary : AppTheme.primary,
                  width: 22,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildCalendarHeatmap(BuildContext context) {
    final practicedDates = StorageService.getPracticedDates();
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    final startWeekday = startOfMonth.weekday % 7;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.divider),
      ),
      child: Column(
        children: [
          Text(
            DateFormat('MMMM yyyy').format(now),
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: ['S', 'M', 'T', 'W', 'T', 'F', 'S']
                .map((d) => SizedBox(
                      width: 32,
                      child: Text(d,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 12, color: AppTheme.textMuted)),
                    ))
                .toList(),
          ),
          const SizedBox(height: 8),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
            ),
            itemCount: startWeekday + daysInMonth,
            itemBuilder: (_, i) {
              if (i < startWeekday) return const SizedBox();
              final day = i - startWeekday + 1;
              final date = DateFormat('yyyy-MM-dd').format(DateTime(now.year, now.month, day));
              final practiced = practicedDates.contains(date);
              final isToday = day == now.day;

              return Container(
                decoration: BoxDecoration(
                  color: practiced
                      ? AppTheme.secondary
                      : isToday
                          ? AppTheme.primary.withValues(alpha: 0.15)
                          : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  border: isToday ? Border.all(color: AppTheme.primary, width: 1.5) : null,
                ),
                alignment: Alignment.center,
                child: Text(
                  '$day',
                  style: TextStyle(
                    fontSize: 12,
                    color: practiced ? Colors.white : AppTheme.textDark,
                    fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _legendDot(AppTheme.secondary, 'Practiced'),
              const SizedBox(width: 16),
              _legendDot(AppTheme.primary.withValues(alpha: 0.15), 'Today'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _legendDot(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(3)),
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 11, color: AppTheme.textMuted)),
      ],
    );
  }
}
