import 'package:f_web_authentication/domain/models/credentials.dart';
import 'package:f_web_authentication/domain/models/user.dart';
import 'package:f_web_authentication/domain/repositories/repository.dart';
import 'package:get/get.dart';

class AuthenticationUseCase {
  final Repository _repository = Get.find();

  Future<User> login(Credentials credentials) async =>
      await _repository.login(credentials);

  Future<User> signUp(User user, String password) async =>
      await _repository.signUp(user, password);

  Future<bool> logOut() async => await _repository.logOut();

  Future<bool> levelUp(int difficulty) async => await _repository.levelUp(difficulty);
}
