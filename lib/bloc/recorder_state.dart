part of 'recorder_bloc.dart';

class RecorderState extends Equatable {
  final bool isRecording;
  final double amplitude;
  final List<Recording> recordings;
  final String? error;

  const RecorderState({required this.isRecording, required this.amplitude, required this.recordings, this.error});

  RecorderState copyWith({bool? isRecording, double? amplitude, List<Recording>? recordings, String? error}) {
    return RecorderState(
      isRecording: isRecording ?? this.isRecording,
      amplitude: amplitude ?? this.amplitude,
      recordings: recordings ?? this.recordings,
      error: error,
    );
  }

  @override
  List<Object?> get props => [isRecording, amplitude, recordings, error];
}
