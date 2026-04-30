import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:app/features/diary/diary.dart';

abstract class CrisisRemoteDataSource {
  Future<void> addCrisis(CrisisModel crisis);
  Future<void> updateCrisis(CrisisModel crisis);
  Future<void> deleteCrisis(int id);
  Future<List<CrisisModel>> getCrisesByDayAndUser(DateTime day, int userId);
  Future<List<DateTime>> getCrisesDaysByUser(int userId);
  Future<List<CrisisModel>> getCrisesByMonthAndYear(int month, int year, int userId);
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

  @override
  Future<List<CrisisModel>> getCrisesByDayAndUser(DateTime day, int userId) async {
    final formattedDay = "${day.year}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}";

    final data = await supabaseClient
        .from('crisis')
        .select()
        .eq('userId', userId)
        .like('crisisDate', '$formattedDay%');

    return data.map((json) => CrisisModel.fromMap(json)).toList();
  }

  @override
  Future<List<DateTime>> getCrisesDaysByUser(int userId) async {
    final data = await supabaseClient
        .from('crisis')
        .select('crisisDate')
        .eq('userId', userId);

    return data.map((json) => DateTime.parse(json['crisisDate'] as String)).toList();
  }

  @override
  Future<List<CrisisModel>> getCrisesByMonthAndYear(int month, int year, int userId) async {
    final formattedMonth = "$year-${month.toString().padLeft(2, '0')}";

    final data = await supabaseClient
        .from('crisis')
        .select()
        .eq('userId', userId)
        .like('crisisDate', '$formattedMonth%');

    return data.map((json) => CrisisModel.fromMap(json)).toList();
  }
}
