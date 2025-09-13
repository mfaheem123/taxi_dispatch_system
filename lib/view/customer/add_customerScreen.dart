import 'package:flutter/material.dart';

class CustomerFormScreen extends StatelessWidget {
  const CustomerFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      alignment: Alignment.center,
      child: SingleChildScrollView(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1100),
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                color: Colors.grey.shade100,
                padding: const EdgeInsets.all(12),
                child: const Text(
                  "CUSTOMER",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.black87),
                  textAlign: TextAlign.center,
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(16),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    bool isWide = constraints.maxWidth > 600;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Checkbox(value: true, onChanged: (v) {}),

                            const Text("ENABLE SMS"),

                            const Spacer(),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                              ),
                              onPressed: () {},
                              child: const Text(
                                "RESTRICTED DRIVERS",
                                style: TextStyle(color: Colors.white),
                              ),
                            )
                          ],
                        ),

                        const SizedBox(height: 16),

                        Flex(
                          direction: isWide ? Axis.horizontal : Axis.vertical,
                          children: [
                            Expanded(child: _buildTextField("NAME")),
                            const SizedBox(width: 16, height: 16),
                            Expanded(child: _buildTextField("EMAIL")),
                          ],
                        ),

                        const SizedBox(height: 16),

                        Flex(
                          direction: isWide ? Axis.horizontal : Axis.vertical,
                          children: [
                            Expanded(child: _buildTextField("MOBILE")),
                            const SizedBox(width: 16, height: 16),
                            Expanded(child: _buildTextField("TELEPHONE")),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),

              Container(
                color: Colors.grey.shade100,
                padding: const EdgeInsets.all(12),
                child: const Text(
                  "OTHERS",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.black87),
                  textAlign: TextAlign.center,
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(16),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    bool isWide = constraints.maxWidth > 600;
                    return Column(
                      children: [
                        // Door # & Notes
                        Flex(
                          direction: isWide ? Axis.horizontal : Axis.vertical,
                          children: [
                            Expanded(child: _buildTextField("DOOR #")),
                            const SizedBox(width: 16, height: 16),
                            Expanded(child: _buildTextField("NOTES")),
                          ],
                        ),


                        const SizedBox(height: 16),

                        Flex(
                          direction: isWide ? Axis.horizontal : Axis.vertical,
                          children: [
                            Expanded(child: _buildMultilineTextField("ADDRESS 1")),
                            const SizedBox(width: 16, height: 16),
                            Expanded(child: _buildMultilineTextField("ADDRESS 2")),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),

              Container(
                color: Colors.grey.shade100,
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: SizedBox(
                    width: 400, // 👈 yahan apni desired width dal do
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
              )

            ],
          ),
        ),
      ),
    );
  }

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
