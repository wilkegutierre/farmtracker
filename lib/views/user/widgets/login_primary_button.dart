import 'package:farmtracker/views/core/style/app_colors.dart';
import 'package:farmtracker/views/core/style/app_spacing.dart';
import 'package:farmtracker/views/core/style/app_text_styles.dart';
import 'package:flutter/material.dart';

class LoginPrimaryButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool loading;
  final String label;

  const LoginPrimaryButton({
    super.key,
    required this.onPressed,
    this.loading = false,
    this.label = 'ENTRAR',
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: loading ? null : onPressed,
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
            gradient: AppColors.primaryCtaGradient,
            boxShadow: const [
              BoxShadow(
                color: AppColors.ambientShadow,
                offset: Offset(0, 8),
                blurRadius: 24,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child: loading
                  ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.onPrimary,
                      ),
                    )
                  : Text(
                      label,
                      style: AppTextStyles.labelLarge.copyWith(
                        color: AppColors.onPrimary,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
