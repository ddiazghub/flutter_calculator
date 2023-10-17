import 'package:f_web_authentication/ui/controller/user_controller.dart';
import 'package:f_web_authentication/ui/controller/calculator_controller.dart';
import 'package:f_web_authentication/ui/pages/content/history_page.dart';
import 'package:f_web_authentication/ui/pages/content/home_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loggy/loggy.dart';

class MainPage extends StatelessWidget {
  MainPage({Key? key}) : super(key: key);

  static const LOGOUT = Key("ButtonHomeLogOff");
  static const USER = Key("ButtonHomeUser");

  final UserController controller = Get.find();
  final CalculatorController calculator = Get.find();

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackbar(
      BuildContext context, String text, Color color) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(milliseconds: 1500),
        backgroundColor: color,
        content: Text(text),
      ),
    );
  }

  void _showPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Datos de Usuario'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Email: ${controller.user!.email}'),
              Text('Colegio: ${controller.user!.school}'),
              Text('Grado: ${controller.user!.grade}'),
            ],
          ),
          actions: [
            ElevatedButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the pop-up
              },
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
            key: MainPage.LOGOUT,
            onPressed: () => controller.logOut(),
            icon: const Icon(Icons.logout),
          ),
          IconButton(
            onPressed: () =>
                Get.to(() => HistoryPage(items: controller.user!.history)),
            icon: const Icon(Icons.history),
          )
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
                      flex: 2,
                      child: Center(
                        child: Text(
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                          key: const Key('TextHomeHello'),
                          "Hello ${controller.user!.email}",
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Center(
                        child: Text(
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                          key: const Key('TextSchool'),
                          "School: ${controller.user!.school}",
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Center(
                        child: Text(
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                          key: const Key('TextGrade'),
                          "Grade: ${controller.user!.grade}",
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Row(
                          children: [
                            Expanded(
                              child: Center(
                                child: Text(
                                  "Difficulty: ${calculator.difficulty.value}",
                                ),
                              ),
                            ),
                            Expanded(
                              child: Center(
                                child: Text(
                                  "Answers: ${calculator.session.current}",
                                ),
                              ),
                            ),
                            Expanded(
                              child: Center(
                                child: Text(
                                  "Correct: ${calculator.session.correct}",
                                ),
                              ),
                            ),
                            Expanded(
                              child: Center(
                                child: Text(
                                  "Time: ${calculator.session.elapsedString}",
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () => Get.to(() => HomePage()),
                      child: const Text("Start Excercise"),
                    )
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
