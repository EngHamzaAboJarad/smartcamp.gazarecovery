import '../../../tents/domain/repositories/tents_repository.dart';
import '../../../tents/domain/entities/tents_entity.dart';
import '../datasources/tents_local_data_source.dart';

class TentsRepositoryImpl implements TentsRepository {
  final TentsLocalDataSource local;
  TentsRepositoryImpl(this.local);

  @override
  Future<TentsEntity?> getTentsData() async => local.getData();
}

