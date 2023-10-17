import 'dart:convert';

import 'package:f_web_authentication/domain/models/user.dart';
import 'package:loggy/loggy.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalDataSource {
  Future<void> save(UserWithTokens session) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("user", jsonEncode(session.user.toJson()));
    prefs.setString("access_token", session.accessToken);
    prefs.setString("refresh_token", session.refreshToken);
  }

  Future<UserWithTokens?> load() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString("user");
    final accessToken = prefs.getString("access_token");
    final refreshToken = prefs.getString("refresh_token");

    if (userJson == null || refreshToken == null) {
      return null;
    }

    logInfo("User: $userJson");
    logInfo("Access: $accessToken");
    logInfo("Refresh: $refreshToken");

    final user = User.fromJson(jsonDecode(userJson));

    return UserWithTokens(accessToken!, refreshToken, user);
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
