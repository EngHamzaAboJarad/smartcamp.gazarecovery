// Auto-generated model for manager/dashboard/home response

class DashboardModel {
  final String message;
  final DashboardData? data;

  DashboardModel({required this.message, this.data});

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      message: json['message']?.toString() ?? '',
      data: json['data'] != null && json['data'] is Map
          ? DashboardData.fromJson(Map<String, dynamic>.from(json['data']))
          : null,
    );
  }
}

class DashboardData {
  final String? campName;
  final CampLocation? campLocation;
  final String? status;
  final int tentNumber;
  final int numberOldPeople;
  final int numberOfIndividuals;
  final int familiesNumber;
  final int childrenNumbers;
  final int malesNumber;
  final int femalesNumber;
  final int numberOfPeopleWithDisabilities;
  final int numberOfAdjacentTents;
  final int numberOfFamiliesInBuildings;
  final int bathrooms;
  final Map<String, int> classification;
  final List<NeedModel> needs; // changed to typed list
  final List<LatestNeed> latest_needs; // changed to typed list
  final InfrastructureItem? water;
  final InfrastructureItem? waterForDrinks;

  DashboardData({
    this.campName,
    this.campLocation,
    this.status,
    required this.tentNumber,
    required this.latest_needs,
    required this.numberOldPeople,
    required this.numberOfIndividuals,
    required this.familiesNumber,
    required this.childrenNumbers,
    required this.malesNumber,
    required this.femalesNumber,
    required this.numberOfPeopleWithDisabilities,
    required this.numberOfAdjacentTents,
    required this.numberOfFamiliesInBuildings,
    required this.bathrooms,
    required this.classification,
    required this.needs,
    this.water,
    this.waterForDrinks,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    Map<String, int> classification = {'A': 0, 'B': 0, 'C': 0};
    if (json['classification'] is Map) {
      final cls = Map<String, dynamic>.from(json['classification'] as Map);
      classification = {
        'A': (cls['A'] is int) ? cls['A'] as int : int.tryParse(cls['A']?.toString() ?? '') ?? 0,
        'B': (cls['B'] is int) ? cls['B'] as int : int.tryParse(cls['B']?.toString() ?? '') ?? 0,
        'C': (cls['C'] is int) ? cls['C'] as int : int.tryParse(cls['C']?.toString() ?? '') ?? 0,
      };
    }

    // parse needs into typed models
    List<NeedModel> needsList = [];
    if (json['needs'] is List) {
      try {
        needsList = (json['needs'] as List)
            .where((e) => e != null)
            .map((e) => NeedModel.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList();
      } catch (_) {
        needsList = [];
      }
    }

    InfrastructureItem? parseInfra(dynamic v) {
      if (v == null) return null;
      if (v is Map<String, dynamic>) return InfrastructureItem.fromJson(v);
      if (v is Map) return InfrastructureItem.fromJson(Map<String, dynamic>.from(v));
      return null;
    }
// parse latest_needs into typed models
    List<LatestNeed> latestNeedsList = [];
    if (json['latest_needs'] is List) {
      try {
        latestNeedsList = (json['latest_needs'] as List)
            .where((e) => e != null)
            .map((e) => LatestNeed.fromJson(
          Map<String, dynamic>.from(e as Map),
        ))
            .toList();
      } catch (_) {
        latestNeedsList = [];
      }
    }
    return DashboardData(
      campName: json['camp_name']?.toString(),
      campLocation: json['camp_location'] is Map
          ? CampLocation.fromJson(Map<String, dynamic>.from(json['camp_location']))
          : null,
      latest_needs: latestNeedsList,
      status: json['status']?.toString(),
      tentNumber: (json['tent_number'] is int) ? json['tent_number'] as int : int.tryParse(json['tent_number']?.toString() ?? '') ?? 0,
      numberOldPeople: (json['number_of_old_people'] is int) ? json['number_of_old_people'] as int : int.tryParse(json['number_of_old_people']?.toString() ?? '') ?? 0,
      numberOfIndividuals: (json['number_of_individuals'] is int) ? json['number_of_individuals'] as int : int.tryParse(json['number_of_individuals']?.toString() ?? '') ?? 0,
      familiesNumber: (json['families_number'] is int) ? json['families_number'] as int : int.tryParse(json['families_number']?.toString() ?? '') ?? 0,
      childrenNumbers: (json['children_numbers'] is int) ? json['children_numbers'] as int : int.tryParse(json['children_numbers']?.toString() ?? '') ?? 0,
      malesNumber: (json['males_number'] is int) ? json['males_number'] as int : int.tryParse(json['males_number']?.toString() ?? '') ?? 0,
      femalesNumber: (json['females_number'] is int) ? json['females_number'] as int : int.tryParse(json['females_number']?.toString() ?? '') ?? 0,
      numberOfPeopleWithDisabilities: (json['number_of_people_with_disabilities'] is int) ? json['number_of_people_with_disabilities'] as int : int.tryParse(json['number_of_people_with_disabilities']?.toString() ?? '') ?? 0,
      numberOfAdjacentTents: (json['number_of_adjacent_tents'] is int) ? json['number_of_adjacent_tents'] as int : int.tryParse(json['number_of_adjacent_tents']?.toString() ?? '') ?? 0,
      numberOfFamiliesInBuildings: (json['number_of_families_in_buildings'] is int) ? json['number_of_families_in_buildings'] as int : int.tryParse(json['number_of_families_in_buildings']?.toString() ?? '') ?? 0,
      bathrooms: (json['bathrooms'] is int) ? json['bathrooms'] as int : int.tryParse(json['bathrooms']?.toString() ?? '') ?? 0,
      classification: classification,
      needs: needsList,
      water: parseInfra(json['water']),
      waterForDrinks: parseInfra(json['water_for_drinks']),
    );
  }
}
class LatestNeed {
  final String type;
  final String status;
  final DateTime? createdAt;

  LatestNeed({
    required this.type,
    required this.status,
    this.createdAt,
  });

  factory LatestNeed.fromJson(Map<String, dynamic> json) {
    return LatestNeed(
      type: json['type'] as String,
      status: json['status'] as String,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'status': status,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}
class CampLocation {
  final String? name;
  final String? city;
  final String? region;
  final String? address;

  CampLocation({this.name, this.city, this.region, this.address});

  factory CampLocation.fromJson(Map<String, dynamic> json) {
    return CampLocation(
      name: json['name']?.toString(),
      city: json['city']?.toString(),
      region: json['region']?.toString(),
      address: json['address']?.toString(),
    );
  }
}

// New model for individual need items in the dashboard response
class NeedModel {
  final int id;
  final int campId;
  final int tentId;
  final String priority;
  final String details;
  final int requestedBy;
  final String status;
  final DateTime? respondedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  NeedModel({
    required this.id,
    required this.campId,
    required this.tentId,
    required this.priority,
    required this.details,
    required this.requestedBy,
    required this.status,
    this.respondedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory NeedModel.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(dynamic v) {
      if (v == null) return null;
      try {
        return DateTime.parse(v.toString());
      } catch (_) {
        return null;
      }
    }

    int parseInt(dynamic v) {
      if (v == null) return 0;
      if (v is int) return v;
      return int.tryParse(v.toString()) ?? 0;
    }

    return NeedModel(
      id: parseInt(json['id']),
      campId: parseInt(json['camp_id']),
      tentId: parseInt(json['tent_id']),
      priority: json['priority']?.toString() ?? '',
      details: json['details']?.toString() ?? '',
      requestedBy: parseInt(json['requested_by']),
      status: json['status']?.toString() ?? '',
      respondedAt: parseDate(json['responded_at']),
      createdAt: parseDate(json['created_at']),
      updatedAt: parseDate(json['updated_at']),
    );
  }
}

// New model for simple infrastructure items (water, water_for_drinks, etc.)
class InfrastructureItem {
  final int? id;
  final String? name;
  final String? type;
  final bool available;

  InfrastructureItem({this.id, this.name, this.type, required this.available});

  factory InfrastructureItem.fromJson(Map<String, dynamic> json) {
    int? parseNullableInt(dynamic v) {
      if (v == null) return null;
      if (v is int) return v;
      return int.tryParse(v.toString());
    }

    bool parseBool(dynamic v) {
      if (v == null) return false;
      if (v is bool) return v;
      final s = v.toString().toLowerCase();
      return s == 'true' || s == '1';
    }

    return InfrastructureItem(
      id: parseNullableInt(json['id']),
      name: json['name']?.toString(),
      type: json['type']?.toString(),
      available: parseBool(json['available']),
    );
  }
}