import '../../domain/entities/assistance_entity.dart';

class AssistanceModel extends AssistanceEntity {
  const AssistanceModel({required String id}) : super(id: id);

  factory AssistanceModel.fromJson(Map<String, dynamic> json) => AssistanceModel(id: json['id']?.toString() ?? '');

  Map<String, dynamic> toJson() => {'id': id};
}

