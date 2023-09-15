import 'dart:async';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

class Session {
  static final timeFormat = DateFormat.ms();
  final correct = 0.obs;
  final current = 0.obs;
  final start = DateTime.now().obs;
  final _elapsed = Duration.zero.obs;

  Duration get elapsed => DateTime.now().difference(start.value);

  String get elapsedString {
    final time = DateTime.fromMillisecondsSinceEpoch(_elapsed.value.inMilliseconds);
    
    return timeFormat.format(time);
  }

  Session() {
    Timer.periodic(
      const Duration(seconds: 1),
      (timer) => _elapsed.value = elapsed,
    );
  }

  void reset() {
    correct.value = 0;
    current.value = 0;
    start.value = DateTime.now();
  }
}
