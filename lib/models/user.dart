import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final String id;
  final String email;
  final String name;
  final String? phone;
  final String? address;
  final DateTime createdAt;

  User({
    required this.id,
    required this.email,
    required this.name,
    this.phone,
    this.address,
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);

  User copyWith({
    String? id,
    String? email,
    String? name,
    String? phone,
    String? address,
    DateTime? createdAt,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}