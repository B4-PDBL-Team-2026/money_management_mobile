import 'package:flutter/material.dart';
import 'package:money_management_mobile/core/theme/theme.dart';

class AppSnackBar {
  static void show({
    required BuildContext context,
    required String message,
    Color? backgroundColor,
    SnackBarAction? action,
  }) {
    // Menghitung safe area bottom padding dari layar
    final bottomPadding = MediaQuery.paddingOf(context).bottom;
    
    // Posisi di atas BottomNavigationBar
    // Jika tidak berada di halaman dengan navbar, bisa menggunakan padding standar.
    // Tapi karena kita ingin di atas navbar utama shell container:
    // shell_container.dart FAB memposisikan bottom: kBottomNavigationBarHeight + 16 + bottomPadding
    // Jadi agar snackbar sejajar dengan area di atas bottom navigation bar:
    final marginBottom = kBottomNavigationBarHeight + 16.0 + bottomPadding;

    final snackBar = SnackBar(
      content: Text(
        message,
        style: AppTextStyles.bodyMain.copyWith(
          color: AppColors.gohan,
          fontWeight: FontWeight.w600,
        ),
      ),
      backgroundColor: backgroundColor ?? AppColors.bulma,
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(
        bottom: marginBottom,
        left: 16.0,
        right: 16.0,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusNm),
      ),
      elevation: 3.0,
      action: action,
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  static void showSuccess(BuildContext context, String message) {
    show(
      context: context,
      message: message,
      backgroundColor: AppColors.success100,
    );
  }

  static void showError(
    BuildContext context,
    String message, {
    SnackBarAction? action,
  }) {
    show(
      context: context,
      message: message,
      backgroundColor: AppColors.danger100,
      action: action,
    );
  }

  static void showWarning(BuildContext context, String message) {
    show(
      context: context,
      message: message,
      backgroundColor: AppColors.warning100,
    );
  }
}
