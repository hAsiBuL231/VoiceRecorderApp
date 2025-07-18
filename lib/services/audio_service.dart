import 'package:just_audio/just_audio.dart' hide PlayerState;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import '../models/recording.dart';

class AudioService {
  final RecorderController _recorder;
  final AudioPlayer _player;
  DateTime? _recordingStartTime;
  String? _currentPath;

  AudioService() : _recorder = RecorderController(), _player = AudioPlayer() {
    _recorder.updateFrequency = const Duration(milliseconds: 50);
  }

  RecorderController get recorder => _recorder;
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
    _currentPath =
        '${dir.path}/recording_${DateTime.now().millisecondsSinceEpoch}.m4a';

    await _recorder.record(path: _currentPath);
    _recordingStartTime = DateTime.now();
  }

  Future<Recording> stopRecording() async {
    await _recorder.stop();
    if (_currentPath == null || _recordingStartTime == null) {
      throw Exception('No recording in progress');
    }

    final recording = Recording(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      path: _currentPath!,
      createdAt: _recordingStartTime!,
      duration: DateTime.now().difference(_recordingStartTime!),
    );

    _recordingStartTime = null;
    _currentPath = null;
    return recording;
  }

  Future<void> setAudioSource(String path) async {
    await _player.setFilePath(path);
  }

  Future<void> startPlaying(String path) async {
    try {
      if (_player.playing) {
        await _player.stop();
      }
      await _player.setFilePath(path);
      await _player.play();
    } catch (e) {
      throw Exception('Error playing audio: $e');
    }
  }

  Future<void> pausePlaying() async {
    try {
      await _player.pause();
    } catch (e) {
      throw Exception('Error pausing audio: $e');
    }
  }

  Future<void> resumePlaying() async {
    try {
      await _player.play();
    } catch (e) {
      throw Exception('Error resuming audio: $e');
    }
  }

  Future<void> seekTo(Duration position) async {
    try {
      await _player.seek(position);
    } catch (e) {
      throw Exception('Error seeking audio: $e');
    }
  }

  Future<void> setPlaybackSpeed(double speed) async {
    try {
      await _player.setSpeed(speed);
    } catch (e) {
      throw Exception('Error setting playback speed: $e');
    }
  }

  // Additional streams for more detailed player state
  Stream<ProcessingState> get processingStateStream =>
      _player.processingStateStream;
  bool get playing => _player.playing;

  Future<void> dispose() async {
    _recorder.dispose();
    await _player.dispose();
  }
}
