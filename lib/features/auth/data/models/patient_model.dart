import 'package:app/features/auth/domain/auth_domain.dart';

class PatientModel extends Patient {
  PatientModel({
    required super.userId,
    required super.caregiverNumber,
    required super.caregiverEmail,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'caregiverNumber': caregiverNumber,
      'caregiverEmail': caregiverEmail,
    };
  }

  factory PatientModel.fromMap(Map<String, dynamic> map) {
    return PatientModel(
      userId: map['userId'],
      caregiverNumber: map['caregiverNumber'],
      caregiverEmail: map['caregiverEmail'],
    );
  }
}
