import '../../../family/domain/repositories/family_repository.dart';
import '../../../family/domain/entities/family_entity.dart';
import '../datasources/family_local_data_source.dart';

class FamilyRepositoryImpl implements FamilyRepository {
  final FamilyLocalDataSource local;

  FamilyRepositoryImpl(this.local);

  @override
  Future<FamilyEntity?> getFamily(String id) async {
    return local.getFamily(id);
  }
}

