import 'dart:convert';

import 'package:money_management_mobile/features/auth/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.id,
    required super.name,
    required super.email,
    super.emailVerifiedAt,
    super.goal,
    super.cycleType,
    super.cycleStart,
    super.balance,
    super.profileUrl,
    required super.createdAt,
    required super.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final now = DateTime.now().toUtc();

    return UserModel(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      emailVerifiedAt: json['email_verified_at'] != null
          ? DateTime.parse(json['email_verified_at'] as String)
          : null,
      goal: json['goal'] as String?,
      cycleType: json['cycle_type'] as String?,
      cycleStart: json['cycle_start'] != null
          ? DateTime.parse(json['cycle_start'] as String)
          : null,
      balance: _parseNullableDouble(json['balance']),
      profileUrl: json['profile_url'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : now,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : now,
    );
  }

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      name: entity.name,
      email: entity.email,
      emailVerifiedAt: entity.emailVerifiedAt,
      goal: entity.goal,
      cycleType: entity.cycleType,
      cycleStart: entity.cycleStart,
      balance: entity.balance,
      profileUrl: entity.profileUrl,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'email_verified_at': emailVerifiedAt?.toIso8601String(),
      'goal': goal,
      'cycle_type': cycleType,
      'cycle_start': cycleStart?.toIso8601String(),
      'balance': balance,
      'profile_url': profileUrl,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  String toRawJson() => jsonEncode(toJson());

  static double? _parseNullableDouble(dynamic value) {
    if (value == null) {
      return null;
    }

    if (value is num) {
      return value.toDouble();
    }

    if (value is String) {
      return double.tryParse(value);
    }

    return null;
  }
}
