import 'package:f_web_authentication/data/datasources/remote/user_datasource.dart';
import 'package:f_web_authentication/domain/models/credentials.dart';

import '../models/user.dart';

class UserRepository {
  late UserDataSource _dataSource;
  String token = "";

  // the base url of the API should end without the /
  late String _baseUrl;

  UserRepository(String baseUrl) {
    _dataSource = UserDataSource();
    _baseUrl = baseUrl;
  }

  String get baseUrl => _baseUrl;

  Future<User> login(Credentials credentials) async {
    final data = await _dataSource.login(_baseUrl, credentials);
    token = data.token;

    return data.user;
  }

  Future<User> signUp(User user, String password) async {
    final data = await _dataSource.signUp(_baseUrl, user, password);
    token = data.token;

    return data.user;
  }

  Future<bool> logOut() async => await _dataSource.logOut();

  Future<bool> update(User user) async => await _dataSource.update(_baseUrl, token, user);
}
