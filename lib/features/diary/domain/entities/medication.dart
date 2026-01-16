class Medication {
  final int? id;
  final int? userId;
  final String? name;
  final String? dosage;
  final String? notes;
  final List<String>? schedules; // e.g. ["08:00", "12:00"]

  Medication({
    this.id,
    this.userId,
    this.name,
    this.dosage,
    this.notes,
    this.schedules,
  });

  Medication copyWith({
    int? id,
    int? userId,
    String? name,
    String? dosage,
    String? notes,
    List<String>? schedules,
  }) {
    return Medication(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      dosage: dosage ?? this.dosage,
      notes: notes ?? this.notes,
      schedules: schedules ?? this.schedules,
    );
  }
}
