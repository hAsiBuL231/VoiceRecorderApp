import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/recorder_bloc.dart';
import '../widgets/record_button.dart';
import '../widgets/recording_list_item.dart';
import 'player_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Voice Recorder'),
      ),
      body: BlocBuilder<RecorderBloc, RecorderState>(
        builder: (context, state) {
          return Column(
            children: [
              Expanded(
                child: state.recordings.isEmpty
                    ? const Center(
                        child: Text('No recordings yet'),
                      )
                    : ListView.builder(
                        itemCount: state.recordings.length,
                        itemBuilder: (context, index) {
                          final recording = state.recordings[index];
                          return RecordingListItem(
                            recording: recording,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => PlayerScreen(recording: recording),
                                ),
                              );
                            },
                          );
                        },
                      ),
              ),
              if (state.isRecording)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text(
                        'Recording...',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: state.amplitude,
                      ),
                    ],
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: RecordButton(),
              ),
            ],
          );
        },
      ),
    );
  }
}
