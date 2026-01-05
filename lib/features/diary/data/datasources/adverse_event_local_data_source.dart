import 'package:app/features/diary/diary.dart';
import 'package:sqflite/sqflite.dart';

abstract class AdverseEventLocalDataSource {
  Future<int> addAdverseEvent(AdverseEventModel adverseEvent);
  Future<List<AdverseEvent>> getAdverseEventByDayAndUser(
    DateTime day,
    int userId,
  );
  Future<List<DateTime>> getAdverseEventDaysByUser(int userId);
  Future<int> deleteAdverseEvent(int id);
  Future<void> updateAdverseEvent(AdverseEventModel event);
  Future<List<AdverseEventModel>> getAdverseEventByMonthAndYear(
    int month,
    int year,
    int userId,
  );
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

  // PARA LAS TARJETAS
  @override
  Future<List<AdverseEventModel>> getAdverseEventByDayAndUser(
    DateTime date,
    int userId,
  ) async {
    final normalizedDay = DateTime(
      date.year,
      date.month,
      date.day,
    ).toIso8601String().split('T').first;

    final result = await db.query(
      'adverse_events',
      where: 'eventDate = ? AND userId = ?',
      whereArgs: [normalizedDay, userId],
      orderBy: 'registeredDate DESC',
    );

    return result.map((map) => AdverseEventModel.fromMap(map)).toList();
  }

  // PARA LOS PUNTICOS DEL CALENDARIO
  @override
  Future<List<DateTime>> getAdverseEventDaysByUser(int userId) async {
    final result = await db.rawQuery(
      'SELECT DISTINCT eventDate FROM adverse_events WHERE userId = ? ORDER BY eventDate DESC',
      [userId],
    );

    return result
        .map((row) => DateTime.parse(row['eventDate'] as String))
        .map((d) => DateTime(d.year, d.month, d.day)) // normalizamos
        .toList();
  }

  @override
  Future<int> deleteAdverseEvent(int id) async {
    try {
      return await db.delete(
        'adverse_events',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      return -1;
    }
  }

  @override
  Future<void> updateAdverseEvent(AdverseEventModel event) async {
    try {
      await db.update(
        'adverse_events',
        event.toMap(),
        where: 'id = ?',
        whereArgs: [event.id],
      );
    } catch (e) {
      throw Exception('Failed to update adverse event: $e');
    }
  }

  @override
  Future<List<AdverseEventModel>> getAdverseEventByMonthAndYear(
    int month,
    int year,
    int userId,
  ) async {
    final monthStr = month.toString().padLeft(2, '0');
    final yearStr = year.toString();
    final result = await db.rawQuery(
      ''' SELECT * FROM adverse_events
      WHERE strftime('%m', eventDate) = ? 
      AND strftime('%Y', eventDate) = ? 
      AND userId = ? 
      ORDER BY eventDate DESC ''',
      [monthStr, yearStr, userId],
    );
    return result.map((map) => AdverseEventModel.fromMap(map)).toList();
  }
}
