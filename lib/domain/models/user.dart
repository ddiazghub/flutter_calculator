class User {
  User({
    this.id,
    required this.fistName,
    required this.lastName,
    required this.email,
  });

  int? id;
  String fistName;
  String lastName;
  String email;

  String get name => '$fistName $lastName';

  String get emailAddress => email;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        fistName: json["firstname"],
        lastName: json["lastName"],
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "id": id ?? 0,
        "firstname": fistName,
        "lastName": lastName,
        "email": email,
      };
}
