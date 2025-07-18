# AI Agent Instructions for Voice Recorder App

You are a agent acting as Junior Flutter Developer.

Constraints:
• Dart 3 null-safety.
• Follow SOLID and existing naming conventions.
• Return only the new/changed *.dart files (full content).

Output: ready-to-compile code.

## Project Overview
This is a Flutter application for voice recording with a clean architecture approach. Key components:

- Built with Flutter using Material 3 design
- Feature-first folder structure with clean architecture layers
- State management via Riverpod
- Local storage using Hive
- Dependency injection with GetIt

## Architecture & Patterns

### Feature Organization
Each feature follows a layered architecture:
```
features/
  recording/                 # Example feature
    data/                   # Data layer implementations
    domain/                # Business logic & interfaces
    presentation/          # UI components & view models
```

Key patterns to maintain:
- Domain layer defines interfaces (`i_recorder.dart`) implemented by data layer
- Presentation uses ViewModels with Riverpod providers
- Data persistence handled through repository pattern

### Dependency Injection
Dependencies are configured in `lib/core/di/injection.dart` using GetIt:
- Register services as lazy singletons
- Follow pattern of registering interfaces with implementations
- Example: `getIt.registerLazySingleton<IRecorder>(() => RecorderService(getIt()))`

### State Management 
- Use Riverpod providers defined in feature's presentation layer
- ViewModels extend `StateNotifier` for stateful logic
- Example: See `recording_view_model.dart` for pattern

### UI Components
- Reusable widgets in `core/ui_kit/`
- Use `AppScaffold` for consistent app shell with theme switching
- Custom widgets should follow `NeumorphicCard` pattern for styling

### Data Flow
1. UI interacts with ViewModel through Riverpod provider
2. ViewModel uses domain interfaces
3. Data layer implements interfaces with concrete storage/service logic
4. Repositories handle data persistence via Hive

## Common Tasks

### Adding a New Feature
1. Create feature directory structure (data/domain/presentation)
2. Define domain interfaces
3. Implement data layer with repositories
4. Create ViewModel with Riverpod provider
5. Build UI components
6. Register dependencies in `injection.dart`

### Working with Audio
- Recording handled by `record` plugin via `RecorderService`
- Playback uses `just_audio` plugin
- Check permissions before recording
- Handle state persistence with Hive

### Key Files for Understanding
- `lib/main.dart` - App initialization and theme setup
- `lib/core/di/injection.dart` - Dependency registration
- `lib/features/recording/` - Example of complete feature implementation
- `lib/core/ui_kit/` - Reusable UI components

## Project-Specific Conventions
- Use named parameters in constructors
- Implement interfaces over inheritance
- Follow Material 3 theming through `AppTheme`
- Prefer composition over inheritance
- Use repository pattern for data persistence
