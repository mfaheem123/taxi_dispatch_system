import 'package:flutter/material.dart';

import '../../component/color.dart';
import '../../component/text_field.dart';

class NewLoginScreen extends StatefulWidget {
  const NewLoginScreen({super.key});

  @override
  State<NewLoginScreen> createState() => _NewLoginScreenState();
}

bool _obscurePassword = true;

class _NewLoginScreenState extends State<NewLoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/login_backImg.png', fit: BoxFit.cover),
          Container(color: const Color(0xFFECEBF5).withOpacity(.25)),

          // WELCOME TEXT
          Positioned(
            left: 150,
            top: 100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'WELCOME BACK!',
                  style: TextStyle(
                    fontSize: 22, fontWeight: FontWeight.bold, color: DynamicColors.black,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'SIGN IN TO CONTINUE TO YOUR NEXUS DASHBOARD',
                  style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold, color: DynamicColors.black,
                  ),
                ),
              ],
            ),
          ),

          LayoutBuilder(
            builder: (context, constraints) {
              final screenWidth = constraints.maxWidth;

              final right = screenWidth >= 1400
                  ? 90.0
                  : screenWidth >= 1000
                      ? 20.0
                      : screenWidth * 0.08;

              return Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.only(right: right),
                  child: Container(
                    width: 440,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(30),
                          decoration: BoxDecoration(
                            color: Colors.white, borderRadius: BorderRadius.circular(14),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12, blurRadius: 25, spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'USERNAME',
                                  style: TextStyle(
                                    fontSize: 14, color: DynamicColors.black,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextField(
                                inputFormatters: [UpperCaseTextFormatter()],
                                decoration: field(
                                  'ENTER YOUR USERNAME',
                                  Icons.person_outline,
                                ),
                              ),
                              const SizedBox(height: 25),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'PASSWORD',
                                  style: TextStyle(fontSize: 14, color: DynamicColors.black,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextField(
                                obscureText: _obscurePassword,
                                decoration: field(
                                  'ENTER YOUR PASSWORD',
                                  Icons.lock_outline, suffix: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _obscurePassword = !_obscurePassword;
                                      });
                                    },
                                    icon: Icon(
                                      _obscurePassword
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                      size: 16,
                                      color: DynamicColors.black,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 25),
                              SizedBox(
                                width: double.infinity,
                                height: 40,
                                child: ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: DynamicColors.primaryClr,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7),
                                    ),
                                  ),
                                  child: const Text(
                                    'LOGIN',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 18),
                        Text(
                          '© NEXUS 2026. ALL RIGHTS RESERVED.',
                          style: TextStyle(
                            fontSize: 12,
                            color: DynamicColors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  final border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: BorderSide(color: Colors.grey.shade700),
  );

  InputDecoration field(String hint, IconData icon, {Widget? suffix}) =>
      InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(fontSize: 11, color: Color(0xFFB0B0B0)),
        prefixIcon: Icon(icon, size: 17, color: Color(0xFF9E9E9E)),
        suffixIcon: suffix,
        border: border,
        enabledBorder: border,
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
      );
}
