import 'package:f_web_authentication/domain/use_case/user_usecase.dart';
import 'package:f_web_authentication/ui/controller/calculator_controller.dart';
import 'package:f_web_authentication/ui/pages/authentication/login_page.dart';
import 'package:f_web_authentication/ui/pages/content/home_page.dart';
import 'package:f_web_authentication/ui/pages/content/summary_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CalculatorPage extends StatelessWidget {
  CalculatorPage({Key? key}) : super(key: key);

  static const LOGOUT = Key("ButtonCalculatorLogOff");
  static const USER = Key("ButtonCalculatorUser");
  static const GO = Key("ButtonCalculatorGo");

  final UserUseCase useCase = Get.find();
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
        key: GO,
        child: const Text("GO"),
        onPressed: () async {
          final difficulty = calculator.difficulty;

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

              await Get.off(SummaryPage(
                  record: useCase.user!.history.last, difficulty: difficulty));

              break;
            case AnswerResult.SessionReset:
              showSnackbar(
                context,
                "Level up failed, difficulty will stay the same",
                Colors.red,
              );

              await Get.off(SummaryPage(
                  record: useCase.user!.history.last, difficulty: difficulty));
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
        title: const Text("Game"),
        actions: [
          IconButton(
            key: LOGOUT,
            onPressed: () async {
              await useCase.logOut();
              await Get.offAll(() => const LoginPage());
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
                      flex: 2,
                      child: Center(
                        child: Text(
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                          key: const Key('TextHomeHello'),
                          "Hello ${useCase.user!.email}",
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
                                  "Difficulty: ${calculator.difficulty}",
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
                                  calculator.question.question,
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
