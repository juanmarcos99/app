import 'package:flutter/material.dart';

class Schedule {
  final int? id;
  final int? medicationId;
  final TimeOfDay? time;
  final int? notificationId;

  Schedule({
    this.id,
    this.medicationId,
    this.time,
    this.notificationId,
  });

  Schedule copyWith({
    int? id,
    int? medicationId,
    TimeOfDay? time,
    int? notificationId,
  }) {
    return Schedule(
      id: id ?? this.id,
      medicationId: medicationId ?? this.medicationId,
      time: time ?? this.time,
      notificationId: notificationId ?? this.notificationId,
    );
  }
}
