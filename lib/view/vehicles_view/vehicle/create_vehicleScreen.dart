import 'package:dashboard_new1/component/color.dart';
import 'package:flutter/material.dart';

class CreateVehicle extends StatefulWidget {
  const CreateVehicle({super.key});

  @override
  State<CreateVehicle> createState() => _CreateVehicleState();
}

class _CreateVehicleState extends State<CreateVehicle> {
  bool _enableMinimumMiles = false;
  bool _enableMinimumFares = false;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return LayoutBuilder(
      builder: (context, constraints) {
        bool isMobile = constraints.maxWidth < 800;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: isMobile
              ? Column(
            children: [
              _buildImageBox(isMobile),
              const SizedBox(height: 20),
              _buildFormBox(screenHeight),
            ],
          )
              : Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(flex: 1, child: _buildImageBox(isMobile)),
              const SizedBox(width: 20),
              Flexible(flex: 3, child: _buildFormBox(screenHeight)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildImageBox(bool isMobile) {
    return Container(
      height: isMobile ? 200 : 400,
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey),
      ),
      child: const Center(
        child: Text(
          "UPLOAD IMAGE",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _buildFormBox(double screenHeight) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: screenHeight / 20,
            width: double.infinity,
            color: DynamicColors.gryClr,
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 12),
              child: Text(
                "VEHICLE TYPE",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              runSpacing: 12,
              spacing: 12,
              children: [
                _buildTextField("Vehicle Type"),
                _buildTextField("Passengers"),
                _buildTextField("Luggages"),
                _buildTextField("Hand Luggages"),
                _buildCheckBox("Default Vehicle", false, (v) {}),
                _buildCheckBox("Minimum Miles", _enableMinimumMiles, (v) {
                  setState(() {
                    _enableMinimumMiles = v ?? false;
                  });
                }),
                _buildTextField("Minimum Miles",
                    enabled: _enableMinimumMiles),

                _buildCheckBox("Minimum Fares", _enableMinimumFares, (v) {
                  setState(() {
                    _enableMinimumFares = v ?? false;
                  });
                }),
                _buildTextField("Minimum Fares",
                    enabled: _enableMinimumFares),

                _buildTextField("Background Color"),
                _buildTextField("Foreground Color"),
                _buildTextField("Driver Waiting Charges / 10s"),
                _buildTextField("Account Waiting Charges / 10s"),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
              height: screenHeight / 20,
              width: double.infinity,
              color: DynamicColors.gryClr,
              child: Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 120, vertical: 14),
                  ),
                  onPressed: () {},
                  child: const Text(
                    "SAVE",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              )),
        ],
      ),
    );
  }

  static Widget _buildTextField(String label, {bool enabled = true}) {
    return SizedBox(
      width: 220,
      height: 40,
      child: TextField(
        enabled: enabled,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: enabled ? Colors.white : Colors.grey.shade200,
          labelStyle: TextStyle(
            color: enabled ? Colors.black87 : Colors.grey,
          ),
          border: const OutlineInputBorder(),
          isDense: true,
        ),
      ),
    );
  }

  static Widget _buildCheckBox(
      String label, bool value, Function(bool?) onChanged) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Checkbox(value: value, onChanged: onChanged),
        Text(label),
      ],
    );
  }
}
