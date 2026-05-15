// import 'package:flutter/material.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:get/get_navigation/src/extension_navigation.dart';
//
// import '../component/color.dart';
// import '../component/customButton.dart';
// import '../component/textStyle.dart';
//
// void showDriverPanicAlert() {
//   Get.dialog(
//     const DriverPanicAlert(driverName: 'MARK',),
//     barrierColor: Colors.black54,
//   );
// }
//
// class DriverPanicAlert extends StatelessWidget {
//   final String driverName;
//   const DriverPanicAlert({super.key, required this.driverName});
//
//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       backgroundColor: Colors.transparent,
//       child: Container(
//         width: 420,
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(12),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.1),
//               blurRadius: 10,
//               spreadRadius: 2,
//             ),
//           ],
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const SizedBox(height: 25),
//             Icon(
//               Icons.warning_amber_rounded,
//               color: Colors.red.shade600,
//               size: 50,
//             ),
//
//             const SizedBox(height: 15),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20),
//               child: Text(
//                 "DRIVER ($driverName)",
//                 textAlign: TextAlign.center,
//                 style: mozillaTextSemiBoldText(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black87,
//                 ),
//               ),
//             ),
//
//             const SizedBox(height: 10),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20),
//               child: Text(
//                 "$driverName is in panic!",
//                 textAlign: TextAlign.center,
//                 style: mozillaTextSemiBoldText(
//                   fontSize: 15,
//                   color: Colors.red.shade600,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ),
//
//             const SizedBox(height: 25),
//             const Divider(height: 1),
//             Padding(
//               padding: const EdgeInsets.all(20.0),
//               child: Align(
//                 alignment: Alignment.centerRight,
//                 child: CustomButton(
//                   height: 45,
//                   width: 120,
//                   btnText: "CLOSE",
//                   btnColor: DynamicColors.primaryClr,
//                   borderRadius: 8,
//                   style: mozillaTextSemiBoldText(
//                     fontSize: 14,
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                   ),
//                   onTap: () => Get.back(),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:html' as html;
import '../component/color.dart';
import '../component/customButton.dart';
import '../component/textStyle.dart';

class DriverPanicAlert extends StatefulWidget {
  final String driverName;
  final String driverUsername; // Naya Field
  final String driverMobile;   // Naya Field
  final String driverID;   // Naya Field

  const DriverPanicAlert({
    super.key,
    required this.driverName,
    required this.driverUsername,
    required this.driverMobile,
    required this.driverID,
  });

  @override
  State<DriverPanicAlert> createState() => _DriverPanicAlertState();
}

class _DriverPanicAlertState extends State<DriverPanicAlert> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  html.AudioElement? _audioElement;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..repeat(reverse: true);

    _playPanicSound();
  }

  void _playPanicSound() {
    try {
      _audioElement = html.AudioElement();
      _audioElement!.src = 'assets/sound/alarm_sound.mp3';
      _audioElement!.loop = true;
      _audioElement!.volume = 1.0;
      _audioElement!.setAttribute('type', 'audio/mpeg');
      _audioElement!.play().catchError((e) => print("Autoplay Blocked"));
    } catch (e) {
      print("Audio Logic Error: $e");
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    if (_audioElement != null) {
      _audioElement!.pause();
      _audioElement!.remove();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Container(
            width: 450,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: Color.lerp(Colors.red, Colors.transparent, _controller.value)!,
                width: 5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.red.withOpacity(_controller.value * 0.7),
                  blurRadius: 20,
                  spreadRadius: 10,
                ),
              ],
            ),
            child: child,
          );
        },

        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              decoration: const BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
              ),
              child: const Text(
                "🚨 EMERGENCY - PANIC ALERT 🚨",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            const SizedBox(height: 20),
            const Icon(Icons.warning_amber_rounded, color: Colors.red, size: 80),

            const SizedBox(height: 10),
            Text(
              widget.driverName.toUpperCase(),
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const Text("IS IN DANGER!", style: TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.w600)),

            const SizedBox(height: 20),

            // --- Naya Data Display Section ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.person, size: 20, color: Colors.blueGrey),
                        const SizedBox(width: 10),
                        Text("Username: ", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey.shade700)),
                        Text(widget.driverUsername, style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(Icons.phone, size: 20, color: Colors.green),
                        const SizedBox(width: 10),
                        Text("Mobile: ", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey.shade700)),
                        Text(widget.driverMobile, style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: CustomButton(
                height: 55,
                width: double.infinity,
                btnText: "STOP SIREN & CLOSE",
                btnColor: Colors.black,
                borderRadius: 10,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                onTap: () => Get.back(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}