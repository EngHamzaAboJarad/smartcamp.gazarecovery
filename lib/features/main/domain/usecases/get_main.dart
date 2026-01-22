import '../entities/main_entity.dart';
import '../repositories/main_repository.dart';

class GetMain {
  final MainRepository repository;
  GetMain(this.repository);

  Future<MainEntity?> call() async => repository.getMainData();
}

