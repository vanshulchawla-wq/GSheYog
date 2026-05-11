import 'package:flutter/material.dart';
import '../theme.dart';
import '../services/storage_service.dart';
import '../services/notification_service.dart';
import 'badges_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late bool _reminderEnabled;
  late int _reminderHour;
  late int _reminderMinute;
  late int _weeklyGoal;
  late int _dailyGoal;

  @override
  void initState() {
    super.initState();
    _reminderEnabled = StorageService.reminderEnabled;
    _reminderHour = StorageService.reminderHour;
    _reminderMinute = StorageService.reminderMinute;
    _weeklyGoal = StorageService.weeklyGoalDays;
    _dailyGoal = StorageService.dailyGoalMinutes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildSection('Daily Reminder', [
            SwitchListTile(
              title: const Text('Enable Reminder'),
              subtitle: Text(_reminderEnabled
                  ? 'Daily at ${_formatTime(_reminderHour, _reminderMinute)}'
                  : 'Off'),
              value: _reminderEnabled,
              activeThumbColor: AppTheme.primary,
              onChanged: (v) async {
                setState(() => _reminderEnabled = v);
                await StorageService.setReminder(_reminderHour, _reminderMinute, v);
                if (v) {
                  await NotificationService.requestPermissions();
                  await NotificationService.scheduleDailyReminder();
                } else {
                  await NotificationService.cancelAll();
                }
              },
            ),
            if (_reminderEnabled)
              ListTile(
                title: const Text('Reminder Time'),
                trailing: Text(_formatTime(_reminderHour, _reminderMinute)),
                onTap: () async {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay(hour: _reminderHour, minute: _reminderMinute),
                  );
                  if (time != null) {
                    setState(() {
                      _reminderHour = time.hour;
                      _reminderMinute = time.minute;
                    });
                    await StorageService.setReminder(_reminderHour, _reminderMinute, true);
                    await NotificationService.scheduleDailyReminder();
                  }
                },
              ),
          ]),
          const SizedBox(height: 16),
          _buildSection('Goals', [
            ListTile(
              title: const Text('Weekly Goal'),
              subtitle: Text('$_weeklyGoal days per week'),
              trailing: SizedBox(
                width: 120,
                child: Slider(
                  value: _weeklyGoal.toDouble(),
                  min: 1,
                  max: 7,
                  divisions: 6,
                  activeColor: AppTheme.primary,
                  onChanged: (v) async {
                    setState(() => _weeklyGoal = v.toInt());
                    await StorageService.setWeeklyGoal(v.toInt());
                  },
                ),
              ),
            ),
            ListTile(
              title: const Text('Daily Goal'),
              subtitle: Text('$_dailyGoal minutes'),
              trailing: SizedBox(
                width: 120,
                child: Slider(
                  value: _dailyGoal.toDouble(),
                  min: 5,
                  max: 60,
                  divisions: 11,
                  activeColor: AppTheme.primary,
                  onChanged: (v) async {
                    setState(() => _dailyGoal = v.toInt());
                    await StorageService.setDailyGoal(v.toInt());
                  },
                ),
              ),
            ),
          ]),
          const SizedBox(height: 16),
          _buildSection('Profile', [
            ListTile(
              title: const Text('Achievements'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const BadgesScreen()),
              ),
            ),
            ListTile(
              title: const Text('Streak Freezes'),
              subtitle: Text('${StorageService.streakFreezes} remaining'),
              trailing: const Icon(Icons.ac_unit),
            ),
          ]),
          const SizedBox(height: 16),
          _buildSection('About', [
            const ListTile(
              title: Text('Yoga By Gargi'),
              subtitle: Text('Version 2.0.0 • Your Yoga Companion'),
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppTheme.cardBg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppTheme.divider),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  String _formatTime(int h, int m) {
    final period = h >= 12 ? 'PM' : 'AM';
    final hour = h > 12 ? h - 12 : (h == 0 ? 12 : h);
    return '$hour:${m.toString().padLeft(2, '0')} $period';
  }
}
