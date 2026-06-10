import 'package:farmtracker/views/core/style/app_spacing.dart';
import 'package:farmtracker/views/core/style/app_text_styles.dart';
import 'package:flutter/material.dart';

class CustomCardClient extends StatelessWidget {
  final String clientName;
  final String project;
  final VoidCallback? onTap;

  const CustomCardClient({super.key, required this.clientName, required this.project, this.onTap});

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return Material(
      color: scheme.surfaceContainer,
      elevation: 0,
      borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.s4 + AppSpacing.s2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(clientName, style: AppTextStyles.titleMedium.copyWith(color: scheme.onSurface)),
              const SizedBox(height: AppSpacing.s2),
              Text('Projeto: $project', style: AppTextStyles.bodyMedium.copyWith(color: scheme.onSurfaceVariant)),
            ],
          ),
        ),
      ),
    );
  }
}
