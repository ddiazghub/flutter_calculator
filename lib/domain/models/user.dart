import 'package:f_web_authentication/domain/models/credentials.dart';
import 'package:f_web_authentication/domain/models/session.dart';
import 'package:f_web_authentication/domain/repositories/local_repository.dart';
import 'package:get/get.dart';

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

  UserWithTokens(this.accessToken, this.refreshToken, this.user,
      {this.tokenType = "bearer"});

  factory UserWithTokens.fromJson(Map<String, dynamic> json) {
    return UserWithTokens(
      json["access_token"],
      json["refresh_token"],
      User.fromJson(json["user"]),
    );
  }

  Future<void> save() async => Get.find<LocalRepository>().save(this);

  static Future<UserWithTokens?> load() async =>
      Get.find<LocalRepository>().load();

  static Future<void> clear() async => Get.find<LocalRepository>().clear();
}

class UserWithPassword {
  final User user;
  final String password;

  String get email => user.email;
  String get firstName => user.firstName;
  String get lastName => user.lastName;
  String get birthday => user.birthday;
  String get school => user.school;
  String get grade => user.grade;
  int get difficulty => user.difficulty;
  List<SessionRecord> get history => user.history;
  DateTime get updatedAt => user.updatedAt;

  set user(User value) => user = value;

  UserWithPassword(this.user, this.password);

  bool validate(Credentials credentials) =>
      user.email == credentials.email && password == credentials.password;
}
