import '../domain/recording_entity.dart';
import '../domain/recording_repository.dart';
import 'hive_recording_datasource.dart';

class RecordingRepositoryImpl implements RecordingRepository {
  final HiveRecordingDatasource _datasource;

  RecordingRepositoryImpl(this._datasource);

  @override
  Future<void> saveRecord(RecordingEntity record) async {
    await _datasource.create(record);
  }

  @override
  Future<List<RecordingEntity>> getRecords() async {
    return _datasource.readAll();
  }

  @override
  Stream<List<RecordingEntity>> watchRecords() {
    return _datasource.watchAll();
  }

  @override
  Future<void> updateRecord(RecordingEntity record) async {
    await _datasource.update(record);
  }

  @override
  Future<void> deleteRecord(String id) async {
    await _datasource.delete(id);
  }
}