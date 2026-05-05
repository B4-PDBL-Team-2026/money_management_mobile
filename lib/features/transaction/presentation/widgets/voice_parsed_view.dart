import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_management_mobile/core/theme/theme.dart';
import 'package:money_management_mobile/features/transaction/domain/entities/transaction_entity.dart';
import 'package:money_management_mobile/features/transaction/presentation/cubit/voice_transaction_state.dart';

class VoiceParsedView extends StatelessWidget {
  final ParsedTransactionData data;
  final int? overrideCategoryId;
  final String? overrideCategoryName;
  final Future<void> Function(ParsedTransactionData, int) onShowCategoryPicker;
  final VoidCallback onSave;
  final VoidCallback onReset;

  const VoiceParsedView({
    super.key,
    required this.data,
    required this.overrideCategoryId,
    required this.overrideCategoryName,
    required this.onShowCategoryPicker,
    required this.onSave,
    required this.onReset,
  });

  String _formatCurrency(int amount) => NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  ).format(amount);

  String _formatDate(DateTime dt) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final d = DateTime(dt.year, dt.month, dt.day);
    if (d == today) return 'Hari ini';
    if (d == yesterday) return 'Kemarin';
    return DateFormat('dd MMM yyyy', 'id_ID').format(dt);
  }

  @override
  Widget build(BuildContext context) {
    final isExpense = data.type == TransactionType.expense;
    final activeCategoryId = overrideCategoryId ?? data.categoryId;
    final activeCategoryName = overrideCategoryName ?? data.categoryName;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const SizedBox(height: 20),

          // Amount
          Text(
            'NOMINAL TERDETEKSI',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.trunks,
              letterSpacing: 1.2,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _formatCurrency(data.amount),
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 24),

          // Detail card
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                _DetailRow(
                  icon: isExpense
                      ? Icons.arrow_circle_up_rounded
                      : Icons.arrow_circle_down_rounded,
                  iconColor: isExpense ? AppColors.danger100 : AppColors.success100,
                  label: 'Tipe',
                  value: isExpense ? 'Pengeluaran (Beli)' : 'Pemasukan (Dapat)',
                ),
                const Divider(height: 1, indent: 72),

                // Category row — tappable
                InkWell(
                  onTap: () => onShowCategoryPicker(data, activeCategoryId),
                  borderRadius: BorderRadius.circular(20),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 16),
                    child: Row(
                      children: [
                        _IconBox(
                          child: Icon(Icons.grid_view_rounded,
                              color: AppColors.primary, size: 22),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _LabelValue(
                              label: 'Kategori', value: activeCategoryName),
                        ),
                        // "Ubah" chip
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.edit_outlined,
                                  size: 12, color: AppColors.primary),
                              const SizedBox(width: 3),
                              Text(
                                'Ubah',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall
                                    ?.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(height: 1, indent: 72),

                _DetailRow(
                  icon: Icons.calendar_today_rounded,
                  iconColor: AppColors.primary,
                  label: 'Tanggal',
                  value: _formatDate(data.transactionAt),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Save button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onSave,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
                elevation: 0,
              ),
              icon: const Icon(Icons.check_circle_outline_rounded,
                  color: Colors.white, size: 20),
              label: Text(
                'Simpan Transaksi',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          TextButton.icon(
            onPressed: onReset,
            icon: const Icon(Icons.refresh_rounded,
                size: 18, color: AppColors.trunks),
            label: Text(
              'Coba Lagi',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.trunks,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

// Shared small widgets (used only within parsed view)

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          _IconBox(child: Icon(icon, color: iconColor, size: 22)),
          const SizedBox(width: 16),
          _LabelValue(label: label, value: value),
        ],
      ),
    );
  }
}

class _IconBox extends StatelessWidget {
  final Widget child;
  const _IconBox({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: AppColors.gohan,
        borderRadius: BorderRadius.circular(10),
      ),
      child: child,
    );
  }
}

class _LabelValue extends StatelessWidget {
  final String label;
  final String value;
  const _LabelValue({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: AppColors.trunks,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.bulma,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}