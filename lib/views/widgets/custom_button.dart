import 'package:farmtracker/views/core/style/app_colors.dart';
import 'package:farmtracker/views/core/style/app_spacing.dart';
import 'package:farmtracker/views/core/style/app_text_styles.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final IconData? icon;
  final void Function()? onPressed;
  final String textButton;
  final Color? colorBackground;

  const CustomButton({
    super.key,
    this.onPressed,
    required this.textButton,
    this.icon,
    this.colorBackground,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final bool useGradient = colorBackground == null;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
            gradient: useGradient ? AppColors.primaryCtaGradient : null,
            color: useGradient ? null : colorBackground,
            boxShadow: onPressed == null
                ? null
                : [
                    BoxShadow(
                      color: AppColors.ambientShadow,
                      offset: const Offset(0, 8),
                      blurRadius: 24,
                    ),
                  ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) Icon(icon, color: scheme.onPrimary),
                if (icon != null) const SizedBox(width: 16),
                Text(
                  textButton,
                  style: AppTextStyles.button.copyWith(
                    color: scheme.onPrimary,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
