import 'package:farmtracker/views/core/style/app_colors.dart';
import 'package:farmtracker/views/core/style/app_text_styles.dart';
import 'package:flutter/material.dart';

class LoginSignupFooter extends StatelessWidget {
  final VoidCallback? onCreatePassword;

  const LoginSignupFooter({super.key, this.onCreatePassword});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      alignment: WrapAlignment.center,
      spacing: 0,
      children: [
        Text(
          'Ainda não definiu sua senha? ',
          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.onSurfaceVariant),
        ),
        GestureDetector(
          onTap: onCreatePassword,
          child: Text(
            'Criar senha',
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
