import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';

import '../models/recording.dart';
import '../services/audio_service.dart';
import '../services/hive_service.dart';

part 'recorder_event.dart';
part 'recorder_state.dart';

class RecorderBloc extends Bloc<RecorderEvent, RecorderState> {
  final AudioService _audioService;
  final HiveService _hiveService;

  RecorderController get recorder => _audioService.recorder;

  RecorderBloc(this._audioService, this._hiveService) : super(const RecorderState(isRecording: false, amplitude: 0, recordings: [])) {
    _loadRecordings();
    on<StartRecording>(_onStartRecording);
    on<StopRecording>(_onStopRecording);
    on<UpdateAmplitude>(_onUpdateAmplitude);
    on<UpdateNote>(_onUpdateNote);
    on<DeleteRecording>(_onDeleteRecording);
    on<ShareRecording>(_onShareRecording);
  }

  Future<void> _onStartRecording(StartRecording event, Emitter<RecorderState> emit) async {
    try {
      await _audioService.startRecording();
      emit(state.copyWith(isRecording: true, error: null));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> _loadRecordings() async {
    try {
      final recordings = await _hiveService.getRecordings();
      emit(state.copyWith(recordings: recordings));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> _onStopRecording(StopRecording event, Emitter<RecorderState> emit) async {
    if (!state.isRecording) return;

    try {
      final recording = await _audioService.stopRecording();
      await _hiveService.saveRecording(recording);
      emit(state.copyWith(isRecording: false, amplitude: 0, recordings: [...state.recordings, recording], error: null));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  void _onUpdateAmplitude(UpdateAmplitude event, Emitter<RecorderState> emit) {
    emit(state.copyWith(amplitude: event.amplitude));
  }

  Future<void> _onUpdateNote(UpdateNote event, Emitter<RecorderState> emit) async {
    try {
      final updatedRecordings = state.recordings.map((recording) {
        if (recording.id == event.id) {
          final updatedRecording = recording.copyWith(note: event.note);
          _hiveService.updateRecording(updatedRecording);
          return updatedRecording;
        }
        return recording;
      }).toList();

      emit(state.copyWith(recordings: updatedRecordings));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> _onDeleteRecording(DeleteRecording event, Emitter<RecorderState> emit) async {
    try {
      await _hiveService.deleteRecording(event.id);
      final updatedRecordings = state.recordings.where((recording) => recording.id != event.id).toList();

      emit(state.copyWith(recordings: updatedRecordings));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> _onShareRecording(ShareRecording event, Emitter<RecorderState> emit) async {
    try {
      await Share.shareXFiles([XFile(event.recording.path)], text: event.recording.note);
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }
}
