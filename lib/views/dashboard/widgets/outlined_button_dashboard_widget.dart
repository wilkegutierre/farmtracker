import 'package:farmtracker/views/core/style/app_text_styles.dart';
import 'package:flutter/material.dart';

class OutlinedButtonDashboardWidget extends StatelessWidget {
  final VoidCallback? onPressed;
  final Color borderSideColor;
  final String text;
  final Color textColor;

  const OutlinedButtonDashboardWidget({
    super.key,
    this.onPressed,
    required this.borderSideColor,
    required this.text,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: borderSideColor),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
        child: Text(text, style: AppTextStyles.bodyMedium.copyWith(color: textColor)),
      ),
    );
  }
}
