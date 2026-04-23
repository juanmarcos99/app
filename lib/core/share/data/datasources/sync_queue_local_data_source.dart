import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:app/core/core.dart';

abstract class SyncQueueLocalDataSource {
  Future<int> addToQueue(SyncTaskModel task);
  Future<List<SyncTaskModel>> getPendingTasks();
  Future<void> markAsError(int id, String error);
  Future<void> deleteTask(int id);
}

class SyncQueueLocalDataSourceImpl extends SyncQueueLocalDataSource {
  final Database db;

  SyncQueueLocalDataSourceImpl(this.db);

  @override
  Future<int> addToQueue(SyncTaskModel task) async {
    return await db.insert('sync_queue', task.toMap());
  }

  @override
  Future<List<SyncTaskModel>> getPendingTasks() async {
    final List<Map<String, dynamic>> result = await db.query(
      'sync_queue',
      where: 'status = ?',
      whereArgs: ['pending'],
      orderBy: 'id ASC',
    );

    return result.map((map) => SyncTaskModel.fromMap(map)).toList();
  }

  @override
  Future<void> markAsError(int id, String error) async {
    final rowsAffected = await db.update(
      'sync_queue',
      {
        'status': 'error',
        'last_error': error,
      },
      where: 'id = ?',
      whereArgs: [id],
    );

    if (rowsAffected == 0) {
      debugPrint("SyncQueueError: ID $id not found");
    }
  }

  @override
  Future<void> deleteTask(int id) async {
    final rowsDeleted = await db.delete(
      'sync_queue',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (rowsDeleted == 0) {
      debugPrint("SyncQueueError: ID $id not found");
    }
  }
}