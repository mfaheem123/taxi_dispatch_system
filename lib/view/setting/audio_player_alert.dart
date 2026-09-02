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
    return FocusScope(
        autofocus: true,
      child: AlertDialog(
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
                  visualDensity: VisualDensity.compact,
                  splashRadius: 15,
                  icon: Icon(
                    isPlaying ? Icons.pause : Icons.play_arrow,
                    size: 28,
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
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: 3.0,
                      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6.0),
                      overlayShape: const RoundSliderOverlayShape(overlayRadius: 12.0),
                    ),
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
                  )),
                ),

                const Icon(Icons.volume_up, color: Colors.grey),

                // Dots Vertical Playback Speed Option
                SizedBox(
                  width: 30,
                  height: 30,
                  child: PopupMenuButton<double>(
                    constraints: const BoxConstraints(
                      maxHeight: 180,
                      maxWidth: 100,
                    ),
                    padding: EdgeInsets.zero,
                    splashRadius: 15,
                    icon: const Icon(Icons.more_vert, color: Colors.grey, size: 20),
                    onSelected: (double speed) async {
                      setState(() {
                        currentSpeed = speed;
                      });
                      await _audioPlayer.setPlaybackRate(speed);
                    },
                    itemBuilder: (BuildContext context) => <PopupMenuEntry<double>>[
                      const PopupMenuItem<double>(height: 32, value: 0.5, child: Text('0.5x', style: TextStyle(fontSize: 13))),
                      const PopupMenuItem<double>(height: 32, value: 0.75, child: Text('0.75x', style: TextStyle(fontSize: 13))),
                      const PopupMenuItem<double>(height: 32, value: 1.0, child: Text('NORMAL', style: TextStyle(fontSize: 13))),
                      const PopupMenuItem<double>(height: 32, value: 1.25, child: Text('1.25x', style: TextStyle(fontSize: 13))),
                      const PopupMenuItem<double>(height: 32, value: 1.5, child: Text('1.5x', style: TextStyle(fontSize: 13))),
                      const PopupMenuItem<double>(height: 32, value: 1.75, child: Text('1.75x', style: TextStyle(fontSize: 13))),
                      const PopupMenuItem<double>(height: 32, value: 2.0, child: Text('2.0x', style: TextStyle(fontSize: 13))),
                    ],
                  ),
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
                  // Container(
                  //   padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  //   decoration: BoxDecoration(
                  //     color: Colors.grey.shade200,
                  //     borderRadius: BorderRadius.circular(4),
                  //   ),
                  //   // child: Text("${currentSpeed}x", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  // )
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
    ));
  }
}