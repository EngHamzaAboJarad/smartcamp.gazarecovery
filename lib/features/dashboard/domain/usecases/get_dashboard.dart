import '../entities/dashboard_entity.dart';
import '../repositories/dashboard_repository.dart';

class GetDashboard {
  final DashboardRepository repository;
  GetDashboard(this.repository);

  Future<DashboardEntity?> call() async => repository.getDashboardData();
}

