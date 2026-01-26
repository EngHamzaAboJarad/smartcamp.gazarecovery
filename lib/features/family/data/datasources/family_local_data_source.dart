import '../../domain/entities/family_entity.dart';

class FamilyModel extends FamilyEntity {
  const FamilyModel({required String id, required String name}) : super(id: id, name: name);

  factory FamilyModel.fromJson(Map<String, dynamic> json) {
    return FamilyModel(id: json['id']?.toString() ?? '', name: json['name']?.toString() ?? '');
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}

class FamilyLocalDataSource {
  // Minimal placeholder implementation. Replace with real storage access.
  Future<FamilyModel?> getFamily(String id) async {
    // Return null to indicate not found in placeholder.
    return null;
  }
}

