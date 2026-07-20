class FocusSessionModel {
  final int? id;
  final DateTime date;
  final int durationSeconds;
  final DateTime createdAt;

  FocusSessionModel({
    this.id,
    required this.date,
    required this.durationSeconds,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  FocusSessionModel copyWith({
    int? id,
    DateTime? date,
    int? durationSeconds,
    DateTime? createdAt,
  }) {
    return FocusSessionModel(
      id: id ?? this.id,
      date: date ?? this.date,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  String get dateString =>
      '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'date': dateString,
      'duration_seconds': durationSeconds,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory FocusSessionModel.fromMap(Map<String, dynamic> map) {
    return FocusSessionModel(
      id: map['id'] as int?,
      date: DateTime.parse(map['date'] as String),
      durationSeconds: map['duration_seconds'] as int,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }
}
