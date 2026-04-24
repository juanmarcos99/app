import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:app/core/core.dart';

class SyncRepositoryImpl implements SyncRepository {
  final SyncQueueLocalDataSource localDataSource;
  final SupabaseClient supabaseClient;

  SyncRepositoryImpl( {
    required this.localDataSource,
    required this.supabaseClient,
  });

  @override
  Future<void> addToQueue(SyncTask task) async {
    // Si localDataSource espera un SyncTaskModel, convertimos el SyncTask
    if (task is SyncTaskModel) {
      await localDataSource.addToQueue(task);
    } else {
      // Opcional: convertir una entidad genérica a modelo si es necesario
      final model = SyncTaskModel(
        id: task.id,
        endpoint: task.endpoint,
        method: task.method,
        payload: task.payload,
        status: task.status,
        lastError: task.lastError,
      );
      await localDataSource.addToQueue(model);
    }
  }

  @override
  Future<List<SyncTaskModel>> getPendingTasks() async {
    return await localDataSource.getPendingTasks();
  }

  @override
  Future<void> markAsError(int id, String error) async {
    await localDataSource.markAsError(id, error);
  }

  @override
  Future<void> deleteTask(int id) async {
    await localDataSource.deleteTask(id);
  }

  @override
  Future<void> processFullQueue() async {
    final tasks = await localDataSource.getPendingTasks();

    for (var task in tasks) {
      try {
        if (task.method == 'INSERT') {
          await supabaseClient
              .from(task.endpoint)
              .insert(task.payload)
              .timeout(const Duration(seconds: 15));
        } else if (task.method == 'UPDATE') {
          await supabaseClient
              .from(task.endpoint)
              .update(task.payload)
              .eq('id', task.payload['id'])
              .timeout(const Duration(seconds: 15));
        } else if (task.method == 'DELETE') {
          await supabaseClient
              .from(task.endpoint)
              .delete()
              .eq('id', task.payload['id'])
              .timeout(const Duration(seconds: 15));
        }

        await localDataSource.deleteTask(task.id!);
      } on SocketException {
        break;
      } on PostgrestException catch (e) {
        await localDataSource.markAsError(task.id!, e.message);
      } catch (e) {
        await localDataSource.markAsError(task.id!, e.toString());
      }
    }
  }

  @override
Future<String> syncFirstTask() async {
  final tasks = await localDataSource.getPendingTasks();
  
  if (tasks.isEmpty) return "QUEUE_EMPTY";

  final task = tasks.first;

  try {
    dynamic response;
    
    if (task.method == 'INSERT') {
      response = await supabaseClient
          .from(task.endpoint)
          .insert(task.payload)
          .select()
          .single();
    } else if (task.method == 'UPDATE') {
      response = await supabaseClient
          .from(task.endpoint)
          .update(task.payload)
          .eq('id', task.payload['id'])
          .select()
          .single();
    } else if (task.method == 'DELETE') {
      await supabaseClient
          .from(task.endpoint)
          .delete()
          .eq('id', task.payload['id']);
      response = "DELETED";
    }

    await localDataSource.deleteTask(task.id!);
    return response.toString();

  } on PostgrestException catch (e) {
    await localDataSource.markAsError(task.id!, e.message);
    return "SUPABASE_ERROR: ${e.message}";
  } on SocketException {
    return "NETWORK_ERROR";
  } catch (e) {
    await localDataSource.markAsError(task.id!, e.toString());
    return "UNKNOWN_ERROR: $e";
  }
}
}