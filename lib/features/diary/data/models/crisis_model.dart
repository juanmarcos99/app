import '../../diary.dart';

class CrisisModel extends Crisis {
  CrisisModel({
    super.id,
    required super.registeredDate,
    required super.crisisDate,
    required super.timeRange,
    required super.quantity,
    required super.type,
    required super.userId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'registeredDate': registeredDate!.toIso8601String(),
      'crisisDate': crisisDate!.toIso8601String().split('T').first,
      'timeRange': timeRange,
      'quantity': quantity,
      'type': type,
      'userId': userId,
    };
  }

  factory CrisisModel.fromMap(Map<String, dynamic> map) {
    return CrisisModel(
      id: map['id'],
      registeredDate: DateTime.parse(map['registeredDate']),
      crisisDate: DateTime.parse(map['crisisDate']),
      timeRange: map['timeRange'],
      quantity: map['quantity'],
      type: map['type'],
      userId: map['userId'],
    );
  }

  @override
  CrisisModel copyWith({
    int? id,
    DateTime? registeredDate,
    DateTime? crisisDate,
    String? timeRange,
    int? quantity,
    String? type,
    int? userId,
  }) {
    return CrisisModel(
      id: id ?? this.id,
      registeredDate: registeredDate ?? this.registeredDate,
      crisisDate: crisisDate ?? this.crisisDate,
      timeRange: timeRange ?? this.timeRange,
      quantity: quantity ?? this.quantity,
      type: type ?? this.type,
      userId: userId ?? this.userId,
    );
  }
}
