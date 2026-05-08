import 'package:money_management_mobile/features/transaction/domain/entities/transaction_entity.dart';

class CategoryEntity {
  final int id;
  final int? userId;
  final String name;
  final String icon;
  final bool isSystem;
  final TransactionType type;

  CategoryEntity({
    required this.id,
    this.userId,
    required this.name,
    required this.icon,
    required this.type,
    required this.isSystem,
  });
}
