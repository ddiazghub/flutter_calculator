import 'package:f_web_authentication/data/datasources/remote/authentication_datasource.dart';

class Repository {
  late AuthenticationDatatasource _authentication;

  Repository() {
    _authentication = AuthenticationDatatasource();
  }

  Future<bool> login(String email, String password) async =>
      await _authentication.login(email, password);

  Future<bool> signUp(String email, String password) async =>
      await _authentication.signUp(email, password);

  Future<bool> logOut() async => await _authentication.logOut();
}
