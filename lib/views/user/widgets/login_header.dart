import 'package:farmtracker/views/core/style/app_colors.dart';
import 'package:farmtracker/views/core/style/app_spacing.dart';
import 'package:farmtracker/views/core/style/app_text_styles.dart';
import 'package:flutter/material.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Container(
            width: 96,
            height: 96,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryContainer,
            ),
            alignment: Alignment.center,
            child: Icon(Icons.agriculture_rounded, size: 44, color: AppColors.secondary),
          ),
        ),
        const SizedBox(height: AppSpacing.s6),
        Text(
          'Bem-vindo ao FarmTracker',
          textAlign: TextAlign.center,
          style: AppTextStyles.headlineMedium.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: AppSpacing.s2),
        Text(
          'Entre para continuar',
          textAlign: TextAlign.center,
          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.onSurfaceVariant),
        ),
      ],
    );
  }
}
