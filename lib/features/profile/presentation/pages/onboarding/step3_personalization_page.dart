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
    final TextEditingController nameController = TextEditingController();
    final TextEditingController amountController = TextEditingController();
    final TextEditingController dueDateController = TextEditingController();
    String frequency = isMainCycleWeekly ? 'weekly' : 'monthly';
    String category = _expenseCategories.first;

    List<MapEntry<int, String>> dueOptions = _buildDueOptions(frequency);
    int selectedDueValue = dueOptions.first.key;
    if (!isMainCycleWeekly) {
      selectedDueValue = DateTime.now().day;
      dueDateController.text = _monthlyDueText(selectedDueValue);
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) => StatefulBuilder(
        builder: (modalContext, setModalState) => Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(modalContext).viewInsets.bottom,
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
                  style: Theme.of(modalContext).textTheme.headlineMedium
                      ?.copyWith(color: AppColors.primary),
                ),
                const SizedBox(height: AppSizes.spacing4),
                AppTextField(
                  hint: 'Nama biaya (contoh: WiFi)',
                  controller: nameController,
                  prefixIcon: const Icon(
                    Icons.receipt_outlined,
                    color: AppColors.trunks,
                  ),
                ),
                const SizedBox(height: AppSizes.spacing4),
                AppCurrencyTextField(
                  controller: amountController,
                  hint: 'Nominal',
                  prefixIcon: const Icon(
                    Icons.attach_money,
                    color: AppColors.trunks,
                  ),
                ),
                const SizedBox(height: AppSizes.spacing4),
                DropdownButtonFormField<String>(
                  initialValue: category,
                  decoration: _dropdownDecoration(modalContext, 'Kategori'),
                  items: _expenseCategories
                      .map(
                        (item) =>
                            DropdownMenuItem(value: item, child: Text(item)),
                      )
                      .toList(growable: false),
                  onChanged: (value) {
                    if (value == null) {
                      return;
                    }
                    setModalState(() => category = value);
                  },
                ),
                if (!isMainCycleWeekly) ...[
                  const SizedBox(height: AppSizes.spacing4),
                  DropdownButtonFormField<String>(
                    initialValue: frequency,
                    decoration: _dropdownDecoration(
                      modalContext,
                      'Frekuensi Cost',
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'weekly',
                        child: Text('Mingguan'),
                      ),
                      DropdownMenuItem(
                        value: 'monthly',
                        child: Text('Bulanan'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value == null) {
                        return;
                      }
                      setModalState(() {
                        frequency = value;
                        dueOptions = _buildDueOptions(frequency);
                        selectedDueValue = dueOptions.first.key;
                        if (frequency == 'monthly') {
                          selectedDueValue = DateTime.now().day;
                          dueDateController.text = _monthlyDueText(
                            selectedDueValue,
                          );
                        }
                      });
                    },
                  ),
                ],
                const SizedBox(height: AppSizes.spacing4),
                if (frequency == 'weekly')
                  DropdownButtonFormField<int>(
                    initialValue: selectedDueValue,
                    decoration: _dropdownDecoration(
                      modalContext,
                      'Jatuh Tempo (Hari)',
                    ),
                    items: dueOptions
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
                      setModalState(() => selectedDueValue = value);
                    },
                  )
                else
                  AppTextField(
                    hint: 'Pilih tanggal jatuh tempo (bulan ini)',
                    controller: dueDateController,
                    readOnly: true,
                    prefixIcon: const Icon(
                      Icons.calendar_today_outlined,
                      color: AppColors.trunks,
                    ),
                    onTap: () async {
                      final pickedDate = await _pickDueDateInCurrentMonth(
                        modalContext,
                        selectedDueValue,
                      );
                      if (pickedDate == null) {
                        return;
                      }

                      setModalState(() {
                        selectedDueValue = pickedDate.day;
                        dueDateController.text = _monthlyDueText(
                          selectedDueValue,
                        );
                      });
                    },
                  ),
                const SizedBox(height: AppSizes.spacing2),
                Row(
                  children: [
                    Text(
                      'Jatuh tempo yang lewat akan diabaikan.',
                      style: Theme.of(
                        modalContext,
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
                AppButton(
                  text: 'Simpan',
                  onPressed: () {
                    final name = nameController.text.trim();
                    final amount = CurrencyFormatter.parse(
                      amountController.text,
                    );

                    if (name.isEmpty || amount <= 0) {
                      _showError('Nama dan nominal pengeluaran wajib diisi');
                      return;
                    }

                    draftCubit.addFixedCost(
                      name: name,
                      amount: amount,
                      category: category,
                      cycle: frequency,
                      dueValue: selectedDueValue,
                    );

                    modalContext.pop();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    ).whenComplete(() {
      nameController.dispose();
      amountController.dispose();
      dueDateController.dispose();
    });
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

  String _apiCycleToLabel(String cycle) {
    return cycle == 'weekly' ? 'Mingguan' : 'Bulanan';
  }

  String _buildDueLabel({required int dueValue, required String frequency}) {
    if (frequency == 'weekly') {
      return _weekdayOptions.firstWhere((item) => item.key == dueValue).value;
    }

    return 'Tanggal $dueValue';
  }

  List<MapEntry<int, String>> _buildDueOptions(String frequency) {
    if (frequency == 'weekly') {
      return _weekdayOptions;
    }

    return List.generate(
      31,
      (index) => MapEntry(index + 1, 'Tanggal ${index + 1}'),
    );
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
    return 'Tanggal $day bulan ini';
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

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColors.danger100),
    );
  }
}
