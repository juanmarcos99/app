import 'package:equatable/equatable.dart';

class PatientEntity extends Equatable {
  final int id;
  final String name;
  final String lastName;

  const PatientEntity({
    required this.id,
    required this.name,
    required this.lastName,
  });

  @override
  List<Object?> get props => [id, name, lastName];
}
