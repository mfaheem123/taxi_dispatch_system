import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../component/color.dart';
import '../../component/textStyle.dart';
import '../../component/text_field.dart';
import 'Controller/auth_controller.dart';

class NewLoginScreen extends StatefulWidget {
  const NewLoginScreen({super.key});

  @override
  State<NewLoginScreen> createState() => _NewLoginScreenState();
}

class _NewLoginScreenState extends State<NewLoginScreen> {
  final AuthController controller = Get.put(AuthController());
  final RxBool _obscurePassword = true.obs;
  final RxBool loader = false.obs;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) setState(() => _isLoaded = true);
    });
  }

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
                Text('WELCOME BACK!',
                  style: headingText(fontWeight: FontWeight.w700, fontSize: 22, color: DynamicColors.black,
                  )),
                const SizedBox(height: 5),
                Text('SIGN IN TO CONTINUE TO YOUR NEXUS DASHBOARD',
                  style: headingText(fontWeight: FontWeight.w600, fontSize: 14, color: DynamicColors.black,
                  )),
              ]),
          ),

          LayoutBuilder(
            builder: (context, constraints) {
              final right = constraints.maxWidth >= 1400 ? 90.0 : constraints.maxWidth >= 1000 ? 20.0 : constraints.maxWidth * 0.08;

              return Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.only(right: right),
                  child: SizedBox(
                    width: 440,
                    child: AnimatedOpacity(
                      opacity: _isLoaded ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 700),
                      curve: Curves.easeOut,
                      child: AnimatedSlide(
                        offset: _isLoaded ? Offset.zero : const Offset(0, 0.1),
                        duration: const Duration(milliseconds: 700),
                        curve: Curves.easeOut,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.fromLTRB(30, 30, 30, 12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(14),
                                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 25, spreadRadius: 2)],
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text('USERNAME',
                                      style: headingText(fontWeight: FontWeight.w600, fontSize: 13, color: DynamicColors.black,
                                      )),
                                  ),
                                  const SizedBox(height: 8),

                                  CustomTextField(
                                    controller: controller.usernameController,
                                    hintText: 'ENTER YOUR USERNAME',
                                    width: double.infinity,
                                    height: 48,
                                    borderRadius: 8,
                                    borderWidth: 1,
                                    borderColor: Colors.grey.shade400,
                                    prefixIcon: const Icon(Icons.person_outline, size: 17, color: Color(0xFF9E9E9E)),
                                    inputFormatters: [UpperCaseTextFormatter()],
                                    contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                                  ),

                                  const SizedBox(height: 25),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'PASSWORD',
                                      style: headingText(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13,
                                        color: DynamicColors.black,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Obx(() => CustomTextField(
                                    controller: controller.passwordController,
                                    hintText: 'ENTER YOUR PASSWORD',
                                    obscureText: _obscurePassword.value,
                                    width: double.infinity,
                                    height: 48,
                                    borderRadius: 8,
                                    borderWidth: 1,
                                    borderColor: Colors.grey.shade400,
                                    prefixIcon: const Icon(Icons.lock_outline, size: 17, color: Color(0xFF9E9E9E)),
                                    suffixIcon: IconButton(
                                      onPressed: () => _obscurePassword.value = !_obscurePassword.value,
                                      icon: Icon(_obscurePassword.value ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                                        size: 16, color: DynamicColors.black,
                                      ),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                                  )),

                                  const SizedBox(height: 25),

                                  Obx(() => SizedBox(
                                    width: double.infinity,
                                    height: 45,
                                    child: ElevatedButton(
                                      onPressed: loader.value ? null : () async {
                                        if (controller.usernameController.text.isEmpty || controller.passwordController.text.isEmpty) {
                                          BotToast.showText(text: "PLEASE ENTER USERNAME OR PASSWORD");
                                          return;
                                        }
                                        loader(true);
                                          await controller.postLoginDetails();
                                          loader(false);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: DynamicColors.primaryClr,
                                        disabledBackgroundColor: DynamicColors.primaryClr,
                                        elevation: 5,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                      ),
                                      child: loader.value ? const SizedBox(height: 20, width: 20,
                                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                      ) : Text('LOGIN',
                                        style: headingText(fontWeight: FontWeight.w700, fontSize: 14, color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  )),
                                  const SizedBox(height: 30),
                                  Text('© NEXUS 2026. ALL RIGHTS RESERVED.',
                                    style: headingText(fontWeight: FontWeight.w600, fontSize: 10, color: Colors.grey.shade700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
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
}