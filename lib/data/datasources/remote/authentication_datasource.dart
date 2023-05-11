class AuthenticationDatatasource {
  Future<bool> login(String email, String password) async {
    var request =
        Uri.parse("https://randomuser.me/api").resolveUri(Uri(queryParameters: {
      "format": 'json',
      "results": "1",
    }));

    return Future.value(true);
  }

  Future<bool> signUp(String email, String password) async {
    return Future.value(true);
  }

  Future<bool> logOut() async {
    return Future.value(true);
  }
}
