import 'package:flutter/material.dart';

class NoteInput extends StatefulWidget {
  final String? initialValue;
  final ValueChanged<String> onSaved;

  const NoteInput({super.key, this.initialValue, required this.onSaved});

  @override
  State<NoteInput> createState() => _NoteInputState();
}

class _NoteInputState extends State<NoteInput> {
  late final TextEditingController _controller;
  bool _showSave = false;
  String? _lastSavedValue;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
    _lastSavedValue = widget.initialValue;
    _controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    final changed = _controller.text != (_lastSavedValue ?? '');
    if (_showSave != changed) {
      setState(() {
        _showSave = changed;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _saveNote() {
    widget.onSaved(_controller.text);
    setState(() {
      _lastSavedValue = _controller.text;
      _showSave = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Note saved!'), duration: Duration(milliseconds: 900)));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceVariant, borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: TextField(
            controller: _controller,
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: 'Add a note...',
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 10), // Space for button
            ),
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        if (_showSave)
          Positioned(
            top: 8,
            right: 16,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.save, size: 18),
              label: const Text('Save', style: TextStyle(fontSize: 14)),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(10, 32),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              onPressed: _saveNote,
            ),
          ),
      ],
    );
  }
}
