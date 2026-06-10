import 'package:farmtracker/views/clients/models/cultura_item.dart';
import 'package:farmtracker/views/core/style/app_colors.dart';
import 'package:flutter/material.dart';

class CulturasBox extends StatelessWidget {
  final List<CulturaItem> culturas;
  final ValueChanged<CulturaItem> onRemover;
  final ValueChanged<CulturaItem> onEditar;

  const CulturasBox({super.key, required this.culturas, required this.onRemover, required this.onEditar});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color border = theme.colorScheme.outlineVariant.withValues(alpha: 0.6);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: culturas.isEmpty ? AppColors.error : theme.colorScheme.surfaceContainerLowest,
        border: Border.all(color: border, style: BorderStyle.solid),
        borderRadius: BorderRadius.circular(16),
      ),
      child: culturas.isEmpty
          ? Text(
              'Nenhuma cultura adicionada',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: culturas.isEmpty ? AppColors.white : AppColors.textSecondary,
              ),
            )
          : Wrap(
              spacing: 8,
              runSpacing: 8,
              children: culturas
                  .map(
                    (item) => InputChip(
                      label: Text(item.rotuloExibicao, style: theme.textTheme.labelSmall),
                      onPressed: () => onEditar(item),
                      onDeleted: () => onRemover(item),
                      deleteIcon: const Icon(Icons.close),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    ),
                  )
                  .toList(),
            ),
    );
  }
}
