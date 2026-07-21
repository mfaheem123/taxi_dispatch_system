import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DriverRecoveryDialog extends StatelessWidget {
  final String driverName;
  final String driverUsername;
  final String driverMobile;
  final String driverID;
  final String bookingRef;
  final VoidCallback? onDecline;
  final VoidCallback? onApprove;

  const DriverRecoveryDialog({
    super.key,
    required this.driverName,
    required this.driverUsername,
    required this.driverMobile,
    required this.driverID,
    this.bookingRef = '',
    this.onDecline,
    this.onApprove,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
      clipBehavior: Clip.antiAlias,
      child: Container(
        width: 500,
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header Section
            Container(
              color: const Color(0xFFF7FCF9),
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Row(
                children: [
                  const Icon(
                    Icons.cancel,
                    color: Colors.redAccent,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'DRIVER RECOVERY REQUEST',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.black87,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => Get.back(), // GetX back
                    child: const Icon(
                      Icons.close,
                      color: Colors.grey,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),

            // Content Box Section
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  // Inner Box
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFAFAFA),
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(
                        color: Colors.grey.shade300,
                        width: 1,
                      ),
                    ),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 15.0,
                          color: Colors.black87,
                          height: 1.4,
                        ),
                        children: [
                          const TextSpan(text: 'DRIVER '),
                          TextSpan(
                            text: '$driverName ($driverID)',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const TextSpan(text: ' IS REQUESTING RECOVER OF BOOKING REFERENCE '),
                          TextSpan(
                            text: bookingRef,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const TextSpan(text: '.'),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Action Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Decline Button
                      ElevatedButton.icon(
                        onPressed: () {
                          Get.back();
                          if (onDecline != null) onDecline!();
                        },
                        icon: const Icon(Icons.close, size: 16, color: Colors.white),
                        label: const Text(
                          'DECLINE RECOVERY',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF4D4D),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          elevation: 0,
                        ),
                      ),

                      const SizedBox(width: 16),

                      // Approve Button
                      ElevatedButton.icon(
                        onPressed: () {
                          Get.back();
                          if (onApprove != null) onApprove!();
                        },
                        icon: const Icon(Icons.check, size: 16, color: Colors.white),
                        label: const Text(
                          'APPROVE RECOVERY',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF28C745),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          elevation: 0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}