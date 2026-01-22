import '../../domain/entities/dashboard_entity.dart';

class DashboardModel extends DashboardEntity {
  const DashboardModel({required String id}) : super(id: id);

  factory DashboardModel.fromJson(Map<String, dynamic> json) => DashboardModel(id: json['id']?.toString() ?? '');

  Map<String, dynamic> toJson() => {'id': id};
}

