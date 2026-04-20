import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:money_management_mobile/core/theme/theme.dart';
import 'package:money_management_mobile/core/utils/currency_formatter.dart';

class AppCurrencyTextField extends StatefulWidget {
  final String hint;
  final int? initialValue;
  final TextEditingController controller;
  final String? label;
  final String? Function(int?)? validator;
  final Widget? prefixIcon;
  final void Function(String)? onChanged;
  final TextAlign textAlign;
  final String? errorText;
  final bool? isDisabled;
  final int? max;
  final int? min;

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
    this.initialValue,
    this.max,
    this.min,
  });

  @override
  State<AppCurrencyTextField> createState() => _AppCurrencyTextFieldState();
}

class _AppCurrencyTextFieldState extends State<AppCurrencyTextField> {
  final _currencyFormatter = AppCurrencyInputFormatter();

  @override
  void initState() {
    super.initState();

    if (widget.initialValue != null) {
      widget.controller.text = CurrencyFormatter.format(widget.initialValue!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontSize: 14,
              color: AppColors.trunks,
            ),
          ),
          const SizedBox(height: 8),
        ],
        TextFormField(
          controller: widget.controller,
          textAlign: widget.textAlign,
          keyboardType: const TextInputType.numberWithOptions(decimal: false),
          enableSuggestions: false,
          autocorrect: false,
          validator: (value) {
            if (widget.validator != null) {
              if (value == null || value.trim().isEmpty) {
                return widget.validator!(null);
              }

              final unformattedValue = CurrencyFormatter.parse(value);
              return widget.validator!(unformattedValue);
            }

            return null;
          },
          onChanged: widget.onChanged,
          enabled: widget.isDisabled != true,
          style: Theme.of(context).textTheme.titleLarge,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            TextInputFormatter.withFunction((oldValue, newValue) {
              if (newValue.text.isEmpty) {
                return newValue.copyWith(text: '');
              }

              int numericValue = CurrencyFormatter.parse(newValue.text);

              if (widget.max != null && numericValue > widget.max!) {
                return oldValue;
              }

              if (widget.min != null && numericValue < widget.min!) {
                return oldValue;
              }

              return newValue;
            }),
            _currencyFormatter,
          ],
          errorBuilder: (context, errorText) => switch (widget.textAlign) {
            TextAlign.center => Center(
              child: Text(
                errorText,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: AppColors.danger100),
                textAlign: widget.textAlign,
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
            errorText: widget.errorText,
            hintText: widget.hint,
            hintStyle: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.trunks),
            prefixIcon: widget.prefixIcon,
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

class AppCurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    final cleanText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    if (cleanText.isEmpty) {
      return const TextEditingValue(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
      );
    }

    int digitsBeforeCursor = 0;
    int cursorPosition = newValue.selection.baseOffset;

    if (cursorPosition > newValue.text.length) {
      cursorPosition = newValue.text.length;
    }

    for (int i = 0; i < cursorPosition; i++) {
      if (RegExp(r'[0-9]').hasMatch(newValue.text[i])) {
        digitsBeforeCursor++;
      }
    }

    String formattedText = CurrencyFormatter.formatString(cleanText);

    int newCursorOffset = 0;
    int digitsCounted = 0;

    for (int i = 0; i < formattedText.length; i++) {
      if (digitsCounted == digitsBeforeCursor) {
        break;
      }

      if (RegExp(r'[0-9]').hasMatch(formattedText[i])) {
        digitsCounted++;
      }

      newCursorOffset++;
    }

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: newCursorOffset),
    );
  }
}
