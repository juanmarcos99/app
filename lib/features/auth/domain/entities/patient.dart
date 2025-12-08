class Patient {
  final int userId;
  final String caregiverNumber;
  final String caregiverEmail;

  Patient({
    required this.userId,
    required this.caregiverNumber,
    required this.caregiverEmail,
  });

  Patient copyWith({
    int? userId,
    String? caregiverNumber,
    String? caregiverEmail,
  }) {
    return Patient(
      userId: userId ?? this.userId,
      caregiverNumber: caregiverNumber ?? this.caregiverNumber,
      caregiverEmail: caregiverEmail ?? this.caregiverEmail,
    );
  }
}
