import 'package:flutter/material.dart';
import 'package:audio_waveforms/audio_waveforms.dart';

class RecordingVisualizer extends StatelessWidget {
  final RecorderController controller;
  final Color color;

  const RecordingVisualizer({super.key, required this.controller, required this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: AudioWaveforms(
        enableGesture: false,
        size: Size(MediaQuery.of(context).size.width, 80),
        recorderController: controller,
        waveStyle: WaveStyle(
          showMiddleLine: false,
          extendWaveform: true,
          spacing: 4.0,
          waveColor: color,
          showDurationLabel: false,
          waveCap: StrokeCap.round,
          waveThickness: 3,
        ),
      ),
    );
  }
}
