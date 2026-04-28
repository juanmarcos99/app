import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/doctor_linked_patient_model.dart';

abstract class DoctorRemoteDataSource {
  Future<List<DoctorLinkedPatientModel>> getPatientsByIds(List<int> patientIds);
}

class DoctorRemoteDataSourceImpl implements DoctorRemoteDataSource {
  final SupabaseClient supabaseClient;

  DoctorRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<List<DoctorLinkedPatientModel>> getPatientsByIds(List<int> patientIds) async {
    if (patientIds.isEmpty) return [];
    
    final response = await supabaseClient
        .from('users')
        .select()
        .inFilter('id', patientIds);
    
    return (response as List).map((map) => DoctorLinkedPatientModel.fromMap(map)).toList();
  }
}
