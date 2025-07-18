import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import '../models/recording.dart';

class AudioService {
  final AudioRecorder _recorder;
  final AudioPlayer _player;
  DateTime? _recordingStartTime;

  AudioService()
      : _recorder = AudioRecorder(),
        _player = AudioPlayer();

  Stream<double> get amplitude => 
      _recorder.onAmplitudeChanged(const Duration(milliseconds: 300))
          .map((amp) => amp.current);

  Stream<Duration> get position => _player.positionStream;
  Stream<bool> get isPlaying => _player.playingStream;
  Duration? get duration => _player.duration;

  Future<bool> hasPermission() async {
    final status = await Permission.microphone.request();
    return status.isGranted;
  }

  Future<void> startRecording() async {
    if (!await hasPermission()) {
      throw Exception('Microphone permission not granted');
    }

    final dir = await getTemporaryDirectory();
    final path = '${dir.path}/recording_${DateTime.now().millisecondsSinceEpoch}.m4a';
    
    await _recorder.start(
      RecordConfig(encoder: AudioEncoder.aacLc, numChannels: 1),
      path: path,
    );
    _recordingStartTime = DateTime.now();
  }

  Future<Recording> stopRecording() async {
    final path = await _recorder.stop();
    if (path == null || _recordingStartTime == null) {
      throw Exception('No recording in progress');
    }

    final recording = Recording(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      path: path,
      createdAt: _recordingStartTime!,
      duration: DateTime.now().difference(_recordingStartTime!),
    );

    _recordingStartTime = null;
    return recording;
  }

  Future<void> startPlaying(String path) async {
    await _player.setFilePath(path);
    await _player.play();
  }

  Future<void> pausePlaying() async {
    await _player.pause();
  }

  Future<void> seekTo(Duration position) async {
    await _player.seek(position);
  }

  Future<void> setPlaybackSpeed(double speed) async {
    await _player.setSpeed(speed);
  }

  Future<void> dispose() async {
    await _recorder.dispose();
    await _player.dispose();
  }
}
