import 'dart:convert';

import 'package:f_web_authentication/domain/models/session.dart';
import 'package:shared_preferences/shared_preferences.dart';

class User {
  final String email;
  final String firstName;
  final String lastName;
  final String birthday;
  final String school;
  final String grade;
  int difficulty;
  final List<SessionRecord> history;
  DateTime updatedAt;

  User(
    this.email,
    this.firstName,
    this.lastName,
    this.birthday,
    this.school,
    this.grade,
    this.difficulty,
    this.history,
    this.updatedAt,
  );

  String get name => '$firstName $lastName';

  factory User.fromJson(Map<String, dynamic> json) => User(
        json["email"] ?? "someemail",
        json["first_name"] ?? "somefirstName",
        json["last_name"] ?? "someLastName",
        json["birthday"] ?? "2000-1-1",
        json["school"] ?? "someschool",
        json["grade"] ?? "first grade",
        json["difficulty"] ?? 0,
        parseHistory(json["history"] ?? []),
        json["updated_at"] != null
            ? DateTime.parse(json["updated_at"])
            : DateTime.now(),
      );

  List<Map<String, dynamic>> serializeHistory() {
    return history.map((record) => record.toJson()).toList();
  }

  Map<String, dynamic> toJson() => {
        "email": email,
        "first_name": firstName,
        "last_name": lastName,
        "birthday": birthday,
        "school": school,
        "grade": grade,
        "difficulty": difficulty,
        "history": serializeHistory(),
        "updated_at": updatedAt.toIso8601String(),
      };

  Map<String, dynamic> toJsonWithPassword(String password) {
    final json = toJson();
    json["password"] = password;

    return json;
  }

  Map<String, dynamic> sessionDataJson() {
    return {"difficulty": difficulty, "history": serializeHistory()};
  }

  static List<SessionRecord> parseHistory(List<dynamic> history) {
    return history.map((record) => SessionRecord.fromJson(record)).toList();
  }
}

class UserWithTokens {
  final String accessToken;
  final String refreshToken;
  late String tokenType = "bearer";
  User user;

  UserWithTokens(this.accessToken, this.refreshToken, this.user, {this.tokenType = "bearer"});

  factory UserWithTokens.fromJson(Map<String, dynamic> json) {
    return UserWithTokens(
      json["access_token"],
      json["refresh_token"],
      User.fromJson(json["user"]),
    );
  }

  void save() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("user", jsonEncode(user.toJson()));
    prefs.setString("access_token", accessToken);
    prefs.setString("refresh_token", refreshToken);
  }

  static Future<UserWithTokens?> load() async {
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
}
