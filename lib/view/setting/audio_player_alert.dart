import 'package:flutter/material.dart';
import '../../component/customButton.dart';
import '../../component/textStyle.dart';
import '../../component/color.dart';
import '../../component/text_widget.dart';

class AudioPlayerDialog extends StatefulWidget {
  final String customerName;

  const AudioPlayerDialog({super.key, required this.customerName});

  @override
  State<AudioPlayerDialog> createState() => _AudioPlayerDialogState();
}

class _AudioPlayerDialogState extends State<AudioPlayerDialog> {
  double currentSpeed = 1.0;
  bool isPlaying = false;
  double sliderValue = 0.3;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      titlePadding: const EdgeInsets.all(16),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      actionsPadding: const EdgeInsets.all(12),
      title: Text(
        "RECORDING - ${widget.customerName}",
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
                  onPressed: () {
                    setState(() {
                      isPlaying = !isPlaying;
                    });
                  },
                ),
                // Voice Line (Timeline Slider)
                Expanded(
                  child: Slider(
                    value: sliderValue,
                    onChanged: (val) {
                      setState(() {
                        sliderValue = val;
                      });
                    },
                    activeColor: Colors.green,
                    inactiveColor: Colors.grey.shade300,
                  ),
                ),

                const Icon(Icons.volume_up, color: Colors.grey),

                // Dots Vertical Playback Speed Option
                PopupMenuButton<double>(
                  icon: const Icon(Icons.more_vert, color: Colors.grey),
                  onSelected: (double speed) {
                    setState(() {
                      currentSpeed = speed;
                    });
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
                  const Text("0:45 / 2:30", style: TextStyle(fontSize: 12, color: Colors.grey)),
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
          height: 40,
          width: 80,
          verticalPadding: 0.0,
          borderRadius: 4,
          btnText: "CLOSE",
          fontSize: 14,
          onTap: () {},
        ),
        // TextButton(
        //   onPressed: () => Navigator.pop(context),
        //   child: Text(
        //     "CLOSE",
        //     style: TextStyle(color: DynamicColors.primaryClr, fontWeight: FontWeight.bold),
        //   ),
        // ),
      ],
    );
  }
}