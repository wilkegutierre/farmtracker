import 'package:farmtracker/views/core/style/app_colors.dart';
import 'package:farmtracker/views/core/style/app_spacing.dart';
import 'package:farmtracker/views/core/style/app_text_styles.dart';
import 'package:farmtracker/views/user/widgets/login_input_decoration.dart';
import 'package:flutter/material.dart';

class LoginCredentialFields extends StatelessWidget {
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final bool obscurePassword;
  final VoidCallback onTogglePasswordVisibility;

  const LoginCredentialFields({
    super.key,
    required this.usernameController,
    required this.passwordController,
    required this.obscurePassword,
    required this.onTogglePasswordVisibility,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: usernameController,
          textInputAction: TextInputAction.next,
          autocorrect: false,
          style: AppTextStyles.bodyMedium,
          decoration: loginSurfaceFieldDecoration(
            hint: 'Usuário',
            prefixIcon: Icon(Icons.person_outline_rounded, color: AppColors.onSurfaceVariant),
          ),
        ),
        const SizedBox(height: AppSpacing.s4),
        TextField(
          controller: passwordController,
          obscureText: obscurePassword,
          textInputAction: TextInputAction.done,
          style: AppTextStyles.bodyMedium,
          decoration: loginSurfaceFieldDecoration(
            hint: 'Senha',
            prefixIcon: Icon(Icons.lock_outline_rounded, color: AppColors.onSurfaceVariant),
            suffixIcon: IconButton(
              onPressed: onTogglePasswordVisibility,
              icon: Icon(
                obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
