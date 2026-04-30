import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:app/features/diary/diary.dart';

abstract class AdverseEventRemoteDataSource {
  Future<void> addEvent(AdverseEventModel event);
  Future<void> updateEvent(AdverseEventModel event);
  Future<void> deleteEvent(int id);
  Future<List<AdverseEventModel>> getAdverseEventremotesByDayAndUser(DateTime day, int userId);
  Future<List<DateTime>> getAdverseEventremotesDaysByUser(int userId);
  Future<List<AdverseEventModel>> getAdverseEventremotesByMonthAndYear(int month, int year, int userId);
}

class AdverseEventRemoteDataSourceImpl implements AdverseEventRemoteDataSource {
  final SupabaseClient supabaseClient;

  AdverseEventRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<void> addEvent(AdverseEventModel event) async {
    await supabaseClient.from('adverse_events').insert(event.toMap());
  }

  @override
  Future<void> updateEvent(AdverseEventModel event) async {
    await supabaseClient
        .from('adverse_events')
        .update(event.toMap())
        .eq('id', event.id!);
  }

  @override
  Future<void> deleteEvent(int id) async {
    await supabaseClient.from('adverse_events').delete().eq('id', id);
  }

  @override
  Future<List<AdverseEventModel>> getAdverseEventremotesByDayAndUser(DateTime day, int userId) async {
    final formattedDay = "${day.year}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}";

    final data = await supabaseClient
        .from('adverse_events')
        .select()
        .eq('userId', userId)
        .like('eventDate', '$formattedDay%');

    return data.map((json) => AdverseEventModel.fromMap(json)).toList();
  }

  @override
  Future<List<DateTime>> getAdverseEventremotesDaysByUser(int userId) async {
    final data = await supabaseClient
        .from('adverse_events')
        .select('eventDate')
        .eq('userId', userId);

    return data.map((json) => DateTime.parse(json['eventDate'] as String)).toList();
  }

  @override
  Future<List<AdverseEventModel>> getAdverseEventremotesByMonthAndYear(int month, int year, int userId) async {
    final formattedMonth = "$year-${month.toString().padLeft(2, '0')}";

    final data = await supabaseClient
        .from('adverse_events')
        .select()
        .eq('userId', userId)
        .like('eventDate', '$formattedMonth%');

    return data.map((json) => AdverseEventModel.fromMap(json)).toList();
  }
}
