import 'package:hive/hive.dart';
import '../models/recording.dart';
import '../models/duration_adapter.dart';

class HiveService {
  static const String recordingsBoxName = 'recordings';

  Future<void> init() async {
    Hive.registerAdapter(DurationAdapter());
    Hive.registerAdapter(RecordingAdapter());
    await Hive.openBox<Recording>(recordingsBoxName);
  }

  Future<List<Recording>> getRecordings() async {
    final box = Hive.box<Recording>(recordingsBoxName);
    return box.values.toList();
  }

  Future<void> saveRecording(Recording recording) async {
    final box = Hive.box<Recording>(recordingsBoxName);
    await box.put(recording.id, recording);
  }

  Future<void> deleteRecording(String id) async {
    final box = Hive.box<Recording>(recordingsBoxName);
    await box.delete(id);
  }

  Future<void> updateRecording(Recording recording) async {
    await saveRecording(recording);
  }
}
