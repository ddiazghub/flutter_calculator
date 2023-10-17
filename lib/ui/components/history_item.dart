import 'package:f_web_authentication/domain/models/session.dart';
import 'package:flutter/material.dart';

class HistoryItem extends StatelessWidget {
  final String title;
  final SessionRecord record;
  final bool correctFail;
  final bool timeFail;

  static const GREEN = Color.fromRGBO(144, 238, 144, 1);
  static const RED = Color.fromRGBO(255, 114, 118, 1);
  static const FAIL_TEXT = TextStyle(color: RED);
  static const CORRECT_TEXT = TextStyle(color: GREEN);

  const HistoryItem(
      {Key? key,
      required this.title,
      required this.record,
      this.correctFail = false,
      this.timeFail = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              title,
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    style: timeFail ? FAIL_TEXT : const TextStyle(),
                    'Total Time: ${record.totalTimeString}',
                  ),
                  Text(
                    style: correctFail ? FAIL_TEXT : const TextStyle(),
                    'Correct: ${record.correct}',
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: record.questions.map((question) {
                return Card(
                  color: question.correct ? GREEN : RED,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text("Question: ${question.question}"),
                            Text("Expected: ${question.expected}"),
                          ],
                        ),
                        Text("Answer: ${question.answer}"),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
