import 'package:farmtracker/views/core/style/app_text_styles.dart';
import 'package:flutter/material.dart';

/// Secondary "Ver" action — ghost border (outline @ low opacity).
class OutlinedButtonDashboardWidget extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;

  const OutlinedButtonDashboardWidget({
    super.key,
    this.onPressed,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return OutlinedButton(
      onPressed: onPressed,
      style: Theme.of(context).outlinedButtonTheme.style,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Text(
          text,
          style: AppTextStyles.labelMedium.copyWith(color: scheme.onSecondaryContainer),
        ),
      ),
    );
  }
}
