import 'package:f_web_authentication/data/datasources/remote/authentication_datasource.dart';

import '../../data/datasources/remote/user_datasource.dart';
import '../models/user.dart';

class Repository {
  late AuthenticationDatatasource _authenticationDataSource;
  late UserDataSource _userDatatasource;

  Repository() {
    _authenticationDataSource = AuthenticationDatatasource();
    _userDatatasource = UserDataSource();
  }

  Future<bool> login(String email, String password) async =>
      await _authenticationDataSource.login(email, password);

  Future<bool> signUp(String email, String password) async =>
      await _authenticationDataSource.signUp(email, password);

  Future<bool> logOut() async => await _authenticationDataSource.logOut();

  Future<List<User>> getUsers() async => await _userDatatasource.getUsers();

  Future<bool> addUser(User user) async =>
      await _userDatatasource.addUser(user);

  Future<bool> updateUser(User user) async =>
      await _userDatatasource.updateUser(user);

  Future<bool> deleteUser(int id) async =>
      await _userDatatasource.deleteUser(id);
}
