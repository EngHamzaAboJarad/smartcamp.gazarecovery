import '../entities/family_entity.dart';

abstract class FamilyRepository {
  Future<FamilyEntity?> getFamily(String id);
}

