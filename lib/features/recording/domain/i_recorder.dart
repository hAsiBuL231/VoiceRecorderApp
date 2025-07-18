import 'recording_entity.dart';

abstract class IRecorder {
  Future<void> start();
  Future<RecordingEntity> stop();
  Stream<double> get decibelStream;
}