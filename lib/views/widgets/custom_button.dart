import 'package:farmtracker/views/core/style/app_colors.dart';
import 'package:farmtracker/views/core/style/app_text_styles.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final IconData? icon;
  final void Function()? onPressed;
  final String textButton;
  final Color? colorBackground;
  const CustomButton({super.key, this.onPressed, required this.textButton, this.icon, this.colorBackground});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith<Color?>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.pressed)) {
                return AppColors.primaryTeal.withOpacity(0.5);
              } else {
                return colorBackground ?? AppColors.primaryTeal;
              }
            },
          ),
        ),
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null)
                Icon(
                  icon,
                  color: AppColors.white,
                ),
              if (icon != null) const SizedBox(width: 16),
              Text(
                textButton,
                style: AppTextStyles.button.copyWith(fontSize: 20),
              ),
            ],
          ),
        ));
  }
}
