import '../entities/assistance_entity.dart';
import '../repositories/assistance_repository.dart';

class GetAssistance {
  final AssistanceRepository repository;
  GetAssistance(this.repository);

  Future<AssistanceEntity?> call(String id) async => repository.getAssistance(id);
}

