import 'package:f_web_authentication/data/datasources/remote/user_datasource.dart';
import 'package:f_web_authentication/domain/models/credentials.dart';
import 'package:f_web_authentication/domain/models/operator.dart';
import 'package:f_web_authentication/domain/models/session.dart';
import 'package:f_web_authentication/domain/models/user.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeUserDataSource extends Fake implements IUserDataSource {
  final List<UserWithPassword> users = [
    UserWithPassword(
      User(
        'test@example.com',
        'John',
        'Doe',
        '2000-01-01',
        'Test School',
        '12',
        0,
        [],
        DateTime.now(),
      ),
      "123456",
    ),
    UserWithPassword(
      User(
        'test2@example.com',
        'Joanne',
        'Doe',
        '2000-01-01',
        'Test School 2',
        '12',
        1,
        [
          SessionRecord(const Duration(seconds: 25), 5, [
            Question(1, 1, Operator.Add, 2),
            Question(4, 1, Operator.Add, 5),
            Question(9, 5, Operator.Add, 14),
            Question(9, 7, Operator.Add, 17),
            Question(2, 7, Operator.Add, 9),
            Question(0, 0, Operator.Add, 0),
          ])
        ],
        DateTime.now(),
      ),
      "123456",
    ),
  ];

  @override
  Future<UserWithTokens> login(Credentials credentials) async {
    int index = users.indexWhere((user) => user.validate(credentials));

    if (index == -1) {
      throw Exception("401 Unauthorized");
    }

    String idx = index.toString();

    return UserWithTokens(idx, idx, users[index].user);
  }

  @override
  Future<UserWithTokens> signUp(User user, String password) async {
    if (users.indexWhere((u) => u.email == user.email) > -1) {
      throw Exception("Email already exists");
    }

    String index = users.length.toString();
    users.add(UserWithPassword(user, password));
    user.updatedAt = DateTime.now();

    return UserWithTokens(index, index, user);
  }

  @override
  Future<bool> logOut() async => true;

  @override
  Future<bool> update(String token, User user) async {
    int index = int.parse(token);
    users[index].user = user;

    return true;
  }

  @override
  Future<UserWithTokens> refresh(String token) async {
    int index = int.parse(token);

    return UserWithTokens(token, token, users[index].user);
  }
}
