import '../entities/family_entity.dart';
import '../repositories/family_repository.dart';

class GetFamily {
  final FamilyRepository repository;
  GetFamily(this.repository);

  Future<FamilyEntity?> call(String id) async {
    return repository.getFamily(id);
  }
}

