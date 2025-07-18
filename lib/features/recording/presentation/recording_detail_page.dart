import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

import '../domain/recording_entity.dart';
import '../domain/recording_repository.dart';
import '../../../core/di/injection.dart';

class RecordingDetailPage extends ConsumerStatefulWidget {
  final RecordingEntity recording;
  const RecordingDetailPage({super.key, required this.recording});

  @override
  ConsumerState<RecordingDetailPage> createState() => _RecordingDetailPageState();
}

class _RecordingDetailPageState extends ConsumerState<RecordingDetailPage> {
  late final AudioPlayer _player;
  late final TextEditingController _controller;
  bool _playing = false;

  RecordingRepository get _repo => getIt();

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _player.setFilePath(widget.recording.path);
    _controller = TextEditingController(text: widget.recording.note);
  }

  @override
  void dispose() {
    _player.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _toggle() async {
    if (_playing) {
      await _player.pause();
    } else {
      await _player.play();
    }
    setState(() => _playing = !_playing);
  }

  Future<void> _save() async {
    final updated = widget.recording.copyWith(note: _controller.text);
    await _repo.updateRecord(updated);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail"),
        centerTitle: true,
        elevation: 4,
        actions: [IconButton(onPressed: _save, icon: const Icon(Icons.save))],
      ),

      body: Column(
        children: [
          Hero(
            tag: widget.recording.id,
            child: Card(
              margin: const EdgeInsets.all(16),
              child: ListTile(title: Text(widget.recording.path.split('/').last), subtitle: Text('${widget.recording.duration.inSeconds}s')),
            ),
          ),
          IconButton(iconSize: 48, icon: Icon(_playing ? Icons.pause : Icons.play_arrow), onPressed: _toggle),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(prefixIcon: Icon(Icons.note), hintText: 'Note'),
            ),
          ),
        ],
      ),
    );
  }
}
