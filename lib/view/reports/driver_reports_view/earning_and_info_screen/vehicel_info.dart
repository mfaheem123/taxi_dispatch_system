import 'package:flutter/material.dart';

class VehicelsScreen extends StatelessWidget {
  const VehicelsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 700),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.green, width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /// HEADER
              Column(children: [ Text(
                "UPLOAD\nIMAGE",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
             ],),
              Row(children: [ Text(
                "27 | RICHARD HARDWICK",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(width: 2),
              const Text(
                "LOGGED OUT",
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),],),
             
              const SizedBox(height: 2),

              /// VEHICLE INFO
              const Text(
                "VEHICLE INFORMATION",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.1),
              ),
              const SizedBox(height: 10),

              Wrap(
                spacing: 20,
                runSpacing: 10,
                alignment: WrapAlignment.center,
                children: const [
                  InfoTile(title: "VEHICLE #", value: ""),
                  InfoTile(title: "START DATE", value: "27-05-25"),
                  InfoTile(title: "VEHICLE TYPE", value: "SALOON"),
                  InfoTile(title: "MAKE", value: ""),
                  InfoTile(title: "MODEL", value: ""),
                  InfoTile(title: "COLOR", value: ""),
                ],
              ),
              const SizedBox(height: 20),

              /// DOCUMENTS SECTION
              const Text(
                "DOCUMENTS",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              const Text(
                "EXPIRY DATES",
                style: TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 10),

              Wrap(
                spacing: 16,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: const [
                  InfoTile(title: "PHC DRIVER", value: "00-00-0000"),
                  InfoTile(title: "PHC VEHICLE", value: "00-00-0000"),
                  InfoTile(title: "INSURANCE", value: "00-00-0000"),
                  InfoTile(title: "MOT2", value: "00-00-0000"),
                  InfoTile(title: "MOT", value: "00-00-0000"),
                ],
              ),
              const SizedBox(height: 20),

              const Text(
                "DOCUMENT #",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              Wrap(
                spacing: 16,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: const [
                  InfoTile(title: "PHC DRIVER", value: ""),
                  InfoTile(title: "PHC VEHICLE", value: ""),
                  InfoTile(title: "INSURANCE", value: ""),
                  InfoTile(title: "MOT2", value: ""),
                  InfoTile(title: "MOT", value: ""),
                ],
              ),
              const SizedBox(height: 25),

              /// FOOTER
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                color: Colors.grey.shade100,
                child: Wrap(
                  spacing: 20,
                  alignment: WrapAlignment.center,
                  children: const [
                    FooterInfo(
                        icon: Icons.money,
                        title: "TOTAL AMOUNT",
                        value: "£0.00"),
                    FooterInfo(
                        icon: Icons.directions_car,
                        title: "TOTAL BOOKINGS",
                        value: "0"),
                    FooterInfo(
                        icon: Icons.calendar_today,
                        title: "PERIOD",
                        value: "27-09-25 27-09-25"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class InfoTile extends StatelessWidget {
  final String title;
  final String value;
  const InfoTile({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
   
      // decoration: BoxDecoration(
      //   border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      // ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),
        
          Text(
            value,
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black),
          ),
        ],
      ),
    );
  }
}

class FooterInfo extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const FooterInfo(
      {super.key, required this.icon, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: Colors.black54),
        const SizedBox(width: 5),
        Text(
          "$title: ",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 13, color: Colors.black87),
        ),
      ],
    );
  }
}
