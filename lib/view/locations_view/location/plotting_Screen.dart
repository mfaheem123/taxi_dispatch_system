import 'package:dashboard_new1/component/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ManagePostcodes extends StatefulWidget {
  const ManagePostcodes({super.key});

  @override
  State<ManagePostcodes> createState() => _ManagePostcodesState();
}

class _ManagePostcodesState extends State<ManagePostcodes> {
  // Dummy data
  final List<Map<String, String>> allPostcodes = [
    {"area": "Aberdeen", "postcode": "AB"},
    {"area": "St Albans", "postcode": "AL"},
    {"area": "Birmingham", "postcode": "B"},

  ];

  List<Map<String, String>> selectedPostcodes = [];

  void addSelected(List<Map<String, String>> list) {
    setState(() {
      selectedPostcodes.addAll(list);
      allPostcodes.removeWhere((e) => list.contains(e));
    });
  }

  void removeSelected(List<Map<String, String>> list) {
    setState(() {
      allPostcodes.addAll(list);
      selectedPostcodes.removeWhere((e) => list.contains(e));
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Container(
   
      color: Colors.grey.shade100,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Title
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Manage Postcode",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
          ),

          const SizedBox(height: 16),

          Container(
            color: Colors.purple.shade50,
            padding: const EdgeInsets.all(8),
            child: Center(
              child: Text(
                "All Postcodes",
                // "$title (${list.length})",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),

         Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 150,
                  width: Get.width/3,
                  decoration: BoxDecoration(
                      border: Border.all(color: DynamicColors.textClr)
                  ),
                  child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, index){
                        return Container(
                          width: 200,
                          padding: EdgeInsets.symmetric(vertical: 4,horizontal: 4),
                          decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: DynamicColors.textClr),
                              )
                          ),

                          child: Row(
                            children: [
                              Checkbox(value: false, onChanged: (v){

                              }),
                              Text("data$index"),
                            ],
                          ),
                        );
                      }),
                ),

                Container(
                  height: 150,
                  width: Get.width/3,
                  decoration: BoxDecoration(
                      border: Border.all(color: DynamicColors.textClr)
                  ),
                  child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, index){
                        return Container(
                          width: 200,
                          padding: EdgeInsets.symmetric(vertical: 4,horizontal: 4),
                          decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: DynamicColors.textClr),
                              )
                          ),
                          child: Row(
                            children: [
                              Checkbox(value: false, onChanged: (v){
                              }),
                              Text("data$index"),
                            ],
                          ),
                        );
                      }),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildTable(List<Map<String, String>> list, String title, bool isLeft) {
    return Container(
      width: 150,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.purple.shade200),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Container(
            color: Colors.purple.shade50,
            padding: const EdgeInsets.all(8),
            child: Center(
              child: Text(
                "$title (${list.length})",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),

          ListView(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            children: list
                .map((item) => CheckboxListTile(
              value: false,
              onChanged: (_) {},
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: Text(item["area"]!)),
                  Text(item["postcode"]!),
                ],
              ),
            ))
                .toList(),
          )
        ],
      ),
    );
  }

  Widget _buildButtons(bool vertical) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.purple,
            minimumSize: const Size(60, 40),
          ),
          onPressed: () {
            // example - select Bath
            addSelected(allPostcodes.where((e) => e["area"] == "Bath").toList());
          },
          child: const Text(">>"),
        ),
        const SizedBox(height: 12),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.purple.shade200,
            minimumSize: const Size(60, 40),
          ),
          onPressed: () {
            removeSelected(selectedPostcodes.where((e) => e["area"] == "Bath").toList());
          },
          child: const Text("<<"),
        ),
      ],
    );
  }
}
