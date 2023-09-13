import 'package:get/get.dart';

class Session {
  final correct = 0.obs;
  final current = 0.obs;
  final elapsedTime = 0.obs;

  void reset() {
    correct.value = 0;
    current.value = 0;
    elapsedTime.value = 0;
  }
}
