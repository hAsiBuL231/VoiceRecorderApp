import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/recording.dart';
import '../services/audio_service.dart';

// Events
abstract class RecorderEvent {}

class StartRecording extends RecorderEvent {}
class StopRecording extends RecorderEvent {}
class UpdateAmplitude extends RecorderEvent {
  final double amplitude;
  UpdateAmplitude(this.amplitude);
}

// States
class RecorderState extends Equatable {
  final bool isRecording;
  final double amplitude;
  final List<Recording> recordings;

  const RecorderState({
    required this.isRecording,
    required this.amplitude,
    required this.recordings,
  });

  RecorderState copyWith({
    bool? isRecording,
    double? amplitude,
    List<Recording>? recordings,
  }) {
    return RecorderState(
      isRecording: isRecording ?? this.isRecording,
      amplitude: amplitude ?? this.amplitude,
      recordings: recordings ?? this.recordings,
    );
  }

  @override
  List<Object?> get props => [isRecording, amplitude, recordings];
}

// BLoC
class RecorderBloc extends Bloc<RecorderEvent, RecorderState> {
  final AudioService _audioService;

  RecorderBloc(this._audioService) : super(
    const RecorderState(
      isRecording: false,
      amplitude: 0,
      recordings: [],
    )
  ) {
    on<StartRecording>(_onStartRecording);
    on<StopRecording>(_onStopRecording);
    on<UpdateAmplitude>(_onUpdateAmplitude);

    // Listen to amplitude changes
    _audioService.amplitude.listen(
      (amp) => add(UpdateAmplitude(amp)),
    );
  }

  Future<void> _onStartRecording(
    StartRecording event,
    Emitter<RecorderState> emit,
  ) async {
    try {
      await _audioService.startRecording();
      emit(state.copyWith(isRecording: true));
    } catch (e) {
      // Handle error
    }
  }

  Future<void> _onStopRecording(
    StopRecording event,
    Emitter<RecorderState> emit,
  ) async {
    if (!state.isRecording) return;

    try {
      final recording = await _audioService.stopRecording();
      emit(state.copyWith(
        isRecording: false,
        amplitude: 0,
        recordings: [...state.recordings, recording],
      ));
    } catch (e) {
      // Handle error
    }
  }

  void _onUpdateAmplitude(
    UpdateAmplitude event,
    Emitter<RecorderState> emit,
  ) {
    emit(state.copyWith(amplitude: event.amplitude));
  }
}
