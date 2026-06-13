import 'package:farmtracker/views/core/style/app_colors.dart';
import 'package:farmtracker/views/core/style/app_spacing.dart';
import 'package:farmtracker/views/core/style/app_text_styles.dart';
import 'package:flutter/material.dart';

Future<void> showRetroactiveDateDialog(BuildContext context) {
  return showDialog<void>(context: context, builder: (_) => const RetroactiveDateDialog());
}

class RetroactiveDateDialog extends StatelessWidget {
  const RetroactiveDateDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return Dialog(
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusXl)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        decoration: BoxDecoration(color: scheme.surface, borderRadius: BorderRadius.circular(AppSpacing.radiusXl)),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.s6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(color: AppColors.warning.withValues(alpha: 0.15), shape: BoxShape.circle),
                child: const Icon(Icons.event_busy, size: 32, color: AppColors.warning),
              ),
              const SizedBox(height: AppSpacing.s4),
              Text(
                'Data retroativa',
                style: AppTextStyles.titleLarge.copyWith(fontWeight: FontWeight.bold, color: scheme.onSurface),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.s2),
              Text(
                'Não é possível criar uma agenda com data retroativa. Selecione o dia atual ou uma data futura no calendário.',
                style: AppTextStyles.bodyMedium.copyWith(color: scheme.onSurfaceVariant),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.s6),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(
                    'Entendi',
                    style: AppTextStyles.labelLarge.copyWith(fontWeight: FontWeight.w600, color: AppColors.onPrimary),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
