class User {
  final int? id;
  final String name;
  final String lastName;
  final String email;
  final String phoneNumber;
  final String userName;
  final String passwordHash; // en BD guardas hash, no texto plano
  final String role; // doctor o paciente

  User({
    this.id,
    required this.name,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.userName,
    required this.passwordHash,
    required this.role,
  });
}
