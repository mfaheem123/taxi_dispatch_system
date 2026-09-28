import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/component/textStyle.dart';
import 'package:flutter/material.dart';

import '../component/alert_close_button.dart';
import '../component/dropdown_button.dart';

class RestrictedDriversDialog extends StatefulWidget {
  final List<Map<String, String>> drivers;
  final List<Map<String, String>> initialRestrictedDrivers;
  final ValueChanged<List<Map<String, String>>> onDriversChanged;

  const RestrictedDriversDialog({super.key, required this.drivers, required this.initialRestrictedDrivers, required this.onDriversChanged});

  @override
  State<RestrictedDriversDialog> createState() => _RestrictedDriversDialogState();
}

class _RestrictedDriversDialogState extends State<RestrictedDriversDialog> {
  Map<String, String>? selectedDriver;
  late List<Map<String, String>> restrictedDrivers;

  @override
  void initState() {
    super.initState();
    restrictedDrivers = List.from(widget.initialRestrictedDrivers);
  }


  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 100, vertical: 40),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: SizedBox(
        width: 500,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: DynamicColors.gryClr.withOpacity(0.5),
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                  ),
                  child: Row(
                    children: [
                      Text('RESTRICTED DRIVERS', style: titleDesign()),
                      const Spacer(),
                      FocusTraversalOrder(
                        order: const NumericFocusOrder(999),
                        child: const AlertCloseButton(),
                      ),
                    ],
                  )),
              const Divider(height: 1, thickness: 1),
              SizedBox(height: 15),

              // Dropdown Row
              Padding(
                padding: const EdgeInsets.all(20),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFDEE2E6)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        color: Colors.grey.shade200,
                        child: Row(
                          children: [
                            // Index Header (#)
                            Container(
                              width: 50,
                              height: 48,
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(
                                border: Border(right: BorderSide(color: Color(0xFFDEE2E6)),
                                ),
                              ),
                              child: Text(
                                '#',
                                style: outFitRegular(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),

                            // Dropdown Field
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  child:  CustomDropdownField<Map<String, String>>(
                                    height: 35,
                                    label: "SELECT DRIVER",
                                    items: widget.drivers,
                                    value: selectedDriver,
                                    itemLabel: (item) => "${item['username'] ?? ''} - ${item['name'] ?? ''}",
                                    onChanged: (val) {
                                      setState(() {
                                        selectedDriver = val;
                                      });
                                    },
                                  ),
                                ),
                              ),

                            // Add Button
                            Container(
                              width: 60,
                              height: 48,
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(
                                border: Border(
                                  left: BorderSide(color: Color(0xFFDEE2E6)),
                                ),
                              ),
                              child: Material(
                                color: DynamicColors.primaryClr,
                                borderRadius: BorderRadius.circular(6),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(6),
                                  onTap: () {
                                    if (selectedDriver != null && !restrictedDrivers.contains(selectedDriver)) {
                                      setState(() {
                                        restrictedDrivers.add(selectedDriver!);
                                        selectedDriver = null;
                                      });
                                      widget.onDriversChanged(restrictedDrivers);
                                    }
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.all(6),
                                    child: Icon(
                                      Icons.add_circle,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // List of Restricted Drivers
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxHeight: 300),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: restrictedDrivers.length,
                          itemBuilder: (context, index) {
                            final driver = restrictedDrivers[index];
                            return Container(
                              decoration: const BoxDecoration(
                                border: Border(top: BorderSide(color: Color(0xFFDEE2E6)),
                                ),
                              ),
                              child: Row(
                                children: [
                                  // Index Number
                                  Container(
                                    width: 50,
                                    height: 52,
                                    alignment: Alignment.center,
                                    decoration: const BoxDecoration(
                                      border: Border(right: BorderSide(color: Color(0xFFDEE2E6)),
                                      ),
                                    ),
                                    child: Text(
                                      '${index + 1}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),

                                  // Driver Tag and Name
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 12),
                                      child: Row(
                                        children: [
                                          // Username Tag Badge
                                          Container(
                                            width: 70,
                                            padding: const EdgeInsets.symmetric(vertical: 8),
                                            decoration: BoxDecoration(color: DynamicColors.primaryClr,
                                              borderRadius: BorderRadius.circular(2),
                                            ),
                                            child: Center(
                                              child: Text(
                                              driver['username'] ?? '',
                                              style: outFitRegular(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 13,
                                              ),
                                            ),
                                          )),
                                          const SizedBox(width: 12),
                                          // Driver Name
                                          Expanded(
                                            child: Text(
                                              driver['name'] ?? '',
                                              style: outFitRegular(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 13),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  // Delete Button
                                  Container(
                                    width: 60,
                                    height: 52,
                                    alignment: Alignment.center,
                                    decoration: const BoxDecoration(
                                      border: Border(left: BorderSide(color: Color(0xFFDEE2E6)),
                                      ),
                                    ),
                                    child: Material(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(6),
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(6),
                                        onTap: () {
                                          setState(() {restrictedDrivers.removeAt(index);
                                          });
                                          widget.onDriversChanged(restrictedDrivers);
                                        },
                                        child: const Padding(
                                          padding: EdgeInsets.all(8),
                                          child: Icon(
                                            Icons.delete_forever,
                                            color: Colors.white,
                                            size: 18,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
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
}

class DriverDropdownItem extends StatelessWidget {
  final String userName;
  final String name;

  const DriverDropdownItem({
    Key? key,
    required this.userName,
    required this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          child: Text(
            userName,
            style: outFitRegular(
              color: Colors.green,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            name,
            overflow: TextOverflow.ellipsis,
            style: outFitRegular(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
