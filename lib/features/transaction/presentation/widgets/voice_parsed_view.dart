import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_management_mobile/core/theme/theme.dart';
import 'package:money_management_mobile/features/category/domain/entities/category_entity.dart';
import 'package:money_management_mobile/features/transaction/domain/entities/transaction_entity.dart';
import 'package:money_management_mobile/features/transaction/presentation/cubit/voice_transaction_state.dart';

class VoiceParsedView extends StatefulWidget {
  final ParsedTransactionData data;

  /// Valid categories from CategoryCubit, filtered by transaction type.
  /// The view uses this to validate/resolve the inferred categoryId.
  final List<CategoryEntity> categories;

  /// Opens the existing CategoryBottomSheet. Returns the picked id via callback.
  final Future<int?> Function(int currentId) onShowCategoryPicker;

  /// Called with fully resolved data (real categoryId, chosen date) on save.
  final void Function(ParsedTransactionData resolved) onSave;

  final VoidCallback onReset;

  const VoiceParsedView({
    super.key,
    required this.data,
    required this.categories,
    required this.onShowCategoryPicker,
    required this.onSave,
    required this.onReset,
  });

  @override
  State<VoiceParsedView> createState() => _VoiceParsedViewState();
}

class _VoiceParsedViewState extends State<VoiceParsedView> {
  late CategoryEntity _category;
  late DateTime _date;

  @override
  void initState() {
    super.initState();
    _date = widget.data.transactionAt;
    _category = _resolveCategory();
  }

  @override
  void didUpdateWidget(VoiceParsedView old) {
    super.didUpdateWidget(old);
    if (old.data != widget.data) {
      _date = widget.data.transactionAt;
      _category = _resolveCategory();
    }
  }

  /// Matches the inferred categoryId against the real backend list.
  /// Falls back to the first item so the UI always shows a valid category.
  CategoryEntity _resolveCategory() {
    if (widget.categories.isEmpty) {
      // No categories loaded yet — use inferred data as a placeholder.
      return _syntheticCategory(widget.data.categoryId, widget.data.categoryName);
    }
    return widget.categories.firstWhere(
          (c) => c.id == widget.data.categoryId,
      orElse: () => widget.categories.first,
    );
  }

  CategoryEntity _syntheticCategory(int id, String name) {
    return CategoryEntity(
      id: id,
      name: name,
      icon: '',
      type: widget.data.type,
      categoryType: RealCategoryType.system,
    );
  }

  // Date picker — mirrors AddTransactionPage._pickDate

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(_date.year - 3),
      lastDate: DateTime.now(),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(
            primary: AppColors.primary,
            onPrimary: AppColors.gohan,
            onSurface: AppColors.bulma,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null && mounted) {
      setState(() => _date = picked);
    }
  }

  // Category picker

  Future<void> _pickCategory() async {
    final pickedId = await widget.onShowCategoryPicker(_category.id);
    if (pickedId == null || !mounted) return;
    final picked = widget.categories.firstWhere(
          (c) => c.id == pickedId,
      orElse: () => _category,
    );
    setState(() => _category = picked);
  }

  // Helpers

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
    return DateFormat('d MMMM yyyy', 'id_ID').format(dt);
  }

  /// Builds the final resolved payload passed to onSave.
  ParsedTransactionData get _resolved => ParsedTransactionData(
    amount: widget.data.amount,
    type: widget.data.type,
    name: widget.data.name,
    categoryId: _category.id,
    categoryName: _category.name,
    transactionAt: _date,
    note: widget.data.note,
  );

  @override
  Widget build(BuildContext context) {
    final isExpense = widget.data.type == TransactionType.expense;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const SizedBox(height: 20),

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
            _formatCurrency(widget.data.amount),
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 24),

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
                // Type — read-only
                _DetailRow(
                  icon: isExpense
                      ? Icons.arrow_circle_up_rounded
                      : Icons.arrow_circle_down_rounded,
                  iconColor:
                  isExpense ? AppColors.danger100 : AppColors.success100,
                  label: 'Tipe',
                  value: isExpense
                      ? 'Pengeluaran (Beli)'
                      : 'Pemasukan (Dapat)',
                ),
                const Divider(height: 1, indent: 72),

                // Category — tappable
                _TappableRow(
                  icon: Icons.grid_view_rounded,
                  iconColor: AppColors.primary,
                  label: 'Kategori',
                  value: _category.name,
                  onTap: _pickCategory,
                ),
                const Divider(height: 1, indent: 72),

                // Date — tappable, opens native date picker
                _TappableRow(
                  icon: Icons.calendar_today_rounded,
                  iconColor: AppColors.primary,
                  label: 'Tanggal',
                  value: _formatDate(_date),
                  onTap: _pickDate,
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => widget.onSave(_resolved),
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
            onPressed: widget.onReset,
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

// Private sub-widgets

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

class _TappableRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final VoidCallback onTap;

  const _TappableRow({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            _IconBox(child: Icon(icon, color: iconColor, size: 22)),
            const SizedBox(width: 16),
            Expanded(child: _LabelValue(label: label, value: value)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
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
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
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