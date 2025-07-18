# Voice Recorder App

A simple and efficient Flutter voice recorder application with a clean, modern UI.

## Features

- Record audio with amplitude visualization
- List and playback recordings
- Playback speed control (1x, 1.5x, 2x)
- Material Design 3 UI

## Architecture

The app follows a simple and maintainable architecture using the BLoC pattern:

```
lib/
├── blocs/          # Business Logic Components
├── models/         # Data models
├── screens/        # UI screens
├── services/       # Core services
├── widgets/        # Reusable UI components
└── main.dart
```

### Key Components

- **BLoC Pattern**: Clean state management using flutter_bloc
- **AudioService**: Unified service for recording and playback
- **Reusable Widgets**: Modular components like RecordButton and RecordingListItem

## Dependencies

Core dependencies:
- flutter_bloc: State management
- record: Audio recording
- just_audio: Audio playback
- hive: Local storage
- permission_handler: Microphone permissions
