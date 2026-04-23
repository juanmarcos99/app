class SyncTask {
  final int? id;
  final String endpoint;
  final String method;
  final Map<String, dynamic> payload;
  final String status;
  final String? lastError;

  SyncTask({
    this.id,
    required this.endpoint,
    required this.method,
    required this.payload,
    this.status = 'pending',
    this.lastError,
  });
}