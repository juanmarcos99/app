import 'package:equatable/equatable.dart';

class PatientLincked extends Equatable {
  final int id;
  final String name;
  final String lastName;

  const PatientLincked({
    required this.id,
    required this.name,
    required this.lastName,
  });

  @override
  List<Object?> get props => [id, name, lastName];
}
