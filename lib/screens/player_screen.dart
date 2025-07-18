import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart' show ProcessingState;
import '../blocs/recorder_bloc.dart';
import '../models/recording.dart';
import '../services/audio_service.dart';
import '../widgets/note_input.dart';

class PlayerScreen extends StatefulWidget {
  final Recording recording;

  const PlayerScreen({super.key, required this.recording});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  late final AudioService _audioService;
  bool _isPlaying = false;
  bool _isLoading = true;
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
    try {
      setState(() => _isLoading = true);
      // Start loading the audio file
      await _audioService.startPlaying(widget.recording.path);
      await _audioService.pausePlaying(); // Pause immediately
      if (mounted) setState(() => _isLoading = false);

      // Set initial duration
      setState(() => _duration = _audioService.duration);

      // Listen to position changes
      _audioService.position.listen((pos) {
        if (mounted) {
          setState(() => _position = pos);
          // Check if we reached the end
          if (_duration != null && pos >= _duration!) {
            setState(() => _isPlaying = false);
          }
        }
      });

      // Listen to playback state changes
      _audioService.isPlaying.listen((playing) {
        if (mounted) setState(() => _isPlaying = playing);
      });

      // Listen to processing state for errors and completion
      _audioService.processingStateStream.listen((state) {
        if (!mounted) return;
        if (state == ProcessingState.completed) {
          setState(() => _isPlaying = false);
          _audioService.seekTo(Duration.zero);
        }
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading audio: ${e.toString()}')),
        );
      }
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
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
        title: const Text('Recording Details'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              context.read<RecorderBloc>().add(
                ShareRecording(widget.recording),
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Recording info card
                Card(
                  margin: const EdgeInsets.all(16),
                  elevation: 0,
                  color: Theme.of(
                    context,
                  ).colorScheme.primaryContainer.withOpacity(0.1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(
                          Icons.mic,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Recorded on ${_formatDate(widget.recording.createdAt)}',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Duration: ${_formatDuration(widget.recording.duration)}',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Player card
                Expanded(
                  child: Card(
                    margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        // Waveform placeholder
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(
                                context,
                              ).colorScheme.surfaceVariant,
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(20),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                _formatDuration(_position),
                                style: Theme.of(context).textTheme.displaySmall
                                    ?.copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurfaceVariant,
                                    ),
                              ),
                            ),
                          ),
                        ),

                        // Player controls
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(
                                color: Theme.of(
                                  context,
                                ).colorScheme.outlineVariant,
                              ),
                            ),
                          ),
                          child: Column(
                            children: [
                              // Progress slider
                              if (_duration != null)
                                SliderTheme(
                                  data: SliderThemeData(
                                    trackHeight: 4,
                                    thumbShape: RoundSliderThumbShape(
                                      enabledThumbRadius: 6,
                                      elevation: 4,
                                    ),
                                  ),
                                  child: Slider(
                                    value: _position.inSeconds.toDouble(),
                                    max: _duration!.inSeconds.toDouble(),
                                    onChanged: (value) {
                                      _audioService.seekTo(
                                        Duration(seconds: value.toInt()),
                                      );
                                    },
                                  ),
                                ),

                              const SizedBox(height: 8),

                              // Time indicators
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _formatDuration(_position),
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall,
                                  ),
                                  Text(
                                    _formatDuration(_duration ?? Duration.zero),
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall,
                                  ),
                                ],
                              ),

                              const SizedBox(height: 16),

                              // Play controls and speed
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Card(
                                    elevation: 0,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primaryContainer,
                                    shape: const CircleBorder(),
                                    child: IconButton(
                                      iconSize: 32,
                                      padding: const EdgeInsets.all(16),
                                      icon: Icon(
                                        _isPlaying
                                            ? Icons.pause_rounded
                                            : Icons.play_arrow_rounded,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onPrimaryContainer,
                                      ),
                                      onPressed: () async {
                                        try {
                                          if (_isPlaying) {
                                            await _audioService.pausePlaying();
                                          } else {
                                            if (_position.inSeconds == 0 ||
                                                _position >=
                                                    (_duration ??
                                                        Duration.zero)) {
                                              await _audioService.startPlaying(
                                                widget.recording.path,
                                              );
                                            } else {
                                              await _audioService
                                                  .resumePlaying();
                                            }
                                          }
                                        } catch (e) {
                                          if (mounted) {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  'Error: ${e.toString()}',
                                                ),
                                              ),
                                            );
                                          }
                                        }
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  PopupMenuButton<double>(
                                    initialValue: _speed,
                                    child: Chip(
                                      avatar: const Icon(Icons.speed, size: 18),
                                      label: Text('${_speed}x'),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                    itemBuilder: (context) =>
                                        [1.0, 1.5, 2.0].map((speed) {
                                          return PopupMenuItem(
                                            value: speed,
                                            child: Text('${speed}x Speed'),
                                          );
                                        }).toList(),
                                    onSelected: (speed) {
                                      setState(() => _speed = speed);
                                      _audioService.setPlaybackSpeed(speed);
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Note section
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.note_alt_outlined,
                            color: Theme.of(context).colorScheme.primary,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Note',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      NoteInput(
                        initialValue: widget.recording.note,
                        onSaved: (note) {
                          context.read<RecorderBloc>().add(
                            UpdateNote(widget.recording.id, note),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
