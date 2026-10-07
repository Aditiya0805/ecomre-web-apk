class UserModel {
  final int? id;
  final String username;
  final String role;

  const UserModel({
    this.id,
    required this.username,
    required this.role,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] is int
          ? map['id'] as int
          : int.tryParse(map['id']?.toString() ?? ''),
      username: map['username']?.toString() ?? '',
      role: map['role']?.toString() ?? 'user',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'role': role,
    };
  }

  bool get isAdmin => role.toLowerCase() == 'admin';
}
