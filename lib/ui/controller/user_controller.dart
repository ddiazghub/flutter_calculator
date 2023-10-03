import 'package:f_web_authentication/domain/models/credentials.dart';
import 'package:f_web_authentication/domain/models/session.dart';
import 'package:f_web_authentication/domain/models/user.dart';
import 'package:f_web_authentication/domain/repositories/repository.dart';
import 'package:f_web_authentication/domain/use_case/user_usecase.dart';
import 'package:f_web_authentication/ui/controller/calculator_controller.dart';
import 'package:get/get.dart';
import 'package:loggy/loggy.dart';

class UserController extends GetxController {
  final Rxn<User> _user = Rxn();

  bool get isLogged => _user.value != null;
  User? get user => _user.value;
  set user(User? value) => _user.value = value;

  void doLogin(User user) {
    _user.value = user;
    CalculatorController calculator = Get.find();
    calculator.reset(user.difficulty);
  }

  Future<void> login(Credentials credentials) async {
    final UserUseCase useCase = Get.find();
    final user = await useCase.login(credentials);
    doLogin(user);
  }

  Future<bool> signUp(User user, String password) async {
    final UserUseCase useCase = Get.find();
    logInfo('Controller Sign Up');
    final newUser = await useCase.signUp(user, password);
    doLogin(newUser);

    return true;
  }

  Future<void> logOut() async {
    _user.value = null;
    Get.find<UserUseCase>().logOut();
  }

  void updateData(int difficulty, SessionRecord lastSession) {
    if (user != null) {
      user!.difficulty = difficulty;
      user!.history.add(lastSession);
      Get.find<UserUseCase>().update(user!);
    }
  }

  Future<void> tryLoad() async {
    final session = await UserWithTokens.load();

    if (session == null) {
      return;
    }
    
    final UserRepository repo = Get.find();
    final UserUseCase useCase = Get.find();

    user = await useCase.refresh();

    if (user!.updatedAt.isBefore(session.user.updatedAt)) {
      repo.update(session.user);
      user = session.user;
    } else {
      repo.session!.save();
    }
  }
}
