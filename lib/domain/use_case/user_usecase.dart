import 'package:get/get.dart';
import 'package:loggy/loggy.dart';

import '../models/user.dart';
import '../repositories/repository.dart';

class UserUseCase {
  final Repository _repository = Get.find();

  UserUseCase();

  Future<List<User>> getUsers() async {
    logInfo("Getting users  from UseCase");
    return await _repository.getUsers();
  }

  Future<void> addUser() async {}
}
