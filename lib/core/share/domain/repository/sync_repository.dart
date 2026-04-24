import 'package:app/core/core.dart';
abstract class SyncRepository { 
  Future<void> addToQueue(SyncTask task); 
  Future<List<SyncTask>> getPendingTasks();
  Future<List<SyncTask>> getPendingTasksByUserId(int userId);
  Future<void> markAsError(int id, String error);
  Future<void> deleteTask(int id);
  Future<void> processFullQueue();
  Future<String> syncFirstTask();
}