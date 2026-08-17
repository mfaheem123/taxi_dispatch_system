import 'package:dashboard_new1/component/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../component/textStyle.dart';
import 'controller/extension_controller.dart';
import 'controller/setting_controller.dart';

class WallboardScreen extends StatefulWidget {
  const WallboardScreen({super.key});

  @override
  State<WallboardScreen> createState() => _WallboardScreenState();
}

class _WallboardScreenState extends State<WallboardScreen> {
  final SettingController controller = Get.isRegistered<SettingController>()
      ? Get.find<SettingController>()
      : Get.put(SettingController());

  Stream<DateTime> _timeStream() {
    return Stream.periodic(const Duration(seconds: 1), (_) => DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingController>(
        initState: (v) {},
        builder: (controller) {
          return LayoutBuilder(builder: (context, constraints) {
            final double maxWidth = constraints.maxWidth;
            final bool isMobile = maxWidth < 600;

            const double totalBodyHeight = 720;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  // Header Section
                  Container(
                    width: Get.width,
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    color: DynamicColors.gryClr.withOpacity(0.5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Image(
                              image: AssetImage('assets/logo.jpeg'),
                              width: 55,
                              height: 55,
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "NEXUS",
                                  style: mozillaTextSemiBoldText(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 18),
                                ),
                                const SizedBox(height: 2),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    border: Border.all(
                                        color: Colors.purple, width: 1.5),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.computer,
                                          size: 14, color: Colors.purple),
                                      const SizedBox(width: 4),
                                      Text(
                                        "WALLBOARD",
                                        style: mozillaTextSemiBoldText(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 10)
                                            .copyWith(color: Colors.purple),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              "WALLBOARD",
                              style: mozillaTextSemiBoldText(
                                  fontWeight: FontWeight.w800, fontSize: 20),
                            ),
                          ),
                        ),
                        // Date/Time Raised White Card
                        StreamBuilder<DateTime>(
                          stream: _timeStream(),
                          builder: (context, snapshot) {
                            final now = snapshot.data ?? DateTime.now();
                            final formattedDate =
                            DateFormat('dd MMM yyyy').format(now);
                            final formattedTime =
                            DateFormat('HH:mm:ss').format(now);

                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.grey.shade100),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.04),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    )
                                  ]
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.calendar_today_rounded, size: 16, color: Colors.blueAccent),
                                  const SizedBox(width: 6),
                                  Text(
                                    formattedDate,
                                    style: mozillaTextSemiBoldText(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13),
                                  ),
                                  const SizedBox(width: 12),
                                  Container(
                                    height: 16,
                                    width: 1,
                                    color: Colors.grey.shade300,
                                  ),
                                  const SizedBox(width: 12),
                                  const Icon(Icons.access_time_filled_rounded, size: 16, color: Colors.deepPurple),
                                  const SizedBox(width: 6),
                                  Text(
                                    formattedTime,
                                    style: mozillaTextSemiBoldText(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 13)
                                        .copyWith(color: Colors.black),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Main Body Area
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // LEFT SIDE CONTAINERS
                      Expanded(
                        child: SizedBox(
                          height: totalBodyHeight,
                          child: Column(
                            children: [
                              // BOOKING OVERVIEW CONTAINER
                              Expanded(
                                flex: 8,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                        color: DynamicColors.gryClr.withOpacity(0.3)),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Column(
                                    children: [
                                      // Booking Overview Header
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 12),
                                        color: DynamicColors.gryClr.withOpacity(0.5),
                                        child: Row(
                                          children: [
                                            const Icon(Icons.event_available_rounded,
                                                color: Colors.blueAccent, size: 20),
                                            const SizedBox(width: 8),
                                            Text(
                                              "BOOKING OVERVIEW",
                                              style: mozillaTextSemiBoldText(
                                                  fontWeight: FontWeight.w800,
                                                  fontSize: 16),
                                            ),
                                          ],
                                        ),
                                      ),

                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Column(
                                            children: [
                                              // ROW 1
                                              Expanded(
                                                flex: 6,
                                                child: Row(
                                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                                  children: [
                                                    // Payment Breakdown Container
                                                    Expanded(
                                                      child: _buildSectionContainer(
                                                        title: "PAYMENT BREAKDOWN",
                                                        titleBgColor: Colors.teal.withOpacity(0.12),
                                                        icon: Icons.account_balance_wallet_outlined,
                                                        iconColor: Colors.teal,
                                                        child: Row(
                                                          children: [
                                                            Expanded(
                                                              flex: 5,
                                                              child: Center(
                                                                child: CustomPaint(
                                                                  size: const Size(110, 110),
                                                                  painter: SpecialCirclePainter(color: Colors.teal),
                                                                ),
                                                              ),
                                                            ),
                                                            const SizedBox(width: 12),
                                                            Expanded(
                                                              flex: 6,
                                                              child: Column(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                children: [
                                                                  _buildPaymentRow(Colors.green, Icons.money, "CASH", "0"),
                                                                  const SizedBox(height: 8),
                                                                  _buildPaymentRow(Colors.blue, Icons.account_box, "ACCOUNT", "0"),
                                                                  const SizedBox(height: 8),
                                                                  _buildPaymentRow(Colors.orange, Icons.credit_card, "CARD", "0"),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 16),

                                                    // Driver Status Container
                                                    Expanded(
                                                      child: _buildSectionContainer(
                                                        title: "DRIVER STATUS",
                                                        titleBgColor: Colors.indigo.withOpacity(0.12),
                                                        icon: Icons.drive_eta_outlined,
                                                        iconColor: Colors.indigo,
                                                        child: Column(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            Expanded(
                                                              child: Column(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                children: [
                                                                  Text(
                                                                    "1",
                                                                    style: mozillaTextSemiBoldText(fontWeight: FontWeight.w900, fontSize: 32).copyWith(color: Colors.green),
                                                                  ),
                                                                  Text(
                                                                    "AVAILABLE",
                                                                    style: mozillaTextSemiBoldText(fontWeight: FontWeight.w600, fontSize: 13).copyWith(color: Colors.grey.shade600),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Divider(thickness: 1, color: Colors.grey.shade200, height: 1),
                                                            Expanded(
                                                              child: Column(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                children: [
                                                                  Text(
                                                                    "2",
                                                                    style: mozillaTextSemiBoldText(fontWeight: FontWeight.w900, fontSize: 32).copyWith(color: Colors.red),
                                                                  ),
                                                                  Text(
                                                                    "BUSY",
                                                                    style: mozillaTextSemiBoldText(fontWeight: FontWeight.w600, fontSize: 13).copyWith(color: Colors.grey.shade600),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 16),

                                                    // Source Panel (Web, App, IVR)
                                                    Expanded(
                                                      child: Column(
                                                        children: [
                                                          Expanded(
                                                            child: _buildSectionContainer(
                                                              title: "WEB",
                                                              titleBgColor: Colors.purple.withOpacity(0.15),
                                                              icon: Icons.language,
                                                              iconColor: Colors.purple,
                                                              child: Center(
                                                                child: Text(
                                                                  "0",
                                                                  style: mozillaTextSemiBoldText(fontWeight: FontWeight.w900, fontSize: 32).copyWith(color: Colors.purple),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(height: 10),
                                                          Expanded(
                                                            child: _buildSectionContainer(
                                                              title: "APP",
                                                              titleBgColor: Colors.orange.withOpacity(0.15),
                                                              icon: Icons.phone_android,
                                                              iconColor: Colors.orange,
                                                              child: Center(
                                                                child: Text(
                                                                  "0",
                                                                  style: mozillaTextSemiBoldText(fontWeight: FontWeight.w900, fontSize: 32).copyWith(color: Colors.orange),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(height: 10),
                                                          Expanded(
                                                            child: _buildSectionContainer(
                                                              title: "IVR",
                                                              titleBgColor: Colors.blue.withOpacity(0.15),
                                                              icon: Icons.settings_phone,
                                                              iconColor: Colors.blue,
                                                              child: Center(
                                                                child: Text(
                                                                  "0",
                                                                  style: mozillaTextSemiBoldText(fontWeight: FontWeight.w900, fontSize: 32).copyWith(color: Colors.blue),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(height: 16),

                                              // ROW 2: 6 Status Containers
                                              Expanded(
                                                flex: 2,
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: _buildSectionContainer(
                                                        title: "ACTIVE",
                                                        titleBgColor: Colors.teal.withOpacity(0.15),
                                                        icon: Icons.route,
                                                        iconColor: Colors.teal,
                                                        child: Center(
                                                          child: Text("0", style: mozillaTextSemiBoldText(fontWeight: FontWeight.w900, fontSize: 32).copyWith(color: Colors.teal)),
                                                        ),
                                                      ),

                                                    ),
                                                    const SizedBox(width: 10),
                                                    Expanded(
                                                      child: _buildSectionContainer(
                                                        title: "TOTAL",
                                                        titleBgColor: Colors.blue.withOpacity(0.15),
                                                        icon: Icons.bar_chart_rounded,
                                                        iconColor: Colors.blue,
                                                        child: Center(
                                                          child: Text("0", style: mozillaTextSemiBoldText(fontWeight: FontWeight.w900, fontSize: 32).copyWith(color: Colors.blue)),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 10),
                                                    Expanded(
                                                      child: _buildSectionContainer(
                                                        title: "COMPLETED",
                                                        titleBgColor: Colors.green.withOpacity(0.15),
                                                        icon: Icons.check_circle_outline_rounded,
                                                        iconColor: Colors.green,
                                                        child: Center(
                                                          child: Text("0", style: mozillaTextSemiBoldText(fontWeight: FontWeight.w900, fontSize: 32).copyWith(color: Colors.green)),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 10),
                                                    Expanded(
                                                      child: _buildSectionContainer(
                                                        title: "WAITING",
                                                        titleBgColor: Colors.amber.withOpacity(0.15),
                                                        icon: Icons.hourglass_empty_rounded,
                                                        iconColor: Colors.amber.shade800,
                                                        child: Center(
                                                          child: Text("0", style: mozillaTextSemiBoldText(fontWeight: FontWeight.w900, fontSize: 32).copyWith(color: Colors.amber.shade800)),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 10),
                                                    Expanded(
                                                      child: _buildSectionContainer(
                                                        title: "CANCELLED",
                                                        titleBgColor: Colors.red.withOpacity(0.15),
                                                        icon: Icons.cancel_outlined,
                                                        iconColor: Colors.red,
                                                        child: Center(
                                                          child: Text("0", style: mozillaTextSemiBoldText(fontWeight: FontWeight.w900, fontSize: 32).copyWith(color: Colors.red)),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 10),
                                                    Expanded(
                                                      child: _buildSectionContainer(
                                                        title: "NO PICKUP",
                                                        titleBgColor: Colors.red.withOpacity(0.15),
                                                        icon: Icons.not_interested_rounded,
                                                        iconColor: Colors.red,
                                                        child: Center(
                                                          child: Text("0", style: mozillaTextSemiBoldText(fontWeight: FontWeight.w900, fontSize: 32).copyWith(color: Colors.red)),
                                                        ),
                                                      ),
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
                              ),
                              const SizedBox(height: 16),

                              // CALL STATISTICS CONTAINER
                              Container(
                                height: 160,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                      color: DynamicColors.gryClr.withOpacity(0.3)),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  children: [
                                    // Call Statistics Header
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 8),
                                      color: DynamicColors.gryClr.withOpacity(0.5),
                                      child: Row(
                                        children: [
                                          const Icon(Icons.call_rounded,
                                              color: Colors.green, size: 18),
                                          const SizedBox(width: 8),
                                          Text(
                                            "CALL STATISTICS",
                                            style: mozillaTextSemiBoldText(
                                                fontWeight: FontWeight.w800,
                                                fontSize: 16),
                                          ),
                                        ],
                                      ),
                                    ),

                                    // Call Statistics
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Row(
                                          children: [
                                            Expanded(child: _buildCallStatCard("RECEIVED", "0", Colors.blue)),
                                            const SizedBox(width: 8),
                                            Expanded(child: _buildCallStatCard("ANSWER", "0", Colors.green)),
                                            const SizedBox(width: 8),
                                            Expanded(child: _buildCallStatCard("MISSED", "0", Colors.red)),
                                            const SizedBox(width: 8),
                                            Expanded(child: _buildCallStatCard("WAITING", "0", Colors.amber.shade800)),
                                            const SizedBox(width: 8),
                                            Expanded(child: _buildCallStatCard("ABANDONED", "0", Colors.purple)),
                                            const SizedBox(width: 8),
                                            Expanded(child: _buildCallStatCard("IVR ACTIVE", "0", Colors.teal)),
                                            const SizedBox(width: 8),
                                            Expanded(child: _buildCallStatCard("IVR ANSWER", "0", Colors.deepOrange)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),

                      // RIGHT SIDEBAR
                      Container(
                        width: isMobile ? 120 : 400,
                        height: totalBodyHeight,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                              color: DynamicColors.gryClr.withOpacity(0.3)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Extensions Header
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              color: DynamicColors.gryClr.withOpacity(0.5),
                              child: Row(
                                children: [
                                  const Icon(Icons.contact_phone_rounded,
                                      color: Colors.deepPurple, size: 20),
                                  const SizedBox(width: 8),
                                  Text(
                                    "EXTENSIONS",
                                    style: mozillaTextSemiBoldText(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 16),
                                  ),
                                ],
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                    Expanded(child: _buildStatusRoundButton(Colors.green, "4", "ONLINE")),
                                  const SizedBox(width: 8),
                                  Expanded(child: _buildStatusRoundButton(Colors.orange, "1", "IDLE")),
                                  const SizedBox(width: 8),
                                  Expanded(child: _buildStatusRoundButton(Colors.blue, "5", "TOTAL")),
                                ],
                              ),
                            ),

                            const Divider(height: 1, thickness: 1),

                            Expanded(
                              child: ListView(
                                padding: const EdgeInsets.all(12),
                                children: [
                                  _buildExtensionDetailCard(
                                      extensionNo: "255",
                                      statusText: "IDLE",
                                      statusColor: Colors.green,
                                      showPlayIcon: true,
                                      callVal: "0", forwardVal: "0", cancelVal: "0"
                                  ),
                                  const SizedBox(height: 12),
                                  _buildExtensionDetailCard(
                                      extensionNo: "200",
                                      statusText: "UNAVAILABLE",
                                      statusColor: Colors.red,
                                      showPlayIcon: true,
                                      callVal: "0", forwardVal: "0", cancelVal: "0"
                                  ),
                                  const SizedBox(height: 12),
                                  _buildExtensionDetailCard(
                                      extensionNo: "201",
                                      statusText: "UNAVAILABLE",
                                      statusColor: Colors.red,
                                      showPlayIcon: true,
                                      callVal: "0", forwardVal: "0", cancelVal: "0"
                                  ),
                                  const SizedBox(height: 12),
                                  _buildExtensionDetailCard(
                                      extensionNo: "202",
                                      statusText: "UNAVAILABLE",
                                      statusColor: Colors.red,
                                      showPlayIcon: true,
                                      callVal: "0", forwardVal: "0", cancelVal: "0"
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            );
          });
        });
  }

  Widget _buildStatusRoundButton(Color colorTheme, String label, String count) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colorTheme.withOpacity(0.5), width: 1.2),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              color: colorTheme,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              "$label $count",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: mozillaTextSemiBoldText(fontWeight: FontWeight.w800, fontSize: 11).copyWith(color: colorTheme),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExtensionDetailCard({
    required String extensionNo,
    required String statusText,
    required Color statusColor,
    required bool showPlayIcon,
    required String callVal,
    required String forwardVal,
    required String cancelVal,
  }) {

    final Color cardBgColor = statusColor.withOpacity(0.08);
    final Color contentColor = Colors.grey.shade800;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: statusColor.withOpacity(0.25),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "# $extensionNo",
                style: mozillaTextSemiBoldText(fontWeight: FontWeight.w900, fontSize: 18).copyWith(color: contentColor),
              ),


              Expanded(
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.15), // Semi-transparent colored background
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: statusColor.withOpacity(0.4), width: 1.2),
                    ),
                    child: Text(
                      statusText,
                      style: mozillaTextSemiBoldText(fontWeight: FontWeight.w800, fontSize: 10.5).copyWith(color: statusColor),
                    ),
                  ),
                ),
              ),

              // Elevated Grey Shadow Play Button (Right)
              if (showPlayIcon)
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey.shade300, width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                      BoxShadow(
                        color: Colors.white.withOpacity(0.9),
                        blurRadius: 2,
                        offset: const Offset(-1, -1),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      Icons.play_arrow_rounded,
                      color: Colors.grey.shade700,
                      size: 20,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 14),
          Divider(height: 1, thickness: 1, color: statusColor.withOpacity(0.15)),
          const SizedBox(height: 14),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                children: [
                  Icon(Icons.phone_in_talk_rounded, size: 18, color: Colors.green),
                  const SizedBox(width: 6),
                  Text(callVal, style: mozillaTextSemiBoldText(fontWeight: FontWeight.w800, fontSize: 14).copyWith(color: contentColor)),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.call_made, size: 18, color: Colors.blue.shade600),
                  const SizedBox(width: 6),
                  Text(forwardVal, style: mozillaTextSemiBoldText(fontWeight: FontWeight.w800, fontSize: 14).copyWith(color: contentColor)),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.phone_disabled_rounded, size: 18, color: Colors.red.shade600),
                  const SizedBox(width: 6),
                  Text(cancelVal, style: mozillaTextSemiBoldText(fontWeight: FontWeight.w800, fontSize: 14).copyWith(color: contentColor)),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildSectionContainer({
    required String title,
    required Color titleBgColor,
    required IconData icon,
    required Color iconColor,
    required Widget child
  }) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 4,
              offset: const Offset(0, 2),
            )
          ]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 13),
            decoration: BoxDecoration(
              color: titleBgColor,
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
            ),
            child: Row(
              children: [
                Icon(icon, size: 18, color: iconColor),
                const SizedBox(width: 5),
                Expanded(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: mozillaTextSemiBoldText(fontWeight: FontWeight.w800, fontSize: 14).copyWith(color: iconColor),
                  ),
                ),
              ],
            ),
          ),
          Expanded(child: Padding(padding: const EdgeInsets.all(6), child: child)),
        ],
      ),
    );
  }


  Widget _buildPaymentRow(Color themeColor, IconData icon, String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade100),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 3,
              offset: const Offset(0, 1),
            )
          ]
      ),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: themeColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(icon, color: themeColor, size: 18),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: mozillaTextSemiBoldText(fontWeight: FontWeight.w700, fontSize: 14),
          ),
          const Spacer(),
          Text(
            value,
            style: mozillaTextSemiBoldText(fontWeight: FontWeight.w800, fontSize: 18),
          ),
        ],
      ),
    );
  }

  Widget _buildCallStatCard(String title, String value, Color colorTheme) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colorTheme.withOpacity(0.5), width: 1.2),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Spacer(),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: mozillaTextSemiBoldText(fontWeight: FontWeight.w800, fontSize: 14).copyWith(color: colorTheme),
          ),
          const Spacer(),
          Text(
            value,
            style: mozillaTextSemiBoldText(fontWeight: FontWeight.w900, fontSize: 32).copyWith(color: colorTheme),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}


class SpecialCirclePainter extends CustomPainter {
  final Color color;
  SpecialCirclePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final circlePaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, circlePaint);

    final linePaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(size.width / 2, 0), center, linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
