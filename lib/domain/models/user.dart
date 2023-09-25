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
        json["firstName"] ?? "somefirstName",
        json["lastName"] ?? "someLastName",
        json["birthday"] ?? "2000-1-1",
        json["school"] ?? "someschool",
        json["grade"] ?? "first grade",
        json["difficulty"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "firstName": firstName,
        "lastName": lastName,
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
}
