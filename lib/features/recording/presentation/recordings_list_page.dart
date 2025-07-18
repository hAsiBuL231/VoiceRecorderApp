import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../domain/recording_entity.dart';
import 'recordings_list_view_model.dart';
import 'recording_detail_page.dart';
import 'recording_card.dart';
import 'recording_page.dart';

class RecordingsListPage extends ConsumerWidget {
  const RecordingsListPage({super.key});

  void _showActions(BuildContext context, WidgetRef ref, RecordingEntity rec) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Edit'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => RecordingDetailPage(recording: rec),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text('Delete'),
                onTap: () {
                  ref.read(recordingsListProvider.notifier).delete(rec.id);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.share),
                title: const Text('Share'),
                onTap: () {
                  Share.shareXFiles([XFile(rec.path)]);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recordings = ref.watch(recordingsListProvider);
    final vm = ref.read(recordingsListProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text("Recordings"),
        centerTitle: true,
        elevation: 4,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const RecordingPage()),
          );
        },
        child: const Icon(Icons.mic),
      ),
      body: ReorderableListView.builder(
        itemCount: recordings.length,
        onReorder: (int oldIndex, int newIndex) {
          vm.reorder(oldIndex, newIndex); // Your provider should update the order in state
        },
        itemBuilder: (context, index) {
          final item = recordings[index];
          return ListTile(
            key: ValueKey(item.id),
            title: RecordingCard(
              recording: item,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => RecordingDetailPage(recording: item),
                  ),
                );
              },
              onLongPress: () => _showActions(context, ref, item),
            ),
          );
        },
      ),
    );
  }
}
