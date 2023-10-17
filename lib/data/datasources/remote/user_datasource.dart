import 'dart:convert';
import 'package:f_web_authentication/domain/models/credentials.dart';
import 'package:f_web_authentication/domain/models/user.dart';
import 'package:loggy/loggy.dart';
import 'package:http/http.dart' as http;

class UserDataSource {
  Future<UserWithTokens> login(String baseUrl, Credentials credentials) async {
    final response = await http.post(
      Uri.parse("$baseUrl/login"),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(credentials.toJson()),
    );

    logInfo(response.statusCode);

    if (response.statusCode == 200) {
      logInfo(response.body);

      final json = jsonDecode(response.body);
      final data = UserWithTokens.fromJson(json);

      return Future.value(data);
    } else {
      logError(response.body);
      return Future.error('Error code ${response.statusCode}');
    }
  }

  Future<UserWithTokens> signUp(
      String baseUrl, User user, String password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/register"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(user.toJsonWithPassword(password)),
    );

    logInfo(response.statusCode);

    if (response.statusCode == 200) {
      logInfo(response.body);
      final user = UserWithTokens.fromJson(jsonDecode(response.body));

      return Future.value(user);
    } else {
      logError(response.body);
      return Future.error('Error code ${response.statusCode}');
    }
  }

  Future<bool> logOut() async {
    return Future.value(true);
  }

  Future<bool> update(String baseUrl, String token, User user) async {
    final response = await http.patch(Uri.parse("$baseUrl/update"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(user.sessionDataJson()));

    logInfo(response.statusCode);

    if (response.statusCode == 200) {
      logInfo(response.body);

      return Future.value(true);
    } else {
      logError(response.body);
      return Future.error('Error code ${response.statusCode}');
    }
  }

  Future<UserWithTokens> refresh(String baseUrl, String token) async {
    final response = await http.post(
      Uri.parse("$baseUrl/refresh"),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({"refresh_token": token}),
    ).timeout(const Duration(seconds: 2));

    logInfo(response.statusCode);

    if (response.statusCode == 200) {
      logInfo(response.body);

      final user = UserWithTokens.fromJson(jsonDecode(response.body));

      return Future.value(user);
    } else {
      logError(response.body);
      return Future.error('Error code ${response.statusCode}');
    }
  }
}
