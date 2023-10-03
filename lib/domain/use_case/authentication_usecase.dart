import 'package:f_web_authentication/domain/models/credentials.dart';
import 'package:f_web_authentication/domain/models/user.dart';
import 'package:f_web_authentication/domain/repositories/repository.dart';
import 'package:get/get.dart';

class UserUseCase {
  final UserRepository _repository = Get.find();

  Future<User> login(Credentials credentials) async =>
      await _repository.login(credentials);

  Future<User> signUp(User user, String password) async =>
      await _repository.signUp(user, password);

  Future<bool> logOut() async => await _repository.logOut();

  Future<bool> update(User user) async => await _repository.update(user);
}
