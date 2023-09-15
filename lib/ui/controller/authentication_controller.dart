import 'package:f_web_authentication/domain/models/credentials.dart';
import 'package:f_web_authentication/domain/use_case/authentication_usecase.dart';
import 'package:f_web_authentication/ui/controller/calculator_controller.dart';
import 'package:get/get.dart';

import 'package:loggy/loggy.dart';

class AuthenticationController extends GetxController {
  final Rxn<Credentials> _credentials = Rxn();

  bool get isLogged => _credentials.value != null;
  Credentials? get credentials => _credentials.value;

  void doLogin(String email, String password) {
    _credentials.value = Credentials(email, password);
    CalculatorController calculator = Get.find();
    calculator.reset(0);
  }

  Future<void> login(email, password) async {
    final AuthenticationUseCase authentication = Get.find();
    await authentication.login(email, password);
    doLogin(email, password);
  }

  Future<bool> signUp(email, password) async {
    final AuthenticationUseCase authentication = Get.find();
    logInfo('Controller Sign Up');
    await authentication.signUp(email, password);
    doLogin(email, password);

    return true;
  }

  Future<void> logOut() async => _credentials.value = null;
}
