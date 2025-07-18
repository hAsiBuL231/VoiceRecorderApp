import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/recording_entity.dart';
import '../domain/recording_repository.dart';
import '../../../core/di/injection.dart';

class RecordingsListViewModel extends StateNotifier<List<RecordingEntity>> {
  final RecordingRepository _repository;
  StreamSubscription<List<RecordingEntity>>? _sub;

  RecordingsListViewModel(this._repository) : super([]) {
    _sub = _repository.watchRecords().listen((records) {
      state = records;
    });
  }

  void reorder(int from, int to) {
    final items = [...state];
    final item = items.removeAt(from);
    items.insert(to, item);
    state = items;
  }

  Future<void> delete(String id) => _repository.deleteRecord(id);

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}

final recordingsListProvider =
StateNotifierProvider<RecordingsListViewModel, List<RecordingEntity>>(
        (ref) {
      return RecordingsListViewModel(getIt());
    });