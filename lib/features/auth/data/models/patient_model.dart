import 'package:app/features/auth/auth.dart';
class PatientModel extends Patient {
  PatientModel({
    required super.id,
    required super.userId,
    required super.caregiverNumber,
    required super.caregiverEmail, 
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'caregiverNumber': caregiverNumber,
      'caregiverEmail': caregiverEmail,
    };
  }

  factory PatientModel.fromMap(Map<String, dynamic> map) {
    return PatientModel(
      id: map['id'],
      userId: map['userId'],
      caregiverNumber: map['caregiverNumber'],
      caregiverEmail: map['caregiverEmail'], 
    );
  }
}
