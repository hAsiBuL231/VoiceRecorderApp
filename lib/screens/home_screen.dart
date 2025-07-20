import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/recorder_bloc.dart';
import '../widgets/record_button.dart';
import '../widgets/recording_list_item.dart';
import '../widgets/recording_visualizer.dart';
import '../widgets/timer_widget.dart';
import 'player_screen.dart';

class HomeScreen extends StatelessWidget {
  final ThemeMode themeMode;
  final VoidCallback onToggleTheme;
  const HomeScreen({super.key, required this.themeMode, required this.onToggleTheme});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Voice Recorder'),
        titleTextStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: themeMode == ThemeMode.light ? Colors.redAccent : Colors.greenAccent),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'Toggle theme',
            icon: Icon(themeMode == ThemeMode.light ? Icons.dark_mode_rounded : Icons.light_mode_rounded),
            onPressed: onToggleTheme,
          ),
        ],
      ),
      body: BlocConsumer<RecorderBloc, RecorderState>(
        listener: (context, state) {
          if (state.error != null) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.error!)));
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              Expanded(
                child: state.recordings.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.mic_none, size: 64, color: Theme.of(context).colorScheme.primary),
                            const SizedBox(height: 16),
                            Text('No recordings yet', style: Theme.of(context).textTheme.titleLarge),
                            const SizedBox(height: 8),
                            Text('Tap the button below to start recording', style: Theme.of(context).textTheme.bodyMedium),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: state.recordings.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          final reversedIndex = state.recordings.length - 1 - index;

                          final recording = state.recordings[reversedIndex];
                          return RecordingListItem(
                            recording: recording,
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (_) => PlayerScreen(recording: recording)));
                            },
                            onDelete: () {
                              context.read<RecorderBloc>().add(DeleteRecording(recording.id));
                            },
                          );
                        },
                      ),
              ),
              if (state.isRecording)
                Card(
                  margin: const EdgeInsets.all(20),
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Theme.of(context).colorScheme.primary.withOpacity(0.1), Theme.of(context).colorScheme.surface],
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.mic, color: Theme.of(context).colorScheme.primary, size: 24),
                            const SizedBox(width: 8),
                            Text(
                              'Recording in progress...',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        TimerWidget(isRecording: state.isRecording),
                        const SizedBox(height: 20),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Theme.of(context).colorScheme.primary.withOpacity(0.2), width: 1),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: RecordingVisualizer(controller: context.read<RecorderBloc>().recorder, color: Theme.of(context).colorScheme.primary),
                        ),
                      ],
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: RecordButton(color: Theme.of(context).colorScheme.primary),
              ),
            ],
          );
        },
      ),
    );
  }
}
