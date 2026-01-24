import '../../../dashboard/domain/repositories/dashboard_repository.dart';
import '../../../dashboard/domain/entities/dashboard_entity.dart';
import '../datasources/dashboard_local_data_source.dart';
import '../models/dashboard_model.dart' as dm;

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardLocalDataSource local;
  DashboardRepositoryImpl(this.local);

  @override
  Future<DashboardEntity?> getDashboardData() async {
    final dm.DashboardModel? model = await local.getData();
    if (model == null) return null;
    // NOTE: Domain entity currently only has an `id` field.
    // There's a mismatch between the rich data model and the simple domain entity.
    // As a pragmatic fix we map a meaningful stable field (campName) to the entity id.
    // If you prefer a different mapping (or to expand DashboardEntity) update the domain entity accordingly.
    final id = model.data?.campName ?? '';
    return DashboardEntity(id: id);
  }
}
