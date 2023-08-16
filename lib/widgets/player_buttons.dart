import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class PlayerButtons extends StatefulWidget {
  const PlayerButtons({
    super.key,
    required this.audioPlayer,
  });

  final AudioPlayer audioPlayer;

  @override
  State<PlayerButtons> createState() => _PlayerButtonsState();
}

class _PlayerButtonsState extends State<PlayerButtons> {
  bool _isMute = false;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
            onPressed: () {
              setState(() {
                _isMute = !_isMute;
                widget.audioPlayer.setVolume(_isMute ? 0.0 : 1.0);
              });
            },
            icon: _isMute
                ? const Icon(
                    Icons.music_off_rounded,
                    color: Colors.white,
                  )
                : const Icon(
                    Icons.music_note_rounded,
                    color: Colors.white,
                  )),
        StreamBuilder<SequenceState?>(
          stream: widget.audioPlayer.sequenceStateStream,
          builder: (context, index) {
            return IconButton(
              onPressed: () {
                if (widget.audioPlayer.hasPrevious) {
                  if (widget.audioPlayer.position.inMilliseconds <= 5000) {
                    widget.audioPlayer.seekToPrevious();
                  } else {
                    widget.audioPlayer.seek(
                      const Duration(
                        milliseconds: 0,
                      ),
                    );
                  }
                } else {
                  widget.audioPlayer.seek(
                    const Duration(
                      milliseconds: 0,
                    ),
                  );
                }
              },
              icon: const Icon(
                Icons.skip_previous,
                color: Colors.white,
              ),
              iconSize: 45,
            );
          },
        ),
        StreamBuilder<PlayerState>(
          stream: widget.audioPlayer.playerStateStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final playerState = snapshot.data;
              final processingState = playerState!.processingState;

              if (processingState == ProcessingState.loading ||
                  processingState == ProcessingState.buffering) {
                return Container(
                  width: 64.0,
                  height: 64.0,
                  margin: const EdgeInsets.all(10.0),
                  child: const CircularProgressIndicator(),
                );
              } else if (!widget.audioPlayer.playing) {
                return IconButton(
                  onPressed: widget.audioPlayer.play,
                  icon: const Icon(
                    Icons.play_circle,
                    size: 75,
                    color: Colors.white,
                  ),
                );
              } else if (processingState != ProcessingState.completed) {
                return IconButton(
                  onPressed: widget.audioPlayer.pause,
                  icon: const Icon(
                    Icons.pause,
                    size: 75,
                    color: Colors.white,
                  ),
                );
              } else {
                return IconButton(
                  onPressed: () => widget.audioPlayer.seek(
                    Duration.zero,
                    index: widget.audioPlayer.effectiveIndices!.first,
                  ),
                  icon: const Icon(
                    Icons.replay_circle_filled_outlined,
                    size: 75,
                    color: Colors.white,
                  ),
                );
              }
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
        StreamBuilder<SequenceState?>(
          stream: widget.audioPlayer.sequenceStateStream,
          builder: (context, index) {
            return IconButton(
              onPressed: widget.audioPlayer.hasNext
                  ? widget.audioPlayer.seekToNext
                  : null,
              icon: const Icon(
                Icons.skip_next,
                color: Colors.white,
              ),
              iconSize: 45,
            );
          },
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.send_rounded,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
