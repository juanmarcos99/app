import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  // Instancia principal del plugin de notificaciones
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Promesa de inicialización
  late final Future<void> _initialized;

  // Constructor: lanza la inicialización
  NotificationService() {
    _initialized = _init();
  }

  // Pedir permiso de notificaciones (Android 13+ y iOS)
  Future<bool> requestNotificationPermission() async {
    final status = await Permission.notification.request();
    return status.isGranted;
  }

  // Inicialización del plugin
  Future<void> _init() async {
    // Configuración inicial para Android
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    // Configuración inicial para iOS
    const iosSettings = DarwinInitializationSettings();

    // Unir configuraciones
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    // Inicializo el plugin con la configuración
    await _notificationsPlugin.initialize(
      initSettings,
      // Callback: qué pasa cuando el usuario interactúa con la notificación
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        {
          final id = response.id ?? 0;
          if (response.actionId == null || response.actionId!.isEmpty) {
            return;
          }
          if (response.actionId == 'remind_tomorrow' &&
              response.payload != null) {
            final data = jsonDecode(response.payload!);
            await _notificationsPlugin.cancel(id);
            final hour = data['hour'];
            final minute = data['minute'];
            final tomorrow = DateTime.now().add(const Duration(days: 1));
            final scheduledDate = DateTime(
              tomorrow.year,
              tomorrow.month,
              tomorrow.day,
              hour,
              minute,
            );
            await addDailyAlert(
              notificationId: data['id'],
              time: TimeOfDay(
                hour: scheduledDate.hour,
                minute: scheduledDate.minute,
              ),
              title: data['title'],
              body: data['body'],
            );
          } else if (response.actionId == 'cancel_alert') {
            await _notificationsPlugin.cancel(id);
          }
        }
      },
    );

    // Crear canal de notificación en Android
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

    // Configuración de zona horaria
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('America/Havana'));
  }

  // Notificación diaria fija (sin botones)
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

    final androidDetails = AndroidNotificationDetails(
      'daily_channel_id',
      'Daily Notifications',
      channelDescription: 'Notificaciones diarias programadas',
      importance: Importance.max,
      priority: Priority.high,
      ongoing: true, // Notificación fija
      autoCancel: false, // No se borra al tocarla
      category: AndroidNotificationCategory.reminder,
      actions: <AndroidNotificationAction>[
        // Botón para recordar mañana
        const AndroidNotificationAction(
          'remind_tomorrow',
          'Recordar mañana',
          showsUserInterface: false,
          foreground: false,
        ),
        // Botón para cancelar
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

    // Aquí construimos el payload como JSON
    final payload = jsonEncode({
      'id': notificationId,
      'hour': time.hour,
      'minute': time.minute,
      'title': title,
      'body': body,
    });

    await _notificationsPlugin.zonedSchedule(
      notificationId,
      title,
      body,
      _nextInstanceOfTime(scheduledDate),
      details,
      payload: payload,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.inexact,
    );
  }

  // Cancelar una notificación específica
  Future<void> cancelAlert(int notificationId) async {
    await _initialized;
    await _notificationsPlugin.cancel(notificationId);
  }

  // Cancelar todas las notificaciones
  Future<void> cancelAllAlerts() async {
    await _initialized;
    await _notificationsPlugin.cancelAll();
  }

  // Verificar si una notificación está programada
  Future<bool> isNotificationScheduled(int notificationId) async {
    await _initialized;
    final pending = await _notificationsPlugin.pendingNotificationRequests();
    return pending.any((n) => n.id == notificationId);
  }

  // Calcular la próxima instancia de la hora indicada
  tz.TZDateTime _nextInstanceOfTime(DateTime scheduledDate) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime.from(scheduledDate, tz.local);
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }
}
