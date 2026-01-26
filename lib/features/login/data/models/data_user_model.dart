// ...existing code...

class DataUserModel {
  final UserModel user;
  final String token;

  DataUserModel({required this.user, required this.token});

  factory DataUserModel.fromJson(Map<String, dynamic> json) {
    final userJson = json['user'] as Map<String, dynamic>? ?? {};
    return DataUserModel(
      user: UserModel.fromJson(userJson),
      token: json['token']?.toString() ?? json['access_token']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'user': user.toJson(),
        'token': token,
      };

  DataUserModel copyWith({UserModel? user, String? token}) {
    return DataUserModel(
      user: user ?? this.user,
      token: token ?? this.token,
    );
  }
}

class UserModel {
  final int id;
  final String name;
  final String username;
  final String identityNumber;
  final String mobileNumber;
  final String? email;
  final String? createdAt;
  final String? updatedAt;

  UserModel({
    required this.id,
    required this.name,
    required this.username,
    required this.identityNumber,
    required this.mobileNumber,
    this.email,
    this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] is int ? json['id'] as int : int.tryParse(json['id']?.toString() ?? '') ?? 0,
      name: json['name']?.toString() ?? '',
      username: json['username']?.toString() ?? '',
      identityNumber: json['identity_number']?.toString() ?? json['identityNumber']?.toString() ?? '',
      mobileNumber: json['mobile_number']?.toString() ?? json['mobileNumber']?.toString() ?? '',
      email: json['email']?.toString(),
      createdAt: json['created_at']?.toString() ?? json['createdAt']?.toString(),
      updatedAt: json['updated_at']?.toString() ?? json['updatedAt']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'username': username,
        'identity_number': identityNumber,
        'mobile_number': mobileNumber,
        'email': email,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };

  UserModel copyWith({
    int? id,
    String? name,
    String? username,
    String? identityNumber,
    String? mobileNumber,
    String? email,
    String? createdAt,
    String? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      username: username ?? this.username,
      identityNumber: identityNumber ?? this.identityNumber,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      email: email ?? this.email,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

