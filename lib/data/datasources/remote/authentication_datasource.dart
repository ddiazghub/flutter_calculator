import 'dart:convert';
import 'package:loggy/loggy.dart';
import 'package:http/http.dart' as http;

class AuthenticationDatatasource {
  final String _baseUrl =
      "http://ip172-19-0-71-chhvne01k7jg00ba0t4g-8000.direct.labs.play-with-docker.com";

  Future<bool> login(String email, String password) async {
    var request =
        Uri.parse("https://randomuser.me/api").resolveUri(Uri(queryParameters: {
      "format": 'json',
      "results": "1",
    }));

    return Future.value(true);
  }

  Future<bool> signUp(String email, String password) async {
    final response = await http.post(
      Uri.parse("$_baseUrl/register"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "username": email,
        "first_name": email,
        "last_name": email,
        "password": "password",
      }),
    );

    logInfo("$_baseUrl/register/");
    logInfo(response.statusCode);
    if (response.statusCode == 200) {
      //logInfo(response.body);
      return Future.value(true);
    } else {
      logError("Got error code ${response.statusCode}");
      return Future.error('Error code ${response.statusCode}');
    }
  }

  Future<bool> logOut() async {
    return Future.value(true);
  }
}
