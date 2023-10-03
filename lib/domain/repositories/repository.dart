import 'package:f_web_authentication/data/datasources/remote/user_datasource.dart';
import 'package:f_web_authentication/domain/models/credentials.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';

class UserRepository {
  late UserDataSource _dataSource;
  UserWithTokens? session;

  // the base url of the API should end without the /
  late String _baseUrl;

  String get accessToken => session?.accessToken ?? "";
  String get refreshToken => session?.refreshToken ?? "";

  set user(User value) => session?.user = value;

  UserRepository(String baseUrl) {
    _dataSource = UserDataSource();
    _baseUrl = baseUrl;
  }

  String get baseUrl => _baseUrl;

  Future<User> login(Credentials credentials) async {
    session = await _dataSource.login(_baseUrl, credentials);
    session!.save();

    return session!.user;
  }

  Future<User> signUp(User user, String password) async {
    session = await _dataSource.signUp(_baseUrl, user, password);
    session!.save();

    return session!.user;
  }

  Future<bool> logOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    
    return await _dataSource.logOut();
  }

  Future<bool> update(User user) async {
    session?.user = user;

    return await _dataSource.update(_baseUrl, accessToken, user);
  }

  Future<User> refresh() async {
    session = await _dataSource.refresh(_baseUrl, refreshToken);

    return session!.user;
  }
}
