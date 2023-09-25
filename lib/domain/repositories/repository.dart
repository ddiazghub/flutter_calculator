import 'package:f_web_authentication/data/datasources/remote/authentication_datasource.dart';
import 'package:f_web_authentication/domain/models/credentials.dart';

import '../models/user.dart';

class Repository {
  late AuthenticationDatatasource _authenticationDataSource;
  String token = "";

  // the base url of the API should end without the /
  final String _baseUrl = "http://192.168.1.3:8000";

  Repository() {
    _authenticationDataSource = AuthenticationDatatasource();
  }

  Future<User> login(Credentials credentials) async {
    final data = await _authenticationDataSource.login(_baseUrl, credentials);
    token = data.token;

    return data.user;
  }

  Future<User> signUp(User user, String password) async {
    final data = await _authenticationDataSource.signUp(_baseUrl, user, password);
    token = data.token;

    return data.user;
  }

  Future<bool> logOut() async => await _authenticationDataSource.logOut();

  Future<bool> levelUp(int difficulty) async => await _authenticationDataSource.levelUp(_baseUrl, token, difficulty);
}
