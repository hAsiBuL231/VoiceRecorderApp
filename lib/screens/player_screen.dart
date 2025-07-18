import 'package:flutter/material.dart';
import '../models/recording.dart';
import '../services/audio_service.dart';

class PlayerScreen extends StatefulWidget {
  final Recording recording;

  const PlayerScreen({
    super.key,
    required this.recording,
  });

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  late final AudioService _audioService;
  bool _isPlaying = false;
  Duration _position = Duration.zero;
  Duration? _duration;
  double _speed = 1.0;

  @override
  void initState() {
    super.initState();
    _audioService = AudioService();
    _setupAudio();
  }

  Future<void> _setupAudio() async {
    await _audioService.startPlaying(widget.recording.path);
    _audioService.position.listen((pos) {
      if (mounted) setState(() => _position = pos);
    });
    _audioService.isPlaying.listen((playing) {
      if (mounted) setState(() => _isPlaying = playing);
    });
    setState(() => _duration = _audioService.duration);
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  void dispose() {
    _audioService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Playing Recording'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _formatDuration(_position),
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            if (_duration != null)
              Slider(
                value: _position.inSeconds.toDouble(),
                max: _duration!.inSeconds.toDouble(),
                onChanged: (value) {
                  _audioService.seekTo(Duration(seconds: value.toInt()));
                },
              ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  iconSize: 64,
                  icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                  onPressed: () {
                    if (_isPlaying) {
                      _audioService.pausePlaying();
                    } else {
                      _audioService.startPlaying(widget.recording.path);
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            DropdownButton<double>(
              value: _speed,
              items: [1.0, 1.5, 2.0].map((speed) {
                return DropdownMenuItem(
                  value: speed,
                  child: Text('${speed}x'),
                );
              }).toList(),
              onChanged: (speed) {
                if (speed != null) {
                  setState(() => _speed = speed);
                  _audioService.setPlaybackSpeed(speed);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
