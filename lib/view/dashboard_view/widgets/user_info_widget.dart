


import 'package:flutter/material.dart';

import '../../../component/textStyle.dart';
import '../../../component/text_field.dart';
import '../../../component/text_widget.dart';

class UserInfoWidget extends StatelessWidget {
  const UserInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context, constraints) {
          bool isMobile = constraints.maxWidth < 600;
          bool isTablet = constraints.maxWidth >= 600 && constraints.maxWidth < 1024;
          bool isWeb = constraints.maxWidth >= 1024;

          double pickupWidth = isMobile
              ? constraints.maxWidth * 0.9
              : isTablet
              ? constraints.maxWidth / 2.5
              : constraints.maxWidth / 3.5;

          double notesWidth = isMobile
              ? constraints.maxWidth * 0.9
              : isTablet
              ? constraints.maxWidth / 4
              : constraints.maxWidth / 8;
          return SingleChildScrollView(
            scrollDirection: isMobile ? Axis.vertical : Axis.horizontal,
            child: Flex(
              direction: isMobile ? Axis.vertical : Axis.horizontal,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildResponsiveField(context, AppText.name, isMobile),
                SizedBox(width: isMobile ? 0 : 10, height: isMobile ? 10 : 0),
                _buildResponsiveField(context, AppText.email, isMobile),
                SizedBox(width: isMobile ? 0 : 10, height: isMobile ? 10 : 0),
                _buildResponsiveField(context, AppText.mobile, isMobile),
                SizedBox(width: isMobile ? 0 : 10, height: isMobile ? 10 : 0),
                _buildResponsiveField(context, AppText.tel, isMobile),
              ],
            ),
          );
        }
    );
  }

  /// Responsive Field Widget
  Widget _buildResponsiveField(BuildContext context, String label, bool isMobile) {
    return SizedBox(
      height: 30, // same height for all
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: mozillaTextSemiBoldText(
              context: context,
              fontSize: 13,
            ),
          ),
          const SizedBox(width: 10),
          if (isMobile)
            Expanded(
              child: CustomTextField(
                controller: TextEditingController(),
                borderRadius: 4,
              ),
            )
          else
            SizedBox(
              width: 150,
              child: CustomTextField(
                controller: TextEditingController(),
                borderRadius: 4,
              ),
            )

        ],
      ),
    );
  }

}
