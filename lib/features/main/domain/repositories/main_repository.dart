import '../entities/main_entity.dart';

abstract class MainRepository {
  Future<MainEntity?> getMainData();
}

