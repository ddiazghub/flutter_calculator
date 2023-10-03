import 'package:f_web_authentication/ui/controller/user_controller.dart';
import 'package:f_web_authentication/ui/pages/content/home_page.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'pages/authentication/login_page.dart';

class Central extends StatelessWidget {
  const Central({super.key});

  @override
  Widget build(BuildContext context) {
    UserController controller = Get.find();

    return FutureBuilder(
      future: controller.tryLoad(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SpinKitRing(color: context.theme.primaryColor, size: 50.0);
        } else {
          return Obx(() => controller.isLogged ? HomePage() : const LoginPage());
        }
      },
    );
  }
}
