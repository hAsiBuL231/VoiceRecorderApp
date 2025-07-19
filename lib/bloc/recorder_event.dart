part of 'recorder_bloc.dart';

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