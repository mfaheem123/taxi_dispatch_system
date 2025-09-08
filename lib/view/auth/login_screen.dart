
// import 'package:get/get.dart';
// import 'package:flutter/material.dart';
// import '../../component/customButton.dart';
// import '../../component/textStyle.dart';
// import '../../component/text_field.dart';
// import '../../component/text_widget.dart';
// import '../../routes/app_pages.dart';
//
// class LoginScreen extends StatelessWidget {
//   LoginScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SizedBox(
//         width: Get.width,
//         height: Get.height,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(AppText.login,
//           style: headingText(
//               fontWeight: FontWeight.w700),
//         ),
//             SizedBox(
//               height: 40,
//             ),
//             CustomTextField(
//               hintText: AppText.username,
//               controller: TextEditingController(),),
//             SizedBox(
//               height: 30,
//             ),
//             CustomTextField(
//               controller: TextEditingController(),
//               hintText: AppText.password,
//             ),
//             SizedBox(
//               height: 35,
//             ),
//             CustomButton(
//               onTap: (){
//                 Get.offAllNamed(Routes.dashBoarScreen);
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../component/customButton.dart';
import '../../component/images.dart';
import '../../component/textStyle.dart';
import '../../component/text_field.dart';
import '../../component/text_widget.dart';
import '../../routes/app_pages.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double width = Get.width;
    double height = Get.height;

    return Scaffold(
      body: Stack(
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

          // ✅ Gradient Overlay for readability
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
          // ✅ Centered Card with form
          Center(
            child: LayoutBuilder(
              builder: (context, constraints) {
                double cardWidth = constraints.maxWidth > 600 ? 400 : width * 0.85;
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
                        controller: usernameController,
                        prefixIcon: const Icon(Icons.person),
                      ),
                      const SizedBox(height: 20),

                      // Password
                      CustomTextField(
                        hintText: AppText.password,
                        fillColor: Colors.white,
                        controller: passwordController,
                        // obscureText: true,
                        prefixIcon: const Icon(Icons.lock),
                      ),



                      const SizedBox(height: 15),



                      const SizedBox(height: 25),

                      // Login Button
                      CustomButton(
                        height: 55,
                        // text: "Login",
                        onTap: () {
                          Get.offAllNamed(Routes.myHomePage);
                          // Get.offAllNamed(Routes.dashBoarScreen);
                        },
                      ),

                      const SizedBox(height: 20),

                      // Register link

                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
