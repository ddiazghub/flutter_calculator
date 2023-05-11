import 'package:f_web_authentication/domain/use_case/authentication.dart';
import 'package:get/get.dart';

import 'package:loggy/loggy.dart';

class AuthenticationController extends GetxController {
  final logged = false.obs;
  final Authentication _authentication = Get.find();

  bool get isLogged => logged.value;

  Future<bool> login(email, password) async {
    var result = await _authentication.login(email, password);
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
    var result = await _authentication.signUp(email, password);
    return result;
  }

  Future<void> logOut() async {
    logged.value = false;
  }
}
