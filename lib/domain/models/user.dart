class User {
  User({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
  });

  int? id;
  String firstName;
  String lastName;
  String email;

  String get name => '$firstName $lastName';

  String get emailAddress => email;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        firstName: json["firstName"] ?? "somefirstname",
        lastName: json["lastName"] ?? "someLastName",
        email: json["email"] ?? "someemail",
      );

  Map<String, dynamic> toJson() => {
        "id": id ?? 0,
        "firstname": firstName,
        "lastName": lastName,
        "email": email,
      };
}
