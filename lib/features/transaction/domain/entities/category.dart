import 'package:flutter/widgets.dart';

enum CategoryType { expense, income }

class Category {
  final int id;
  final String name;
  final IconData icon;
  final CategoryType type;

  const Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.type,
  });
}
