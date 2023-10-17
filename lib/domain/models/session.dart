import 'dart:async';
import 'dart:math';

import 'package:f_web_authentication/domain/models/operator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

final timeFormat = DateFormat.ms();

String durationToString(Duration duration) {
  final time = DateTime.fromMillisecondsSinceEpoch(duration.inMilliseconds);

  return timeFormat.format(time);
}

class Session {
  final _difficulty = 0.obs;
  final correct = 0.obs;
  final current = 0.obs;
  final start = DateTime.now().obs;
  final _elapsed = Duration.zero.obs;
  final List<Question> questions = [];

  int get difficulty => _difficulty.value;
  Duration get totalTime => DateTime.now().difference(start.value);
  String get elapsedString => durationToString(_elapsed.value);
  Duration get targetTime => Duration(seconds: 30 + 15 * _difficulty.value);

  set difficulty(int value) => _difficulty.value = value;

  Session() {
    Timer.periodic(
      const Duration(seconds: 1),
      (timer) => _elapsed.value = totalTime,
    );
  }

  void reset() {
    correct.value = 0;
    current.value = 0;
    questions.clear();
    start.value = DateTime.now();
    _elapsed.value = Duration.zero;
  }

  SessionRecord intoRecord() {
    return SessionRecord(totalTime, correct.value, questions);
  }
}

class SessionRecord {
  final Duration totalTime;
  final int correct;
  final List<Question> questions;

  SessionRecord(this.totalTime, this.correct, this.questions);

  Map<String, dynamic> toJson() => {
        "total_time": totalTime.inSeconds,
        "correct": correct,
        "questions": questions.map((question) => question.toJson()).toList()
      };

  factory SessionRecord.fromJson(Map<String, dynamic> json) => SessionRecord(
        Duration(seconds: json["total_time"]),
        json["correct"],
        (json["questions"] as List<dynamic>).map((json) => Question.fromJson(json)).toList(),
      );

  @override
  String toString() => "Session(time: ${durationToString(totalTime)}, correct: $correct)";
}

class Question {
  static final _rng = Random();

  late int first;
  late int second;
  late Operator op;
  int answer;

  int get expected => op.apply(first, second);
  String get question => "$first $op $second";

  Question(this.first, this.second, this.op, this.answer);

  factory Question.from(String question, int answer) {
    final parts = question.split(" ");

    return Question(
      int.parse(parts[0]),
      int.parse(parts[2]),
      Operator.from(parts[1]),
      answer,
    );
  }

  factory Question.random(int difficulty) {
    var (max, operators) = choicesFor(difficulty);
    final op = operators[_rng.nextInt(operators.length)];
    max = op == Operator.Mul ? max ~/ 10 : max;
    final first = _rng.nextInt(max);
    var second = _rng.nextInt(max);
    second = op == Operator.Sub ? second % first : second;

    return Question(first, second, op, 0);
  }

  Map<String, dynamic> toJson() => {"question": question, "expected": expected, "answer": answer};

  factory Question.fromJson(Map<String, dynamic> json) => Question.from(
        json["question"],
        json["answer"],
      );

  static (int, List<Operator>) choicesFor(int difficulty) {
    final power = 1 + (difficulty + 1) ~/ 2;
    final max = pow(10, power).toInt();
    final operators = Operator.values.take(1 + difficulty ~/ 2);

    return (max, operators.toList());
  }
}
