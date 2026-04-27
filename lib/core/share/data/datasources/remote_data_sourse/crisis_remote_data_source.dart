import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:app/features/diary/diary.dart';

abstract class CrisisRemoteDataSource {
  Future<void> addCrisis(CrisisModel crisis);
  Future<void> updateCrisis(CrisisModel crisis);
  Future<void> deleteCrisis(int id);
}

class CrisisRemoteDataSourceImpl implements CrisisRemoteDataSource {
  final SupabaseClient supabaseClient;

  CrisisRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<void> addCrisis(CrisisModel crisis) async {
    await supabaseClient.from('crisis').insert(crisis.toMap());
  }

  @override
  Future<void> updateCrisis(CrisisModel crisis) async {
    await supabaseClient
        .from('crisis')
        .update(crisis.toMap())
        .eq('id', crisis.id!);
  }

  @override
  Future<void> deleteCrisis(int id) async {
    await supabaseClient.from('crisis').delete().eq('id', id);
  }
}
