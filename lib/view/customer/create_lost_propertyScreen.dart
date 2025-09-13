import 'package:flutter/material.dart';

class LostPropertyScreen extends StatelessWidget {
  const LostPropertyScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Container(

      color: Colors.grey[200],
      alignment: Alignment.topCenter,

      child: SingleChildScrollView(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1200),
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade300),
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

              // LOST PROPERTY + CUSTOMER
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _buildLostPropertySection()),
                  Expanded(child: _buildCustomerSection()),
                ],
              ),

              // REF TABLE HEADER
              Container(
                color: Colors.grey.shade100,
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: const [
                    Expanded(child: Text("REF #", style: TextStyle(fontWeight: FontWeight.bold))),
                    Expanded(child: Text("DATETIME", style: TextStyle(fontWeight: FontWeight.bold))),
                    Expanded(child: Text("VEHICLE", style: TextStyle(fontWeight: FontWeight.bold))),
                    Expanded(child: Text("PICKUP", style: TextStyle(fontWeight: FontWeight.bold))),
                    Expanded(child: Text("DROPOFF", style: TextStyle(fontWeight: FontWeight.bold))),
                  ],
                ),
              ),

              // ENQUIRY HEADER
              Container(
                color: Colors.grey.shade100,
                padding: const EdgeInsets.all(12),
                child: const Text(
                  "ENQUIRY",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              ),

              // ENQUIRY BODY
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [

                    _buildTextField("CHECKED BY"),

                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(child: _buildMultilineTextField("ENQUIRY")),
                        const SizedBox(width: 16),
                        Expanded(child: _buildMultilineTextField("RESULT")),
                      ],
                    ),

                  ],
                ),
              ),

              // SAVE BUTTON
              Container(
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: SizedBox(
                    width: 250,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: () {},
                      child: const Text(
                        "SAVE",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // LOST PROPERTY SECTION
  Widget _buildLostPropertySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          color: Colors.grey.shade100,
          padding: const EdgeInsets.all(12),
          child: const Text(
            "LOST PROPERTY",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(child: _buildTextField("REPORT DATE")),
                  const SizedBox(width: 16),
                  Expanded(child: _buildTextField("FOUND/LOST DATE")),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildMultilineTextField("DETAILS OF PROPERTY")),
                  const SizedBox(width: 16),
                  Expanded(child: _buildMultilineTextField("METHOD OF DISPOSITION")),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // CUSTOMER SECTION
  Widget _buildCustomerSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          color: Colors.grey.shade100,
          padding: const EdgeInsets.all(12),
          child: const Text(
            "CUSTOMER",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(child: _buildTextField("NAME")),
                  const SizedBox(width: 16),
                  Expanded(child: _buildTextField("MOBILE")),
                ],
              ),
              const SizedBox(height: 16),
              _buildMultilineTextField("ADDRESS"),
            ],
          ),
        ),
      ],
    );
  }

  // COMMON TEXTFIELDS
  static Widget _buildTextField(String label) {
    return TextField(
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        isDense: true,
      ),
    );
  }

  static Widget _buildMultilineTextField(String label) {
    return TextField(
      maxLines: 3,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }
}
