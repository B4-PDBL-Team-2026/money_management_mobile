import 'package:money_management_mobile/features/transaction/domain/entities/category.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class DefaultCategories {
  static final List<Category> all = [
    Category(
      id: 1,
      name: 'Makan',
      icon: PhosphorIconsRegular.bowlFood,
      type: TransactionType.expense,
    ),
    Category(
      id: 2,
      name: 'Transport',
      icon: PhosphorIconsRegular.taxi,
      type: TransactionType.expense,
    ),
    Category(
      id: 3,
      name: 'Tagihan',
      icon: PhosphorIconsRegular.invoice,
      type: TransactionType.expense,
    ),
    Category(
      id: 4,
      name: 'Edukasi',
      icon: PhosphorIconsRegular.student,
      type: TransactionType.expense,
    ),
    Category(
      id: 5,
      name: 'Hiburan',
      icon: PhosphorIconsRegular.filmReel,
      type: TransactionType.expense,
    ),
    Category(
      id: 6,
      name: 'Belanja',
      icon: PhosphorIconsRegular.shoppingBag,
      type: TransactionType.expense,
    ),
    Category(
      id: 7,
      name: 'Kesehatan',
      icon: PhosphorIconsRegular.heartbeat,
      type: TransactionType.expense,
    ),
    Category(
      id: 8,
      name: 'Donasi',
      icon: PhosphorIconsRegular.handHeart,
      type: TransactionType.expense,
    ),
    Category(
      id: 9,
      name: 'Lainnya',
      icon: PhosphorIconsRegular.tag,
      type: TransactionType.expense,
    ),
    Category(
      id: 10,
      name: 'Uang saku',
      icon: PhosphorIconsRegular.money,
      type: TransactionType.income,
    ),
    Category(
      id: 11,
      name: 'Gaji',
      icon: PhosphorIconsRegular.wallet,
      type: TransactionType.income,
    ),
    Category(
      id: 12,
      name: 'Refund',
      icon: PhosphorIconsRegular.handCoins,
      type: TransactionType.income,
    ),
    Category(
      id: 13,
      name: 'Hadiah',
      icon: PhosphorIconsRegular.gift,
      type: TransactionType.income,
    ),
    Category(
      id: 14,
      name: 'Investasi',
      icon: PhosphorIconsRegular.chartLineUp,
      type: TransactionType.income,
    ),
    Category(
      id: 15,
      name: 'Pinjaman',
      icon: PhosphorIconsRegular.arrowCircleDown,
      type: TransactionType.income,
    ),
    Category(
      id: 16,
      name: 'Transfer Masuk',
      icon: PhosphorIconsRegular.arrowCircleRight,
      type: TransactionType.income,
    ),
    Category(
      id: 17,
      name: 'Lainnya',
      icon: PhosphorIconsRegular.tag,
      type: TransactionType.income,
    ),
  ];

  static List<Category> get expenses =>
      all.where((c) => c.type == TransactionType.expense).toList();
  static List<Category> get incomes =>
      all.where((c) => c.type == TransactionType.income).toList();
}
