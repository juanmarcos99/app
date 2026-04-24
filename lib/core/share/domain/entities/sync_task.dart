class SyncTask {
  final int? id;
  final int userId;
  final String endpoint;
  final String method;
  final Map<String, dynamic> payload;
  final String status;
  final String? lastError;

  SyncTask({
    this.id,
    required this.userId,
    required this.endpoint,
    required this.method,
    required this.payload,
    this.status = 'pending',
    this.lastError,
  });
}