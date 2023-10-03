import 'dart:math';

import 'package:f_web_authentication/domain/models/operator.dart';
import 'package:f_web_authentication/domain/models/session.dart';
import 'package:f_web_authentication/ui/controller/user_controller.dart';
import 'package:get/get.dart';
import 'package:loggy/loggy.dart';

enum AnswerResult { Correct, Wrong, LevelUp, SessionReset }

class CalculatorController extends GetxController {
  final _difficulty = 0.obs;
  final _question = Question(0, 0, Operator.Add, 0).obs;
  final session = Session();
  final input = <int>[].obs;

  CalculatorController() {
    reset(0);
  }

  int get difficulty => _difficulty.value;
  Question get question => _question.value;

  set difficulty(int value) => _difficulty.value = value;

  void next() {
    _question.value = Question.random(difficulty);
    logInfo("Next question: a = ${question.first}, b = ${question.second}, current = ${session.current}");
  }

  int inputValue() => input.reversed.indexed.fold(
        0,
        (acc, pair) => acc + pair.$2 * pow(10, pair.$1).toInt(),
      );

  void pushInput(int digit) {
    if (input.isEmpty && digit == 0) {
      return;
    }

    input.add(digit);
  }

  void popInput() {
    if (input.isNotEmpty) {
      input.removeLast();
    }
  }

  void clearInput() {
    input.clear();
  }

  void sessionReset() {
    final record = session.intoRecord();
    Get.find<UserController>().updateData(difficulty, record);
    session.reset();
    next();
  }

  AnswerResult submit() {
    int answer = inputValue();

    logInfo("Submitted answer: $answer. Expected answer: ${question.expected}");

    bool correct = false;
    question.answer = answer;
    session.questions.add(question);

    if (answer == question.expected) {
      session.correct.value++;
      correct = true;
    }

    if (session.current.value == 5) {
      if (difficulty < 5) {
        if (session.correct > 4 && session.totalTime < Duration(seconds: 30 + 15 * difficulty)) {
          difficulty++;
          sessionReset();

          return AnswerResult.LevelUp;
        }

        sessionReset();

        return AnswerResult.SessionReset;
      }
    }

    next();
    session.current.value++;

    if (correct) {
      return AnswerResult.Correct;
    } else {
      return AnswerResult.Wrong;
    }
  }

  void reset(int initialDifficulty) {
    difficulty = initialDifficulty;
    session.reset();
    clearInput();
    next();
  }
}
