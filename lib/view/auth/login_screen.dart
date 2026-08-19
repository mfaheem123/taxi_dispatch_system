import 'package:bot_toast/bot_toast.dart';
import 'package:dashboard_new1/view/auth/Controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../component/customButton.dart';
import '../../component/images.dart';
import '../../component/textStyle.dart';
import '../../component/text_field.dart';
import '../../component/text_widget.dart';
import '../../routes/app_pages.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  AuthController controller = Get.put(AuthController());

  RxBool loader = false.obs;
  // Password ki visibility state (default: hidden/true)
  RxBool isPasswordHidden = true.obs;

  // Login button aur password field ka keyboard "Enter" dono yahi call karte hain
  Future<void> _handleLogin() async {
    print("login hit");
    // Double submit se bachne ke liye
    if (loader.value == true) return;

    loader(true);

    if (controller.usernameController.text.isEmpty ||
        controller.passwordController.text.isEmpty) {
      BotToast.showText(text: "Please enter user name or password");
      loader(false);
      return;
    }
    if (controller.PostAuthLoader.value == false) {
      await controller.postLoginDetails();
    }
    loader(false);
  }

  @override
  Widget build(BuildContext context) {
    double width = Get.width;
    double height = Get.height;
    return Scaffold(
      // Ancestor Focus node: focused text field jo key handle na kare, wo event
      // yahan bubble hoke aata hai. Isliye screen par kahin bhi Enter dabao,
      // login chal jayega — chahe kisi field par focus ho ya na ho.
      body: Focus(
        onKeyEvent: (node, event) {
          if (event is KeyDownEvent &&
              (event.logicalKey == LogicalKeyboardKey.enter ||
                  event.logicalKey == LogicalKeyboardKey.numpadEnter)) {
            _handleLogin();
            return KeyEventResult.handled;
          }
          return KeyEventResult.ignored;
        },
        child: Stack(
          children: [
            Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(Images.loginBackground),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Gradient Overlay for readability
            Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.4),
                    Colors.black.withOpacity(0.2),
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
            ),
            // Centered Card with form
            Center(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  double cardWidth =
                      constraints.maxWidth > 600 ? 400 : width * 0.85;
                  return Container(
                    width: cardWidth,
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          spreadRadius: 2,
                        )
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          AppText.login,
                          style: headingText(
                            fontWeight: FontWeight.w700,
                            fontSize: 28,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 30),

                        // Username
                        CustomTextField(
                          hintText: AppText.username,
                          fillColor: Colors.white,
                          controller: controller.usernameController,
                          prefixIcon: const Icon(Icons.person),
                          textInputAction: TextInputAction.done,
                          onSubmitted: (_) => _handleLogin(),
                          inputFormatters: [
                            UpperCaseTextFormatter(),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Password with Eye Icon Toggle
                        Obx(
                          () => CustomTextField(
                            hintText: AppText.password,
                            fillColor: Colors.white,
                            controller: controller.passwordController,
                            obscureText: isPasswordHidden.value,
                            prefixIcon: const Icon(Icons.lock),
                            textInputAction: TextInputAction.done,
                            onSubmitted: (_) => _handleLogin(),
                            suffixIcon: IconButton(
                              icon: Icon(
                                isPasswordHidden.value
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                // Obx screen rebuild karega jab boolean state change hogi
                                isPasswordHidden.value =
                                    !isPasswordHidden.value;
                              },
                            ),
                          ),
                        ),

                        const SizedBox(height: 25),

                        // Login Button
                        Obx(
                          () => CustomButton(
                            height: 55,
                            widget: loader.value == true
                                ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : null,
                            onTap: _handleLogin,
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
