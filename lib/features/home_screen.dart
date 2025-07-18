import 'package:flutter/material.dart';

import '../core/di/injection.dart';
import '../core/ui_kit/primary_button.dart';
import 'recording/domain/i_recorder.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isRecording = false;

  Future<void> _toggleRecord() async {
    final recorder = getIt<IRecorder>();
    if (_isRecording) {
      await recorder.stop();
    } else {
      await recorder.start();
    }
    setState(() => _isRecording = !_isRecording);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text("Voice Recorder App"), centerTitle: true, elevation: 6),
        body: Center(
          child: PrimaryButton(onPressed: _toggleRecord, child: const Text('Record')),
        ),
      ),
    );
  }
}
