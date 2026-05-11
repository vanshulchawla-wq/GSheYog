import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;
import 'storage_service.dart';

class NotificationService {
  static final _plugin = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    tz_data.initializeTimeZones();

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    await _plugin.initialize(
      const InitializationSettings(android: androidSettings, iOS: iosSettings),
    );
  }

  static Future<void> requestPermissions() async {
    await _plugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  static Future<void> scheduleDailyReminder() async {
    if (!StorageService.reminderEnabled) {
      await cancelAll();
      return;
    }

    final hour = StorageService.reminderHour;
    final minute = StorageService.reminderMinute;

    await _plugin.zonedSchedule(
      0,
      'Time for Yoga 🧘‍♀️',
      'Your mat is waiting. Just ${StorageService.dailyGoalMinutes} minutes today!',
      _nextInstanceOfTime(hour, minute),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_reminder',
          'Daily Reminder',
          channelDescription: 'Daily yoga practice reminder',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  static Future<void> scheduleStreakAtRisk() async {
    if (StorageService.practicedToday) return;

    final now = DateTime.now();
    if (now.hour < 20) {
      final evening = tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        now.day,
        20,
        0,
      );

      await _plugin.zonedSchedule(
        1,
        'Streak at risk! 🔥',
        'Don\'t break your ${StorageService.currentStreak}-day streak. A quick session is all you need!',
        evening,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'streak_alert',
            'Streak Alert',
            channelDescription: 'Streak at risk notifications',
            importance: Importance.high,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      );
    }
  }

  static Future<void> scheduleMidDayNudge() async {
    final now = DateTime.now();
    final nudgeTime = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      14,
      0,
    );

    if (nudgeTime.isAfter(now)) {
      await _plugin.zonedSchedule(
        2,
        'Mindful Moment 😊',
        'Take 2 minutes for a quick face yoga break. Your skin will thank you!',
        nudgeTime,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'midday_nudge',
            'Mindful Moments',
            channelDescription: 'Midday face yoga reminders',
            importance: Importance.defaultImportance,
          ),
          iOS: DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      );
    }
  }

  static tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }

  static Future<void> cancelAll() => _plugin.cancelAll();
}
