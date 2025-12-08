import 'package:app/features/auth/domain/auth_domain.dart';

abstract class PatientRepository {
Future<void> registerPatient(Patient patient);
}
