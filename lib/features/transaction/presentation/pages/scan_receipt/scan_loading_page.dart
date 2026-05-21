import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:money_management_mobile/core/routes/app_router.dart';
import 'package:money_management_mobile/core/theme/theme.dart';
import 'package:money_management_mobile/features/transaction/presentation/cubit/receipt_scanner_cubit.dart';
import 'package:money_management_mobile/features/transaction/presentation/cubit/receipt_scanner_state.dart';
import 'package:money_management_mobile/injection_container.dart';

class ScanLoadingPage extends StatelessWidget {
  final File imageFile;

  const ScanLoadingPage({super.key, required this.imageFile});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ReceiptScannerCubit>()..processReceipt(imageFile),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BlocConsumer<ReceiptScannerCubit, ReceiptScannerState>(
          listener: (context, state) {
            if (state is ReceiptScannerSuccess) {
              context.pushReplacement(
                AppRouter.addBatchTransaction,
                extra: state.scannedItems,
              );
            } else if (state is ReceiptScannerError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
              context.pop(); 
            }
          },
          builder: (context, state) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(color: AppColors.primary),
                  const SizedBox(height: 24),
                  Text(
                    'Sedang membaca struk...',
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: AppColors.bulma,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
