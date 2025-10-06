import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/component/textStyle.dart';
import 'package:dashboard_new1/component/text_widget.dart';
import 'package:flutter/material.dart';

class VehicelsScreen extends StatelessWidget {
  const VehicelsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 900),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.green, width: 5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /// HEADER

              Column(
                children: [
                  Text(
                    AppText.upload_image,
                    style: mozillaTextSemiBoldText(fontSize: 20),
                  ),
                ],
              ),

              Expanded(
                child: Column(
                  children: [
                    Wrap(
                      children: [
                        Text(
                          AppText.richard,
                          style: mozillaTextSemiBoldText(fontSize: 18),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          AppText.logout,
                          style: mozillaTextSemiBoldText(
                              color: DynamicColors.redClr, fontSize: 18),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    /// VEHICLE INFO
                    Text(
                      AppText.vehicleinfo,
                      style: mozillaTextRegularText(),
                    ),
                    const SizedBox(height: 10),

                    Wrap(
                      spacing: 20,
                      runSpacing: 10,
                      alignment: WrapAlignment.center,
                      children: [
                        InfoTile(title: AppText.vehicle, value: ""),
                        InfoTile(title: AppText.startDate, value: "27-05-25"),
                        InfoTile(title: AppText.vehicleType, value: "SALOON"),
                      ],
                    ),
                    SizedBox(height: 5),
                    Wrap(
                      spacing: 20,
                      runSpacing: 10,
                      alignment: WrapAlignment.center,
                      children: [
                        InfoTile(title: AppText.make, value: ""),
                        InfoTile(title: AppText.model, value: ""),
                        InfoTile(title: AppText.color, value: ""),
                      ],
                    ),

                    /// DOCUMENTS SECTION
                    Text(
                      AppText.documents,
                      style: mozillaTextSemiBoldText(),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      AppText.expiry,
                      style: TextStyle(color: Colors.black54),
                    ),
                    const SizedBox(height: 6),
                    Divider(
                      indent: 50,
                      endIndent: 50,
                    ),
                    Wrap(
                      spacing: 16,
                      runSpacing: 8,
                      alignment: WrapAlignment.center,
                      children: [
                        InfoTile(title: AppText.phcdriver, value: "00-00-0000"),
                        InfoTile(
                            title: AppText.phcvehicle, value: "00-00-0000"),
                        InfoTile(title: AppText.insurance, value: "00-00-0000"),
                        InfoTile(title: AppText.mot2, value: "00-00-0000"),
                        InfoTile(title: AppText.mot, value: "00-00-0000"),
                      ],
                    ),
                    const SizedBox(height: 10),

                    Text(
                      AppText.document_hash,
                      style: mozillaTextRegularText(fontSize: 15),
                    ),

                    Divider(
                      indent: 50,
                      endIndent: 50,
                    ),
                    Wrap(
                      spacing: 16,
                      runSpacing: 8,
                      alignment: WrapAlignment.center,
                      children: [
                        InfoTile(title: AppText.phcdriver, value: ""),
                        InfoTile(title: AppText.phcvehicle, value: ""),
                        InfoTile(title: AppText.insurance, value: ""),
                        InfoTile(title: AppText.mot2, value: ""),
                        InfoTile(title: AppText.mot, value: ""),
                      ],
                    ),
                    const SizedBox(height: 25),

                    /// FOOTER
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 10),
                      color: Colors.grey.shade100,
                      child: Wrap(
                        spacing: 70,
                        alignment: WrapAlignment.center,
                        children: [
                          FooterInfo(
                              icon: Icons.money,
                              title: AppText.totalamount,
                              value: "£0.00"),
                          FooterInfo(
                              icon: Icons.directions_car,
                              title: AppText.totalBookings,
                              value: "0"),
                          FooterInfo(
                              icon: Icons.calendar_today,
                              title: AppText.period,
                              value: "27-09-25 27-09-25"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class InfoTile extends StatelessWidget {
  final String title;
  final String value;
  const InfoTile({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      child: Column(
        children: [
          Text(
            title,
            style: mozillaTextRegularText(
              fontSize: 12,
            ),
          ),
          Text(
            value,
            style: mozillaTextSemiBoldText(
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

class FooterInfo extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const FooterInfo(
      {super.key,
      required this.icon,
      required this.title,
      required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: Colors.black54),
        const SizedBox(width: 5),
        Text(
          "$title: ",
          style: mozillaTextSemiBoldText(fontSize: 13),
        ),
        Text(
          value,
          style: mozillaTextRegularText(fontSize: 12),
        ),
      ],
    );
  }
}














// LayoutBuilder(
//   builder: (context, constraints) {
//     bool isSmallScreen = constraints.maxWidth < 700;

//     return isSmallScreen
//         ? Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               /// LEFT SECTION (Upload Image)
//               Column(
//                 children: [
//                   Text(
//                     AppText.upload_image,
//                     style: mozillaTextSemiBoldText(fontSize: 20),
//                   ),
//                   const SizedBox(height: 12),
//                 ],
//               ),

//               /// RIGHT SECTION (Vehicle Info)
//               _buildVehicleInfoSection(),
//             ],
//           )
//         : Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               /// LEFT SECTION (Upload Image)
//               Column(
//                 children: [
//                   Text(
//                     AppText.upload_image,
//                     style: mozillaTextSemiBoldText(fontSize: 20),
//                   ),
//                 ],
//               ),
//               const SizedBox(width: 20),

//               /// RIGHT SECTION (Vehicle Info)
//               Expanded(child: _buildVehicleInfoSection()),
//             ],
//           );
//   },
// ),

