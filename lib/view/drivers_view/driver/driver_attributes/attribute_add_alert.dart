import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/component/customButton.dart';
import 'package:dashboard_new1/component/textStyle.dart';
import 'package:dashboard_new1/component/text_field.dart';
import 'package:flutter/material.dart';

class AttributeAddAlert extends StatefulWidget {
  final String? id;
  final String? initialName;
  final String? initialShortName;
  final Function(String name, String shortName)? onSave;

  const AttributeAddAlert({
    super.key,
    this.id,
    this.initialName,
    this.initialShortName,
    this.onSave,
  });

  @override
  State<AttributeAddAlert> createState() => _AttributeAddAlertState();
}

class _AttributeAddAlertState extends State<AttributeAddAlert> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController shortNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.initialName != null) {
      nameController.text = widget.initialName!;
    }
    if (widget.initialShortName != null) {
      shortNameController.text = widget.initialShortName!;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    shortNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Container(
        width: 600,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "DRIVER ATTRIBUTE",
                  style: mozillaTextRegularText(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: DynamicColors.textClr,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close, size: 20, color: Colors.grey),
                ),
              ],
            ),
            const Divider(thickness: 1, height: 30),
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: nameController,
                    hintText: "ATTRIBUTE NAME",
                    columnText: true,
                    width: double.infinity,
                    height: 35,
                    borderRadius: 4,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: CustomTextField(
                    controller: shortNameController,
                    hintText: "SHORT NAME",
                    columnText: true,
                    width: double.infinity,
                    height: 35,
                    borderRadius: 4,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Align(
              alignment: Alignment.bottomRight,
              child: CustomButton(
                onTap: () {
                  if (widget.onSave != null) {
                    widget.onSave!(nameController.text, shortNameController.text);
                  }
                  Navigator.pop(context);
                },
                btnText: "SAVE CHANGES",
                width: 130,
                height: 35,
                borderRadius: 4,
                verticalPadding: 0.0,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
