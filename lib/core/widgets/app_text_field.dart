import 'package:flutter/material.dart';
import 'package:money_management_mobile/core/theme/app_sizes.dart';

import '../theme/app_colors.dart';

class AppTextField extends StatefulWidget {
  final String hint;
  final TextEditingController controller;
  final bool isPassword;
  final TextInputType keyboardType;
  final String? label;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final void Function(String)? onChanged;

  const AppTextField({
    super.key,
    required this.hint,
    required this.controller,
    this.label,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.suffixIcon,
    this.prefixIcon,
    this.onChanged,
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
          keyboardType: widget.keyboardType,
          validator: widget.validator,
          onChanged: widget.onChanged,
          style: Theme.of(context).textTheme.bodyMedium,
          decoration: InputDecoration(
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
