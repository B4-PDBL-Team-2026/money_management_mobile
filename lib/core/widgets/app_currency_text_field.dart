import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:money_management_mobile/core/theme/theme.dart';
import 'package:money_management_mobile/core/utils/utils.dart';

class AppCurrencyTextField extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final String? label;
  final String? Function(String?)? validator;
  final Widget? prefixIcon;
  final void Function(String)? onChanged;
  final TextAlign textAlign;
  final String? errorText;
  final bool? isDisabled;

  const AppCurrencyTextField({
    super.key,
    required this.hint,
    required this.controller,
    this.label,
    this.validator,
    this.prefixIcon,
    this.onChanged,
    this.textAlign = TextAlign.start,
    this.errorText,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontSize: 14,
              color: AppColors.trunks,
            ),
          ),
          const SizedBox(height: 8),
        ],
        TextFormField(
          controller: controller,
          textAlign: textAlign,
          keyboardType: TextInputType.number,
          validator: validator,
          onChanged: onChanged,
          enabled: isDisabled != true,
          style: Theme.of(context).textTheme.titleLarge,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            CurrencyInputFormatter(),
          ],
          errorBuilder: (context, errorText) => switch (textAlign) {
            TextAlign.center => Center(
              child: Text(
                errorText,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: AppColors.danger100),
                textAlign: textAlign,
              ),
            ),
            _ => Text(
              errorText,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppColors.danger100),
            ),
          },
          decoration: InputDecoration(
            errorText: errorText,
            hintText: hint,
            hintStyle: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.trunks),
            prefixIcon: prefixIcon,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSizes.spacing5,
              vertical: AppSizes.spacing4,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.trunks),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.trunks),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.bulma, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.danger100),
            ),
          ),
        ),
      ],
    );
  }
}

class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    String formatted = CurrencyFormatter.formatString(newValue.text);

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
