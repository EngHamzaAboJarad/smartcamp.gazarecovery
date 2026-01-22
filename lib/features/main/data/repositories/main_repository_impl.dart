import '../../../main/domain/repositories/main_repository.dart';
import '../../../main/domain/entities/main_entity.dart';
import '../datasources/main_local_data_source.dart';

class MainRepositoryImpl implements MainRepository {
  final MainLocalDataSource local;
  MainRepositoryImpl(this.local);

  @override
  Future<MainEntity?> getMainData() async => local.getData();
}

