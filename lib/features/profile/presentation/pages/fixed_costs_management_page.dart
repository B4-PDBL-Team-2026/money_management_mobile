import 'package:flutter/material.dart';
import 'package:money_management_mobile/core/theme/app_colors.dart';
import 'package:money_management_mobile/core/theme/app_sizes.dart';
import 'package:money_management_mobile/features/profile/presentation/widgets/active_fixed_cost_item_card.dart';
import 'package:money_management_mobile/features/profile/presentation/widgets/manage_fixed_cost_bottom_sheet.dart';

class FixedCostsManagementPage extends StatefulWidget {
  const FixedCostsManagementPage({super.key});

  @override
  State<FixedCostsManagementPage> createState() =>
      _FixedCostsManagementPageState();
}

class _FixedCostsManagementPageState extends State<FixedCostsManagementPage> {
  // Mock data berdasarkan API response
  final List<Map<String, dynamic>> _fixedCosts = [
    {
      'id': 1,
      'name': 'WiFi',
      'category_type': 'Utilitas',
      'cycle_type': 'Mingguan',
      'due_date': '2026-04-05',
      'status': FixedCostStatus.pending,
      'amount': 'Rp 100.000',
    },
    {
      'id': 2,
      'name': 'Asuransi',
      'category_type': 'Kesehatan',
      'cycle_type': 'Bulanan',
      'due_date': '2026-04-10',
      'status': FixedCostStatus.paid,
      'amount': 'Rp 500.000',
    },
    {
      'id': 3,
      'name': 'Langganan Musik',
      'category_type': 'Entertain',
      'cycle_type': 'Mingguan',
      'due_date': '2026-03-31',
      'status': FixedCostStatus.overdue,
      'amount': 'Rp 50.000',
    },
    {
      'id': 4,
      'name': 'Gym',
      'category_type': 'Kesehatan',
      'cycle_type': 'Bulanan',
      'due_date': '2026-04-15',
      'status': FixedCostStatus.pending,
      'amount': 'Rp 150.000',
    },
    {
      'id': 5,
      'name': 'Tagihan Air',
      'category_type': 'Utilitas',
      'cycle_type': 'Bulanan',
      'due_date': '2026-03-25',
      'status': FixedCostStatus.skipped,
      'amount': 'Rp 75.000',
    },
  ];

  void _showAddFixedCostBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => const ManageFixedCostBottomSheet(),
    );
  }

  void _showEditFixedCostBottomSheet(Map<String, dynamic> fixedCost) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => ManageFixedCostBottomSheet(
        isEditing: true,
        initialName: fixedCost['name'] as String,
        initialAmount: fixedCost['amount'] as String,
        initialCategory: fixedCost['category_type'] as String,
        initialCycleType: fixedCost['cycle_type'] as String,
        initialDueDate: fixedCost['due_date'] as String,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: const Text('Fixed Cost Management'),
            pinned: true,
            elevation: 0,
          ),
          SliverPadding(
            padding: const EdgeInsets.all(AppSizes.spacing6),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final fixedCost = _fixedCosts[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSizes.spacing4),
                  child: ActiveFixedCostItemCard(
                    name: fixedCost['name'] as String,
                    category: fixedCost['category_type'] as String,
                    cycleType: fixedCost['cycle_type'] as String,
                    dueDate: fixedCost['due_date'] as String,
                    amount: fixedCost['amount'] as String,
                    status: fixedCost['status'] as FixedCostStatus,
                    showEditAction: true,
                    showDeleteAction: true,
                    onEdit: () => _showEditFixedCostBottomSheet(fixedCost),
                    onDelete: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Delete ${fixedCost['name']} - Coming soon',
                          ),
                        ),
                      );
                    },
                  ),
                );
              }, childCount: _fixedCosts.length),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddFixedCostBottomSheet,
        backgroundColor: AppColors.secondary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppSizes.radiusLg)),
          side: BorderSide(color: AppColors.bulma, width: 1),
        ),
        child: Icon(Icons.add, color: AppColors.bulma),
      ),
    );
  }
}
