class User {
  User({
    required this.fistName,
    required this.lastName,
    required this.email,
  });

  String fistName;
  String lastName;
  String email;

  String get name => '$fistName $lastName';

  String get emailAddress => email;

  factory User.fromJson(Map<String, dynamic> json) => User(
        fistName: json["firstname"],
        lastName: json["lastName"],
        email: json["email"],
      );
}
