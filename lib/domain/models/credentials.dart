class Credentials {
  final String email;
  final String password;

  Credentials(this.email, this.password);

  Map<String, dynamic> toJson() => {
    "email": email,
    "password": password,
  };
}
