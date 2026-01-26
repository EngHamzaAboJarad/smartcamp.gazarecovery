import '../entities/assistance_entity.dart';

abstract class AssistanceRepository {
  Future<AssistanceEntity?> getAssistance(String id);
}

