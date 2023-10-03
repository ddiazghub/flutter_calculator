import 'package:f_web_authentication/domain/models/session.dart';
import 'package:flutter/material.dart';

class HistoryPage extends StatefulWidget {
  final List<SessionRecord> items;

  const HistoryPage({Key? key, required this.items}) : super(key: key);

  @override
  _DisplayListPageState createState() => _DisplayListPageState();
}

class _DisplayListPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Display Session Records'),
      ),
      body: ListView.builder(
        itemCount: widget.items.length,
        itemBuilder: (context, index) {
          final sessionRecord = widget.items[index];

          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Total Time: ${sessionRecord.totalTime}'),
                  Text('Correct: ${sessionRecord.correct}'),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: sessionRecord.questions.length,
                    itemBuilder: (context, index) {
                      final question = sessionRecord.questions[index];

                      return Text(
                        'Question: ${question.question} - Expected: ${question.expected} - Answer: ${question.answer}',
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
