import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import '../models/recording.dart';

class RecordingListItem extends StatelessWidget {
  final Recording recording;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  RecordingListItem({super.key, required this.recording, required this.onTap, required this.onDelete});

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  final _dateFmt = DateFormat('EEE, d MMM yyyy ‣ h:mm a');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Dismissible(
        key: Key(recording.id),
        direction: DismissDirection.endToStart,
        confirmDismiss: (dir) async => showDeleteConfirmationDialog(context),
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 24),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [scheme.error, scheme.errorContainer], begin: Alignment.centerLeft, end: Alignment.centerRight),
          ),
          child: Icon(Icons.delete_forever_rounded, color: scheme.onErrorContainer, size: 32),
        ),
        onDismissed: (_) => onDelete(),
        child: Material(
          color: scheme.surfaceContainerHighest, // subtle tint
          elevation: 1.5,
          borderRadius: BorderRadius.circular(16),
          clipBehavior: Clip.antiAlias, // for ripple & blur effects
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Leading icon with slight depth & color
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: scheme.primaryContainer,
                    foregroundColor: scheme.onPrimaryContainer,
                    child: const Icon(Icons.play_arrow_rounded, size: 24),
                  ),
                  const SizedBox(width: 8),
                  // Main info column (expands)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            // Date line
                            Text(_dateFmt.format(recording.createdAt), style: theme.textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w600)),
                            SizedBox(width: 6),
                            // Duration chip
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(color: scheme.secondaryContainer, borderRadius: BorderRadius.circular(8)),
                              child: Text(
                                _formatDuration(recording.duration),
                                style: Theme.of(context).textTheme.labelMedium!.copyWith(color: scheme.onSecondaryContainer),
                              ),
                            ),
                          ],
                        ),
                        // Optional note
                        if (recording.note?.trim().isNotEmpty ?? false) ...[
                          const SizedBox(height: 6),
                          Text(
                            recording.note!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                            style: theme.textTheme.bodyMedium!.copyWith(color: scheme.onSurfaceVariant),
                          ),
                        ],
                      ],
                    ),
                  ),
                  // Trailing overflow menu
                  _MoreMenu(
                    recording: recording,
                    shareText: recording.note?.trim().isNotEmpty ?? false ? recording.note! : 'Recording ${recording.id}',
                    onDelete: () async {
                      if (await showDeleteConfirmationDialog(context)) onDelete();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Three-dot overflow menu (currently only “Delete”, easy to expand later).
enum _MenuItem { share, delete }

class _MoreMenu extends StatelessWidget {
  const _MoreMenu({required this.recording, required this.shareText, required this.onDelete});

  final Recording recording;
  final String shareText;
  final Future<void> Function() onDelete;

  @override
  Widget build(BuildContext context) => PopupMenuButton<_MenuItem>(
    icon: const Icon(Icons.more_vert_rounded),
    onSelected: (value) async {
      switch (value) {
        case _MenuItem.share:
          if (recording.path.isNotEmpty) {
            await Share.shareXFiles([XFile(recording.path)], text: shareText);
          } else {
            await Share.share(shareText);
          }
          break;
        case _MenuItem.delete:
          await onDelete();
          break;
      }
    },
    itemBuilder: (context) => const [
      PopupMenuItem(
        value: _MenuItem.share,
        child: ListTile(leading: Icon(Icons.share_rounded), title: Text('Share')),
      ),
      PopupMenuItem(
        value: _MenuItem.delete,
        child: ListTile(leading: Icon(Icons.delete_outline_rounded), title: Text('Delete')),
      ),
    ],
  );
}

Future<bool> showDeleteConfirmationDialog(BuildContext context) async {
  return await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Delete recording?'),
          content: const Text('This action cannot be undone. Proceed with delete?'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('CANCEL')),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Theme.of(context).colorScheme.error),
              onPressed: () => Navigator.pop(context, true),
              child: const Text('DELETE'),
            ),
          ],
        ),
      ) ??
      false;
}
