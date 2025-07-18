import 'recording_entity.dart';

abstract class RecordingRepository {
  Future<void> saveRecord(RecordingEntity record);
  Future<List<RecordingEntity>> getRecords();
  Stream<List<RecordingEntity>> watchRecords();
  Future<void> updateRecord(RecordingEntity record);
  Future<void> deleteRecord(String id);
}