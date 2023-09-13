import 'dart:math';

import 'package:f_web_authentication/domain/models/session.dart';
import 'package:get/get.dart';

enum AnswerResult {
  Correct,
  Wrong,
  LevelUp,
  SessionReset
}

class CalculatorController extends GetxController {
  final _rng = Random();
  late Rx<int> difficulty;
  late Rx<int> first;
  late Rx<int> second;
  var session = Session();

  CalculatorController(int difficulty) {
    this.difficulty = difficulty.obs;
    next();
  }

  int answer() => first.value + second.value;
  next() => genMax(pow(10, difficulty.value + 1) as int);

  AnswerResult submit(int answer) {
    bool correct = false;
    
    if (answer == this.answer()) {
      session.correct.value++;
      correct == true;
    }

    if (session.current.value == 6) {
      if (session.correct > 4 && session.elapsedTime < 40000 && difficulty < 6) {
        difficulty.value++;
        next();
        session.reset();

        return AnswerResult.LevelUp;
      }

      next();
      session.reset();

      return AnswerResult.SessionReset;
    } else {
      next();
      session.current.value++;

      if (correct) {
        return AnswerResult.Correct;
      } else {
        return AnswerResult.Wrong;
      }
    }
  }

  void genMax(int max) {
    first = _rng.nextInt(max).obs;
    second = _rng.nextInt(max).obs;
  }

}
