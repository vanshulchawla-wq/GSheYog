import 'package:flutter/material.dart';
import '../theme.dart';
import '../services/storage_service.dart';

class MoodCheckinScreen extends StatefulWidget {
  const MoodCheckinScreen({super.key});

  @override
  State<MoodCheckinScreen> createState() => _MoodCheckinScreenState();
}

class _MoodCheckinScreenState extends State<MoodCheckinScreen> {
  String? _selectedMood;

  final _moods = [
    {'emoji': '😌', 'label': 'Calm'},
    {'emoji': '😊', 'label': 'Happy'},
    {'emoji': '💪', 'label': 'Energized'},
    {'emoji': '😴', 'label': 'Relaxed'},
    {'emoji': '🧘', 'label': 'Centered'},
    {'emoji': '✨', 'label': 'Refreshed'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('🙏', style: TextStyle(fontSize: 48)),
              const SizedBox(height: 16),
              Text('How do you feel now?',
                  style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 8),
              Text('Track your emotional progress over time',
                  style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 32),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.1,
                ),
                itemCount: _moods.length,
                itemBuilder: (_, i) {
                  final mood = _moods[i];
                  final selected = _selectedMood == mood['label'];
                  return GestureDetector(
                    onTap: () => setState(() => _selectedMood = mood['label']),
                    child: Container(
                      decoration: BoxDecoration(
                        color: selected
                            ? AppTheme.primary.withValues(alpha: 0.1)
                            : AppTheme.cardBg,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: selected ? AppTheme.primary : AppTheme.divider,
                          width: selected ? 2 : 1,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(mood['emoji']!, style: const TextStyle(fontSize: 32)),
                          const SizedBox(height: 6),
                          Text(mood['label']!,
                              style: TextStyle(
                                fontSize: 12,
                                color: selected ? AppTheme.primary : AppTheme.textMuted,
                                fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                              )),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _selectedMood != null ? _save : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Save & Continue'),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => Navigator.of(context).popUntil((r) => r.isFirst),
                child: const Text('Skip'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _save() async {
    await StorageService.logMood('before_session', _selectedMood!);
    if (mounted) Navigator.of(context).popUntil((r) => r.isFirst);
  }
}
