import 'package:f_web_authentication/data/datasources/local/local_datasource.dart';
import 'package:f_web_authentication/domain/models/user.dart';

class LocalRepository {
  late final ILocalDataSource _dataSource;

  LocalRepository({ ILocalDataSource? dataSource }) {
    _dataSource = dataSource ?? LocalDataSource();
  }

  Future<void> save(UserWithTokens session) async => _dataSource.save(session);
  Future<UserWithTokens?> load() async => _dataSource.load();
  Future<void> clear() async => _dataSource.clear();
}
