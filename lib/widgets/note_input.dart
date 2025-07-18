import 'package:flutter/material.dart';

class NoteInput extends StatefulWidget {
  final String? initialValue;
  final ValueChanged<String> onSaved;
  final bool autofocus;

  const NoteInput({
    super.key,
    this.initialValue,
    required this.onSaved,
    this.autofocus = false,
  });

  @override
  State<NoteInput> createState() => _NoteInputState();
}

class _NoteInputState extends State<NoteInput> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        controller: _controller,
        autofocus: widget.autofocus,
        maxLines: null,
        decoration: const InputDecoration(
          hintText: 'Add a note...',
          border: InputBorder.none,
        ),
        onChanged: widget.onSaved,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );
  }
}
