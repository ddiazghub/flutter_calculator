import 'package:get/get.dart';

import '../../domain/models/user.dart';

class UserController extends GetxController {
  final List<User> users = <User>[].obs;

  List<User> get getUsers => users;

  @override
  void onInit() {
    super.onInit();
  }
}
