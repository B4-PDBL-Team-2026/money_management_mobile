import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_management_mobile/core/theme/theme.dart';
import 'package:money_management_mobile/core/widgets/widgets.dart';
import 'package:money_management_mobile/features/category/presentation/cubit/category_cubit.dart';
import 'package:money_management_mobile/features/category/presentation/cubit/category_state.dart';

class OuterShell extends StatelessWidget {
  final Widget child;

  const OuterShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocListener<CategoryCubit, CategoryState>(
      listener: (context, state) {
        if (state is CategoryErrorAndRetry) {
          AppSnackBar.showError(
            context,
            state.message,
            action: SnackBarAction(
              label: 'Retry',
              textColor: AppColors.gohan,
              onPressed: state.onRetry,
            ),
          );
        }
      },
      child: Scaffold(body: child),
    );
  }
}
