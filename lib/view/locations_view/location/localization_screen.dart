import 'package:bot_toast/bot_toast.dart';
import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/component/customButton.dart';
import 'package:dashboard_new1/component/textStyle.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData;
import 'package:get_storage/get_storage.dart';

import '../../../component/networks/api.dart';
import '../../../component/text_field.dart';

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
  final String globalCompanyId = "1";
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
              "ENTER POSTCODE",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: textController,
              inputFormatters: [UpperCaseTextFormatter()],
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
      final response = await _dio.get(
        '${baseUrl}localizations/getlocalization',
        queryParameters: {'company_id': globalCompanyId},
      );
      print("URL: ${baseUrl}localizations");
      if (response.statusCode == 200 ) {
        final List<dynamic> list = response.data['localizationdetail'];
        final List<Postcode> loaded =
        list.map((e) => Postcode.fromJson(e)).toList();
        setState(() {
          postcodes = loaded;
        });

      } else {
        BotToast.showText(text: 'ERROR' + 'FAILED TO FETCH DATA');

      }
    } catch (e) {
      BotToast.showText(text: 'ERROR');
    } finally {
      setState(() => isLoading = false);
    }
  }

  /// 📌 POST API call for adding postcode
  Future<void> _addPostcodeApi(String code) async {
    try {
      Map<String, dynamic> dataToSend = {
        'postcode': code,
        'company_id': globalCompanyId,
      };
      print("URL: ${baseUrl}localizations");
      print("Sending Data: $dataToSend");
      final response = await _dio.post('${baseUrl}localizations',
        data: FormData.fromMap(dataToSend));
      print("URL: ${baseUrl}localizations");
      if (response.statusCode == 200 ) {
        await _fetchPostcodes();
        BotToast.showText(text:
          'POSTCODE ADDED SUCCESSFULLY');
      } else {
        BotToast.showText(text:
        'ERROR' 'FAILED TO ADD POSTCODE');
      }
    } catch (e) {
      BotToast.showText(text:
      'ERROR');


    }
  }

  /// 🗑️ DELETE API call
  Future<void> _deletePostcodeApi(int id) async {
    try {
      final response = await _dio.delete('${baseUrl}localizations/delete/$id',);
      if (response.statusCode == 200) {
        await _fetchPostcodes();
        BotToast.showText(text:
        'POSTCODE DELETED SUCCESSFULLY');
      } else {
        BotToast.showText(text:
        'ERROR'
            'FAILED TO DELETED POSTCODE');
      }
    } catch (e) {
      BotToast.showText(text:
      'ERROR');
    }
  }
}
