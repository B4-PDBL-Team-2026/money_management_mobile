class UserEntity {
  final int id;
  final String name;
  final String email;
  final DateTime? emailVerifiedAt;
  final String? goal;
  final String? cycleType;
  final DateTime? cycleStart;
  final double? balance;
  final String? profileUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserEntity({
    required this.id,
    required this.name,
    required this.email,
    this.emailVerifiedAt,
    this.goal,
    this.cycleType,
    this.cycleStart,
    this.balance,
    this.profileUrl,
    required this.createdAt,
    required this.updatedAt,
  });
}
