import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:money_management_mobile/core/routes/app_router.dart';
import 'package:money_management_mobile/core/theme/app_colors.dart';
import 'package:money_management_mobile/core/theme/app_sizes.dart';
import 'package:money_management_mobile/core/widgets/app_alert.dart';
import 'package:money_management_mobile/core/widgets/app_button.dart';
import 'package:money_management_mobile/core/widgets/app_text_field.dart';
import 'package:money_management_mobile/core/widgets/app_currency_text_field.dart';
import 'package:money_management_mobile/features/auth/presentation/widgets/step_progress_indicator.dart';

class Step2PersonalizationPage extends StatefulWidget {
  const Step2PersonalizationPage({super.key});

  @override
  State<Step2PersonalizationPage> createState() =>
      _Step2PersonalizationPageState();
}

class _Step2PersonalizationPageState extends State<Step2PersonalizationPage> {
  final List<Map<String, dynamic>> _fixedCosts = [
    {"name": "Kos Bulanan", "amount": "Rp 1.500.000", "isIn": true},
  ];

  void _deleteItem(int index) {
    setState(() {
      _fixedCosts.removeAt(index);
    });
  }

  void _showAddExpenseBottomSheet() {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController amountController = TextEditingController();
    bool isIn = true;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
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
                  "Tambah Pengeluaran Tetap",
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: AppSizes.spacing5),
                AppTextField(
                  hint: "Nama Pengeluaran",
                  controller: nameController,
                  prefixIcon: const Icon(
                    Icons.receipt_outlined,
                    color: AppColors.trunks,
                  ),
                ),
                const SizedBox(height: AppSizes.spacing4),
                AppCurrencyTextField(
                  controller: amountController,
                  hint: "Nominal (RP)",
                  prefixIcon: const Icon(
                    Icons.attach_money,
                    color: AppColors.trunks,
                  ),
                ),
                const SizedBox(height: AppSizes.spacing4),
                Text(
                  "Status",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 14,
                    color: AppColors.trunks,
                  ),
                ),
                const SizedBox(height: AppSizes.spacing2),
                Row(
                  children: [
                    Expanded(
                      child: _buildStatusButton(
                        context: context,
                        label: "In",
                        isSelected: isIn,
                        onTap: () => setModalState(() => isIn = true),
                      ),
                    ),
                    const SizedBox(width: AppSizes.spacing3),
                    Expanded(
                      child: _buildStatusButton(
                        context: context,
                        label: "Out",
                        isSelected: !isIn,
                        onTap: () => setModalState(() => isIn = false),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSizes.spacing3),
                const AppAlert(
                  message: "In akan memotong saldo, Out hanya catatan",
                  padding: EdgeInsets.all(AppSizes.spacing3),
                  iconSize: 16,
                ),
                const SizedBox(height: AppSizes.spacing5),
                AppButton(
                  text: "Simpan",
                  onPressed: () {
                    if (nameController.text.isNotEmpty &&
                        amountController.text.isNotEmpty) {
                      setState(() {
                        _fixedCosts.add({
                          "name": nameController.text,
                          "amount": amountController.text,
                          "isIn": isIn,
                        });
                      });
                      Navigator.pop(context);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Transform.translate(
          offset: const Offset(AppSizes.spacing4, 0),
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.spacing2),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(AppSizes.radiusNm),
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: AppColors.gohan,
                  size: 20,
                ),
                onPressed: () => context.pop(),
              ),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppSizes.spacing5),
            child: SvgPicture.asset('assets/svg/single_logo.svg', height: 40),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.spacing6),
          child: Column(
            children: [
              const StepProgressIndicator(
                currentStep: 2,
                totalSteps: 3,
              ),
              const SizedBox(height: AppSizes.spacing6),
              Text(
                "Fixed Cost",
                style: Theme.of(
                  context,
                ).textTheme.displayMedium?.copyWith(color: AppColors.primary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSizes.spacing4),
              Text(
                "Catat pengeluaran tetap bulananmu (kos, langganan, cicilan).",
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: AppColors.trunks),
              ),
              const SizedBox(height: AppSizes.spacing4),
              const AppAlert(
                messages: [
                  "In: Memotong saldo di aplikasi.",
                  "Out: Hanya catatan (tidak memotong saldo).",
                ],
              ),
              const SizedBox(height: AppSizes.spacing4),
              AppButton(
                text: "Tambah Pengeluaran",
                onPressed: () {
                  _showAddExpenseBottomSheet();
                },
                variant: AppButtonVariant.outlined,
              ),
              const SizedBox(height: AppSizes.spacing4),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _fixedCosts.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: AppSizes.spacing4),
                itemBuilder: (context, index) {
                  final item = _fixedCosts[index];

                  return _buildFixedCostItem(
                    item["name"],
                    item["amount"],
                    item["isIn"],
                    () => _deleteItem(index),
                  );
                },
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(AppSizes.spacing6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppButton(
              text: "Lanjut Ke Langkah 3",
              onPressed: () {
                context.go(AppRouter.dashboard);
              },
            ),
            const SizedBox(height: AppSizes.spacing3),
            AppButton(
              text: "Lewatkan",
              onPressed: () {
                context.go(AppRouter.dashboard);
              },
              variant: AppButtonVariant.ghost,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFixedCostItem(
    String name,
    String price,
    bool isIn,
    VoidCallback onDelete,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.spacing4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSizes.radiusNm),
        border: Border.all(color: AppColors.beerus),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Nama Pengeluaran",
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: AppColors.trunks),
              ),
              IconButton(
                icon: const Icon(
                  Icons.delete_outline,
                  color: AppColors.danger100,
                  size: 20,
                ),
                onPressed: onDelete,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.spacing1),
          Text(name, style: Theme.of(context).textTheme.titleLarge),
          const Divider(height: AppSizes.spacing5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Nominal (Rp)",
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: AppColors.trunks),
                  ),
                  const SizedBox(height: AppSizes.spacing1),
                  Text(price, style: Theme.of(context).textTheme.titleLarge),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "Status",
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: AppColors.trunks),
                  ),
                  const SizedBox(height: AppSizes.spacing1),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.spacing3,
                      vertical: AppSizes.spacing1,
                    ),
                    decoration: BoxDecoration(
                      color: isIn ? AppColors.primary : AppColors.gohan,
                      borderRadius: BorderRadius.circular(AppSizes.spacing5),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          isIn ? "In" : "Out",
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: isIn
                                    ? AppColors.gohan
                                    : AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(width: AppSizes.spacing1),
                        Icon(
                          Icons.check_circle,
                          color: isIn ? AppColors.gohan : AppColors.primary,
                          size: 14,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusButton({
    required BuildContext context,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSizes.spacing4),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.gohan,
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          border: Border.all(color: AppColors.primary, width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle,
              color: isSelected ? AppColors.gohan : AppColors.primary,
              size: 18,
            ),
            const SizedBox(width: AppSizes.spacing2),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: isSelected ? AppColors.gohan : AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
