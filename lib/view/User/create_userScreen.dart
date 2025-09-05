import 'package:flutter/material.dart';

class CreateUserscreen extends StatelessWidget {
  CreateUserscreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return LayoutBuilder(
      builder: (context, constraints) {
        bool isMobile = constraints.maxWidth < 800;

        return SingleChildScrollView(
          padding:  EdgeInsets.all(16),
          child: isMobile
              ? Column(
            children: [
              _buildImageBox(isMobile),
               SizedBox(height: 20),
              _buildFormBox(screenHeight),
            ],
          )
              : Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image box fix with Flexible
              Flexible(flex: 1, child: _buildImageBox(isMobile)),
               SizedBox(width: 20),
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
      margin:  EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey),
      ),
      child:  Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.cloud_upload, size: 50, color: Colors.grey),
            SizedBox(height: 10),
            Text(
              "UPLOAD IMAGE",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ],
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
            child:  Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 12),
              child: Text(
                "USER",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
          ),
           SizedBox(height: 16),
          Padding(
            padding:  EdgeInsets.all(16.0),
            child: Wrap(
              runSpacing: 16,
              spacing: 16,
              children: [
                _buildTextField("USERNAME"),
                _buildTextField("EMAIL"),
                _buildPasswordField("PASSWORD"),
                _buildPasswordField("CONFIRM PASSWORD"),
                _buildTextField("PHONE"),
                _buildTextField("FAX"),
                _buildDropdownField("ROLI", ["SELECT ROLI"]),
                _buildTextField("SURBIONARY"),
                _buildTextField("DIDIC COMPANY"),
                _buildCheckBox("ACTIVE"),
                _buildCheckBox("ALL DRIVERS"),
                _buildCheckBox("ALL BOOKINGS"),
                _buildCheckBox("ALL ACCOUNTS"),
                _buildCheckBox("CALL RECEIVER"),
                _buildCheckBox("ALLOW TRANSFER BOOKINGS"),
              ],
            ),
          ),

           SizedBox(height: 20),

          Container(
            height: screenHeight / 20,
            width: double.infinity,
            color: Colors.grey.withOpacity(0.3),
            child: Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding:
                   EdgeInsets.symmetric(horizontal: 120, vertical: 14),
                ),

                onPressed: () {},
                child:  Text(
                  "SAVE",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildTextField(String label) {
    return SizedBox(
      width: 300,
      child: TextField(
        decoration: InputDecoration(
          labelText: label,
          border:  OutlineInputBorder(),
          isDense: true,
          contentPadding:  EdgeInsets.all(12),
        ),
      ),
    );
  }

  static Widget _buildPasswordField(String label) {
    return SizedBox(
      width: 300,
      child: TextField(
        obscureText: true,
        decoration: InputDecoration(
          labelText: label,
          border:  OutlineInputBorder(),
          isDense: true,
          contentPadding:  EdgeInsets.all(12),
        ),
      ),
    );
  }

  static Widget _buildDropdownField(String label, List<String> items) {
    return SizedBox(
      width: 300,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border:  OutlineInputBorder(),
          contentPadding:  EdgeInsets.all(12),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: items.first,
            items: items.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (_) {},
          ),
        ),
      ),
    );
  }

  static Widget _buildCheckBox(String label) {
    return SizedBox(
      width: 300,
      child: Row(
        children: [
          Checkbox(value: false, onChanged: (v) {}),
          Text(label),
        ],
      ),
    );
  }
}