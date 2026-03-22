enum CategoryType {
  system('App\\Models\\SystemCategory'),
  custom('App\\Models\\CustomCategory');

  final String value;

  const CategoryType(this.value);
}

class FixedCostEntity {
  final String name;
  final int amount;
  final String category;
  final int categoryId;
  final CategoryType categoryType;
  final bool isActive;
  final String cycle;
  final int dueValue;

  const FixedCostEntity({
    required this.name,
    required this.amount,
    required this.category,
    required this.categoryId,
    this.categoryType = CategoryType.system,
    this.isActive = true,
    required this.cycle,
    required this.dueValue,
  });
}
