import 'package:dashboard_new1/component/color.dart';
import 'package:flutter/material.dart';

class RestrictedDriversDialog extends StatefulWidget {
  final List<Map<String, String>> drivers;

  const RestrictedDriversDialog({Key? key, required this.drivers})
      : super(key: key);

  @override
  State<RestrictedDriversDialog> createState() =>
      _RestrictedDriversDialogState();
}

class _RestrictedDriversDialogState extends State<RestrictedDriversDialog> {
  Map<String, String>? selectedDriver;
  List<Map<String, String>> restrictedDrivers = [];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 100, vertical: 40),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        width: 700, // 👈 web ke liye wide dialog
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView( // 👈 ensures scroll on smaller screens
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'RESTRICTED DRIVERS',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Divider(),

              // Dropdown Row
              Row(
                children: [
                  Expanded(
                    child: Material(
                      color: Colors.transparent,
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<Map<String, String>>(
                          isExpanded: true,
                          dropdownColor: Colors.white,
                          value: selectedDriver,
                          hint: const Text("Select Driver"),
                          onChanged: (value) {
                            setState(() {
                              selectedDriver = value;
                            });
                          },
                          items: widget.drivers.map((driver) {
                            return DropdownMenuItem<Map<String, String>>(
                              value: driver,
                              child: DriverDropdownItem(
                                userName: driver['username'] ?? '',
                                name: driver['name'] ?? '',
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    icon: const Icon(Icons.add_circle,
                        color: Colors.red, size: 32),
                    onPressed: () {
                      if (selectedDriver != null &&
                          !restrictedDrivers.contains(selectedDriver)) {
                        setState(() {
                          restrictedDrivers.add(selectedDriver!);
                        });
                      }
                    },
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Restricted Drivers List
              Container(
                constraints: const BoxConstraints(maxHeight: 400),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: restrictedDrivers.length,
                  itemBuilder: (context, index) {
                    final driver = restrictedDrivers[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          SizedBox(width: 20, child: Text("${index + 1}")),
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 6),
                            decoration: BoxDecoration(
                              color: DynamicColors.primaryClr,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              driver['username'] ?? '',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              driver['name'] ?? '',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              setState(() {
                                restrictedDrivers.removeAt(index);
                              });
                            },
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
    );
  }
}

// 👇 Reusable Widget for dropdown items
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
            style: const TextStyle(
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
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
