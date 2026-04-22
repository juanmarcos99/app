class AdverseEvent {
  final int? id;
  final DateTime? registerDate;
  final DateTime? eventDate;
  final String? description;
  final int? userId;

  AdverseEvent({
    this.id,
    this.registerDate,
    this.eventDate,
    this.description,
    this.userId, 
  });

  AdverseEvent copyWith({
    int? id,
    DateTime? registerDate,
    DateTime? eventDate,
    String? description,
    int? userId,
  }) {
    return AdverseEvent(
      id: id ?? this.id,
      registerDate: registerDate ?? this.registerDate,
      eventDate: eventDate ?? this.eventDate,
      description: description ?? this.description,
      userId: userId ?? this.userId,
    );
  }
}
