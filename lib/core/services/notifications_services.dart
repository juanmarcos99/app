import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  late final Future<void> _initialized;

  NotificationService() {
    _initialized = _init();
  }

  /// Solicita permisos de notificaciones en runtime (Android 13+)
  Future<bool> requestNotificationPermission() async {
    final status = await Permission.notification.request();
    return status.isGranted;
  }

  Future<void> _init() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings();

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        final id = response.id ?? 0;
        debugPrint('ID: ${response.id}');
        debugPrint('Action: ${response.actionId}');
        debugPrint('Payload: ${response.payload}');

        if (response.actionId == null || response.actionId!.isEmpty) {
          debugPrint('se toco pero algo salio mal');
          return;
        }

        if (response.actionId == 'remind_tomorrow') {
          //  Cancelar la notificación visible inmediatamente
          await _notificationsPlugin.cancel(id);

          //  Reprogramar para mañana
          final tomorrow = DateTime.now().add(const Duration(days: 1));
          await addInexactDailyAlert(
            notificationId: id,
            time: TimeOfDay(hour: tomorrow.hour, minute: tomorrow.minute),
            title: 'Recordatorio',
            body: 'Tu notificación diaria',
          );
        } else if (response.actionId == 'cancel_alert') {
          // Cancelar la notificación visible inmediatamente
          await _notificationsPlugin.cancel(id);
        }
      },
    );

    final androidPlugin = _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    await androidPlugin?.createNotificationChannel(
      const AndroidNotificationChannel(
        'daily_channel_id',
        'Daily Notifications',
        description: 'Notificaciones diarias programadas',
        importance: Importance.max,
      ),
    );

    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('America/Havana'));
  }

  Future<void> addDailyAlert({
    required int notificationId,
    required TimeOfDay time,
    required String title,
    required String body,
  }) async {
    await addInexactDailyAlert(
      notificationId: notificationId,
      time: time,
      title: title,
      body: body,
    );
  }

  Future<void> addInexactDailyAlert({
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

    final androidDetails = AndroidNotificationDetails(
      'daily_channel_id',
      'Daily Notifications',
      channelDescription: 'Notificaciones diarias programadas',
      importance: Importance.max,
      priority: Priority.high,
      ongoing: true, // Notificación permanente
      category: AndroidNotificationCategory.reminder, // más persistente
      autoCancel: false, //  no se borra al tocar
      fullScreenIntent: false, //  evita abrir la app al tocar
      icon: '@mipmap/ic_launcher',
      actions: <AndroidNotificationAction>[
        const AndroidNotificationAction(
          'remind_tomorrow',
          'Recordar mañana',
          showsUserInterface: true,
        ),
        const AndroidNotificationAction(
          'cancel_alert',
          'Cancelar',
          showsUserInterface: true,
          cancelNotification: true,
        ),
      ],
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
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.inexact,
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
