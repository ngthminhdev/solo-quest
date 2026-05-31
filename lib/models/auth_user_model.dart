class AuthUserModel {
  final String id;
  final String name;
  final String email;
  final String? avatarUrl;
  final String provider;

  const AuthUserModel({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
    this.provider = 'google',
  });

  AuthUserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? avatarUrl,
    String? provider,
  }) {
    return AuthUserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      provider: provider ?? this.provider,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatarUrl': avatarUrl,
      'provider': provider,
    };
  }

  factory AuthUserModel.fromJson(Map<String, dynamic> json) {
    return AuthUserModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      avatarUrl: json['avatarUrl'] as String?,
      provider: json['provider'] as String? ?? 'google',
    );
  }
}
