class ScheduleModel {
  final int id;
  final int medicationId;
  final String time;

  ScheduleModel({
    required this.id,
    required this.medicationId,
    required this.time,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'medicationId': medicationId,
      'time': time,
    };
  }

  factory ScheduleModel.fromMap(Map<String, dynamic> map) {
    return ScheduleModel(
      id: map['id'],
      medicationId: map['medicationId'],
      time: map['time'],
    );
  }
}
