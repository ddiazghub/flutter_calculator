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
}
