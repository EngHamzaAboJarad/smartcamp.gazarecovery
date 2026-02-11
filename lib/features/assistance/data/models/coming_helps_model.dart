class ComingHelpsResponse {
  final String? message;
  final ComingHelpsData? data;

  ComingHelpsResponse({this.message, this.data});

  factory ComingHelpsResponse.fromJson(Map<String, dynamic> json) {
    return ComingHelpsResponse(
      message: json['message'] as String?,
      data: json['data'] != null ? ComingHelpsData.fromJson(Map<String, dynamic>.from(json['data'])) : null,
    );
  }
}

class ComingHelpsData {
  final ComingHelpsList? comingHelps;
  final List<HelpTypeCount> helpTypeCounts;

  ComingHelpsData({this.comingHelps, required this.helpTypeCounts});

  factory ComingHelpsData.fromJson(Map<String, dynamic> json) {
    return ComingHelpsData(
      comingHelps: json['coming_helps'] != null
          ? ComingHelpsList.fromJson(Map<String, dynamic>.from(json['coming_helps']))
          : null,
      helpTypeCounts: (json['help_type_counts'] as List<dynamic>?)
              ?.map((e) => HelpTypeCount.fromJson(Map<String, dynamic>.from(e)))
              .toList() ??
          [],
    );
  }
}

class ComingHelpsList {
  final List<dynamic> data;
  final PaginationLinks? links;
  final PaginationMeta? meta;

  ComingHelpsList({required this.data, this.links, this.meta});

  factory ComingHelpsList.fromJson(Map<String, dynamic> json) {
    return ComingHelpsList(
      data: (json['data'] as List<dynamic>?) ?? [],
      links: json['links'] != null ? PaginationLinks.fromJson(Map<String, dynamic>.from(json['links'])) : null,
      meta: json['meta'] != null ? PaginationMeta.fromJson(Map<String, dynamic>.from(json['meta'])) : null,
    );
  }
}

class PaginationLinks {
  final String? first;
  final String? last;
  final String? prev;
  final String? next;

  PaginationLinks({this.first, this.last, this.prev, this.next});

  factory PaginationLinks.fromJson(Map<String, dynamic> json) {
    return PaginationLinks(
      first: json['first'] as String?,
      last: json['last'] as String?,
      prev: json['prev'] as String?,
      next: json['next'] as String?,
    );
  }
}

class PaginationMeta {
  final int? currentPage;
  final int? from;
  final int? lastPage;
  final int? perPage;
  final int? to;
  final int? total;

  PaginationMeta({this.currentPage, this.from, this.lastPage, this.perPage, this.to, this.total});

  factory PaginationMeta.fromJson(Map<String, dynamic> json) {
    int? tryParse(dynamic v) {
      if (v == null) return null;
      if (v is int) return v;
      if (v is String) return int.tryParse(v);
      return null;
    }

    return PaginationMeta(
      currentPage: tryParse(json['current_page']),
      from: tryParse(json['from']),
      lastPage: tryParse(json['last_page']),
      perPage: tryParse(json['per_page']),
      to: tryParse(json['to']),
      total: tryParse(json['total']),
    );
  }
}

class HelpTypeCount {
  final int id;
  final String name;
  final String? nameEn;
  final String? nameAr;
  final String? icon;
  int count;

  HelpTypeCount({required this.id, required this.name, this.nameEn, this.nameAr, this.icon, required this.count});

  factory HelpTypeCount.fromJson(Map<String, dynamic> json) {
    int parseCount(dynamic v) {
      if (v == null) return 0;
      if (v is int) return v;
      if (v is String) return int.tryParse(v) ?? 0;
      return 0;
    }

    return HelpTypeCount(
      id: (json['id'] is int) ? json['id'] as int : int.tryParse(json['id']?.toString() ?? '') ?? 0,
      name: json['name']?.toString() ?? '',
      nameEn: json['name_en']?.toString(),
      nameAr: json['name_ar']?.toString(),
      icon: json['icon']?.toString(),
      count: parseCount(json['count']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'name_en': nameEn,
        'name_ar': nameAr,
        'icon': icon,
        'count': count,
      };
}

