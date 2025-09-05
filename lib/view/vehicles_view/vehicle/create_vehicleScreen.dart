import 'package:flutter/material.dart';

class CreateVehicle extends StatelessWidget {
  CreateVehicle({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
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
              // Image box fix with Flexible
              Flexible(flex: 1, child: _buildImageBox(isMobile)),
              const SizedBox(width: 20),
              // Form box fix with Flexible
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
            color: Colors.grey.withOpacity(0.3),
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

                _buildCheckBox("Default Vehicle"),
                _buildCheckBox("Minimum Miles"),
                _buildTextField("Minimum Fares"),
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
            color: Colors.grey.withOpacity(0.3),
            child:  Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 120, vertical: 14),
                ),
                onPressed: () {},
                child: const Text(
                  "SAVE",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            )
          ),


        ],
      ),
    );
  }


  static Widget _buildTextField(String label) {
    return SizedBox(
      width: 220,
      height: 40,
      child: TextField(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          isDense: true,
        ),
      ),
    );
  }


  static Widget _buildCheckBox(String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Checkbox(value: false, onChanged: (v) {}),
        Text(label),
      ],
    );
  }
}
