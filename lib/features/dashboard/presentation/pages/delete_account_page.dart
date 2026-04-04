import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_management_mobile/core/theme/app_colors.dart';
import 'package:money_management_mobile/core/theme/app_sizes.dart';
import 'package:money_management_mobile/core/widgets/app_button.dart';
import 'package:money_management_mobile/core/widgets/app_text_field.dart';
import 'package:money_management_mobile/features/dashboard/presentation/cubits/delete_account_cubit.dart';
import 'package:money_management_mobile/features/dashboard/presentation/cubits/delete_account_state.dart';

class DeleteAccountPage extends StatefulWidget {
  const DeleteAccountPage({super.key});

  @override
  State<DeleteAccountPage> createState() => _DeleteAccountPageState();
}

class _DeleteAccountPageState extends State<DeleteAccountPage> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();

  void _closeDialogIfOpen(BuildContext context) {
    final rootNavigator = Navigator.of(context, rootNavigator: true);

    if (rootNavigator.canPop()) {
      rootNavigator.pop();
    }
  }

  void _showLoadingDialog(BuildContext context, {required String message}) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          content: Row(
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2.2),
              ),
              SizedBox(width: AppSizes.spacing4),
              Expanded(child: Text(message)),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hapus Akun')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppSizes.spacing6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hapus Akun',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: AppSizes.spacing4),
              const Text(
                'Apakah Anda yakin ingin menghapus akun Anda? Tindakan ini tidak dapat dibatalkan. Semua data Anda akan dihapus secara permanen.',
              ),
              const SizedBox(height: AppSizes.spacing10),
              BlocConsumer<DeleteAccountCubit, DeleteAccountState>(
                listener: (context, state) {
                  if (state is DeleteAccountLoading) {
                    _showLoadingDialog(context, message: 'Menghapus akun...');
                    return;
                  }

                  _closeDialogIfOpen(context);

                  if (state is DeleteAccountSuccess) {
                    Navigator.of(context).pop();
                  } else if (state is DeleteAccountError) {
                    _closeDialogIfOpen(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: AppColors.danger100,
                        content: Text(
                          state.message,
                          style: const TextStyle(color: AppColors.gohan),
                        ),
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  final serverErrors = state is DeleteAccountValidationError
                      ? state.fieldError
                      : null;

                  return Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppTextField(
                          controller: _passwordController,
                          label: 'Masukkan password Anda untuk konfirmasi',
                          hint: 'Password',
                          isPassword: true,
                          errorText: serverErrors?['password']?[0],
                          validator: (password) {
                            if (password == null || password.isEmpty) {
                              return "Password wajib diisi.";
                            }

                            if (password.length < 8) {
                              return "Password minimal 8 karakter.";
                            }

                            return null;
                          },
                        ),
                        const SizedBox(height: AppSizes.spacing10),
                        Row(
                          children: [
                            Expanded(
                              child: AppButton(
                                text: 'Batal',
                                variant: AppButtonVariant.outlined,
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                            ),
                            const SizedBox(width: AppSizes.spacing4),
                            Expanded(
                              child: AppButton(
                                text: 'Hapus Akun',
                                type: AppButtonType.danger,
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    context
                                        .read<DeleteAccountCubit>()
                                        .deleteAccount(
                                          _passwordController.text,
                                        );
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
