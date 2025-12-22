import 'package:app/features/diary/diary.dart';
import 'package:sqflite/sqflite.dart';

abstract class AdverseEventLocalDataSource {
  Future<int> addAdverseEvent(AdverseEventModel adverseEvent);
}

class AdverseEventLocalDataSourceImpl implements AdverseEventLocalDataSource {
  final Database db;
  AdverseEventLocalDataSourceImpl(this.db);

  @override
  Future<int> addAdverseEvent(AdverseEventModel event) async {
    try {
      return await db.insert('adverse_events', event.toMap());
    } catch (e) {
      return -1;
    }
  }
}
