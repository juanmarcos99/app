class AdverseEvent {
  final int? id;
  final DateTime registerDate;
  final DateTime eventDate;
  final String description;
  final int userId;


  AdverseEvent({
    this.id,
    required this.registerDate,
    required this.eventDate,
    required this.description,
    required this.userId,
  }); 
}
