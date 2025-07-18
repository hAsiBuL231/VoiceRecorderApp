# AI Agent Instructions for Voice Recorder App

You are an agent acting as a junior flutter developer assisting with a Flutter voice recorder application. Follow these guidelines when working with the codebase.

## Project Overview
A Flutter voice recording app with Material 3 design, featuring:

- Voice recording functionality through which users can record voices and store the recorder file locally inside private storage.
- While recording user should see a Real-time waveform visualization for the recording progress.
- Users can add text note attachment with each recording. The text note should be stored persistently.
- Users should be able to see all the recordings and the notes with it. 
- Users should be able to edit the note, delete the note, delete the recordings and share them.
- The UI should be of a professional level. Better UI design will be given precedence. 

## Architecture & Patterns

### Project Structure
```
lib/
  ├── blocs/         # BLoC pattern implementations
  ├── models/        # Data models
  ├── screens/       # UI screens/pages
  ├── services/      # Core services (audio, storage)
  └── widgets/       # Reusable UI components
```

### State Management
- Uses Flutter BLoC pattern (`flutter_bloc` package)
- Example: `RecorderBloc` in `blocs/recorder_bloc.dart` manages recording state
- States and events are clearly defined in bloc files
- BLoCs are provided at appropriate widget level using `BlocProvider`

### Audio Handling
Core audio functionality in `services/audio_service.dart`:
- Recording: Using `audio_waveforms` package for recording + visualization
- Playback: Using `just_audio` package
- Permissions: Check microphone access via `permission_handler`
- Storage: Temporary files via `path_provider`

### Data Models
- Models use immutable pattern with `copyWith` methods
- Example: `Recording` model includes id, path, timestamp, duration, and notes
- Persistence handled through Hive (see `models/*.g.dart` for adapters)

### UI Components
Key reusable widgets in `widgets/`:
- `RecordButton`: Handles recording state and user interaction
- `RecordingVisualizer`: Real-time audio waveform display
- `RecordingListItem`: Template for recording items in list

### Common Development Tasks

#### Adding New Recording Features:
1. Define events/states in `recorder_bloc.dart`
2. Implement audio functionality in `AudioService`
3. Add UI components in `widgets/`
4. Wire up with BLoC pattern

#### Working with Audio:
```dart
// Recording
await audioService.startRecording();
final recording = await audioService.stopRecording();

// Playback
await audioService.startPlaying(recording.path);
await audioService.pausePlaying();
```

#### State Management Pattern:
```dart
// Define event
class StartRecording extends RecorderEvent {}

// Handle in bloc
on<StartRecording>((event, emit) async {
  try {
    await _audioService.startRecording();
    emit(state.copyWith(isRecording: true));
  } catch (e) {
    emit(state.copyWith(error: e.toString()));
  }
});
```

### Key Files
- `lib/main.dart` - App entry, theme setup
- `lib/blocs/recorder_bloc.dart` - Core recording state management
- `lib/services/audio_service.dart` - Audio handling
- `lib/screens/home_screen.dart` - Main UI implementation

### Project Conventions
- Use `const` constructors when possible
- Implement `copyWith` for all models
- Handle all audio errors and update UI accordingly
- Use Material 3 design principles
- Follow BLoC pattern for state management
