import 'package:farmtracker/views/core/style/app_colors.dart';
import 'package:farmtracker/views/core/style/app_spacing.dart';
import 'package:farmtracker/views/core/style/app_text_styles.dart';
import 'package:farmtracker/views/user/widgets/login_input_decoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Campo com rótulo em caixa alta (fluxo de autenticação / criar senha).
class AuthLabeledField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String hint;
  final bool obscureText;
  final VoidCallback? onToggleVisibility;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final IconData prefixIcon;

  const AuthLabeledField({
    super.key,
    required this.label,
    required this.controller,
    required this.hint,
    this.obscureText = false,
    this.onToggleVisibility,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.prefixIcon = Icons.edit_outlined,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          style: AppTextStyles.labelSmall.copyWith(
            color: AppColors.onSurfaceVariant,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.6,
          ),
        ),
        const SizedBox(height: AppSpacing.s2),
        TextField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          autocorrect: false,
          enableSuggestions: false,
          inputFormatters: keyboardType == TextInputType.emailAddress
              ? [FilteringTextInputFormatter.deny(RegExp(r'\s'))]
              : null,
          style: AppTextStyles.bodyMedium,
          decoration: loginSurfaceFieldDecoration(
            hint: hint,
            prefixIcon: Icon(prefixIcon, color: AppColors.onSurfaceVariant),
            suffixIcon: onToggleVisibility == null
                ? null
                : IconButton(
                    onPressed: onToggleVisibility,
                    icon: Icon(
                      obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
