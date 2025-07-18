import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:voice_recorder_app/core/ui_kit/toaster.dart';

import '../domain/i_recorder.dart';
import '../domain/recording_entity.dart';

class RecorderService implements IRecorder {
  final AudioRecorder _record;
  final Future<bool> Function() _requestPermission;
  late final Stream<double> _decibelStream;

  RecorderService({AudioRecorder? record, Future<bool> Function()? requestPermission})
    : _record = record ?? AudioRecorder(),
      _requestPermission = requestPermission ?? _defaultPermissionRequest {
    _decibelStream = _record.onAmplitudeChanged(const Duration(milliseconds: 300)).map((amp) => amp.current);
  }

  static Future<bool> _defaultPermissionRequest() async {
    final status = await Permission.microphone.request();
    return status.isGranted;
  }

  @override
  Future<void> start() async {
    if (!await _requestPermission()) {
      showToaster(message: "Microphone permission not granted");
      return;
    }
    final dir = await getTemporaryDirectory();
    final config = RecordConfig(
      encoder: AudioEncoder.aacLc, // or your preferred encoder
      numChannels: 1,
    );
    String path = '${dir.path}/recording_${DateTime.now().millisecondsSinceEpoch}.m4a';

    print("\n \n Path: $path \n");

    await _record.start(config, path: path);
  }

  @override
  Future<RecordingEntity> stop() async {
    final path = await _record.stop();
    if (path == null) {
      throw StateError('No recording in progress');
    }
    return RecordingEntity(path);
  }

  @override
  Stream<double> get decibelStream => _decibelStream;
}
