import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
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

class UpdateNote extends RecorderEvent {
  final String id;
  final String note;
  UpdateNote(this.id, this.note);
}

class DeleteRecording extends RecorderEvent {
  final String id;
  DeleteRecording(this.id);
}

class ShareRecording extends RecorderEvent {
  final Recording recording;
  ShareRecording(this.recording);
}

// States
class RecorderState extends Equatable {
  final bool isRecording;
  final double amplitude;
  final List<Recording> recordings;
  final String? error;

  const RecorderState({
    required this.isRecording,
    required this.amplitude,
    required this.recordings,
    this.error,
  });

  RecorderState copyWith({
    bool? isRecording,
    double? amplitude,
    List<Recording>? recordings,
    String? error,
  }) {
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

// BLoC
class RecorderBloc extends Bloc<RecorderEvent, RecorderState> {
  final AudioService _audioService;

  RecorderController get recorder => _audioService.recorder;

  RecorderBloc(this._audioService)
    : super(
        const RecorderState(isRecording: false, amplitude: 0, recordings: []),
      ) {
    on<StartRecording>(_onStartRecording);
    on<StopRecording>(_onStopRecording);
    on<UpdateAmplitude>(_onUpdateAmplitude);
    on<UpdateNote>(_onUpdateNote);
    on<DeleteRecording>(_onDeleteRecording);
    on<ShareRecording>(_onShareRecording);
  }

  Future<void> _onStartRecording(
    StartRecording event,
    Emitter<RecorderState> emit,
  ) async {
    try {
      await _audioService.startRecording();
      emit(state.copyWith(isRecording: true, error: null));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> _onStopRecording(
    StopRecording event,
    Emitter<RecorderState> emit,
  ) async {
    if (!state.isRecording) return;

    try {
      final recording = await _audioService.stopRecording();
      emit(
        state.copyWith(
          isRecording: false,
          amplitude: 0,
          recordings: [...state.recordings, recording],
          error: null,
        ),
      );
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  void _onUpdateAmplitude(UpdateAmplitude event, Emitter<RecorderState> emit) {
    emit(state.copyWith(amplitude: event.amplitude));
  }

  void _onUpdateNote(UpdateNote event, Emitter<RecorderState> emit) {
    final updatedRecordings = state.recordings.map((recording) {
      if (recording.id == event.id) {
        return recording.copyWith(note: event.note);
      }
      return recording;
    }).toList();

    emit(state.copyWith(recordings: updatedRecordings));
  }

  void _onDeleteRecording(DeleteRecording event, Emitter<RecorderState> emit) {
    final updatedRecordings = state.recordings
        .where((recording) => recording.id != event.id)
        .toList();

    emit(state.copyWith(recordings: updatedRecordings));
  }

  Future<void> _onShareRecording(
    ShareRecording event,
    Emitter<RecorderState> emit,
  ) async {
    try {
      await Share.shareXFiles([
        XFile(event.recording.path),
      ], text: event.recording.note);
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }
}
