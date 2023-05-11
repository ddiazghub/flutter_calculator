import 'package:f_web_authentication/domain/use_case/authentication_usecase.dart';
import 'package:get/get.dart';

import 'package:loggy/loggy.dart';

class AuthenticationController extends GetxController {
  final logged = false.obs;

  bool get isLogged => logged.value;

  Future<bool> login(email, password) async {
    final AuthenticationUseCase authentication = Get.find();
    bool result = await authentication.login(email, password);
    if (result) {
      logged.value = true;
      logInfo('Login OK');
    } else {
      logged.value = false;
      logError('Login NOK');
    }
    return result;
  }

  Future<bool> signUp(email, password) async {
    final AuthenticationUseCase authentication = Get.find();
    var result = await authentication.signUp(email, password);
    return result;
  }

  Future<void> logOut() async {
    logged.value = false;
  }
}
