import 'dart:io';

import 'package:f_web_authentication/domain/models/user.dart';
import 'package:f_web_authentication/domain/use_case/user_usecase.dart';
import 'package:f_web_authentication/ui/controller/calculator_controller.dart';
import 'package:f_web_authentication/ui/pages/authentication/login_page.dart';
import 'package:f_web_authentication/ui/pages/content/calculator_page.dart';
import 'package:f_web_authentication/ui/pages/content/history_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  static const LOGOUT = Key("ButtonHomeLogOff");
  static const USER = Key("ButtonHomeUser");
  static const START = Key("ButtonHomeStart");
  static const HISTORY = Key("ButtonHomeHistory");

  final UserUseCase useCase = Get.find();
  final CalculatorController calculator = Get.find();

  static void showPopup(BuildContext context, User user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('User Data'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Email: ${user.email}'),
              Text('School: ${user.school}'),
              Text('Grade: ${user.grade}'),
            ],
          ),
          actions: [
            ElevatedButton(
              child: const Text('Close'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

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
            onPressed: () => showPopup(context, useCase.user!),
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
                    Expanded(
                      flex: 3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: const EdgeInsets.all(10),
                            child: Center(
                              child: ElevatedButton(
                                key: START,
                                child: const SizedBox(
                                  width: 250,
                                  child: Center(child: Text('Start')),
                                ),
                                onPressed: () async {
                                  calculator.reset(useCase.user!.difficulty);
                                  await Get.to(() => CalculatorPage());
                                },
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.all(10),
                            child: Center(
                              child: ElevatedButton(
                                key: HISTORY,
                                child: const SizedBox(
                                  width: 250,
                                  child: Center(child: Text('History')),
                                ),
                                onPressed: () => Get.to(() => HistoryPage()),
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.all(10),
                            child: Center(
                              child: ElevatedButton(
                                child: const SizedBox(
                                  width: 250,
                                  child: Center(child: Text('Exit')),
                                ),
                                onPressed: () {
                                  if (Platform.isAndroid) {
                                    SystemNavigator.pop();
                                  } else if (Platform.isIOS) {
                                    exit(0);
                                  }
                                },
                              ),
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
