
class Appointment {
  final int? id;
  final int? userId;
  final String? information;
  final DateTime? time;
  final int? notificationId;

  Appointment({
    required this.id,
    required this.userId,
    required this.information,
    required this.time,
    required this.notificationId,
  });

  Appointment copyWith({
    int? id,
    int? userId,
    String? information,
    DateTime? time,
    int? notificationId,
  }) {
    return Appointment(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      information: information ?? this.information,
      time: time ?? this.time,
      notificationId: notificationId ?? this.notificationId,
    );
  }
}
