class User {
  final String email;
  final String firstName;
  final String lastName;
  final String birthday;
  final String school;
  final String grade;
  int difficulty;

  User(
    this.email,
    this.firstName,
    this.lastName,
    this.birthday,
    this.school,
    this.grade,
    this.difficulty,
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
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "first_name": firstName,
        "last_name": lastName,
        "birthday": birthday,
        "school": school,
        "grade": grade,
        "difficulty": difficulty,
      };

  Map<String, dynamic> toJsonWithPassword(String password) {
    final json = toJson();
    json["password"] = password;

    return json;
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
