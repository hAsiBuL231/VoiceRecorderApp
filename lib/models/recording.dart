import 'package:equatable/equatable.dart';

class Recording extends Equatable {
  final String id;
  final String path;
  final DateTime createdAt;
  final Duration duration;
  final String? note;

  const Recording({
    required this.id,
    required this.path,
    required this.createdAt,
    required this.duration,
    this.note,
  });

  Recording copyWith({
    String? id,
    String? path,
    DateTime? createdAt,
    Duration? duration,
    String? note,
  }) {
    return Recording(
      id: id ?? this.id,
      path: path ?? this.path,
      createdAt: createdAt ?? this.createdAt,
      duration: duration ?? this.duration,
      note: note ?? this.note,
    );
  }

  @override
  List<Object?> get props => [id, path, createdAt, duration, note];
}
