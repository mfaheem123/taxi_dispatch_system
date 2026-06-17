import 'package:dashboard_new1/component/networks/api.dart' as Urls;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:bot_toast/bot_toast.dart';
import '../component/networks/Url.dart'; // Apni Url configuration file ka path check karlein

class NewBookingAlert extends StatefulWidget {
  final String bookingId;
  final String bookingMode;

  const NewBookingAlert({
    super.key,
    required this.bookingId,
    required this.bookingMode,
  });

  @override
  State<NewBookingAlert> createState() => _NewBookingAlertState();
}

class _NewBookingAlertState extends State<NewBookingAlert> {
  bool isLoading = true;
  Map<String, dynamic>? bookingData;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    getBookingDetails();
  }

  Future<void> getBookingDetails() async {
    try {
      // Yahan apni actual backend API endpoint lagayein
      final String apiUrl = "${Urls.baseUrl}/booking-details/${widget.bookingId}";

      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        setState(() {
          bookingData = json.decode(response.body) as Map<String, dynamic>;
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = "Failed to load data (Status: ${response.statusCode})";
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "Error connecting to server";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: Row(
        children: [
          const Icon(Icons.local_taxi, color: Colors.blue, size: 28),
          const SizedBox(width: 10),
          Text(
            "New Booking (#${widget.bookingId})",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ],
      ),
      content: SizedBox(
        width: 400, // Web view ke liye fixed width behtar lagti hai
        child: isLoading
            ? const SizedBox(
          height: 150,
          child: Center(
            child: CircularProgressIndicator(color: Colors.blue),
          ),
        )
            : errorMessage != null
            ? SizedBox(
          height: 100,
          child: Center(
            child: Text(
              errorMessage!,
              style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ),
        )
            : SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  "Type: ${widget.bookingMode}",
                  style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 15),

              // Pickup Location Details
               Text("📍 PICKUP LOCATION",
                  style: TextStyle(color:widget.bookingMode == 'SCHEDULE' ? Colors.blue : Colors.green, fontWeight: FontWeight.bold, fontSize: 12)),
              const SizedBox(height: 4),
              Text(
                bookingData?['pickup_address'] ?? bookingData?['pickup'] ?? "N/A",
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 15),

              // Dropoff Location Details
              const Text("🏁 DROPOFF LOCATION",
                  style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 12)),
              const SizedBox(height: 4),
              Text(
                bookingData?['dropoff_address'] ?? bookingData?['dropoff'] ?? "N/A",
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),

              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Divider(),
              ),

              // Additional Dynamic Info (Fare, Passenger, Distance etc.)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                      "Passenger: ${bookingData?['customer_name'] ?? bookingData?['passenger'] ?? 'N/A'}",
                      style: const TextStyle(fontSize: 13, color: Colors.grey)
                  ),
                  Text(
                      "Fare: £${bookingData?['fare'] ?? '0.0'}",
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green)
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: const Text("REJECT / CLOSE", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
        ),
        if (!isLoading && errorMessage == null)
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              Get.back();
              // Yahan aap accept booking ka process write kar sakte hain
              BotToast.showText(text: "Booking #${widget.bookingId} Accepted Successfully");
            },
            child: const Text("ACCEPT", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
      ],
    );
  }
}