import 'package:farmtracker/views/core/style/app_colors.dart';
import 'package:farmtracker/views/core/style/app_text_styles.dart';
import 'package:flutter/material.dart';

class CreatePasswordLoginFooter extends StatelessWidget {
  final VoidCallback? onLogin;

  const CreatePasswordLoginFooter({super.key, this.onLogin});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      alignment: WrapAlignment.center,
      spacing: 0,
      children: [
        Text(
          'Já possui uma conta? ',
          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.onSurfaceVariant),
        ),
        GestureDetector(
          onTap: onLogin,
          child: Text(
            'Entrar agora',
            style: AppTextStyles.labelMedium.copyWith(
              color: AppColors.secondary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
