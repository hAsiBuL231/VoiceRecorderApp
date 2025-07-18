import 'recording_entity.dart';

abstract class RecordingRepository {
  Future<void> saveRecord(RecordingEntity record);
}