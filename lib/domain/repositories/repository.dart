import 'package:f_web_authentication/data/datasources/remote/user_datasource.dart';
import 'package:f_web_authentication/domain/models/credentials.dart';

import '../models/user.dart';

class UserRepository {
  late UserDataSource _dataSource;

  // the base url of the API should end without the /
  late String _baseUrl;

  UserRepository(String baseUrl) {
    _dataSource = UserDataSource();
    _baseUrl = baseUrl;
  }

  String get baseUrl => _baseUrl;

  Future<UserWithTokens> login(Credentials credentials) async => await _dataSource.login(_baseUrl, credentials);

  Future<UserWithTokens> signUp(User user, String password) async => await _dataSource.signUp(baseUrl, user, password);

  Future<bool> logOut() async => await _dataSource.logOut();

  Future<bool> update(String accessToken, User user) async => await _dataSource.update(_baseUrl, accessToken, user);

  Future<UserWithTokens> refresh(String refreshToken) async => await _dataSource.refresh(_baseUrl, refreshToken);
}
