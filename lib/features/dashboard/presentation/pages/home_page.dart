import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_management_mobile/core/theme/app_sizes.dart';
import 'package:money_management_mobile/features/dashboard/presentation/cubits/dashboard_metric_cubit.dart';
import 'package:money_management_mobile/features/dashboard/presentation/cubits/dashboard_metric_state.dart';
import 'package:money_management_mobile/features/dashboard/presentation/widgets/dashboard_budget_metrics.dart';
import 'package:money_management_mobile/features/dashboard/presentation/widgets/dashboard_header.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppSizes.spacing6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocListener<DashboardMetricCubit, DashboardMetricState>(
                listener: (context, state) {
                  if (state is DashboardMetricError) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(state.message)));
                  }
                },
                child: Column(
                  children: [
                    DashboardHeader(),
                    const SizedBox(height: AppSizes.spacing6),
                    DashboardBudgetMetrics(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
