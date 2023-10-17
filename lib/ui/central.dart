import 'package:f_web_authentication/domain/use_case/user_usecase.dart';
import 'package:f_web_authentication/ui/pages/content/home_page.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'pages/authentication/login_page.dart';

class Central extends StatelessWidget {
  const Central({super.key});

  Future<void> tryLoad() async {
    UserUseCase controller = Get.find();

    if (await controller.tryLoad()) {
      Get.off(() => HomePage());
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: tryLoad(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SpinKitRing(color: context.theme.primaryColor, size: 50.0);
        } else {
          return const LoginPage();
        }
      },
    );
  }
}
