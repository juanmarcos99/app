import 'package:flutter/material.dart';
import '../../diary.dart'; // tu entidad Schedule

class ScheduleModel extends Schedule {
  ScheduleModel({
    super.id,
    required super.medicationId,
    required super.time,
    required super.notificationId,
  });

  /// Convierte el modelo a Map para SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'medicationId': medicationId,
      'time': _formatTimeOfDay(time!), // guardamos como "HH:mm"
      'notificationId': notificationId,
    };
  }

  /// Crea el modelo desde Map de SQLite
  factory ScheduleModel.fromMap(Map<String, dynamic> map) {
    return ScheduleModel(
      id: map['id'] as int,
      medicationId: map['medicationId'] as int,
      time: _parseTimeOfDay(map['time'] as String), // convertimos a TimeOfDay
      notificationId: map['notificationId'] as int,
    );
  }

  /// Helpers privados
  static String _formatTimeOfDay(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  static TimeOfDay _parseTimeOfDay(String timeString) {
    final parts = timeString.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    return TimeOfDay(hour: hour, minute: minute);
  }
}
