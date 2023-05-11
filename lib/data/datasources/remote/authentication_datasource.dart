import 'package:http/http.dart' as http;
import 'package:loggy/loggy.dart';
import 'dart:convert';

class AuthenticationDatatasource {
  Future<bool> login(String email, String password) async {
    var request =
        Uri.parse("https://randomuser.me/api").resolveUri(Uri(queryParameters: {
      "format": 'json',
      "results": "1",
    }));

    return Future.error("error");
  }

  Future<bool> signUp(String email, String password) async {
    return Future.error("error");
  }

  Future<bool> logOut() async {
    return Future.error("error");
  }
}
