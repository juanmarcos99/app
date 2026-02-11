import 'package:app/features/auth/auth.dart';
class UserModel extends User {
  UserModel({
    super.id,
    required super.name,
    required super.lastName,
    required super.email,
    required super.phoneNumber,
    required super.userName,
    required super.passwordHash,
    required super.role,
  });

  // Convierte el objeto a un Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'lastName': lastName,
      'email': email,
      'phoneNumber': phoneNumber,
      'userName': userName,
      'passwordHash': passwordHash,
      'role': role,
    };
  }

  // Crea un objeto desde un Map
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      name: map['name'],
      lastName: map['lastName'],
      email: map['email'],
      phoneNumber: map['phoneNumber'],
      userName: map['userName'],
      passwordHash: map['passwordHash'],
      role: map['role'],
    );
  }
}
