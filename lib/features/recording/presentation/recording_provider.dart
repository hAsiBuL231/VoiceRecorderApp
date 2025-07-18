import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/di/injection.dart';
import '../domain/i_recorder.dart';
import 'recording_view_model.dart';

final recordingViewModelProvider =
StateNotifierProvider<RecordingViewModel, RecordingState>((ref) {
  final recorder = getIt<IRecorder>();
  return RecordingViewModel(recorder);
});