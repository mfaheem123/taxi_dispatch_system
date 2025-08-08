import 'package:flutter/material.dart';



class MultiReservationPage extends StatelessWidget {
  const MultiReservationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.directions_car, size: 20),
              SizedBox(width: 8),
              Text(
                'VIA (o)',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // PickUp Location section
          const Text(
            'PickUp Location',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Checkbox(value: false, onChanged: (value) {}),
              const Text('Notes'),
            ],
          ),
          Row(
            children: [
              Checkbox(value: true, onChanged: (value) {}),
              const Text('DropOff Location'),
            ],
          ),
          Row(
            children: [
              Checkbox(value: false, onChanged: (value) {}),
              const Text('Notes'),
            ],
          ),
          const SizedBox(height: 20),

          // Passenger Info section
          const Text(
            'Passenger Name',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          _buildInfoRow('Date:', 'Fri 18 - 7 - 2025'),
          _buildInfoRow('Time:', '19:04'),
          _buildInfoRow('Mobile:', 'Journey Type'),
          _buildInfoRow('Reference#', 'NTG54851'),
          _buildInfoRow('Action:', 'Passenger 1'),
          _buildInfoRow('Account:', 'Luggage'),
          _buildInfoRow('Small Lugga:', 'Special Requirements'),
          _buildInfoRow('Email:', 'Email'),

          const Divider(height: 40, thickness: 1),

          // ETA section
          const Center(
            child: Text(
              'ETA : 0.0 mins',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 8),
          _buildInfoRow('JOURNEY :', '0.0 mins'),
          _buildInfoRow('DISTANCE :', '0.0 miles'),
          _buildInfoRow('PR.', '\$ 4.90'),

          const Divider(height: 40, thickness: 1),

          // Driver section
          const Center(
            child: Text(
              'DRIVERS',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Select Driver',
            ),
            items: const [],
            onChanged: (value) {},
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {},
                child: const Text('CLEAR'),
              ),
              ElevatedButton(
                onPressed: () {},
                child: const Text('QUOTE'),
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                child: const Text('SAVE'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Text(value),
        ],
      ),
    );
  }
}