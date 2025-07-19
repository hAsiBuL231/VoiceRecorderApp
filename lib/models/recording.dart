import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'recording.g.dart';

@HiveType(typeId: 0)
class Recording extends Equatable {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String path;
  @HiveField(2)
  final DateTime createdAt;
  @HiveField(3)
  final Duration duration;
  @HiveField(4)
  final String? note;

  const Recording({required this.id, required this.path, required this.createdAt, required this.duration, this.note});

  Recording copyWith({String? id, String? path, DateTime? createdAt, Duration? duration, String? note}) {
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
