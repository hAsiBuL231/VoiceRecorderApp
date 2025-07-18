import '../../../model/records.dart';

abstract class RecordingRepository {
  Future<void> saveRecord(Records record);
}