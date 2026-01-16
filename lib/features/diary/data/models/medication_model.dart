import '../../diary.dart';

class MedicationModel extends Medication {
  MedicationModel({
    required super.id,
    required super.userId,
    required super.name,
    required super.dosage,
    required super.notes,
    required super.schedules, // viene desde la tabla horarios
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'dosage': dosage,
      'notes': notes,
      // schedules NO se guarda aquí
    };
  }

  factory MedicationModel.fromMap(
    Map<String, dynamic> map,
    List<String> schedules, // se inyecta desde la tabla horarios
  ) {
    return MedicationModel(
      id: map['id'],
      userId: map['userId'],
      name: map['name'],
      dosage: map['dosage'],
      notes: map['notes'],
      schedules: schedules,
    );
  }
}
