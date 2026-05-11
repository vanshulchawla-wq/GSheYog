import 'dart:async';
import 'package:flutter/material.dart';
import '../theme.dart';
import '../services/storage_service.dart';

class BreathingScreen extends StatefulWidget {
  const BreathingScreen({super.key});

  @override
  State<BreathingScreen> createState() => _BreathingScreenState();
}

class _BreathingScreenState extends State<BreathingScreen> with SingleTickerProviderStateMixin {
  int _selectedExercise = 0;
  bool _active = false;
  String _phase = 'Inhale';
  int _phaseSeconds = 0;
  int _totalSeconds = 0;
  int _cycles = 0;
  Timer? _timer;
  late AnimationController _animController;
  late Animation<double> _scaleAnim;

  final _exercises = const [
    {
      'name': 'Box Breathing',
      'icon': '⬜',
      'desc': 'Equal inhale, hold, exhale, hold. Calms the nervous system.',
      'inhale': 4, 'hold1': 4, 'exhale': 4, 'hold2': 4,
    },
    {
      'name': '4-7-8 Relaxing',
      'icon': '🌙',
      'desc': 'Inhale 4, hold 7, exhale 8. Perfect for sleep and anxiety.',
      'inhale': 4, 'hold1': 7, 'exhale': 8, 'hold2': 0,
    },
    {
      'name': 'Energizing Breath',
      'icon': '⚡',
      'desc': 'Quick inhale and exhale to boost energy and alertness.',
      'inhale': 2, 'hold1': 0, 'exhale': 2, 'hold2': 0,
    },
    {
      'name': 'Deep Calm',
      'icon': '🕊️',
      'desc': 'Long exhale activates parasympathetic response for deep calm.',
      'inhale': 4, 'hold1': 2, 'exhale': 8, 'hold2': 2,
    },
  ];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(vsync: this, duration: const Duration(seconds: 4));
    _scaleAnim = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animController.dispose();
    super.dispose();
  }

  void _startExercise() {
    setState(() {
      _active = true;
      _cycles = 0;
      _totalSeconds = 0;
    });
    _startPhase('Inhale');
  }

  void _startPhase(String phase) {
    final ex = _exercises[_selectedExercise];
    int duration;
    switch (phase) {
      case 'Inhale':
        duration = ex['inhale'] as int;
        _animController.duration = Duration(seconds: duration);
        _animController.forward(from: 0);
        break;
      case 'Hold':
        duration = ex['hold1'] as int;
        break;
      case 'Exhale':
        duration = ex['exhale'] as int;
        _animController.duration = Duration(seconds: duration);
        _animController.reverse(from: 1);
        break;
      case 'Hold 2':
        duration = ex['hold2'] as int;
        break;
      default:
        duration = 4;
    }

    if (duration == 0) {
      _advancePhase(phase);
      return;
    }

    setState(() {
      _phase = phase;
      _phaseSeconds = duration;
    });

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _phaseSeconds--;
        _totalSeconds++;
      });
      if (_phaseSeconds <= 0) {
        _timer?.cancel();
        _advancePhase(phase);
      }
    });
  }

  void _advancePhase(String current) {
    switch (current) {
      case 'Inhale':
        _startPhase('Hold');
        break;
      case 'Hold':
        _startPhase('Exhale');
        break;
      case 'Exhale':
        _startPhase('Hold 2');
        break;
      case 'Hold 2':
        setState(() => _cycles++);
        if (_cycles >= 8) {
          _completeExercise();
        } else {
          _startPhase('Inhale');
        }
        break;
    }
  }

  void _completeExercise() async {
    _timer?.cancel();
    final mins = (_totalSeconds / 60).ceil().clamp(1, 30);
    await StorageService.logPractice(minutes: mins, type: 'breathing');
    setState(() => _active = false);

    if (mounted) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('🕊️ Well Done!'),
          content: Text('$_cycles cycles completed.\n+${mins * 10 + 50} XP earned.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('Done'),
            ),
          ],
        ),
      );
    }
  }

  void _stop() {
    _timer?.cancel();
    _animController.stop();
    setState(() => _active = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_active) return _buildActiveView();

    return Scaffold(
      appBar: AppBar(title: const Text('Breathing')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Pranayama', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 4),
            Text('Breathwork for calm, energy & focus',
                style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 24),
            ...List.generate(_exercises.length, (i) {
              final ex = _exercises[i];
              final selected = i == _selectedExercise;
              return GestureDetector(
                onTap: () => setState(() => _selectedExercise = i),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: selected ? AppTheme.primary.withValues(alpha: 0.08) : AppTheme.cardBg,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: selected ? AppTheme.primary : AppTheme.divider,
                      width: selected ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(ex['icon'] as String, style: const TextStyle(fontSize: 28)),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(ex['name'] as String,
                                style: Theme.of(context).textTheme.titleMedium),
                            Text(ex['desc'] as String,
                                style: Theme.of(context).textTheme.bodyMedium),
                          ],
                        ),
                      ),
                      if (selected) const Icon(Icons.check_circle, color: AppTheme.primary),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _startExercise,
                icon: const Icon(Icons.air),
                label: const Text('Begin'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.secondary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveView() {
    final ex = _exercises[_selectedExercise];
    Color phaseColor;
    switch (_phase) {
      case 'Inhale':
        phaseColor = AppTheme.secondary;
        break;
      case 'Exhale':
        phaseColor = AppTheme.accent;
        break;
      default:
        phaseColor = AppTheme.primary;
    }

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(onPressed: _stop, icon: const Icon(Icons.close)),
                  Text('Cycle ${_cycles + 1}/8', style: Theme.of(context).textTheme.titleMedium),
                  Text(ex['name'] as String, style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: AnimatedBuilder(
                  animation: _scaleAnim,
                  builder: (_, __) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 200 * _scaleAnim.value,
                          height: 200 * _scaleAnim.value,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: phaseColor.withValues(alpha: 0.15),
                            border: Border.all(color: phaseColor, width: 3),
                          ),
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '$_phaseSeconds',
                                style: TextStyle(
                                  fontSize: 48,
                                  fontWeight: FontWeight.bold,
                                  color: phaseColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),
                        Text(
                          _phase,
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: phaseColor),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _getPhaseInstruction(),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(32),
              child: ElevatedButton(
                onPressed: _stop,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.divider,
                  foregroundColor: AppTheme.textDark,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Stop'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getPhaseInstruction() {
    switch (_phase) {
      case 'Inhale':
        return 'Breathe in slowly through your nose';
      case 'Hold':
      case 'Hold 2':
        return 'Hold gently, stay relaxed';
      case 'Exhale':
        return 'Release slowly through your mouth';
      default:
        return '';
    }
  }
}
