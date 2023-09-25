import 'package:f_web_authentication/data/datasources/remote/authentication_datasource.dart';
import 'package:f_web_authentication/domain/models/credentials.dart';

import '../models/user.dart';

class Repository {
  late AuthenticationDatatasource _authenticationDataSource;
  String token = "";

  // the base url of the API should end without the /
  final String _baseUrl = "http://ip172-18-0-8-ck8sp0efml8g00816ol0-8000.direct.labs.play-with-docker.com";

  Repository() {
    _authenticationDataSource = AuthenticationDatatasource();
  }

  Future<User> login(Credentials credentials) async {
    final data = await _authenticationDataSource.login(_baseUrl, credentials);
    token = data.token;

    return data.user;
  }

  Future<User> signUp(User user, String password) async => await _authenticationDataSource.signUp(_baseUrl, user, password);

  Future<bool> logOut() async => await _authenticationDataSource.logOut();
}
