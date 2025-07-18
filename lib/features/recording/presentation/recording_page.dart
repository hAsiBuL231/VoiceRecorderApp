import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/ui_kit/primary_button.dart';
import 'recording_provider.dart';
import 'wave_bubble.dart';

class RecordingPage extends ConsumerWidget {
  const RecordingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(recordingViewModelProvider);
    final viewModel = ref.read(recordingViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: Text("Recorder"), centerTitle: true, elevation: 6),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 100,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: WaveBubble(amplitude: state.amplitude),
            ),
          ),
          const SizedBox(height: 16),
          PrimaryButton(onPressed: viewModel.toggle, child: Text(state.isRecording ? 'Stop' : 'Record')),
        ],
      ),
    );
  }
}
