import '../entities/tents_entity.dart';

abstract class TentsRepository {
  Future<TentsEntity?> getTentsData();
}

