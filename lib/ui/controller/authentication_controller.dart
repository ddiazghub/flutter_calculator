import 'package:f_web_authentication/domain/use_case/authentication_usecase.dart';
import 'package:get/get.dart';

import 'package:loggy/loggy.dart';

class AuthenticationController extends GetxController {
  final logged = false.obs;

  bool get isLogged => logged.value;

  Future<void> login(email, password) async {
    final AuthenticationUseCase authentication = Get.find();
    String token = await authentication.login(email, password);
    logInfo('Controller Login ok $token');
    logged.value = true;
  }

  Future<bool> signUp(email, password) async {
    final AuthenticationUseCase authentication = Get.find();
    logInfo('Controller Sign Up');
    await authentication.signUp(email, password);
    return true;
  }

  Future<void> logOut() async {
    logged.value = false;
  }
}
