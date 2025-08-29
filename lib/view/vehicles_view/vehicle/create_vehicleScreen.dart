import 'package:flutter/material.dart';

import '../../../component/text_widget.dart';
import '../../drivers_view/driver/driver_app_features/pda_details_widget.dart';

class CreateVehicle extends StatefulWidget {
  const CreateVehicle({super.key});

  @override
  State<CreateVehicle> createState() => _CreateVehicleState();
}

class _CreateVehicleState extends State<CreateVehicle> {
  // ✅ Controllers for each field
  final TextEditingController vehicleTypeCtrl = TextEditingController();
  final TextEditingController passengersCtrl = TextEditingController();
  final TextEditingController luggagesCtrl = TextEditingController();
  final TextEditingController handLuggagesCtrl = TextEditingController();
  final TextEditingController minFaresCtrl = TextEditingController();
  final TextEditingController bgColorCtrl = TextEditingController();
  final TextEditingController fgColorCtrl = TextEditingController();
  final TextEditingController driverWaitingCtrl = TextEditingController();
  final TextEditingController accountWaitingCtrl = TextEditingController();

  @override
  void dispose() {
    // ✅ Dispose controllers
    vehicleTypeCtrl.dispose();
    passengersCtrl.dispose();
    luggagesCtrl.dispose();
    handLuggagesCtrl.dispose();
    minFaresCtrl.dispose();
    bgColorCtrl.dispose();
    fgColorCtrl.dispose();
    driverWaitingCtrl.dispose();
    accountWaitingCtrl.dispose();
    super.dispose();
  }

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
            color: Colors.grey.withOpacity(0.3),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 12),
              child: Text(
                "VEHICLE TYPE",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),

           SizedBox(height: 16),

          Wrap(
            runSpacing: 12,
            spacing: 12,
            children: [
              _buildTextField("Vehicle Type", vehicleTypeCtrl),
              _buildTextField("Passengers", passengersCtrl),
              _buildTextField("Luggages", luggagesCtrl),
              _buildTextField("Hand Luggages", handLuggagesCtrl),
              _buildCheckBox("Default Vehicle"),
              _buildCheckBox("Minimum Miles"),
              _buildTextField("Minimum Fares", minFaresCtrl),
              _buildTextField("Background Color", bgColorCtrl),
              _buildTextField("Foreground Color", fgColorCtrl),
              _buildTextField("Driver Waiting Charges / 10s", driverWaitingCtrl),
              _buildTextField("Account Waiting Charges / 10s", accountWaitingCtrl),
            ],
          ),

          const SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding:
                const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
              ),
              onPressed: () {
                // ✅ Example: print values
                print("Vehicle Type: ${vehicleTypeCtrl.text}");
                print("Passengers: ${passengersCtrl.text}");
              },
              child: const Text(
                "SAVE",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }

  // ✅ TextField with controller
  Widget _buildTextField(String label, TextEditingController controller) {
    return SizedBox(
      width: 220,
      height: 40,
      child: textFieldsWidget(
          context,
          controller,
          label: AppText.commission,
          width: 200,
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
