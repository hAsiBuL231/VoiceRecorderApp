import 'package:flutter/material.dart';

class WaveBubble extends StatelessWidget {
  final double amplitude;

  const WaveBubble({super.key, required this.amplitude});

  @override
  Widget build(BuildContext context) {
    final height = (amplitude.abs() / 120) * 60 + 2;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 100),
      width: 6,
      height: height.clamp(2.0, 60.0),
      margin: const EdgeInsets.symmetric(horizontal: 1),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}