import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  late final Future<void> _initialized;

  NotificationService() {
    _initialized = _init();
  }

  Future<void> _init() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notificationsPlugin.initialize(initSettings);

    // Crear canal 
    final androidPlugin = _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    await androidPlugin?.createNotificationChannel(
      const AndroidNotificationChannel(
        'daily_channel_id',
        'Daily Notifications',
        description: 'Notificaciones diarias programadas',
        importance: Importance.max,
      ),
    );

    // Inicializar zonas horarias
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('America/Havana'));
  }

  Future<void> addDailyAlert({
    required int notificationId,
    required TimeOfDay time,
    required String title,
    required String body,
  }) async {
    await _initialized;

    final now = DateTime.now();
    final scheduledDate = DateTime(
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    final androidDetails = const AndroidNotificationDetails(
      'daily_channel_id',
      'Daily Notifications',
      channelDescription: 'Notificaciones diarias programadas',
      importance: Importance.max,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails();

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notificationsPlugin.zonedSchedule(
      notificationId,
      title,
      body,
      _nextInstanceOfTime(scheduledDate),
      details,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> cancelAlert(int notificationId) async {
    await _initialized;
    await _notificationsPlugin.cancel(notificationId);
  }

  Future<void> cancelAllAlerts() async {
    await _initialized;
    await _notificationsPlugin.cancelAll();
  }

  Future<bool> isNotificationScheduled(int notificationId) async {
    await _initialized;
    final pending = await _notificationsPlugin.pendingNotificationRequests();
    return pending.any((n) => n.id == notificationId);
  }

  tz.TZDateTime _nextInstanceOfTime(DateTime scheduledDate) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime.from(scheduledDate, tz.local);

    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    return scheduled;
  }
}
