import 'package:f_web_authentication/domain/use_case/user_usecase.dart';
import 'package:f_web_authentication/ui/controller/calculator_controller.dart';
import 'package:f_web_authentication/ui/pages/authentication/login_page.dart';
import 'package:f_web_authentication/ui/pages/content/home_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HistoryPage extends StatelessWidget {
  HistoryPage({Key? key}) : super(key: key);

  static const LOGOUT = Key("ButtonHistoryLogOff");
  static const USER = Key("ButtonHistoryUser");

  final UserUseCase useCase = Get.find();
  final CalculatorController calculator = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        actions: [
          IconButton(
            key: LOGOUT,
            onPressed: () async {
              await useCase.logOut();
              await Get.off(() => const LoginPage());
            },
            icon: const Icon(Icons.logout),
          ),
          IconButton(
            key: USER,
            onPressed: () => HomePage.showPopup(context, useCase.user!),
            icon: const Icon(Icons.person_2_outlined),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Obx(
              () => Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: Center(
                        child: Text(
                          style: const TextStyle(
                            fontSize: 23,
                          ),
                          key: const Key('TextHomeHello'),
                          "Hello ${useCase.user!.email}",
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Center(
                            child: Text('School: ${useCase.user!.school}'),
                          ),
                          Center(
                            child: Text('Grade: ${useCase.user!.grade}'),
                          ),
                          Center(
                            child: Text(
                              "Current Difficulty: ${calculator.difficulty}",
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
