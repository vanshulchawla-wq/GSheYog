import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:confetti/confetti.dart';
import '../theme.dart';
import '../data/yoga_data.dart';
import '../models/yoga_models.dart';
import '../services/storage_service.dart';
import 'mood_checkin_screen.dart';

class RoutineScreen extends StatefulWidget {
  const RoutineScreen({super.key});

  @override
  State<RoutineScreen> createState() => _RoutineScreenState();
}

class _RoutineScreenState extends State<RoutineScreen> {
  int _selectedDuration = 10; // minutes
  String _selectedType = 'body';
  bool _sessionStarted = false;

  @override
  Widget build(BuildContext context) {
    if (_sessionStarted) {
      return _ActiveSession(
        duration: _selectedDuration,
        type: _selectedType,
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Guided Routine')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Create Your Flow', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 8),
            Text('Choose duration and type, we\'ll guide you through',
                style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 28),
            Text('Duration', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            _buildDurationPicker(),
            const SizedBox(height: 28),
            Text('Type', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            _buildTypePicker(),
            const SizedBox(height: 28),
            _buildPreview(),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => setState(() => _sessionStarted = true),
                icon: const Icon(Icons.play_arrow),
                label: const Text('Start Session'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
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

  Widget _buildDurationPicker() {
    final durations = [5, 10, 15, 20, 30];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: durations.map((d) {
        final selected = d == _selectedDuration;
        return GestureDetector(
          onTap: () => setState(() => _selectedDuration = d),
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: selected ? AppTheme.primary : AppTheme.cardBg,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: selected ? AppTheme.primary : AppTheme.divider),
            ),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('$d',
                    style: TextStyle(
                      color: selected ? Colors.white : AppTheme.textDark,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    )),
                Text('min',
                    style: TextStyle(
                      color: selected ? Colors.white70 : AppTheme.textMuted,
                      fontSize: 10,
                    )),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTypePicker() {
    final types = [
      {'id': 'body', 'icon': '🧘', 'label': 'Body Yoga'},
      {'id': 'face', 'icon': '😊', 'label': 'Face Yoga'},
      {'id': 'mix', 'icon': '✨', 'label': 'Mixed'},
    ];

    return Row(
      children: types.map((t) {
        final selected = t['id'] == _selectedType;
        return Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _selectedType = t['id']!),
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: selected ? AppTheme.primary.withValues(alpha: 0.1) : AppTheme.cardBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: selected ? AppTheme.primary : AppTheme.divider,
                  width: selected ? 2 : 1,
                ),
              ),
              child: Column(
                children: [
                  Text(t['icon']!, style: const TextStyle(fontSize: 24)),
                  const SizedBox(height: 4),
                  Text(t['label']!,
                      style: TextStyle(
                        fontSize: 12,
                        color: selected ? AppTheme.primary : AppTheme.textMuted,
                        fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                      )),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPreview() {
    final poses = _getPosesForSession();
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
          Text('Session Preview', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text('${poses.length} poses • ~$_selectedDuration min',
              style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 10),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: poses.take(6).map((p) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(p.name, style: const TextStyle(fontSize: 11, color: AppTheme.primary)),
            )).toList(),
          ),
        ],
      ),
    );
  }

  List<YogaPose> _getPosesForSession() {
    List<YogaPose> pool;
    if (_selectedType == 'face') {
      pool = YogaData.facePoses;
    } else if (_selectedType == 'body') {
      pool = YogaData.bodyPoses;
    } else {
      pool = [...YogaData.bodyPoses.take(5), ...YogaData.facePoses.take(3)];
    }
    final count = (_selectedDuration / 2).ceil().clamp(3, pool.length);
    return pool.take(count).toList();
  }
}

class _ActiveSession extends StatefulWidget {
  final int duration;
  final String type;
  const _ActiveSession({required this.duration, required this.type});

  @override
  State<_ActiveSession> createState() => _ActiveSessionState();
}

class _ActiveSessionState extends State<_ActiveSession> {
  late List<YogaPose> _poses;
  int _currentPoseIndex = 0;
  int _secondsRemaining = 0;
  int _totalSecondsPerPose = 0;
  Timer? _timer;
  bool _paused = false;
  bool _completed = false;
  final _audioPlayer = AudioPlayer();
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
    _setupSession();
  }

  void _setupSession() {
    List<YogaPose> pool;
    if (widget.type == 'face') {
      pool = YogaData.facePoses;
    } else if (widget.type == 'body') {
      pool = YogaData.bodyPoses;
    } else {
      pool = [...YogaData.bodyPoses.take(5), ...YogaData.facePoses.take(3)];
    }
    final count = (widget.duration / 2).ceil().clamp(3, pool.length);
    _poses = pool.take(count).toList();
    _totalSecondsPerPose = (widget.duration * 60) ~/ _poses.length;
    _secondsRemaining = _totalSecondsPerPose;
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_paused) return;
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          _nextPose();
        }
      });
    });
  }

  void _nextPose() {
    if (_currentPoseIndex < _poses.length - 1) {
      _playBell();
      setState(() {
        _currentPoseIndex++;
        _secondsRemaining = _totalSecondsPerPose;
      });
    } else {
      _completeSession();
    }
  }

  void _playBell() async {
    try {
      await _audioPlayer.play(AssetSource('audio/bell.mp3'));
    } catch (_) {
      // Audio file may not exist, that's ok
    }
  }

  void _completeSession() async {
    _timer?.cancel();
    _confettiController.play();
    await StorageService.logPractice(minutes: widget.duration, type: widget.type);
    await StorageService.checkAndUnlockBadges();
    setState(() => _completed = true);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _audioPlayer.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_completed) return _buildCompletionScreen();

    final pose = _poses[_currentPoseIndex];
    final progress = 1 - (_secondsRemaining / _totalSecondsPerPose);

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Top bar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () => _showExitDialog(),
                        icon: const Icon(Icons.close),
                      ),
                      Text(
                        '${_currentPoseIndex + 1} / ${_poses.length}',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      IconButton(
                        onPressed: () => _nextPose(),
                        icon: const Icon(Icons.skip_next),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Pose image
                  Expanded(
                    flex: 3,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        pose.imageUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        errorBuilder: (_, __, ___) => Container(
                          color: AppTheme.divider,
                          child: const Center(
                            child: Icon(Icons.self_improvement, size: 64, color: AppTheme.primary),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Pose info
                  Text(pose.name, style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 4),
                  Text(pose.sanskritName,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontStyle: FontStyle.italic)),
                  const SizedBox(height: 16),
                  // Timer
                  Text(
                    _formatTime(_secondsRemaining),
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          fontSize: 48,
                          color: AppTheme.primary,
                        ),
                  ),
                  const SizedBox(height: 12),
                  // Progress bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 6,
                      backgroundColor: AppTheme.divider,
                      valueColor: const AlwaysStoppedAnimation(AppTheme.primary),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Controls
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () => setState(() => _paused = !_paused),
                        icon: Icon(_paused ? Icons.play_circle_filled : Icons.pause_circle_filled),
                        iconSize: 56,
                        color: AppTheme.primary,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    pose.description,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompletionScreen() {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                colors: const [AppTheme.primary, AppTheme.secondary, AppTheme.accent, AppTheme.primaryLight],
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('🎉', style: TextStyle(fontSize: 64)),
                    const SizedBox(height: 20),
                    Text('Session Complete!',
                        style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(height: 8),
                    Text(
                      '${widget.duration} min • ${_poses.length} poses',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '+${widget.duration * 10 + 50} XP earned!',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppTheme.primary),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '🔥 ${StorageService.currentStreak} day streak',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const MoodCheckinScreen()),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('How do you feel?'),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () => Navigator.of(context).popUntil((r) => r.isFirst),
                      child: const Text('Back to Home'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  void _showExitDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('End Session?'),
        content: const Text('Your progress won\'t be saved.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Continue')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('End'),
          ),
        ],
      ),
    );
  }
}
