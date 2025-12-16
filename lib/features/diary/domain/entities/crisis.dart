class Crisis {
  final int? id;
  final DateTime registeredDate;
  final DateTime crisisDate;
  final String timeRange;
  final int quantity;
  final String type;
  final int userId;

  Crisis({
    this.id,
    required this.registeredDate,
    required this.crisisDate,
    required this.timeRange,
    required this.quantity,
    required this.type,
    required this.userId,
  });

  Crisis copyWith({
    int? id,
    DateTime? registeredDate,
    DateTime? crisisDate,
    String? timeRange,
    int? quantity,
    String? type,
    int? userId,
  }) {
    return Crisis(
      id: id ?? this.id,
      registeredDate: registeredDate ?? this.registeredDate,
      crisisDate: crisisDate ?? this.crisisDate,
      timeRange: timeRange ?? this.timeRange,
      quantity: quantity ?? this.quantity,
      type: type ?? this.type,
      userId: userId ?? this.userId,
    );
  }
}
