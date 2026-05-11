import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

class StorageService {
  static late Box _userBox;
  static late Box _practiceBox;
  static late Box _settingsBox;

  static Future<void> init() async {
    await Hive.initFlutter();
    _userBox = await Hive.openBox('user');
    _practiceBox = await Hive.openBox('practice');
    _settingsBox = await Hive.openBox('settings');
  }

  // --- Streak ---
  static int get currentStreak => _userBox.get('streak', defaultValue: 0);
  static int get longestStreak => _userBox.get('longestStreak', defaultValue: 0);
  static int get totalDays => _userBox.get('totalDays', defaultValue: 0);
  static int get totalMinutes => _userBox.get('totalMinutes', defaultValue: 0);
  static int get xp => _userBox.get('xp', defaultValue: 0);
  static int get level => _userBox.get('level', defaultValue: 1);
  static int get streakFreezes => _userBox.get('streakFreezes', defaultValue: 1);

  static String? get lastPracticeDate => _userBox.get('lastPracticeDate');

  static bool get practicedToday {
    final last = lastPracticeDate;
    if (last == null) return false;
    return last == _todayStr;
  }

  static String get _todayStr => DateFormat('yyyy-MM-dd').format(DateTime.now());

  static Future<void> logPractice({required int minutes, required String type}) async {
    final today = _todayStr;
    final last = lastPracticeDate;

    if (last != today) {
      final yesterday = DateFormat('yyyy-MM-dd')
          .format(DateTime.now().subtract(const Duration(days: 1)));

      if (last == yesterday) {
        await _userBox.put('streak', currentStreak + 1);
      } else if (last != null && last != yesterday) {
        // Streak broken - check freeze
        if (streakFreezes > 0) {
          await _userBox.put('streakFreezes', streakFreezes - 1);
          await _userBox.put('streak', currentStreak + 1);
        } else {
          await _userBox.put('streak', 1);
        }
      } else {
        await _userBox.put('streak', 1);
      }

      await _userBox.put('totalDays', totalDays + 1);
      await _userBox.put('lastPracticeDate', today);

      if (currentStreak > longestStreak) {
        await _userBox.put('longestStreak', currentStreak);
      }
    }

    await _userBox.put('totalMinutes', totalMinutes + minutes);

    // XP: 10 per minute + 50 bonus for daily completion
    final earnedXp = minutes * 10 + (last != today ? 50 : 0);
    await _userBox.put('xp', xp + earnedXp);
    await _updateLevel();

    // Log to practice history
    final history = getPracticeHistory();
    history.add({
      'date': today,
      'minutes': minutes,
      'type': type,
      'timestamp': DateTime.now().toIso8601String(),
    });
    await _practiceBox.put('history', history);
  }

  static Future<void> _updateLevel() async {
    // Level thresholds: 0, 500, 1500, 3000, 5000, 8000, 12000, 17000, 23000, 30000
    final thresholds = [0, 500, 1500, 3000, 5000, 8000, 12000, 17000, 23000, 30000];
    int newLevel = 1;
    for (int i = 0; i < thresholds.length; i++) {
      if (xp >= thresholds[i]) newLevel = i + 1;
    }
    await _userBox.put('level', newLevel);
  }

  static int get xpForNextLevel {
    final thresholds = [0, 500, 1500, 3000, 5000, 8000, 12000, 17000, 23000, 30000];
    if (level >= thresholds.length) return thresholds.last;
    return thresholds[level];
  }

  static List<dynamic> getPracticeHistory() {
    return List.from(_practiceBox.get('history', defaultValue: []));
  }

  static Map<String, int> getWeeklyMinutes() {
    final history = getPracticeHistory();
    final now = DateTime.now();
    final Map<String, int> weekly = {};

    for (int i = 6; i >= 0; i--) {
      final day = now.subtract(Duration(days: i));
      final key = DateFormat('yyyy-MM-dd').format(day);
      weekly[key] = 0;
    }

    for (final entry in history) {
      final date = entry['date'] as String;
      if (weekly.containsKey(date)) {
        weekly[date] = (weekly[date] ?? 0) + (entry['minutes'] as int);
      }
    }
    return weekly;
  }

  static Set<String> getPracticedDates() {
    final history = getPracticeHistory();
    return history.map((e) => e['date'] as String).toSet();
  }

  // --- Badges ---
  static List<String> get unlockedBadges =>
      List<String>.from(_userBox.get('badges', defaultValue: <String>[]));

  static Future<List<String>> checkAndUnlockBadges() async {
    final badges = List<String>.from(unlockedBadges);
    final newBadges = <String>[];

    final allBadges = {
      'first_session': totalDays >= 1,
      '7_day_warrior': currentStreak >= 7,
      '30_day_lotus': currentStreak >= 30,
      'century': totalDays >= 100,
      'hour_power': totalMinutes >= 60,
      'dedicated_10h': totalMinutes >= 600,
      'level_5': level >= 5,
      'level_10': level >= 10,
      'early_bird': true, // unlocked on first morning session
      'face_yoga_fan': getPracticeHistory().where((e) => e['type'] == 'face').length >= 10,
    };

    for (final entry in allBadges.entries) {
      if (entry.value && !badges.contains(entry.key)) {
        badges.add(entry.key);
        newBadges.add(entry.key);
      }
    }

    await _userBox.put('badges', badges);
    return newBadges;
  }

  // --- Goals ---
  static int get weeklyGoalDays => _settingsBox.get('weeklyGoalDays', defaultValue: 4);
  static Future<void> setWeeklyGoal(int days) => _settingsBox.put('weeklyGoalDays', days);

  static int get dailyGoalMinutes => _settingsBox.get('dailyGoalMinutes', defaultValue: 15);
  static Future<void> setDailyGoal(int mins) => _settingsBox.put('dailyGoalMinutes', mins);

  // --- Reminder ---
  static int get reminderHour => _settingsBox.get('reminderHour', defaultValue: 7);
  static int get reminderMinute => _settingsBox.get('reminderMinute', defaultValue: 0);
  static bool get reminderEnabled => _settingsBox.get('reminderEnabled', defaultValue: false);

  static Future<void> setReminder(int hour, int minute, bool enabled) async {
    await _settingsBox.put('reminderHour', hour);
    await _settingsBox.put('reminderMinute', minute);
    await _settingsBox.put('reminderEnabled', enabled);
  }

  // --- Onboarding ---
  static bool get onboardingDone => _settingsBox.get('onboardingDone', defaultValue: false);
  static Future<void> completeOnboarding() => _settingsBox.put('onboardingDone', true);

  static String get userGoal => _settingsBox.get('userGoal', defaultValue: 'flexibility');
  static String get userLevel => _settingsBox.get('userLevel', defaultValue: 'beginner');
  static String get preferredTime => _settingsBox.get('preferredTime', defaultValue: 'morning');

  static Future<void> saveOnboardingData({
    required String goal,
    required String level,
    required String time,
  }) async {
    await _settingsBox.put('userGoal', goal);
    await _settingsBox.put('userLevel', level);
    await _settingsBox.put('preferredTime', time);
  }

  // --- Mood ---
  static Future<void> logMood(String before, String after) async {
    final moods = List.from(_practiceBox.get('moods', defaultValue: []));
    moods.add({
      'date': _todayStr,
      'before': before,
      'after': after,
    });
    await _practiceBox.put('moods', moods);
  }

  static List<dynamic> getMoodHistory() =>
      List.from(_practiceBox.get('moods', defaultValue: []));

  // --- Poses Unlocked ---
  static Set<String> get unlockedPoses =>
      Set<String>.from(_userBox.get('unlockedPoses', defaultValue: <String>[]));

  static Future<void> unlockPose(String poseName) async {
    final poses = unlockedPoses;
    poses.add(poseName);
    await _userBox.put('unlockedPoses', poses.toList());
  }
}
