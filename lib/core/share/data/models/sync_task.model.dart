import 'dart:convert';
import 'package:app/core/core.dart';

class SyncTaskModel extends SyncTask {
  SyncTaskModel({
    super.id,
    required super.endpoint,
    required super.method,
    required super.payload,
    super.status,
    super.lastError,
  });

  // Para insertar en SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'endpoint': endpoint,
      'method': method,
      'payload': jsonEncode(payload),
      'status': status,
      'last_error': lastError,
    };
  }

  // Para leer de SQLite
  factory SyncTaskModel.fromMap(Map<String, dynamic> map) {
    return SyncTaskModel(
      id: map['id'],
      endpoint: map['endpoint'],
      method: map['method'],
      payload: jsonDecode(map['payload']),
      status: map['status'],
      lastError: map['last_error'],
    );
  }
}