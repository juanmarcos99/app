import '../../domain/repositories/doctor_repository.dart';
import '../../domain/entities/patient_entity.dart';
import '../datasources/doctor_local_data_source.dart';
import '../datasources/doctor_remote_data_source.dart';

class DoctorRepositoryImpl implements DoctorRepository {
  final DoctorLocalDataSource localDataSource;
  final DoctorRemoteDataSource remoteDataSource;

  DoctorRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<List<PatientEntity>> getLinkedPatients() async {
    final ids = await localDataSource.getLinkedPatientIds();
    if (ids.isEmpty) {
      return [];
    }
    
    return await remoteDataSource.getPatientsByIds(ids);
  }

  @override
  Future<void> linkPatient(int patientId) async {
    await localDataSource.linkPatient(patientId);
  }
}
