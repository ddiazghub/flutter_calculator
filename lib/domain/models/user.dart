import 'package:f_web_authentication/domain/models/session.dart';

class User {
  final String email;
  final String firstName;
  final String lastName;
  final String birthday;
  final String school;
  final String grade;
  int difficulty;
  final List<SessionRecord> history;

  User(
    this.email,
    this.firstName,
    this.lastName,
    this.birthday,
    this.school,
    this.grade,
    this.difficulty,
    this.history,
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
      );

  static List<SessionRecord> parseHistory(List<dynamic> history) {
    return history.map((record) => SessionRecord.fromJson(record)).toList();
  }

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
      };

  Map<String, dynamic> toJsonWithPassword(String password) {
    final json = toJson();
    json["password"] = password;

    return json;
  }

  Map<String, dynamic> sessionDataJson() {
    return {"difficulty": difficulty, "history": serializeHistory()};
  }
}

class UserWithToken {
  final String token;
  final User user;

  UserWithToken(this.token, this.user);

  factory UserWithToken.fromJson(Map<String, dynamic> json) {
    return UserWithToken(json["access_token"], User.fromJson(json["user"]));
  }
}
