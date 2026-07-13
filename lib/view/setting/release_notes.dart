import 'package:flutter/material.dart';
import '../../component/color.dart';
import '../../component/textStyle.dart';

class ReleaseNotesDialog extends StatelessWidget {
  const ReleaseNotesDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Container(
        width: 960,
        constraints: const BoxConstraints(maxHeight: 800),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HEADER CONTAINER
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: DynamicColors.gryClr.withOpacity(0.5),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Row(
                children: [

                  const Icon(Icons.rocket_launch_rounded, size: 32, color: Colors.blueAccent),
                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "SYSTEM UPDATES",
                          style: mozillaTextSemiBoldText(fontWeight: FontWeight.w800, fontSize: 20),
                        ),
                        const Text(
                          "LATEST PLATFORM RELEASES",
                          style: TextStyle(fontSize: 13, color: Colors.black54),
                        ),
                      ],
                    ),
                  ),

                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.black87),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: DynamicColors.gryClr.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [

                              const Icon(Icons.event_available_rounded, color: Colors.green, size: 24),
                              const SizedBox(width: 10),
                              Text(
                                "January 2026",
                                style: mozillaTextSemiBoldText(fontWeight: FontWeight.w800, fontSize: 18),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                "(v1.2.3)",
                                style: TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.purple.withOpacity(0.1),
                                  border: Border.all(color: Colors.purple.withOpacity(0.4), width: 1.5),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text(
                                  "STABLE RELEASE",
                                  style: TextStyle(color: Colors.purple, fontWeight: FontWeight.w700, fontSize: 12),
                                ),
                              ),

                              // Download PDF Option
                              InkWell(
                                onTap: () {},
                                child: const Row(
                                  children: [
                                    Icon(Icons.picture_as_pdf, color: Colors.redAccent, size: 20),
                                    SizedBox(width: 6),
                                    Text(
                                      "DOWNLOAD PDF",
                                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 25),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Row(
                            children: [
                              const Icon(Icons.info_outline_rounded, color: Colors.blue, size: 24),
                              const SizedBox(width: 10),
                              Text(
                                "WHAT'S NEW?",
                                style: mozillaTextSemiBoldText(fontWeight: FontWeight.w800, fontSize: 18),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "Here is a summary of the latest features, enhancements, and bug fixes implemented in this version to optimize dispatch operations.",
                            style: TextStyle(color: Colors.black87, fontSize: 14, height: 1.4),
                          ),
                          const Divider(height: 30, thickness: 1),

                          _buildUpdateSection(
                            title: " New Core Dispatch Dashboard",
                            description: "Introduced a real-time auto-allocation algorithm for swift driver matching. Multi-map routing integration allows operators to switch layers dynamically.",
                          ),
                          _buildUpdateSection(
                            title: " System Enhancements",
                            description: "Enhanced database indexing for rapid query execution on logs. Reduced latency in live location tracking by optimizing websocket payloads.",
                          ),
                          _buildUpdateSection(
                            title: "Bug Fixes",
                            description: "Fixed periodic notification failures occurring on older Android clients. Patched historical call record sorting glitches on the configuration panels.",
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpdateSection({required String title, required String description}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black87),
          ),
          const SizedBox(height: 6),
          Text(
            description,
            style: const TextStyle(color: Colors.black54, fontSize: 13, height: 1.4),
          ),
        ],
      ),
    );
  }
}

