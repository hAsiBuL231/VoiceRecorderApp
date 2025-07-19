import 'package:flutter/material.dart';
import '../models/recording.dart';

class RecordingListItem extends StatelessWidget {
  final Recording recording;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const RecordingListItem({super.key, required this.recording, required this.onTap, required this.onDelete});

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}';
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(recording.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        return showDeleteConfirmationDialog(context);
      },
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) {
        onDelete();
      },
      child: Card(
        elevation: 2,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: ListTile(
          onTap: onTap,
          leading: const CircleAvatar(child: Icon(Icons.audio_file)),
          title: Text(_formatDate(recording.createdAt)),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(_formatDuration(recording.duration)),
              if (recording.note != null && recording.note!.trim().isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    recording.note!,
                    style: TextStyle(color: Colors.grey[700], fontStyle: FontStyle.italic),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
            ],
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              final confirmed = await showDeleteConfirmationDialog(context);
              if (confirmed) {
                onDelete();
              }
            },
          ),
        ),
      ),
    );
  }
}

Future<bool> showDeleteConfirmationDialog(context) async {
  return await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Delete Recording'),
        content: const Text('Are you sure you want to delete this recording?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('CANCEL')),
          TextButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('DELETE')),
        ],
      );
    },
  );
}
