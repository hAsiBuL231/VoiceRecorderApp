import 'package:flutter/material.dart';

import '../core/ui_kit/primary_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text("Voice Recorder App"), centerTitle: true, elevation: 6),
        body: Center(
          child: PrimaryButton(onPressed: () {}, child: const Text('Record')),
        ),
      ),
    );
  }
}
