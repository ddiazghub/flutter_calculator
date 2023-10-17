import 'package:f_web_authentication/domain/models/credentials.dart';
import 'package:f_web_authentication/domain/models/session.dart';
import 'package:f_web_authentication/domain/models/user.dart';
import 'package:f_web_authentication/domain/repositories/local_repository.dart';
import 'package:f_web_authentication/domain/repositories/repository.dart';
import 'package:f_web_authentication/ui/controller/calculator_controller.dart';
import 'package:get/get.dart';
import 'package:loggy/loggy.dart';

class UserUseCase {
  UserWithTokens? session;
  final UserRepository _repository = Get.find();
  final LocalRepository _localRepository = Get.find();

  String get accessToken => session?.accessToken ?? "";
  String get refreshToken => session?.refreshToken ?? "";
  User? get user => session?.user;
  bool get isLoggedIn => session != null;

  set user(User? value) => session?.user = value!;

  Future<User> login(Credentials credentials) async {
    session = await _repository.login(credentials);
    session!.save();
    logInfo(user?.difficulty);
    Get.find<CalculatorController>().reset(user!.difficulty);

    return session!.user;
  }

  Future<User> signUp(User user, String password) async {
    session = await _repository.signUp(user, password);
    session!.save();
    Get.find<CalculatorController>().reset(0);

    return session!.user;
  }

  Future<bool> logOut() async {
    await _localRepository.clear();
    
    return await _repository.logOut();
  }

  Future<bool> update(int difficulty, SessionRecord lastSession) async {
    user?.difficulty = difficulty;
    user?.history.add(lastSession);
    user?.updatedAt = DateTime.now();
    logInfo(lastSession);
    logInfo("q1 = ${user!.history.last.questions}");
    session?.save();
    final response = await _repository.update(accessToken, user!);
    logInfo("q2 = ${user!.history.last.questions}");

    return response;
  }

  Future<User> refresh(String refreshToken) async {
    session = await _repository.refresh(refreshToken);

    return session!.user;
  }

  Future<bool> tryLoad() async {
    final localSession = await _localRepository.load();

    if (localSession == null) {
      return false;
    }
    
    try {
      final remoteUser = await refresh(localSession.refreshToken);
      logInfo("Local updated at: ${localSession.user.updatedAt}");
      logInfo("Remote updated at: ${remoteUser.updatedAt}");

      if (remoteUser.updatedAt.isBefore(localSession.user.updatedAt)) {
        await _repository.update(session!.accessToken, localSession.user);
        user = localSession.user;
        await session!.save();
      } else {
        user = remoteUser;
        await session!.save();
      }
    } catch (e) {
      logError(e);
      session = localSession;
    }

    Get.find<CalculatorController>().reset(user!.difficulty);

    return true;
  }
}
