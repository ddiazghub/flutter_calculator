import 'dart:convert';

import 'package:f_web_authentication/domain/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class ILocalDataSource {
  Future<void> save(UserWithTokens session);
  Future<UserWithTokens?> load();
  Future<void> clear();
}

class LocalDataSource implements ILocalDataSource {
  @override
  Future<void> save(UserWithTokens session) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("user", jsonEncode(session.user.toJson()));
    prefs.setString("access_token", session.accessToken);
    prefs.setString("refresh_token", session.refreshToken);
  }

  @override
  Future<UserWithTokens?> load() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString("user");
    final accessToken = prefs.getString("access_token");
    final refreshToken = prefs.getString("refresh_token");

    if (userJson == null || refreshToken == null) {
      return null;
    }

    final user = User.fromJson(jsonDecode(userJson));

    return UserWithTokens(accessToken!, refreshToken, user);
  }

  @override
  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
