import '../../domain/entities/patient_entity.dart';

class DoctorLinkedPatientModel extends PatientEntity {
  const DoctorLinkedPatientModel({
    required super.id,
    required super.name,
    required super.lastName,
  });

  factory DoctorLinkedPatientModel.fromMap(Map<String, dynamic> map) {
    return DoctorLinkedPatientModel(
      id: map['id'] as int,
      name: map['name'] as String,
      lastName: map['lastName'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'lastName': lastName,
    };
  }
}
