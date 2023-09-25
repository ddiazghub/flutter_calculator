import 'package:f_web_authentication/domain/models/credentials.dart';
import 'package:f_web_authentication/domain/models/user.dart';
import 'package:f_web_authentication/domain/use_case/authentication_usecase.dart';
import 'package:f_web_authentication/ui/controller/calculator_controller.dart';
import 'package:get/get.dart';

import 'package:loggy/loggy.dart';

class AuthenticationController extends GetxController {
  final Rxn<User> _user = Rxn();

  bool get isLogged => _user.value != null;
  User? get user => _user.value;

  void doLogin(User user) {
    _user.value = user;
    CalculatorController calculator = Get.find();
    calculator.reset(user.difficulty);
  }

  Future<void> login(Credentials credentials) async {
    final AuthenticationUseCase authentication = Get.find();
    final user = await authentication.login(credentials);
    doLogin(user);
  }

  Future<bool> signUp(User user, String password) async {
    final AuthenticationUseCase authentication = Get.find();
    logInfo('Controller Sign Up');
    final newUser = await authentication.signUp(user, password);
    doLogin(newUser);

    return true;
  }

  Future<void> logOut() async => _user.value = null;
}
