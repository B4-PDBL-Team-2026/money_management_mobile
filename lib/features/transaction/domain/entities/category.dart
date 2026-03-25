import 'package:flutter/widgets.dart';

enum TransactionType { expense, income }

class Category {
  final int id;
  final String name;
  final IconData icon;
  final TransactionType type;

  const Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.type,
  });
}
