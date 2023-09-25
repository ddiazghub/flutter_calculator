import 'dart:math';

import 'package:f_web_authentication/domain/models/session.dart';
import 'package:f_web_authentication/domain/use_case/authentication_usecase.dart';
import 'package:get/get.dart';
import 'package:loggy/loggy.dart';

enum AnswerResult { Correct, Wrong, LevelUp, SessionReset }

class CalculatorController extends GetxController {
  final _rng = Random();
  final difficulty = 0.obs;
  final first = 0.obs;
  final second = 0.obs;
  final session = Session();
  final input = <int>[].obs;

  final AuthenticationUseCase auth = Get.find();

  CalculatorController() {
    reset(0);
  }

  int get expectedAnswer => first.value + second.value;
  bool get emptyInput => input.isEmpty;

  void next() {
    genMax(pow(10, difficulty.value + 1) as int);
    logInfo("Next question: a = $first, b = $second, current = ${session.current}");
  }

  int inputtedAnswer() => input.reversed.indexed.fold(
        0,
        (acc, pair) => acc + pair.$2 * pow(10, pair.$1) as int,
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
    auth.levelUp(difficulty.value);
    next();
    session.reset();
  }

  AnswerResult submit() {
    int answer = inputtedAnswer();

    logInfo("Submitted answer: $answer. Expected answer: $expectedAnswer");

    bool correct = false;

    if (answer == expectedAnswer) {
      session.correct.value++;
      correct = true;
    }

    if (session.current.value == 5) {
      if (difficulty < 5) {
        if (session.correct > 4 && session.elapsed < const Duration(seconds: 40)) {
          difficulty.value++;
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

  void genMax(int max) {
    first.value = _rng.nextInt(max);
    second.value = _rng.nextInt(max);
  }

  void reset(int initialDifficulty) {
    difficulty.value = initialDifficulty;
    session.reset();
    clearInput();
    next();
  }
}
