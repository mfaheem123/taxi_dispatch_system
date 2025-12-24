import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/component/customButton.dart';
import 'package:dashboard_new1/component/textStyle.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData;

class Postcode {
  final int id;
  final String code;

  Postcode({
    required this.id,
    required this.code,
  });

  factory Postcode.fromJson(Map<String, dynamic> json) {
    return Postcode(
      id: json['id'] ?? 0,
      code: json['postcode'] ?? '',
    );
  }
}

class LocalizationScreen extends StatefulWidget {
  const LocalizationScreen({super.key});

  @override
  State<LocalizationScreen> createState() => _LocalizationScreenState();
}

class _LocalizationScreenState extends State<LocalizationScreen> {
  List<Postcode> postcodes = [];
  final Dio _dio = Dio();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchPostcodes(); // 📌 load list from API
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double screenWidth = constraints.maxWidth;
        double tableWidthFactor = screenWidth < 600
            ? 0.95
            : screenWidth < 1000
            ? 0.7
            : 0.5;

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text(
                    "LOCALIZATION",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 10),
                  CustomButton(
                    width: 30,
                    onTap: () => _showAddDialog(context),
                    height: 30,
                    verticalPadding: 0.0,
                    widget: Icon(
                      Icons.add,
                      color: DynamicColors.whiteClr,
                    ),
                    style: mozillaTextSemiBoldText(
                      fontSize: 12,
                      color: DynamicColors.whiteClr,
                    ),
                    borderRadius: 4,
                  ),
                ],
              ),
            ),

            // 📌 Loader
            if (isLoading)
              const Padding(
                padding: EdgeInsets.all(20),
                child: CircularProgressIndicator(),
              ),

            // 📌 Table
            if (!isLoading)
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: FractionallySizedBox(
                    widthFactor: tableWidthFactor,
                    child: Table(
                      border: const TableBorder(
                        horizontalInside:
                        BorderSide(width: 0.5, color: Colors.grey),
                        verticalInside:
                        BorderSide(width: 0.5, color: Colors.grey),
                        top: BorderSide(width: 0.5, color: Colors.grey),
                        bottom: BorderSide(width: 0.5, color: Colors.grey),
                        left: BorderSide(width: 0.5, color: Colors.grey),
                        right: BorderSide(width: 0.5, color: Colors.grey),
                      ),
                      columnWidths: const {
                        0: FlexColumnWidth(3),
                        1: FlexColumnWidth(1),
                      },
                      children: [
                        TableRow(
                          decoration: const BoxDecoration(
                            color: Color(0xFFE0E0E0),
                          ),
                          children: const [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 14, horizontal: 20),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "POSTCODE",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 14, horizontal: 30),
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  "ACTIONS",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        ...postcodes.map((postcode) {
                          return TableRow(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                            ),
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 9, horizontal: 20),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    postcode.code,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                const EdgeInsets.symmetric(horizontal: 30),
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red),
                                    splashRadius: 20,
                                    onPressed: () async {
                                      await _deletePostcodeApi(postcode.id);
                                    },
                                  ),
                                ),
                              ),
                            ],
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  /// 📌 Dialog open
  void _showAddDialog(BuildContext context) {
    final TextEditingController textController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
        title: const Text(
          "POSTCODE",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Enter Postcode",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: textController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.zero,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
            ),
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "CLOSE",
              style: TextStyle(color: Colors.black87),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
            ),
            onPressed: () async {
              final code = textController.text.trim();
              if (code.isNotEmpty) {
                await _addPostcodeApi(code);
                Navigator.pop(context);
              }
            },
            child: const Text(
              "SAVE",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  /// 📌 GET API - fetch list from server
  Future<void> _fetchPostcodes() async {
    setState(() => isLoading = true);
    try {
      final response = await _dio.get('http://192.168.110.3:5000/api/localizations/getlocalization',);
      // final response = await _dio.get('https://www.nexustechnologys.com/api/localizations/getlocalization',);

      if (response.statusCode == 200 && response.data['status'] == true) {
        final List<dynamic> list = response.data['localizationdetail'];
        final List<Postcode> loaded =
        list.map((e) => Postcode.fromJson(e)).toList();
        setState(() {
          postcodes = loaded;
        });
      } else {
        Get.snackbar('Error', 'Failed to fetch data',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  /// 📌 POST API call for adding postcode
  Future<void> _addPostcodeApi(String code) async {
    try {
      final response = await _dio.post('http://192.168.110.3:5000/api/localizations', data: FormData.fromMap({'postcode': code,}),);
      // final response = await _dio.post('https://www.nexustechnologys.com/api/localizations', data: FormData.fromMap({'postcode': code,}),);

      if (response.statusCode == 200 || response.statusCode == 201) {
        await _fetchPostcodes();
        Get.snackbar(
          'Success',
          'Postcode added successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          'Failed to add postcode',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  /// 🗑️ DELETE API call
  Future<void> _deletePostcodeApi(int id) async {
    try {
      final response = await _dio.delete('http://192.168.110.3:5000/api/localizations/delete/$id',);
      // final response = await _dio.delete('https://www.nexustechnologys.com/api/localizations/delete/$id',);

      if (response.statusCode == 200) {
        await _fetchPostcodes();
        Get.snackbar(
          'Deleted',
          'Postcode deleted successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          'Failed to delete postcode',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
