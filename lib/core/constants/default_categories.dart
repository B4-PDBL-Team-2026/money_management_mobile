import 'package:money_management_mobile/features/transaction/domain/entities/category.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class DefaultCategories {
  static final List<Category> all = [
    Category(
      id: 1,
      name: 'Makan',
      icon: PhosphorIconsRegular.bowlFood,
      type: CategoryType.expense,
    ),
    Category(
      id: 2,
      name: 'Transport',
      icon: PhosphorIconsRegular.taxi,
      type: CategoryType.expense,
    ),
    Category(
      id: 3,
      name: 'Tagihan',
      icon: PhosphorIconsRegular.invoice,
      type: CategoryType.expense,
    ),
    Category(
      id: 4,
      name: 'Edukasi',
      icon: PhosphorIconsRegular.student,
      type: CategoryType.expense,
    ),
    Category(
      id: 5,
      name: 'Hiburan',
      icon: PhosphorIconsRegular.filmReel,
      type: CategoryType.expense,
    ),
    Category(
      id: 6,
      name: 'Belanja',
      icon: PhosphorIconsRegular.shoppingBag,
      type: CategoryType.expense,
    ),
    Category(
      id: 7,
      name: 'Kesehatan',
      icon: PhosphorIconsRegular.heartbeat,
      type: CategoryType.expense,
    ),
    Category(
      id: 8,
      name: 'Donasi',
      icon: PhosphorIconsRegular.handHeart,
      type: CategoryType.expense,
    ),
    Category(
      id: 9,
      name: 'Lainnya',
      icon: PhosphorIconsRegular.tag,
      type: CategoryType.expense,
    ),
    Category(
      id: 10,
      name: 'Uang saku',
      icon: PhosphorIconsRegular.money,
      type: CategoryType.income,
    ),
    Category(
      id: 11,
      name: 'Gaji',
      icon: PhosphorIconsRegular.wallet,
      type: CategoryType.income,
    ),
    Category(
      id: 12,
      name: 'Refund',
      icon: PhosphorIconsRegular.handCoins,
      type: CategoryType.income,
    ),
    Category(
      id: 13,
      name: 'Hadiah',
      icon: PhosphorIconsRegular.gift,
      type: CategoryType.income,
    ),
    Category(
      id: 14,
      name: 'Investasi',
      icon: PhosphorIconsRegular.chartLineUp,
      type: CategoryType.income,
    ),
    Category(
      id: 15,
      name: 'Pinjaman',
      icon: PhosphorIconsRegular.arrowCircleDown,
      type: CategoryType.income,
    ),
    Category(
      id: 16,
      name: 'Transfer Masuk',
      icon: PhosphorIconsRegular.arrowCircleRight,
      type: CategoryType.income,
    ),
    Category(
      id: 17,
      name: 'Lainnya',
      icon: PhosphorIconsRegular.tag,
      type: CategoryType.income,
    ),
  ];

  static List<Category> get expenses =>
      all.where((c) => c.type == CategoryType.expense).toList();
  static List<Category> get incomes =>
      all.where((c) => c.type == CategoryType.income).toList();
}
