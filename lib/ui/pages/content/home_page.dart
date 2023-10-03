import 'package:f_web_authentication/ui/controller/user_controller.dart';
import 'package:f_web_authentication/ui/controller/calculator_controller.dart';
import 'package:f_web_authentication/ui/pages/content/history_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loggy/loggy.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

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

  List<Widget> renderButtons(BuildContext context) {
    final buttons = Iterable.generate(
      9,
      (i) => ElevatedButton(
        child: Text((i + 1).toString()),
        onPressed: () => calculator.pushInput((i + 1)),
      ),
    ).toList();

    buttons.addAll([
      ElevatedButton(
        child: const Text("0"),
        onPressed: () => calculator.pushInput(0),
      ),
      ElevatedButton(
        child: const Text("DEL"),
        onPressed: () => calculator.popInput(),
      ),
      ElevatedButton(
        child: const Text("GO"),
        onPressed: () {
          if (calculator.emptyInput) {
            showSnackbar(
              context,
              "Input should not be empty, type a number to continue",
              Colors.red,
            );
          }

          switch (calculator.submit()) {
            case AnswerResult.Correct:
              showSnackbar(
                context,
                "Correct answer",
                Colors.green,
              );
              break;
            case AnswerResult.Wrong:
              showSnackbar(
                context,
                "Wrong answer",
                Colors.red,
              );
              break;
            case AnswerResult.LevelUp:
              showSnackbar(
                context,
                "Level up, difficulty will increase",
                Colors.green,
              );
              break;
            case AnswerResult.SessionReset:
              showSnackbar(
                context,
                "Level up failed, difficulty will stay the same",
                Colors.red,
              );
          }

          calculator.clearInput();
        },
      ),
    ]);

    return buttons;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        actions: [
          IconButton(
            key: HomePage.LOGOUT,
            onPressed: () => controller.logOut(),
            icon: const Icon(Icons.logout),
          ),
          IconButton(
            key: USER,
            onPressed: () {
              _showPopup(context);
            },
            icon: const Icon(Icons.person_2_outlined),
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
                    Expanded(
                      child: Center(
                        child: Row(
                          children: [
                            const Expanded(
                              child: Center(child: Text("Question:")),
                            ),
                            Expanded(
                              child: Center(
                                child: Text(
                                  style: const TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  "${calculator.first} + ${calculator.second}",
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Row(
                          children: [
                            const Expanded(
                              child: Center(child: Text("Your answer:")),
                            ),
                            Expanded(
                              child: Center(
                                child: Text(
                                  style: const TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  calculator.input.isNotEmpty
                                      ? calculator.input.join()
                                      : "0",
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            GridView.count(
              primary: false,
              padding: const EdgeInsets.all(20),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              crossAxisCount: 3,
              shrinkWrap: true,
              children: renderButtons(context),
            ),
          ],
        ),
      ),
    );
  }
}
