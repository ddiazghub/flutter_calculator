import 'package:f_web_authentication/data/datasources/local/local_datasource.dart';
import 'package:f_web_authentication/domain/models/user.dart';

class FakeLocalDataSource implements ILocalDataSource {
  UserWithTokens? session;

  @override
  Future<void> save(UserWithTokens session) async => this.session = session;

  @override
  Future<UserWithTokens?> load() async => session;

  @override
  Future<void> clear() async => session = null;
}
