import 'package:farmtracker/views/clients/models/cultura_item.dart';
import 'package:farmtracker/views/core/style/app_spacing.dart';
import 'package:farmtracker/views/core/style/app_text_styles.dart';
import 'package:flutter/material.dart';

const List<Color> _coresLote = [
  Color(0xFFC8E6C9),
  Color(0xFFFFE082),
  Color(0xFFE1BEE7),
  Color(0xFFBBDEFB),
  Color(0xFFFFCCBC),
];

Future<CulturaItem?> showCustomerCulturasDialog(
  BuildContext context, {
  required String customerName,
  required List<CulturaItem> culturas,
}) {
  return showDialog<CulturaItem>(
    context: context,
    builder: (_) => CustomerCulturasDialog(customerName: customerName, culturas: culturas),
  );
}

class CustomerCulturasDialog extends StatelessWidget {
  final String customerName;
  final List<CulturaItem> culturas;

  const CustomerCulturasDialog({super.key, required this.customerName, required this.culturas});

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return Dialog(
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusXl)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 600),
        decoration: BoxDecoration(color: scheme.surface, borderRadius: BorderRadius.circular(AppSpacing.radiusXl)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.s4 + AppSpacing.s2),
              decoration: BoxDecoration(
                color: scheme.surface,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppSpacing.radiusXl),
                  topRight: Radius.circular(AppSpacing.radiusXl),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      customerName,
                      style: AppTextStyles.titleLarge.copyWith(fontWeight: FontWeight.bold, color: scheme.onSurface),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: scheme.primaryContainer.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${culturas.length} ${culturas.length == 1 ? 'Cultura' : 'Culturas'}',
                      style: AppTextStyles.labelMedium.copyWith(color: scheme.primary, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              child: Container(
                color: scheme.surfaceContainerLow,
                child: culturas.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.all(AppSpacing.s10),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.inbox_outlined, size: 64, color: scheme.onSurfaceVariant),
                            const SizedBox(height: AppSpacing.s4),
                            Text(
                              'Nenhuma cultura encontrada',
                              style: AppTextStyles.bodyMedium.copyWith(color: scheme.onSurfaceVariant),
                            ),
                          ],
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.all(AppSpacing.s4),
                        shrinkWrap: true,
                        itemCount: culturas.length,
                        separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.s4),
                        itemBuilder: (context, index) {
                          return _CulturaCard(cultura: culturas[index], corLote: _coresLote[index % _coresLote.length]);
                        },
                      ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(AppSpacing.s4),
              decoration: BoxDecoration(
                color: scheme.surface,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(AppSpacing.radiusXl),
                  bottomRight: Radius.circular(AppSpacing.radiusXl),
                ),
              ),
              child: SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text('Cancelar', style: AppTextStyles.labelLarge.copyWith(color: scheme.onSurfaceVariant)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CulturaCard extends StatelessWidget {
  final CulturaItem cultura;
  final Color corLote;

  const _CulturaCard({required this.cultura, required this.corLote});

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusXl), side: BorderSide.none),
      color: scheme.surfaceContainer,
      child: InkWell(
        onTap: () => Navigator.of(context).pop(cultura),
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.s4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _valorSemLegenda(cultura.projeto, 'P:'),
                style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.w600, color: scheme.onSurface),
              ),
              const SizedBox(height: AppSpacing.s2),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      'Cultura: ${_valorSemLegenda(cultura.cultura, 'C:')}',
                      style: AppTextStyles.bodySmall.copyWith(color: scheme.onSurfaceVariant),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.s4),

                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(color: corLote, borderRadius: BorderRadius.circular(8)),
                    child: Text(
                      'Lote: ${_valorSemLegenda(cultura.lote, 'L:')}',
                      style: AppTextStyles.labelSmall.copyWith(fontWeight: FontWeight.w600, color: scheme.onSurface),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _valorSemLegenda(String valor, String legenda) {
    final String texto = valor.trim();
    if (texto.startsWith(legenda)) {
      return texto.substring(legenda.length).trim();
    }
    return texto;
  }
}
