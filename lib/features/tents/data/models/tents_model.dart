import '../../domain/entities/tents_entity.dart';

class TentsModel extends TentsEntity {
  const TentsModel({required String id}) : super(id: id);

  factory TentsModel.fromJson(Map<String, dynamic> json) => TentsModel(id: json['id']?.toString() ?? '');

  Map<String, dynamic> toJson() => {'id': id};
}

