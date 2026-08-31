import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import '../../component/customButton.dart';
import '../../component/textStyle.dart';

class AudioPlayerDialog extends StatefulWidget {
final String audioUrl;

  const AudioPlayerDialog({super.key, required this.audioUrl});

  @override
  State<AudioPlayerDialog> createState() => _AudioPlayerDialogState();
}

class _AudioPlayerDialogState extends State<AudioPlayerDialog> {
  late AudioPlayer _audioPlayer;
  bool isPlaying = false;
  double currentSpeed = 1.0;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();

    // Listen to duration changes
    _audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() => duration = newDuration);
    });

    // Listen to position changes (slider movement)
    _audioPlayer.onPositionChanged.listen((newPosition) {
      setState(() => position = newPosition);
    });

    // Listen when audio completes
    _audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        isPlaying = state == PlayerState.playing;
      });
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      titlePadding: const EdgeInsets.all(16),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      actionsPadding: const EdgeInsets.all(12),
      title: Text(
        "RECORDING",
        style: mozillaTextSemiBoldText(fontWeight: FontWeight.w800, fontSize: 18),
      ),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),

            Row(
              children: [
                IconButton(
                  icon: Icon(
                    isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
                    size: 36,
                    color: Colors.green,
                  ),
                  onPressed: () async {
                    if (isPlaying) {
                      await _audioPlayer.pause();
                    } else {
                      await _audioPlayer.play(UrlSource(widget.audioUrl));
                    }
                  },
                ),
                // Timeline Slider
                Expanded(
                  child: Slider(
                    min: 0,
                    max: duration.inSeconds.toDouble(),
                    value: position.inSeconds.toDouble().clamp(0.0, duration.inSeconds.toDouble()),
                    onChanged: (val) async {
                      final position = Duration(seconds: val.toInt());
                      await _audioPlayer.seek(position);
                    },
                    activeColor: Colors.green,
                    inactiveColor: Colors.grey.shade300,
                  ),
                ),

                const Icon(Icons.volume_up, color: Colors.grey),

                // Dots Vertical Playback Speed Option
                PopupMenuButton<double>(
                  icon: const Icon(Icons.more_vert, color: Colors.grey),
                  onSelected: (double speed) async {
                    setState(() {
                      currentSpeed = speed;
                    });
                    await _audioPlayer.setPlaybackRate(speed);
                  },
                  itemBuilder: (BuildContext context) => <PopupMenuEntry<double>>[
                    const PopupMenuItem<double>(value: 1.0, child: Text('1.0x Normal')),
                    const PopupMenuItem<double>(value: 1.5, child: Text('1.5x Speed')),
                    const PopupMenuItem<double>(value: 2.0, child: Text('2.0x Speed')),
                  ],
                ),
              ],
            ),
            // Duration details and Speed tag
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("${formatTime(position)} / ${formatTime(duration)}", style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text("${currentSpeed}x", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  )
                ],
              ),
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
      actions: [
        CustomButton(
          height: 35,
          width: 80,
          verticalPadding: 0.0,
          borderRadius: 4,
          btnText: "CLOSE",
          fontSize: 14,
          onTap: () {
            _audioPlayer.stop();
            Get.back();
          },
        ),
      ],
    );
  }
}