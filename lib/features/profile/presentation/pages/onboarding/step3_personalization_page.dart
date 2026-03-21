import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:money_management_mobile/core/routes/app_router.dart';
import 'package:money_management_mobile/core/theme/app_colors.dart';
import 'package:money_management_mobile/core/theme/app_sizes.dart';
import 'package:money_management_mobile/core/utils/currency_formatter.dart';
import 'package:money_management_mobile/core/widgets/app_button.dart';
import 'package:money_management_mobile/core/widgets/app_currency_text_field.dart';
import 'package:money_management_mobile/core/widgets/app_text_field.dart';
import 'package:money_management_mobile/features/profile/domain/entities/financial_profile_entity.dart';
import 'package:money_management_mobile/features/profile/presentation/cubit/financial_profile_draft_cubit.dart';
import 'package:money_management_mobile/features/profile/presentation/cubit/financial_profile_draft_state.dart';
import 'package:money_management_mobile/features/profile/presentation/widgets/fixed_cost_item_card.dart';
import 'package:money_management_mobile/features/profile/presentation/widgets/step_progress_indicator.dart';

class Step3PersonalizationPage extends StatefulWidget {
  const Step3PersonalizationPage({super.key});

  @override
  State<Step3PersonalizationPage> createState() =>
      _Step3PersonalizationPageState();
}

class _Step3PersonalizationPageState extends State<Step3PersonalizationPage> {
  static const List<String> _expenseCategories = [
    'Tempat Tinggal',
    'Transportasi',
    'Tagihan',
    'Langganan',
    'Makan',
    'Lainnya',
  ];

  static const List<MapEntry<int, String>> _weekdayOptions = [
    MapEntry(1, 'Senin'),
    MapEntry(2, 'Selasa'),
    MapEntry(3, 'Rabu'),
    MapEntry(4, 'Kamis'),
    MapEntry(5, 'Jumat'),
    MapEntry(6, 'Sabtu'),
    MapEntry(7, 'Minggu'),
  ];

  void _deleteItem(int index) {
    context.read<FinancialProfileDraftCubit>().removeFixedCostAt(index);
  }

  void _showAddExpenseBottomSheet() {
    final draftCubit = context.read<FinancialProfileDraftCubit>();
    final isMainCycleWeekly =
        draftCubit.state.budgetCycle == BudgetCycle.weekly;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) => _AddFixedCostBottomSheet(
        draftCubit: draftCubit,
        isMainCycleWeekly: isMainCycleWeekly,
        expenseCategories: _expenseCategories,
        weekdayOptions: _weekdayOptions,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FinancialProfileDraftCubit, FinancialProfileDraftState>(
      builder: (context, state) {
        final cycleLabel = state.budgetCycle == BudgetCycle.weekly
            ? 'Mingguan'
            : 'Bulanan';

        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSizes.spacing6),
              child: Column(
                children: [
                  const SizedBox(height: AppSizes.spacing4),
                  const StepProgressIndicator(currentStep: 3, totalSteps: 4),
                  const SizedBox(height: AppSizes.spacing7),
                  Text(
                    'Biaya Rutin',
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      color: AppColors.primary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSizes.spacing2),
                  Text(
                    'Tambahkan fixed cost agar proyeksi budget lebih akurat.',
                    textAlign: TextAlign.center,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: AppColors.trunks),
                  ),
                  const SizedBox(height: AppSizes.spacing3),
                  _buildStepHint(cycleLabel, state.budgetCycle),
                  const SizedBox(height: AppSizes.spacing5),
                  AppButton(
                    text: 'Tambah Fixed Cost',
                    onPressed: _showAddExpenseBottomSheet,
                    variant: AppButtonVariant.outlined,
                  ),
                  const SizedBox(height: AppSizes.spacing4),
                  if (state.fixedCosts.isEmpty)
                    _buildEmptyState()
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: state.fixedCosts.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: AppSizes.spacing4),
                      itemBuilder: (context, index) {
                        final item = state.fixedCosts[index];

                        return FixedCostItemCard(
                          name: item.name,
                          category: item.category,
                          cycle: _apiCycleToLabel(item.cycle),
                          dueLabel: _buildDueLabel(
                            dueValue: item.dueValue,
                            frequency: item.cycle,
                          ),
                          amount:
                              'Rp ${CurrencyFormatter.format(item.amount.toInt())}',
                          showDeleteAction: true,
                          onDelete: () => _deleteItem(index),
                        );
                      },
                    ),
                  const SizedBox(height: AppSizes.spacing7),
                  Row(
                    children: [
                      Expanded(
                        child: AppButton(
                          text: 'Sebelumnya',
                          onPressed: context.pop,
                          variant: AppButtonVariant.ghost,
                        ),
                      ),
                      const SizedBox(width: AppSizes.spacing2),
                      Expanded(
                        child: AppButton(
                          text: state.fixedCosts.isEmpty
                              ? 'Lewati'
                              : 'Selanjutnya',
                          onPressed: () {
                            context.push(AppRouter.step4Personalization);
                          },
                          variant: state.fixedCosts.isEmpty
                              ? AppButtonVariant.ghost
                              : AppButtonVariant.filled,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String _apiCycleToLabel(String cycle) {
    return cycle == 'weekly' ? 'Mingguan' : 'Bulanan';
  }

  String _buildDueLabel({required int dueValue, required String frequency}) {
    if (frequency == 'weekly') {
      return _weekdayOptions.firstWhere((item) => item.key == dueValue).value;
    }

    return 'Tanggal $dueValue';
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSizes.spacing5),
      decoration: BoxDecoration(
        color: AppColors.gohan,
        borderRadius: BorderRadius.circular(AppSizes.radiusNm),
        border: Border.all(color: AppColors.beerus),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.receipt_long_outlined,
            size: AppSizes.spacing6,
            color: AppColors.trunks,
          ),
          const SizedBox(height: AppSizes.spacing2),
          Text(
            'Belum ada fixed cost',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.bulma,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSizes.spacing1),
          Text(
            'Anda bisa lewati langkah ini atau tambah satu biaya rutin terlebih dulu.',
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.trunks),
          ),
        ],
      ),
    );
  }

  Widget _buildStepHint(String cycleLabel, BudgetCycle cycle) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Siklus aktif: $cycleLabel',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.trunks,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: AppSizes.spacing1),
        Tooltip(
          message: cycle == BudgetCycle.monthly
              ? 'Biaya mingguan akan disesuaikan dengan sisa minggu pada bulan berjalan.'
              : 'Biaya rutin akan dihitung untuk sisa hari pada minggu berjalan.',
          child: const Icon(
            Icons.info_outline,
            size: 16,
            color: AppColors.trunks,
          ),
        ),
      ],
    );
  }
}

class _AddFixedCostBottomSheet extends StatefulWidget {
  const _AddFixedCostBottomSheet({
    required this.draftCubit,
    required this.isMainCycleWeekly,
    required this.expenseCategories,
    required this.weekdayOptions,
  });

  final FinancialProfileDraftCubit draftCubit;
  final bool isMainCycleWeekly;
  final List<String> expenseCategories;
  final List<MapEntry<int, String>> weekdayOptions;

  @override
  State<_AddFixedCostBottomSheet> createState() =>
      _AddFixedCostBottomSheetState();
}

class _AddFixedCostBottomSheetState extends State<_AddFixedCostBottomSheet> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _dueDateController = TextEditingController();

  late String _frequency;
  late String _category;
  late List<MapEntry<int, String>> _dueOptions;
  late int _selectedDueValue;

  @override
  void initState() {
    super.initState();
    _frequency = widget.isMainCycleWeekly ? 'weekly' : 'monthly';
    _category = widget.expenseCategories.first;
    _dueOptions = _buildDueOptions(_frequency);
    _selectedDueValue = _dueOptions.first.key;

    if (!widget.isMainCycleWeekly) {
      _selectedDueValue = DateTime.now().day;
      _dueDateController.text = _monthlyDueText(_selectedDueValue);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _dueDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: const BoxDecoration(
        color: AppColors.gohan,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSizes.spacing6),
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.spacing6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.beerus,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: AppSizes.spacing4),
            Text(
              'Tambah Fixed Cost',
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(color: AppColors.primary),
            ),
            const SizedBox(height: AppSizes.spacing4),
            AppTextField(
              hint: 'Nama biaya (contoh: WiFi)',
              controller: _nameController,
              prefixIcon: const Icon(
                Icons.receipt_outlined,
                color: AppColors.trunks,
              ),
            ),
            const SizedBox(height: AppSizes.spacing4),
            AppCurrencyTextField(
              controller: _amountController,
              hint: 'Nominal',
              prefixIcon: const Icon(
                Icons.attach_money,
                color: AppColors.trunks,
              ),
            ),
            const SizedBox(height: AppSizes.spacing4),
            DropdownButtonFormField<String>(
              initialValue: _category,
              decoration: _dropdownDecoration(context, 'Kategori'),
              items: widget.expenseCategories
                  .map(
                    (item) => DropdownMenuItem(value: item, child: Text(item)),
                  )
                  .toList(growable: false),
              onChanged: (value) {
                if (value == null) {
                  return;
                }
                setState(() => _category = value);
              },
            ),
            if (!widget.isMainCycleWeekly) ...[
              const SizedBox(height: AppSizes.spacing4),
              DropdownButtonFormField<String>(
                initialValue: _frequency,
                decoration: _dropdownDecoration(context, 'Frekuensi Cost'),
                items: const [
                  DropdownMenuItem(value: 'weekly', child: Text('Mingguan')),
                  DropdownMenuItem(value: 'monthly', child: Text('Bulanan')),
                ],
                onChanged: (value) {
                  if (value == null) {
                    return;
                  }
                  setState(() {
                    _frequency = value;
                    _dueOptions = _buildDueOptions(_frequency);
                    _selectedDueValue = _dueOptions.first.key;
                    if (_frequency == 'monthly') {
                      _selectedDueValue = DateTime.now().day;
                      _dueDateController.text = _monthlyDueText(
                        _selectedDueValue,
                      );
                    }
                  });
                },
              ),
            ],
            const SizedBox(height: AppSizes.spacing4),
            if (_frequency == 'weekly')
              DropdownButtonFormField<int>(
                initialValue: _selectedDueValue,
                decoration: _dropdownDecoration(context, 'Jatuh Tempo (Hari)'),
                items: _dueOptions
                    .map(
                      (item) => DropdownMenuItem(
                        value: item.key,
                        child: Text(item.value),
                      ),
                    )
                    .toList(growable: false),
                onChanged: (value) {
                  if (value == null) {
                    return;
                  }
                  setState(() => _selectedDueValue = value);
                },
              )
            else
              AppTextField(
                hint: 'Pilih tanggal jatuh tempo (bulan ini)',
                controller: _dueDateController,
                readOnly: true,
                prefixIcon: const Icon(
                  Icons.calendar_today_outlined,
                  color: AppColors.trunks,
                ),
                onTap: _handleDueDateTap,
              ),
            const SizedBox(height: AppSizes.spacing2),
            Row(
              children: [
                Text(
                  'Jatuh tempo yang lewat akan diabaikan.',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: AppColors.trunks),
                ),
                const SizedBox(width: AppSizes.spacing1),
                const Tooltip(
                  message:
                      'Jika tanggal sudah terlewat dalam siklus aktif, fixed cost tidak dihitung untuk proyeksi saat ini.',
                  child: Icon(
                    Icons.info_outline,
                    size: 16,
                    color: AppColors.trunks,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.spacing5),
            AppButton(text: 'Simpan', onPressed: _handleSave),
          ],
        ),
      ),
    );
  }

  InputDecoration _dropdownDecoration(BuildContext context, String labelText) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: Theme.of(
        context,
      ).textTheme.bodyMedium?.copyWith(color: AppColors.trunks),
      filled: true,
      fillColor: AppColors.gohan,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        borderSide: const BorderSide(color: AppColors.beerus, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        borderSide: const BorderSide(color: AppColors.bulma, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSizes.spacing4,
        vertical: AppSizes.spacing4,
      ),
    );
  }

  List<MapEntry<int, String>> _buildDueOptions(String frequency) {
    if (frequency == 'weekly') {
      return widget.weekdayOptions;
    }

    return List.generate(
      31,
      (index) => MapEntry(index + 1, 'Tanggal ${index + 1}'),
    );
  }

  Future<void> _handleDueDateTap() async {
    final pickedDate = await _pickDueDateInCurrentMonth(
      context,
      _selectedDueValue,
    );
    if (!mounted || pickedDate == null) {
      return;
    }

    setState(() {
      _selectedDueValue = pickedDate.day;
      _dueDateController.text = _monthlyDueText(_selectedDueValue);
    });
  }

  void _handleSave() {
    final name = _nameController.text.trim();
    final amount = CurrencyFormatter.parse(_amountController.text);

    if (name.isEmpty || amount <= 0) {
      ScaffoldMessenger.maybeOf(context)?.showSnackBar(
        const SnackBar(
          content: Text('Nama dan nominal pengeluaran wajib diisi'),
          backgroundColor: AppColors.danger100,
        ),
      );
      return;
    }

    widget.draftCubit.addFixedCost(
      name: name,
      amount: amount,
      category: _category,
      cycle: _frequency,
      dueValue: _selectedDueValue,
    );

    if (!mounted) {
      return;
    }
    context.pop();
  }

  Future<DateTime?> _pickDueDateInCurrentMonth(
    BuildContext context,
    int selectedDay,
  ) {
    final now = DateTime.now();
    final firstDate = DateTime(now.year, now.month, 1);
    final lastDate = DateTime(now.year, now.month + 1, 0);
    final initialDay = selectedDay.clamp(1, lastDate.day);

    return showDatePicker(
      context: context,
      initialDate: DateTime(now.year, now.month, initialDay),
      firstDate: firstDate,
      lastDate: lastDate,
      helpText: 'Pilih tanggal bulan ini',
      cancelText: 'Batal',
      confirmText: 'Pilih',
    );
  }

  String _monthlyDueText(int day) {
    return 'Tanggal $day';
  }
}
