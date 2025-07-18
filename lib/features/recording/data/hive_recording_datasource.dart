import 'package:hive_flutter/hive_flutter.dart';

import '../domain/recording_entity.dart';

class HiveRecordingDatasource {
  static const _boxName = 'recordings';

  Future<Box> _openBox() async => Hive.openBox(_boxName);

  List<RecordingEntity> _mapValues(Iterable values) {
    return values.map((e) {
      final map = Map<String, dynamic>.from(e as Map);
      return RecordingEntity(
        id: map['id'] as String,
        path: map['path'] as String,
        createdAt: DateTime.parse(map['createdAt'] as String),
        duration: Duration(milliseconds: map['duration'] as int),
        note: map['note'] as String?,
      );
    }).toList();
  }

  Stream<List<RecordingEntity>> watchAll() async* {
    final box = await _openBox();
    yield _mapValues(box.values);
    await for (final _ in box.watch()) {
      yield _mapValues(box.values);
    }
  }

  Future<void> create(RecordingEntity record) async {
    final box = await _openBox();
    await box.put(record.id, {
      'id': record.id,
      'path': record.path,
      'createdAt': record.createdAt.toIso8601String(),
      'duration': record.duration.inMilliseconds,
      'note': record.note,
    });
  }

  Future<List<RecordingEntity>> readAll() async {
    final box = await _openBox();
    return _mapValues(box.values);
  }

  Future<void> update(RecordingEntity record) async {
    final box = await _openBox();
    await box.put(record.id, {
      'id': record.id,
      'path': record.path,
      'createdAt': record.createdAt.toIso8601String(),
      'duration': record.duration.inMilliseconds,
      'note': record.note,
    });
  }

  Future<void> delete(String id) async {
    final box = await _openBox();
    await box.delete(id);
  }
}