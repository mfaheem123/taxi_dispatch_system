import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../controller/zone_controller.dart';

class ZoneScreen extends StatefulWidget {
  const ZoneScreen({Key? key}) : super(key: key);

  @override
  _ZoneScreenState createState() => _ZoneScreenState();
}

class _ZoneScreenState extends State<ZoneScreen> {
  final ZoneController controller = ZoneController();

  final double lat = 50.8543;
  final double lng = 0.5736;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          backgroundColor: Colors.grey.shade200,
          elevation: 0,
          title: const Text(
            "ZONE",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              child: SizedBox(
                width: 220,
                height: 40,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Search...",
                    hintStyle: TextStyle(color: Colors.grey.shade500),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey.shade400, width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.blue, width: 1.5),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {},
                child: const Text("Search"),
              ),
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(
              color: Colors.grey.shade400,
              height: 1,
            ),
          ),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isLargeScreen = constraints.maxWidth > 800;

          return isLargeScreen
              ? Row(children: [_buildForm(flex: 3), _buildMap(flex: 7)])
              : Column(
            children: [
              Expanded(flex: 4, child: _buildForm()),
              Expanded(flex: 6, child: _buildMap()),
            ],
          );
        },
      ),
    );
  }

  Widget _buildForm({int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Checkbox
            Row(
              children: [
                Checkbox(
                  value: controller.zone.base,
                  onChanged: (val) {
                    setState(() {
                      controller.updateBase(val ?? false);
                    });
                  },
                ),
                const Text(
                  "BASE",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            const SizedBox(height: 15),

            const Text(
              "Name",
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            TextField(
              decoration: InputDecoration(
                hintText: "Enter name",
                isDense: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              ),
              onChanged: controller.updateName,
            ),
            const SizedBox(height: 12),

            const Text(
              "Short Name",
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            TextField(
              decoration: InputDecoration(
                hintText: "Enter short name",
                isDense: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              ),
              onChanged: controller.updateShortName,
            ),
            const SizedBox(height: 12),

            const Text(
              "Type",
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            DropdownButtonFormField(
              value: controller.zone.type,
              items: ["MAJOR", "MINOR"]
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (val) {
                setState(() {
                  controller.updateType(val.toString());
                });
              },
              decoration: InputDecoration(
                isDense: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              ),
            ),
            const SizedBox(height: 12),

            const Text(
              "Category",
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            DropdownButtonFormField(
              value: controller.zone.category,
              items: ["INNER", "OUTER"]
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (val) {
                setState(() {
                  controller.updateCategory(val.toString());
                });
              },
              decoration: InputDecoration(
                isDense: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              ),
            ),
            const SizedBox(height: 20),

            // Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: const RoundedRectangleBorder(),
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () {
                      setState(() {
                        controller.clear();
                      });
                    },
                    child: const Text(
                      "CLEAR",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: const RoundedRectangleBorder(),
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () {
                      controller.save();
                    },
                    child: const Text(
                      "SAVE",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildMap({int flex = 1}) {
    return Expanded(
      flex: flex,
      child: FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(lat, lng),
          initialZoom: 14,
        ),
        children: [
          TileLayer(
            urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
            userAgentPackageName: 'com.example.app',
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: LatLng(lat, lng),
                width: 40,
                height: 40,
                child: const Icon(
                  Icons.location_on,
                  color: Colors.red,
                  size: 35,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
