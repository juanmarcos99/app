import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:app/features/diary/diary.dart';

abstract class AdverseEventRemoteDataSource {
  Future<void> addEvent(AdverseEventModel event);
  Future<void> updateEvent(AdverseEventModel event);
  Future<void> deleteEvent(int id);
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
}
