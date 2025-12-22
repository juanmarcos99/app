import 'package:app/features/diary/diary.dart';

class AdverseEventModel extends AdverseEvent {
  AdverseEventModel({
    super.id,
    required super.registerDate,
    required super.eventDate,
    required super.description,
    required super.userId,
  });

  factory AdverseEventModel.fromMap(Map<String, dynamic> map) {
    return AdverseEventModel(
      id: map['id'] as int?,
      registerDate: DateTime.parse(map['registeredDate']),
      eventDate: DateTime.parse(map['eventDate']),
      description: map['description'],
      userId: map['userId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'registeredDate': registerDate.toIso8601String().split('T').first,
      'eventDate': eventDate.toIso8601String().split('T').first,
      'description': description,
      'userId': userId,
    };
  }
}
