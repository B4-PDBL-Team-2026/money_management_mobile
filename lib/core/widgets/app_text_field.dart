import 'package:flutter/material.dart';
import 'package:money_management_mobile/core/theme/app_sizes.dart';

import '../theme/app_colors.dart';

class AppTextField extends StatefulWidget {
  final String hint;
  final TextEditingController controller;
  final bool isPassword;
  final bool readOnly;
  final TextInputType keyboardType;
  final String? label;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final void Function(String)? onChanged;
  final VoidCallback? onTap;
  final int? maxLines;
  final String? errorText;
  final bool? isDisabled;
  final bool? withBorder;

  const AppTextField({
    super.key,
    required this.hint,
    required this.controller,
    this.label,
    this.isPassword = false,
    this.readOnly = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.suffixIcon,
    this.prefixIcon,
    this.onChanged,
    this.onTap,
    this.maxLines = 1,
    this.errorText,
    this.isDisabled = false,
    this.withBorder = true,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...(widget.label != null
            ? [
                Text(
                  widget.label!,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontSize: 14,
                    color: AppColors.trunks,
                  ),
                ),
                const SizedBox(height: 8),
              ]
            : []),
        TextFormField(
          controller: widget.controller,
          obscureText: _obscureText,
          readOnly: widget.readOnly,
          keyboardType: widget.keyboardType,
          validator: widget.validator,
          onChanged: widget.onChanged,
          onTap: widget.onTap,
          style: Theme.of(context).textTheme.bodyMedium,
          maxLines: widget.isPassword ? 1 : widget.maxLines,
          enabled: widget.isDisabled != true,
          decoration: InputDecoration(
            errorText: widget.errorText,
            errorStyle: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.danger100),
            hintText: widget.hint,
            hintStyle: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.trunks),
            prefixIcon: widget.prefixIcon,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSizes.spacing5,
              vertical: AppSizes.spacing4,
            ),

            border: widget.withBorder == true
                ? OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.trunks),
                  )
                : InputBorder.none,
            enabledBorder: widget.withBorder == true
                ? OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.trunks),
                  )
                : InputBorder.none,
            focusedBorder: widget.withBorder == true
                ? OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.bulma,
                      width: 2,
                    ),
                  )
                : InputBorder.none,
            errorBorder: widget.withBorder == true
                ? OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.danger100),
                  )
                : InputBorder.none,
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                      color: AppColors.trunks,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  )
                : widget.suffixIcon,
          ),
        ),
      ],
    );
  }
}
