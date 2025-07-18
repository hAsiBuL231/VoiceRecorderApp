class RecordingEntity {
  final String id;
  final String path;
  final DateTime createdAt;
  final Duration duration;
  final String? note;

  const RecordingEntity({
    required this.id,
    required this.path,
    required this.createdAt,
    required this.duration,
    this.note,
  });

  RecordingEntity copyWith({
    String? id,
    String? path,
    DateTime? createdAt,
    Duration? duration,
    String? note,
  }) {
    return RecordingEntity(
      id: id ?? this.id,
      path: path ?? this.path,
      createdAt: createdAt ?? this.createdAt,
      duration: duration ?? this.duration,
      note: note ?? this.note,
    );
  }
}