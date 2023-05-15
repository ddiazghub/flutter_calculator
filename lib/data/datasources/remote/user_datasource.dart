import 'dart:convert';

import 'package:loggy/loggy.dart';

import '../../../domain/models/user.dart';
import 'package:http/http.dart' as http;

class UserDataSource {
  Future<List<User>> getUsers() async {
    List<User> users = [];
    var request = Uri.parse("https://retoolapi.dev/RltqBw/data")
        .resolveUri(Uri(queryParameters: {
      "format": 'json',
    }));

    var response = await http.get(request);

    if (response.statusCode == 200) {
      logInfo(response.body);
      final data = jsonDecode(response.body);
      users = List<User>.from(data.map((x) => User.fromJson(x)));
    } else {
      logError("Got error code ${response.statusCode}");
    }

    return Future.value(users);
  }

  addUser(User user) {
    logInfo("Web service, Adding user");
  }
}
