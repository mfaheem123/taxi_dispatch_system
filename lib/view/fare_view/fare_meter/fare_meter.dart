


import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../component/color.dart';
import '../../../component/textStyle.dart';
import '../../../component/text_widget.dart';
import '../../dashboard_view/Controller/dashboard_controller.dart';
import '../controller/controller.dart';

class FareMeter extends StatefulWidget {
  const FareMeter({super.key});

  @override
  State<FareMeter> createState() => _FareMeterState();
}

class _FareMeterState extends State<FareMeter> {

  FareController controller = Get.isRegistered<FareController>()
      ? Get.find<FareController>()
      : Get.put(FareController());

  int selectedRowIndex = 0; // currently selected row
  final int totalRows =
  50; // total rows (dynamic list ke hisaab se change hoga)
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    shortCutKeyValue.value = "fareMeter";
  }


  @override
  Widget build(BuildContext context) {
    return GetBuilder<FareController>(builder: (controller) {
      return LayoutBuilder(builder: (context, constraints) {
        final double maxWidth = constraints.maxWidth;
        final bool isMobile = maxWidth < 600;
        final bool isTablet = maxWidth >= 600 && maxWidth < 1024;

        // Instead of fixed width, we calculate flexible field widths
        final double fieldWidth = isMobile
            ? maxWidth // full width
            : isTablet
            ? maxWidth / 2
            : maxWidth / 4;

            return Column(
              children: [
                Container(
                  width: Get.width,
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                  color: DynamicColors.gryClr.withOpacity(0.5),
                  child: Text(AppText.fareMeterConfiguration, style: titleDesign()),
                ),
              ],
            );
          }
        );
      }
    );
  }
}
