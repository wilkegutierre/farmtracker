import 'package:farmtracker/views/core/style/app_colors.dart';
import 'package:farmtracker/views/core/style/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final bool readOnly;
  final String labelText;
  final Icon? prefixIcon;
  final Widget? suffix;
  final IconButton? suffixIcon;
  final bool? isPassword;
  final TextInputType keyboardType;
  final TextCapitalization textCapitalization;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;
  final TextStyle? fontStyle;
  final FocusNode? focusNode;
  final VoidCallback? onTap;

  const CustomTextFormField({
    super.key,
    this.fontStyle = AppTextStyles.bodyMedium,
    required this.labelText,
    this.prefixIcon,
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
    this.validator,
    this.controller,
    this.readOnly = false,
    this.onChanged,
    this.onFieldSubmitted,
    this.suffix,
    this.suffixIcon,
    this.isPassword,
    this.textCapitalization = TextCapitalization.none,
    this.textInputAction = TextInputAction.none,
    this.focusNode,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      style: fontStyle,
      obscureText: isPassword ?? false,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: fontStyle,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        contentPadding: const EdgeInsets.all(10),
        suffix: suffix,
        border: const OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: AppColors.primaryTeal,
            width: 2.0,
          ),
        ),
      ),
      keyboardType: keyboardType,
      textCapitalization: textCapitalization,
      textInputAction: textInputAction,
      inputFormatters: inputFormatters,
      validator: validator,
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted,
      focusNode: focusNode,
      onTap: onTap,
    );
  }
}
