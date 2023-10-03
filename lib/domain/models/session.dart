import 'dart:async';

import 'package:f_web_authentication/domain/models/operator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

final timeFormat = DateFormat.ms();

String durationToString(Duration duration) {
  final time = DateTime.fromMillisecondsSinceEpoch(duration.inMilliseconds);

  return timeFormat.format(time);
}

class Session {
  final correct = 0.obs;
  final current = 0.obs;
  final start = DateTime.now().obs;
  final _elapsed = Duration.zero.obs;
  final List<Question> questions = [];

  Duration get totalTime => DateTime.now().difference(start.value);
  String get elapsedString => durationToString(_elapsed.value);

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
        (json["questions"] as List<dynamic>)
            .map((json) => Question.fromJson(json))
            .toList(),
      );

  @override
  String toString() => "Session(time: ${durationToString(totalTime)}, correct: $correct)";
}

class Question {
  late String question;
  final int expected;
  final int answer;

  Question(this.question, this.expected, this.answer);

  factory Question.from(
          int first, int second, Operator op, int expected, int answer) =>
      Question(
        "$first $op $second",
        expected,
        answer,
      );

  Map<String, dynamic> toJson() =>
      {"question": question, "expected": expected, "answer": answer};

  factory Question.fromJson(Map<String, dynamic> json) => Question(
        json["question"],
        json["expected"],
        json["answer"],
      );
}
