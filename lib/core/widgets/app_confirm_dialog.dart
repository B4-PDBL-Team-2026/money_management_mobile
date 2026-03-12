import 'package:flutter/material.dart';
import 'package:money_management_mobile/core/widgets/app_button.dart';

class AppConfirmDialog extends StatelessWidget {
  final String title;
  final String content;
  final String confirmText;
  final String cancelText;
  final AppButtonType confirmButtonType;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;

  const AppConfirmDialog({
    super.key,
    required this.title,
    required this.content,
    this.confirmText = 'Konfirmasi',
    this.cancelText = 'Batal',
    this.confirmButtonType = AppButtonType.primary,
    this.onConfirm,
    this.onCancel,
  });

  /// Show the dialog and return true if confirmed, false if cancelled
  static Future<bool> show({
    required BuildContext context,
    required String title,
    required String content,
    String confirmText = 'Konfirmasi',
    String cancelText = 'Batal',
    AppButtonType confirmButtonType = AppButtonType.primary,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AppConfirmDialog(
        title: title,
        content: content,
        confirmText: confirmText,
        cancelText: cancelText,
        confirmButtonType: confirmButtonType,
      ),
    );

    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title,
        style: Theme.of(context).textTheme.headlineMedium,
      ),
      content: Text(
        content,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      actionsAlignment: MainAxisAlignment.end,
      actions: [
        SizedBox(
          width: 100,
          child: AppButton(
            onPressed: onCancel ?? () => Navigator.of(context).pop(false),
            text: cancelText,
            variant: AppButtonVariant.outlined,
          ),
        ),
        SizedBox(
          width: 100,
          child: AppButton(
            text: confirmText,
            onPressed: onConfirm ?? () => Navigator.of(context).pop(true),
            type: confirmButtonType,
          ),
        ),
      ],
    );
  }
}
