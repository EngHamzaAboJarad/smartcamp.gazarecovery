import '../entities/tents_entity.dart';
import '../repositories/tents_repository.dart';

class GetTents {
  final TentsRepository repository;
  GetTents(this.repository);

  Future<TentsEntity?> call() async => repository.getTentsData();
}

