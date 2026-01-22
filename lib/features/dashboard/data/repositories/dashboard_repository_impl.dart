import '../../../dashboard/domain/repositories/dashboard_repository.dart';
import '../../../dashboard/domain/entities/dashboard_entity.dart';
import '../datasources/dashboard_local_data_source.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardLocalDataSource local;
  DashboardRepositoryImpl(this.local);

  @override
  Future<DashboardEntity?> getDashboardData() async => local.getData();
}

