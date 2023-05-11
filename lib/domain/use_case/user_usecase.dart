import 'package:get/get.dart';

import '../models/user.dart';
import '../repositories/repository.dart';

class UserUseCase {
  final Repository _repository = Get.find();

  UserUseCase();

  Future<List<User>> getUsers() async {
    return await _repository.getUsers();
  }
}
