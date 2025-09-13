// import 'package:flutter/material.dart';
//
// class ComplaintBookingScreen extends StatelessWidget {
//   const ComplaintBookingScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Colors.grey[200],
//       alignment: Alignment.topCenter,
//       child: SingleChildScrollView(
//         child: Container(
//           constraints: const BoxConstraints(maxWidth: 1200),
//           margin: const EdgeInsets.all(16),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             border: Border.all(color: Colors.grey.shade300),
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               // HEADER ROW Customer + Booking
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Expanded(child: _buildCustomerSection()),
//                   Expanded(child: _buildBookingSection()),
//                 ],
//               ),
//
//               // Pickup Dropoff Header
//               Container(
//                 color: Colors.grey.shade100,
//                 padding: const EdgeInsets.all(12),
//                 child: Row(
//                   children: const [
//                     Expanded(
//                         child: Text("PICKUP",
//                             style: TextStyle(fontWeight: FontWeight.bold))),
//                     Expanded(
//                         child: Text("DROPOFF",
//                             style: TextStyle(fontWeight: FontWeight.bold))),
//                   ],
//                 ),
//               ),
//
//               // Save Button
//               Container(
//                 padding: const EdgeInsets.all(16),
//                 child: Center(
//                   child: SizedBox(
//                     width: 300,
//                     child: ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.green,
//                         padding: const EdgeInsets.symmetric(vertical: 16),
//                       ),
//                       onPressed: () {},
//                       child: const Text(
//                         "SAVE",
//                         style: TextStyle(color: Colors.white, fontSize: 16),
//                       ),
//                     ),
//                   ),
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   // ---------------- CUSTOMER SECTION ----------------
//
//   Widget _buildCustomerSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       children: [
//         Container(
//           color: Colors.grey.shade100,
//           padding: const EdgeInsets.all(12),
//           child: const Text(
//             "CUSTOMER",
//             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//             textAlign: TextAlign.center,
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             children: [
//               Row(
//                 children: [
//                   Expanded(child: _buildTextField("COMPLAIN DATE")),
//                   const SizedBox(width: 16),
//                   Expanded(child: _buildTextField("INCIDENT DATE")),
//                 ],
//               ),
//               const SizedBox(height: 16),
//               Row(
//                 children: [
//                   Expanded(child: _buildTextField("NAME")),
//                   const SizedBox(width: 16),
//                   Expanded(
//                     child: Row(
//                       children: [
//                         Expanded(child: _buildTextField("MOBILE")),
//                         const SizedBox(width: 4),
//                         ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.green,
//                             minimumSize: const Size(40, 48),
//                           ),
//                           onPressed: () {},
//                           child: const Icon(Icons.search, color: Colors.white),
//                         )
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
//
//   // ---------------- BOOKING SECTION ----------------
//
//   Widget _buildBookingSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       children: [
//         Container(
//           color: Colors.grey.shade100,
//           padding: const EdgeInsets.all(12),
//           child: Row(
//             children: [
//               const Expanded(
//                 child: Text(
//                   "BOOKING",
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//               Row(
//                 children: [
//                   Row(
//                     children: [
//                       Radio(value: 1, groupValue: 1, onChanged: (_) {}),
//                       const Text("DRIVER"),
//                     ],
//                   ),
//                   const SizedBox(width: 8),
//                   Row(
//                     children: [
//                       Radio(value: 2, groupValue: 1, onChanged: (_) {}),
//                       const Text("EMPLOYEE"),
//                     ],
//                   ),
//                   const SizedBox(width: 8),
//                   Row(
//                     children: [
//                       Radio(value: 3, groupValue: 1, onChanged: (_) {}),
//                       const Text("ACCOUNT"),
//                     ],
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             children: [
//               Row(
//                 children: [
//                   Expanded(
//                     child: Row(
//                       children: [
//                         Expanded(child: _buildTextField("REFERENCE #")),
//                         const SizedBox(width: 4),
//                         ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.green,
//                             minimumSize: const Size(40, 48),
//                           ),
//                           onPressed: () {},
//                           child: const Icon(Icons.search, color: Colors.white),
//                         )
//                       ],
//                     ),
//                   ),
//                   const SizedBox(width: 16),
//                   Expanded(child: _buildDropdownField("DRIVER")),
//                   const SizedBox(width: 16),
//                   Expanded(child: _buildTextField("REG. #")),
//                 ],
//               ),
//               const SizedBox(height: 16),
//               Row(
//                 children: [
//                   Expanded(child: _buildMultilineTextField("NOTES")),
//                   const SizedBox(width: 16),
//                   Expanded(child: _buildMultilineTextField("COMPLAINT")),
//                 ],
//               ),
//               const SizedBox(height: 16),
//               Row(
//                 children: [
//                   Expanded(child: _buildTextField("HOW WAS IT DEALT WITH")),
//                   const SizedBox(width: 16),
//                   Expanded(child: _buildTextField("RESULT")),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
//
//   // ---------------- COMMON FIELDS ----------------
//   static Widget _buildTextField(String label) {
//     return TextField(
//       decoration: InputDecoration(
//         labelText: label,
//         border: const OutlineInputBorder(),
//         isDense: true,
//       ),
//     );
//   }
//
//   static Widget _buildDropdownField(String label) {
//     return DropdownButtonFormField<String>(
//       decoration: InputDecoration(
//         labelText: label,
//         border: const OutlineInputBorder(),
//         isDense: true,
//       ),
//       items: const [
//         DropdownMenuItem(value: "1", child: Text("SELECT DRIVER")),
//       ],
//       onChanged: (value) {},
//     );
//   }
//
//   static Widget _buildMultilineTextField(String label) {
//     return TextField(
//       maxLines: 3,
//       decoration: InputDecoration(
//         labelText: label,
//         border: const OutlineInputBorder(),
//       ),
//     );
//   }
// }
