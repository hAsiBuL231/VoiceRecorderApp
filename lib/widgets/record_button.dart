import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/recorder_bloc.dart';

class RecordButton extends StatelessWidget {
  final double size;
  final Color? color;

  const RecordButton({super.key, this.size = 72.0, this.color});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecorderBloc, RecorderState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () {
            HapticFeedback.mediumImpact();
            if (state.isRecording) {
              HapticFeedback.heavyImpact();
              context.read<RecorderBloc>().add(StopRecording());
            } else {
              HapticFeedback.lightImpact();
              context.read<RecorderBloc>().add(StartRecording());
            }
          },
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color ?? Theme.of(context).primaryColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              state.isRecording ? Icons.stop : Icons.mic,
              color: Colors.white,
              size: size * 0.5,
            ),
          ),
        );
      },
    );
  }
}
