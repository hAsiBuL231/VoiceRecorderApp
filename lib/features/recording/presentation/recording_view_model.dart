import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/i_recorder.dart';

class RecordingState {
  final bool isRecording;
  final double amplitude;

  const RecordingState({required this.isRecording, required this.amplitude});

  RecordingState copyWith({bool? isRecording, double? amplitude}) {
    return RecordingState(
      isRecording: isRecording ?? this.isRecording,
      amplitude: amplitude ?? this.amplitude,
    );
  }

  static const initial = RecordingState(isRecording: false, amplitude: 0);
}

class RecordingViewModel extends StateNotifier<RecordingState> {
  final IRecorder _recorder;

  RecordingViewModel(this._recorder) : super(RecordingState.initial) {
    _recorder.decibelStream.listen(
          (value) => state = state.copyWith(amplitude: value),
    );
  }

  Future<void> toggle() async {
    if (state.isRecording) {
      await _recorder.stop();
    } else {
      await _recorder.start();
    }
    state = state.copyWith(isRecording: !state.isRecording);
  }
}