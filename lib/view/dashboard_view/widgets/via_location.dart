import 'package:flutter/material.dart';

import '../../../Model/via_point.dart';

class ViaLocation extends StatefulWidget {
  const ViaLocation({super.key});

  @override
  State<ViaLocation> createState() => _ViaLocationState();
}

class _ViaLocationState extends State<ViaLocation> {
  final TextEditingController addressController = TextEditingController();
  final List<ViaPoint> viaPoints = [];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.all(20),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: SizedBox(
        height: 300,
        width: 600,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "VIA POINT(S)",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Text(
                        "#",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 22),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                        child: TextField(
                          controller: addressController,
                      decoration: InputDecoration(
                          hintText: "Search Address",
                          border: OutlineInputBorder(),
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                          )),
                    ),
                    SizedBox(width: 12),
                    SizedBox(
                      width: 30,
                      height: 30,
                      child: ElevatedButton(
                        onPressed: () {
                          final addr = addressController.text.trim();
                          if (addr.isNotEmpty) {
                            setState(() {
                              viaPoints.add(ViaPoint(address: addr));
                              addressController.clear();
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        child: Icon(Icons.add, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                ListView.builder(
                    itemCount: viaPoints.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final point = viaPoints[index];
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${index + 1}',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                                child: Column(
                              children: [
                                TextField(
                                  readOnly: true,
                                  controller: TextEditingController(
                                      text: point.address),
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                                SizedBox(height: 10),
                                Row(
                                  children: [
                                    Expanded(
                                        child: TextField(
                                      onChanged: (val) => point.name = val,
                                      decoration: InputDecoration(
                                        hintText: "Name",
                                        border: OutlineInputBorder(),
                                      ),
                                    )),
                                    SizedBox(width: 8),
                                    Expanded(
                                        child: TextField(
                                      onChanged: (val) => point.mobile = val,
                                      decoration: InputDecoration(
                                        hintText: "Mobile",
                                        border: OutlineInputBorder(),
                                      ),
                                    )),
                                  ],
                                ),
                              ],
                            )),

                            Padding(
                              padding: const EdgeInsets.only(left: 12.0, top: 8), // Add spacing from left
                              child: SizedBox(
                                width: 30,
                                height: 30,
                                child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      viaPoints.removeAt(index);
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    padding: EdgeInsets.zero,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                  child: Icon(Icons.delete, color: Colors.white, size: 20),
                                ),
                              ),
                            ),

                            // SizedBox(
                            //   width: 30,
                            //   height: 30,
                            //   child: ElevatedButton(
                            //     onPressed: () {
                            //       setState(() {
                            //         viaPoints.removeAt(index);
                            //       });
                            //     },
                            //     style: ElevatedButton.styleFrom(
                            //         backgroundColor: Colors.red,
                            //         padding: EdgeInsets.zero,
                            //         shape: RoundedRectangleBorder(
                            //           borderRadius: BorderRadius.circular(4),
                            //         )),
                            //     child: Icon(Icons.delete,
                            //         color: Colors.white, size: 20),
                            //   ),
                            // ),
                          ],
                        ),
                      );
                    }),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4)),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        "Cancel",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(width: 10),
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4)),
                      ),
                      onPressed: () {
                        for (var point in viaPoints) {
                          print(
                              "${point.address} - ${point.name} - ${point.mobile}");
                        }
                        Navigator.pop(context);
                      },
                      child: Text(
                        " Save ",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
