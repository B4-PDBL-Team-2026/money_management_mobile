import 'package:money_management_mobile/features/transaction/domain/entities/transaction_entity.dart';

// TODO: tipe kategori tidak konsisten di backend, kadang 'App\\Models\\SystemCategory', kadang 'system'. Perlu disesuaikan agar konsisten
enum RealCategoryType {
  system('system'),
  custom('custom');

  final String value;

  const RealCategoryType(this.value);
}

class CategoryEntity {
  final int id;
  final String name;
  final String icon;
  final TransactionType type;
  final RealCategoryType categoryType;

  CategoryEntity({
    required this.id,
    required this.name,
    required this.icon,
    required this.type,
    required this.categoryType,
  });
}
