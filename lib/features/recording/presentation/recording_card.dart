import 'package:flutter/material.dart';
import '../domain/recording_entity.dart';

class RecordingCard extends StatelessWidget {
  final RecordingEntity recording;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const RecordingCard({
    super.key,
    required this.recording,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final text = recording.note?.isNotEmpty == true
        ? recording.note!
        : recording.path.split('/').last;
    return Hero(
      tag: recording.id,
      child: Card(
        child: ListTile(
          title: Text(text),
          subtitle: Text(
            '${recording.duration.inSeconds}s',
          ),
          onTap: onTap,
          onLongPress: onLongPress,
        ),
      ),
    );
  }
}