import 'package:flutter/material.dart';

class NoteChip extends StatelessWidget {
  final String? note;
  final ValueChanged<String> onSaved;

  const NoteChip({super.key, required this.note, required this.onSaved});

  bool get _hasNote => note != null && note!.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => showNoteEditor(context: context, initialValue: note, onSaved: onSaved),
      child: Container(
        constraints: BoxConstraints(minWidth: MediaQuery.sizeOf(context).width, minHeight: 100),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: scheme.secondaryContainer, borderRadius: BorderRadius.circular(12)),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 100), // space for button
              child: Text(
                _hasNote ? note!.trim() : 'Add note',
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelMedium!.copyWith(color: scheme.onSecondaryContainer),
              ),
            ),

            Positioned(
              top: 0,
              right: 0,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => showNoteEditor(context: context, initialValue: note, onSaved: onSaved),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(color: scheme.onInverseSurface, borderRadius: BorderRadius.circular(12)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(_hasNote ? Icons.edit_note_rounded : Icons.note_add_rounded, size: 18, color: scheme.onSecondaryContainer),
                      const SizedBox(width: 6),
                      Text(_hasNote ? 'Edit note' : 'Add note', style: Theme.of(context).textTheme.labelMedium!.copyWith(color: scheme.onSecondaryContainer)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> showNoteEditor({required BuildContext context, String? initialValue, required ValueChanged<String> onSaved}) async {
  final controller = TextEditingController(text: initialValue);
  final scheme = Theme.of(context).colorScheme;

  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
    builder: (ctx) {
      return Padding(
        padding: EdgeInsets.fromLTRB(16, 20, 16, 16 + MediaQuery.viewInsetsOf(ctx).bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Pull-bar
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(color: scheme.outlineVariant, borderRadius: BorderRadius.circular(2)),
            ),
            TextField(
              controller: controller,
              maxLines: 4,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: 'Type your note here…',
                border: OutlineInputBorder(borderSide: BorderSide.none),
                filled: true,
              ),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.save_rounded, size: 20),
                label: const Text('Save'),
                onPressed: () {
                  onSaved(controller.text);
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Note saved!'), duration: Duration(milliseconds: 900)));
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}
