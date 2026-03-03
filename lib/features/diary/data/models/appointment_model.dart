import '../../diary.dart';

class AppointmentModel extends Appointment {
  AppointmentModel({
    required super.id,
    required super.userId,
    required super.information,
    required super.time,
    required super.notificationId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'information': information,
      'time': time?.toIso8601String(), // guardamos como string ISO
      'notificationId': notificationId,
    };
  }

  factory AppointmentModel.fromMap(Map<String, dynamic> map) {
    return AppointmentModel(
      id: map['id'],
      userId: map['userId'],
      information: map['information'],
      time: map['time'] != null ? DateTime.parse(map['time']) : null,
      notificationId: map['notificationId'],
    );
  }
}
