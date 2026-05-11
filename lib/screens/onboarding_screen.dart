import 'package:flutter/material.dart';
import '../theme.dart';
import '../services/storage_service.dart';

class OnboardingScreen extends StatefulWidget {
  final VoidCallback onComplete;
  const OnboardingScreen({super.key, required this.onComplete});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _page = 0;
  String _goal = 'flexibility';
  String _level = 'beginner';
  String _time = 'morning';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // Progress dots
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (i) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _page == i ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _page == i ? AppTheme.primary : AppTheme.divider,
                    borderRadius: BorderRadius.circular(4),
                  ),
                )),
              ),
              const SizedBox(height: 40),
              Expanded(child: _buildPage()),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _next,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: Text(_page < 2 ? 'Continue' : 'Start My Journey'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPage() {
    switch (_page) {
      case 0:
        return _buildGoalPage();
      case 1:
        return _buildLevelPage();
      case 2:
        return _buildTimePage();
      default:
        return const SizedBox();
    }
  }

  Widget _buildGoalPage() {
    final goals = [
      {'id': 'flexibility', 'icon': '🤸', 'title': 'Flexibility', 'sub': 'Improve range of motion'},
      {'id': 'stress', 'icon': '🧘', 'title': 'Stress Relief', 'sub': 'Calm mind & reduce anxiety'},
      {'id': 'weight', 'icon': '🔥', 'title': 'Weight Loss', 'sub': 'Burn calories & tone up'},
      {'id': 'skin', 'icon': '✨', 'title': 'Glowing Skin', 'sub': 'Face yoga & anti-aging'},
      {'id': 'strength', 'icon': '💪', 'title': 'Build Strength', 'sub': 'Core & full body power'},
      {'id': 'sleep', 'icon': '😴', 'title': 'Better Sleep', 'sub': 'Wind down & relax'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('What\'s your goal?', style: Theme.of(context).textTheme.headlineLarge),
        const SizedBox(height: 8),
        Text('We\'ll personalize your experience', style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 24),
        Expanded(
          child: ListView.separated(
            itemCount: goals.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (_, i) => _buildOption(
              goals[i]['icon']!,
              goals[i]['title']!,
              goals[i]['sub']!,
              _goal == goals[i]['id'],
              () => setState(() => _goal = goals[i]['id']!),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLevelPage() {
    final levels = [
      {'id': 'beginner', 'icon': '🌱', 'title': 'Beginner', 'sub': 'New to yoga'},
      {'id': 'intermediate', 'icon': '🌿', 'title': 'Intermediate', 'sub': 'Some experience'},
      {'id': 'advanced', 'icon': '🌳', 'title': 'Advanced', 'sub': 'Regular practitioner'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Your experience?', style: Theme.of(context).textTheme.headlineLarge),
        const SizedBox(height: 8),
        Text('No judgment — everyone starts somewhere', style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 24),
        ...levels.map((l) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildOption(
            l['icon']!,
            l['title']!,
            l['sub']!,
            _level == l['id'],
            () => setState(() => _level = l['id']!),
          ),
        )),
      ],
    );
  }

  Widget _buildTimePage() {
    final times = [
      {'id': 'morning', 'icon': '🌅', 'title': 'Morning', 'sub': '6 AM - 9 AM'},
      {'id': 'afternoon', 'icon': '☀️', 'title': 'Afternoon', 'sub': '12 PM - 3 PM'},
      {'id': 'evening', 'icon': '🌙', 'title': 'Evening', 'sub': '6 PM - 9 PM'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Best time to practice?', style: Theme.of(context).textTheme.headlineLarge),
        const SizedBox(height: 8),
        Text('We\'ll remind you at the right moment', style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 24),
        ...times.map((t) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildOption(
            t['icon']!,
            t['title']!,
            t['sub']!,
            _time == t['id'],
            () => setState(() => _time = t['id']!),
          ),
        )),
      ],
    );
  }

  Widget _buildOption(String icon, String title, String sub, bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected ? AppTheme.primary.withValues(alpha: 0.08) : AppTheme.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? AppTheme.primary : AppTheme.divider,
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Text(icon, style: const TextStyle(fontSize: 28)),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleMedium),
                  Text(sub, style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ),
            if (selected)
              const Icon(Icons.check_circle, color: AppTheme.primary),
          ],
        ),
      ),
    );
  }

  Future<void> _next() async {
    if (_page < 2) {
      setState(() => _page++);
    } else {
      await StorageService.saveOnboardingData(goal: _goal, level: _level, time: _time);
      await StorageService.completeOnboarding();
      widget.onComplete();
    }
  }
}
