import 'package:dio/dio.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:money_management_mobile/core/constants/app_env.dart';
import 'package:money_management_mobile/core/events/app_events.dart';
import 'package:money_management_mobile/core/routes/app_router.dart';
import 'package:money_management_mobile/core/theme/theme.dart';
import 'package:money_management_mobile/core/utils/utils.dart';
import 'package:money_management_mobile/core/widgets/widgets.dart';
import 'package:money_management_mobile/features/auth/presentation/cubit/reset_password_cubit.dart';
import 'package:money_management_mobile/features/auth/presentation/cubit/reset_password_state.dart';
import 'package:money_management_mobile/features/auth/presentation/cubit/session_cubit.dart';
import 'package:money_management_mobile/features/auth/presentation/cubit/session_state.dart';
import 'package:money_management_mobile/features/auth/presentation/cubit/verify_email_cubit.dart';
import 'package:money_management_mobile/features/auth/presentation/cubit/verify_email_state.dart';
import 'package:money_management_mobile/features/category/presentation/cubit/category_cubit.dart';
import 'package:money_management_mobile/features/dashboard/presentation/cubits/dashboard_metric_cubit.dart';
import 'package:money_management_mobile/features/dashboard/presentation/cubits/dashboard_metric_state.dart';
import 'package:money_management_mobile/features/dashboard/presentation/widgets/other_profile_card.dart';
import 'package:money_management_mobile/features/dashboard/presentation/widgets/other_settings_card.dart';
import 'package:money_management_mobile/features/dashboard/presentation/widgets/other_settings_tile.dart';
import 'package:money_management_mobile/features/notification/presentation/cubit/notification_cubit.dart';
import 'package:money_management_mobile/features/profile/presentation/cubit/update_budget_limits_cubit.dart';
import 'package:money_management_mobile/features/profile/presentation/cubit/update_budget_limits_state.dart';
import 'package:money_management_mobile/injection_container.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class OtherPage extends StatefulWidget {
  const OtherPage({super.key});

  @override
  State<OtherPage> createState() => _OtherPageState();
}

class _OtherPageState extends State<OtherPage> {
  bool _isEditMode = false;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _ceilingController = TextEditingController();
  final TextEditingController _flooringController = TextEditingController();

  @override
  void dispose() {
    _ceilingController.dispose();
    _flooringController.dispose();
    super.dispose();
  }

  Future<void> _onChangePasswordTap(BuildContext context) async {
    final sessionState = context.read<SessionCubit>().state;

    if (sessionState is! SessionAuthenticated) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sesi kamu udah nggak valid. Login lagi ya.'),
          backgroundColor: AppColors.danger100,
        ),
      );
      return;
    }

    await context.read<ResetPasswordCubit>().sendVerificationEmail(
      email: sessionState.user.email,
    );
  }

  Future<void> _onVerifyEmailTap(BuildContext context) async {
    final sessionState = context.read<SessionCubit>().state;

    if (sessionState is! SessionAuthenticated) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sesi kamu udah nggak valid. Login lagi ya.'),
          backgroundColor: AppColors.danger100,
        ),
      );
      return;
    }

    if (sessionState.user.emailVerifiedAt != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email kamu sudah terverifikasi.'),
          backgroundColor: AppColors.success100,
        ),
      );
      return;
    }

    await context.read<VerifyEmailCubit>().requestVerificationEmail();
  }

  void _showLoadingDialog(BuildContext context, {required String message}) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          content: Row(
            children: [
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2.2),
              ),
              const SizedBox(width: AppSizes.spacing4),
              Expanded(child: Text(message)),
            ],
          ),
        );
      },
    );
  }

  void _closeDialogIfOpen(BuildContext context) {
    final rootNavigator = Navigator.of(context, rootNavigator: true);
    if (rootNavigator.canPop()) {
      rootNavigator.pop();
    }
  }

  Future<void> _showSuccessDialog(
    BuildContext context, {
    required String title,
    required String message,
  }) async {
    await AppConfirmDialog.show(
      context: context,
      title: title,
      content: '$message\n\nCek inbox atau folder spam ya.',
      confirmText: 'Mengerti',
      cancelText: 'Tutup',
      confirmButtonType: AppButtonType.primary,
    );
  }

  Future<void> _onLogoutTap(BuildContext context) async {
    final confirmed = await AppConfirmDialog.show(
      context: context,
      title: 'Keluar dari akun?',
      content: 'Sesi login bakal dihapus dari perangkat ini.',
      confirmText: 'Keluar',
      cancelText: 'Batal',
      confirmButtonType: AppButtonType.danger,
    );

    if (!confirmed || !context.mounted) {
      return;
    }

    try {
      await context.read<NotificationCubit>().unregisterCurrentDevice();
    } catch (_) {
      if (!context.mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: AppColors.danger100,
          content: Text(
            'Gagal batalin pendaftaran perangkat. Logout dibatalkan.',
            style: TextStyle(color: AppColors.gohan),
          ),
        ),
      );

      return;
    }

    try {
      if (!context.mounted) {
        return;
      }
      
      await context.read<CategoryCubit>().clearCategories();
    } catch (_) {
      if (!context.mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: AppColors.danger100,
          content: Text(
            'Gagal bersihin kategori. Logout dibatalkan.',
            style: TextStyle(color: AppColors.gohan),
          ),
        ),
      );

      return;
    }

    if (context.mounted) {
      await context.read<SessionCubit>().logout();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Ambil data limit & hari ini dari DashboardMetricCubit
    final dashboardState = context.watch<DashboardMetricCubit>().state;
    
    int safetyCeiling = 100000;
    int safetyFlooring = 30000;

    if (dashboardState is DashboardMetricLoaded) {
      safetyCeiling = dashboardState.metrics.safetyCeiling;
      safetyFlooring = dashboardState.metrics.safetyFlooring;
    }

    // Format nilai Min & Max agar presisi dengan "RP X" di Mockup Figma
    final formattedMin = 'RP ${CurrencyFormatter.format(safetyFlooring).replaceAll('Rp', '').trim()}';
    final formattedMax = 'RP ${CurrencyFormatter.format(safetyCeiling).replaceAll('Rp', '').trim()}';

    return Scaffold(
      backgroundColor: AppColors.gohan,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.spacing6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Profil & Pengaturan',
                style: Theme.of(
                  context,
                ).textTheme.headlineLarge?.copyWith(color: AppColors.primary),
              ),
              const SizedBox(height: AppSizes.spacing6),
              const OtherProfileCard(),
              const SizedBox(height: AppSizes.spacing6),

              // SECTION 1: KEUANGAN (Mockup Figma)
              Text(
                'KEUANGAN',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.trunks,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.1,
                ),
              ),
              const SizedBox(height: AppSizes.spacing4),

              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _isEditMode
                    ? AppContainerCard(
                        key: const ValueKey('edit_mode_card'),
                        backgroundColor: AppColors.gohan,
                        border: Border.all(color: AppColors.beerus, width: 1.5),
                        padding: const EdgeInsets.all(AppSizes.spacing5),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Header Row (Sesuai Gambar 2 Figma)
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(AppSizes.spacing2),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                                    ),
                                    child: const Icon(
                                      Icons.edit_outlined,
                                      color: AppColors.primary,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: AppSizes.spacing3),
                                  Text(
                                    'Edit Batas Budget',
                                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.bulma,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppSizes.spacing1),
                              Text(
                                'Sesuaikan alokasi budget harian sesuai kebutuhan Anda',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppColors.trunks,
                                ),
                              ),
                              const SizedBox(height: AppSizes.spacing5),

                              // Maksimal Input (Sesuai Gambar 2 Figma)
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: const Icon(
                                      Icons.arrow_upward_rounded,
                                      color: AppColors.primary,
                                      size: 14,
                                    ),
                                  ),
                                  const SizedBox(width: AppSizes.spacing2),
                                  Text(
                                    'Maksimal Alokasi Budget Harian',
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.bulma,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppSizes.spacing2),
                              AppCurrencyTextField(
                                controller: _ceilingController,
                                max: 1000000000,
                                hint: 'Rp. 0',
                                validator: (value) {
                                  if (value == null) {
                                    return requiredFieldMessage('Batas atas');
                                  }
                                  if (value <= 0) {
                                    return positiveNumberMessage('Batas atas');
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: AppSizes.spacing4),

                              // Minimal Input (Sesuai Gambar 2 Figma)
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: const Icon(
                                      Icons.arrow_downward_rounded,
                                      color: AppColors.primary,
                                      size: 14,
                                    ),
                                  ),
                                  const SizedBox(width: AppSizes.spacing2),
                                  Text(
                                    'Minimal Alokasi Budget Harian',
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.bulma,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppSizes.spacing2),
                              AppCurrencyTextField(
                                controller: _flooringController,
                                max: 1000000000,
                                hint: 'Rp. 0',
                                validator: (value) {
                                  if (value == null) {
                                    return requiredFieldMessage('Batas bawah');
                                  }
                                  if (value <= 0) {
                                    return positiveNumberMessage('Batas bawah');
                                  }

                                  final ceilingLimit = CurrencyFormatter.parse(
                                    _ceilingController.text,
                                  );
                                  if (value > ceilingLimit) {
                                    return 'Batas bawah tidak boleh melebihi batas atas';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: AppSizes.spacing6),

                              // Button Row (Mengatasi Bug Overflow Menggunakan Outlined Variant & overflow: true)
                              BlocConsumer<UpdateBudgetLimitsCubit, UpdateBudgetLimitsState>(
                                listener: (context, state) {
                                  if (state is UpdateBudgetLimitsSuccess) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Batas budget harian berhasil diperbarui.'),
                                        backgroundColor: AppColors.success100,
                                      ),
                                    );
                                    setState(() {
                                      _isEditMode = false;
                                    });
                                    context.read<UpdateBudgetLimitsCubit>().reset();
                                  } else if (state is UpdateBudgetLimitsFailure) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(state.message),
                                        backgroundColor: AppColors.danger100,
                                      ),
                                    );
                                  }
                                },
                                builder: (context, state) {
                                  final isLoading = state is UpdateBudgetLimitsLoading;
                                  return Row(
                                    children: [
                                      Expanded(
                                        child: AppButton(
                                          text: 'Batal',
                                          variant: AppButtonVariant.outlined,
                                          onPressed: isLoading
                                              ? null
                                              : () {
                                                  setState(() {
                                                    _isEditMode = false;
                                                  });
                                                },
                                        ),
                                      ),
                                      const SizedBox(width: AppSizes.spacing3),
                                      Expanded(
                                        child: AppButton(
                                          text: 'Simpan',
                                          isLoading: isLoading,
                                          onPressed: () {
                                            if (_formKey.currentState?.validate() ?? false) {
                                              final parsedCeiling = CurrencyFormatter.parse(
                                                _ceilingController.text,
                                              );
                                              final parsedFlooring = CurrencyFormatter.parse(
                                                _flooringController.text,
                                              );
                                              context.read<UpdateBudgetLimitsCubit>().updateLimits(
                                                    safetyCeiling: parsedCeiling,
                                                    safetyFlooring: parsedFlooring,
                                                  );
                                            }
                                          },
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      )
                    : AppContainerCard(
                        key: const ValueKey('view_mode_card'),
                        backgroundColor: AppColors.gohan,
                        border: Border.all(color: AppColors.beerus, width: 1.5),
                        padding: const EdgeInsets.all(AppSizes.spacing5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 1. Header Card Row (Sesuai Gambar 1 Figma, Chevron Kanan Dihapus)
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(AppSizes.spacing2),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                                  ),
                                  child: const Icon(
                                    Icons.track_changes_outlined,
                                    color: AppColors.primary,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: AppSizes.spacing3),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Batas Budget Harian',
                                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.bulma,
                                        ),
                                      ),
                                      const SizedBox(height: 1),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _isEditMode = true;
                                            _ceilingController.text = CurrencyFormatter.format(safetyCeiling);
                                            _flooringController.text = CurrencyFormatter.format(safetyFlooring);
                                          });
                                        },
                                        child: Text(
                                          'Atur alokasi budget harian Anda',
                                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                            color: AppColors.primary,
                                            decoration: TextDecoration.underline,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 11,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: AppSizes.spacing4),

                            // 2. Nested Grey Container (Sesuai Gambar 1 Figma, Diselaraskan dengan Gambar 2)
                            Container(
                              padding: const EdgeInsets.all(AppSizes.spacing4),
                              decoration: BoxDecoration(
                                color: AppColors.beerus.withValues(alpha: 0.25),
                                borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                                border: Border.all(color: AppColors.beerus, width: 1),
                              ),
                              child: Column(
                                children: [
                                  // Row of Stacked Allocations (Left) and Edit Button (Right)
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      // Stacked Allocations
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            // 1. Minimal Alokasi (Sesuai Desain Gambar 2)
                                            Row(
                                              children: [
                                                Container(
                                                  padding: const EdgeInsets.all(3),
                                                  decoration: BoxDecoration(
                                                    color: AppColors.primary.withValues(alpha: 0.1),
                                                    borderRadius: BorderRadius.circular(4),
                                                  ),
                                                  child: const Icon(
                                                    Icons.arrow_downward_rounded,
                                                    color: AppColors.primary,
                                                    size: 11,
                                                  ),
                                                ),
                                                const SizedBox(width: AppSizes.spacing2),
                                                Expanded(
                                                  child: Text(
                                                    'Minimal Alokasi Budget Harian',
                                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                      color: AppColors.trunks,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 10,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 2),
                                            Padding(
                                              padding: const EdgeInsets.only(left: 22),
                                              child: Text(
                                                formattedMin,
                                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color: AppColors.primary,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: AppSizes.spacing3),

                                            // 2. Maksimal Alokasi (Sesuai Desain Gambar 2)
                                            Row(
                                              children: [
                                                Container(
                                                  padding: const EdgeInsets.all(3),
                                                  decoration: BoxDecoration(
                                                    color: AppColors.primary.withValues(alpha: 0.1),
                                                    borderRadius: BorderRadius.circular(4),
                                                  ),
                                                  child: const Icon(
                                                    Icons.arrow_upward_rounded,
                                                    color: AppColors.primary,
                                                    size: 11,
                                                  ),
                                                ),
                                                const SizedBox(width: AppSizes.spacing2),
                                                Expanded(
                                                  child: Text(
                                                    'Maksimal Alokasi Budget Harian',
                                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                      color: AppColors.trunks,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 10,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 2),
                                            Padding(
                                              padding: const EdgeInsets.only(left: 22),
                                              child: Text(
                                                formattedMax,
                                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color: AppColors.bulma,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: AppSizes.spacing3),

                                      // Edit Button - Diposisikan di Pojok Kanan Tengah yang Bagus (Sesuai Gambar 1 & Gambar 2)
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _isEditMode = true;
                                            _ceilingController.text = CurrencyFormatter.format(safetyCeiling);
                                            _flooringController.text = CurrencyFormatter.format(safetyFlooring);
                                          });
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(AppSizes.spacing3),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                                            border: Border.all(color: AppColors.primary, width: 1.5),
                                          ),
                                          child: const Icon(
                                            Icons.arrow_forward_ios_rounded,
                                            color: AppColors.primary,
                                            size: 14,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
              const SizedBox(height: AppSizes.spacing8),

              // SECTION 2: AKUN
              Text(
                'AKUN',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.trunks,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.1,
                ),
              ),
              const SizedBox(height: AppSizes.spacing4),

              OtherSettingsCard(
                children: [
                  BlocConsumer<ResetPasswordCubit, ResetPasswordState>(
                    listener: (context, state) async {
                      if (state is ResetPasswordLoading) {
                        _showLoadingDialog(
                          context,
                          message: 'Lagi ngirim email reset password...',
                        );
                        return;
                      }

                      if (state is ResetPasswordSuccess) {
                        _closeDialogIfOpen(context);
                        await _showSuccessDialog(
                          context,
                          title: 'Reset password terkirim',
                          message:
                              'Email reset password sudah dikirim. Cek inbox atau folder spam ya.',
                        );
                        return;
                      }

                      if (state is ResetPasswordError) {
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
                    builder: (context, state) => Column(
                      children: [
                        OtherSettingsTile(
                          icon: Icons.lock_outline,
                          title: 'Ganti Password',
                          subtitle: 'Perbarui keamanan akunmu',
                          iconBackground: AppColors.lightPrimary,
                          iconColor: AppColors.primary,
                          onTap: () => _onChangePasswordTap(context),
                        ),
                        Divider(
                          height: 1,
                          thickness: 1,
                          color: AppColors.beerus,
                        ),
                      ],
                    ),
                  ),
                  BlocConsumer<VerifyEmailCubit, VerifyEmailState>(
                    listener: (context, state) async {
                      if (state is VerifyEmailLoading) {
                        _showLoadingDialog(
                          context,
                          message: 'Lagi ngirim email verifikasi...',
                        );
                        return;
                      }

                      if (state is VerifyEmailSuccess) {
                        _closeDialogIfOpen(context);
                        await _showSuccessDialog(
                          context,
                          title: 'Verifikasi email terkirim',
                          message:
                              'Email verifikasi sudah dikirim. Cek inbox atau folder spam ya.',
                        );
                        return;
                      }

                      if (state is VerifyEmailError) {
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
                    builder: (context, _) {
                      final sessionState = context.watch<SessionCubit>().state;
                      final isVerified =
                          sessionState is SessionAuthenticated &&
                          sessionState.user.emailVerifiedAt != null;

                      if (isVerified) {
                        return const SizedBox.shrink();
                      }

                      return Column(
                        children: [
                          OtherSettingsTile(
                            icon: Icons.email_outlined,
                            title: 'Verifikasi Email',
                            subtitle:
                                'Tingkatkan keamanan akun dengan verifikasi email',
                            iconBackground: AppColors.lightPrimary,
                            iconColor: AppColors.primary,
                            onTap: () => _onVerifyEmailTap(context),
                          ),
                          Divider(
                            height: 1,
                            thickness: 1,
                            color: AppColors.beerus,
                          ),
                        ],
                      );
                    },
                  ),
                  OtherSettingsTile(
                    icon: PhosphorIconsRegular.userMinus,
                    title: 'Hapus Akun',
                    subtitle: 'Hapus akun ini secara permanen',
                    iconBackground: AppColors.danger10,
                    iconColor: AppColors.danger100,
                    onTap: () => context.go(AppRouter.deleteAccount),
                  ),
                  OtherSettingsTile(
                    icon: Icons.logout,
                    title: 'Keluar',
                    subtitle: 'Logout dari akun ini',
                    iconBackground: AppColors.danger10,
                    iconColor: AppColors.danger100,
                    onTap: () => _onLogoutTap(context),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.spacing8),
            ],
          ),
        ),
      ),
    );
  }
}
