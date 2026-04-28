 import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../dashboard_view/Controller/dashboard_controller.dart';
import '../dashboard_view/dashboard/F8_widget_alert.dart';
import '../dashboard_view/dashboard/F9_widget_alert.dart';

class BookingForm extends StatefulWidget {
  @override
  _BookingFormState createState() => _BookingFormState();
}

class _BookingFormState extends State<BookingForm> {
  String? selectedAccount;
  String? selectedDriver;
  bool passSelected = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: Colors.grey[200],
        padding: EdgeInsets.all(16),
        child: Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: 600),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Container(
                  padding: EdgeInsets.all(16),
                  color: Colors.grey[300],
                  child: Column(
                    children: [
                      Text(
                        'BASF ADDRESS',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'BOOKING FORM',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'BODYING',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                // Form content
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // First row
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text('PICK',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          Expanded(
                            flex: 2,
                            child: Container(
                              height: 32,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text('SUR'),
                              ),
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            flex: 3,
                            child: Container(
                              height: 32,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text('DEMO COMPANY'),
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 12),

                      // Second row
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text('DROP',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          Expanded(
                            flex: 2,
                            child: Container(
                              height: 32,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text('SELECT NOT'),
                              ),
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            flex: 3,
                            child: Container(
                              height: 32,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text('INCLUPP NOTES'),
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 12),

                      // Third row
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text('NAME',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          Expanded(
                            flex: 2,
                            child: Container(
                              height: 32,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text('SELECT NOT'),
                              ),
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            flex: 3,
                            child: Container(
                              height: 32,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text('DISPOSITIONS'),
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 12),

                      // Fourth row
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text('DATE',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          Expanded(
                            flex: 2,
                            child: Container(
                              height: 32,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(''),
                              ),
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            flex: 1,
                            child: Text('TEL',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              height: 32,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(''),
                              ),
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            flex: 1,
                            child: Text('Q',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              height: 32,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(''),
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 16),

                      // LIAO section
                      Text(
                        'LIAO',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: 8),

                      // Options
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _buildOptionChip('SELECT ACCOUNT'),
                          _buildOptionChip('PASS'),
                          _buildOptionChip('CASH'),
                          _buildOptionChip('QUOTATION'),
                          _buildOptionChip('SMS'),
                          _buildOptionChip('EMAIL'),
                          _buildOptionChip('TIME'),
                          _buildOptionChip('JOUR'),
                        ],
                      ),

                      SizedBox(height: 16),

                      Divider(height: 1, color: Colors.black),

                      SizedBox(height: 8),

                      // Tax information
                      Row(
                        children: [
                          Text('Q TAX: O M @'),
                          SizedBox(width: 16),
                          Text('TIME: O M A.'),
                          SizedBox(width: 16),
                          Text('DISTANCE: O M'),
                          SizedBox(width: 16),
                          Text('☐'),
                          SizedBox(width: 4),
                          Text('/PASS: E O'),
                        ],
                      ),

                      SizedBox(height: 8),

                      Divider(height: 1, color: Colors.black),

                      SizedBox(height: 8),

                      // Driver selection
                      Row(
                        children: [
                          Text('DRV',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(width: 8),
                          Expanded(
                            child: Container(
                              height: 32,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: selectedDriver,
                                  hint: Text('SELECT DRIVER'),
                                  items: [
                                    DropdownMenuItem(
                                        child: Text('Driver 1'), value: '1'),
                                    DropdownMenuItem(
                                        child: Text('Driver 2'), value: '2'),
                                  ],
                                  onChanged: (value) {
                                    setState(() {
                                      selectedDriver = value;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 8),

                      Divider(height: 1, color: Colors.black),

                      SizedBox(height: 16),

                      // Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {},
                            child: Text('WHITEBOOKING [15]'),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.black,
                              backgroundColor: Colors.grey[300],
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {},
                            child: Text('WHITEWINCH [9]'),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.black,
                              backgroundColor: Colors.grey[300],
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                            ),
                          ),

                          ElevatedButton(
                            onPressed: () {},
                            child: Text('CLEAR [7]'),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.black,
                              backgroundColor: Colors.grey[300],
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {},
                            child: Text('SAVE[HOME]'),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.black,
                              backgroundColor: Colors.grey[300],
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOptionChip(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(text),
    );
  }
}
