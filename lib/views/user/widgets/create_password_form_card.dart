import 'package:farmtracker/views/core/style/app_colors.dart';
import 'package:farmtracker/views/core/style/app_spacing.dart';
import 'package:farmtracker/views/core/style/app_text_styles.dart';
import 'package:farmtracker/views/user/widgets/auth_labeled_field.dart';
import 'package:farmtracker/views/user/widgets/login_primary_button.dart';
import 'package:flutter/material.dart';

class CreatePasswordFormCard extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final bool obscurePassword;
  final bool obscureConfirmPassword;
  final VoidCallback onTogglePasswordVisibility;
  final VoidCallback onToggleConfirmPasswordVisibility;
  final VoidCallback? onSubmit;
  final bool loading;

  const CreatePasswordFormCard({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.obscurePassword,
    required this.obscureConfirmPassword,
    required this.onTogglePasswordVisibility,
    required this.onToggleConfirmPasswordVisibility,
    required this.onSubmit,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.s6),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        boxShadow: const [
          BoxShadow(
            color: AppColors.ambientShadow,
            offset: Offset(0, 8),
            blurRadius: 24,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Crie sua senha',
            style: AppTextStyles.titleLarge.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: AppSpacing.s6),
          AuthLabeledField(
            label: 'E-MAIL',
            controller: emailController,
            hint: 'nome@fazenda.com',
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            prefixIcon: Icons.mail_outline_rounded,
          ),
          const SizedBox(height: AppSpacing.s4),
          AuthLabeledField(
            label: 'SENHA',
            controller: passwordController,
            hint: '••••••••',
            obscureText: obscurePassword,
            onToggleVisibility: onTogglePasswordVisibility,
            textInputAction: TextInputAction.next,
            prefixIcon: Icons.lock_outline_rounded,
          ),
          const SizedBox(height: AppSpacing.s4),
          AuthLabeledField(
            label: 'CONFIRMAR SENHA',
            controller: confirmPasswordController,
            hint: '••••••••',
            obscureText: obscureConfirmPassword,
            onToggleVisibility: onToggleConfirmPasswordVisibility,
            textInputAction: TextInputAction.done,
            prefixIcon: Icons.lock_outline_rounded,
          ),
          const SizedBox(height: AppSpacing.s6),
          LoginPrimaryButton(
            onPressed: onSubmit,
            loading: loading,
            label: 'CRIAR SENHA',
          ),
        ],
      ),
    );
  }
}
