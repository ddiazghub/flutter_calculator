import 'package:f_web_authentication/domain/models/session.dart';
import 'package:f_web_authentication/domain/use_case/user_usecase.dart';
import 'package:f_web_authentication/ui/components/history_item.dart';
import 'package:f_web_authentication/ui/controller/calculator_controller.dart';
import 'package:f_web_authentication/ui/pages/authentication/login_page.dart';
import 'package:f_web_authentication/ui/pages/content/home_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SummaryPage extends StatelessWidget {
  final SessionRecord record;
  final int difficulty;

  Duration get targetTime => Duration(seconds: 30 + 15 * difficulty);

  SummaryPage({Key? key, required this.record, required this.difficulty})
      : super(key: key);

  static const LOGOUT = Key("ButtonSummaryLogOff");
  static const USER = Key("ButtonSummaryUser");
  static const CONTINUE = Key("ButtonSummaryContinue");

  final UserUseCase useCase = Get.find();
  final CalculatorController calculator = Get.find();

  @override
  Widget build(BuildContext context) {
    final timeFail = record.totalTime >= targetTime;
    final correctFail = record.correct < 5;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Session Summary"),
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          HistoryItem(
            title: "Summary",
            record: record,
            timeFail: timeFail,
            correctFail: correctFail,
          ),
          Container(
          padding: const EdgeInsets.only(left: 20, right: 20),
            child: timeFail || correctFail
                ? Text(
                    style: HistoryItem.FAIL_TEXT,
                    "Level up failed: Session must be cleared with at least 5 correct answers and under ${targetTime.inSeconds} seconds",
                  )
                : const Text(style: TextStyle(color: Colors.green), "Level up"),
          ),
          ElevatedButton(
            key: CONTINUE,
            child: const SizedBox(
              width: 250,
              child: Center(child: Text("Continue")),
            ),
            onPressed: () async {
              calculator.reset(useCase.user!.difficulty);
              Get.back();
            },
          ),
        ],
      ),
    );
  }
}
