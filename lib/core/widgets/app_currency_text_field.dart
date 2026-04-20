import 'package:flutter/material.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:money_management_mobile/core/theme/theme.dart';

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
  });

  @override
  State<AppCurrencyTextField> createState() => _AppCurrencyTextFieldState();
}

class _AppCurrencyTextFieldState extends State<AppCurrencyTextField> {
  final _currencyFormatter = CurrencyTextInputFormatter.currency(
    locale: 'id_ID',
    decimalDigits: 0,
    symbol: '',
  );

  @override
  void initState() {
    super.initState();

    if (widget.initialValue != null) {
      widget.controller.text = _currencyFormatter.formatString(
        widget.initialValue.toString(),
      );
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
            debugPrint('Validating input: $value');
            if (widget.validator != null) {
              return widget.validator!(_currencyFormatter.getDouble().toInt());
            }

            return null;
          },
          onChanged: widget.onChanged,
          enabled: widget.isDisabled != true,
          style: Theme.of(context).textTheme.titleLarge,
          inputFormatters: [_currencyFormatter],
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
