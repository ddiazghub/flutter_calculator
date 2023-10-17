import 'package:f_web_authentication/data/datasources/remote/user_datasource.dart';
import 'package:f_web_authentication/domain/models/credentials.dart';

import '../models/user.dart';

class UserRepository {
  late IUserDataSource _dataSource;

  UserRepository(this._dataSource);

  factory UserRepository.remote(String baseUrl) => UserRepository(UserDataSource(baseUrl));

  Future<UserWithTokens> login(Credentials credentials) async => await _dataSource.login(credentials);
  Future<UserWithTokens> signUp(User user, String password) async => await _dataSource.signUp(user, password);
  Future<bool> logOut() async => await _dataSource.logOut();
  Future<bool> update(String accessToken, User user) async => await _dataSource.update(accessToken, user);
  Future<UserWithTokens> refresh(String refreshToken) async => await _dataSource.refresh(refreshToken);
}
