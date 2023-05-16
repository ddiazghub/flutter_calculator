import 'dart:convert';
import 'package:loggy/loggy.dart';
import 'package:http/http.dart' as http;

class AuthenticationDatatasource {
  final String _baseUrl =
      "http://ip172-18-0-22-chhs4oae69v0008fnuag-8000.direct.labs.play-with-docker.com/";

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
      Uri.parse("https://retoolapi.dev/RltqBw/data"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        "username": "augusto",
        "first_name": "fistName",
        "last_name": "lastName",
        "password": "email",
      }),
    );

    if (response.statusCode == 201) {
      //logInfo(response.body);
      return Future.value(true);
    } else {
      logError("Got error code ${response.statusCode}");
      return Future.value(false);
    }
    return Future.value(true);
  }

  Future<bool> logOut() async {
    return Future.value(true);
  }
}
