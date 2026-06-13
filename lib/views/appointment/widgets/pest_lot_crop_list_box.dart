import 'package:farmtracker/views/appointment/widgets/pest_dialog.dart';
import 'package:farmtracker/views/core/style/app_colors.dart';
import 'package:farmtracker/views/core/style/app_spacing.dart';
import 'package:farmtracker/views/core/style/app_text_styles.dart';
import 'package:flutter/material.dart';

class PestLotCropListBox extends StatefulWidget {
  final List<PestLotCropInfo> items;
  final ValueChanged<PestLotCropInfo> onRemove;

  const PestLotCropListBox({super.key, required this.items, required this.onRemove});

  @override
  State<PestLotCropListBox> createState() => _PestLotCropListBoxState();
}

class _PestLotCropListBoxState extends State<PestLotCropListBox> {
  static const double _fadeHeight = 32;

  final ScrollController _scrollController = ScrollController();
  bool _showBottomFade = false;

  Color get _backgroundColor => AppColors.primaryContainer.withValues(alpha: 0.14);

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_atualizarFade);
    WidgetsBinding.instance.addPostFrameCallback((_) => _atualizarFade());
  }

  @override
  void didUpdateWidget(covariant PestLotCropListBox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.items.length != widget.items.length) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _atualizarFade());
    }
  }

  void _atualizarFade() {
    if (!_scrollController.hasClients) return;

    final ScrollPosition position = _scrollController.position;
    final bool possuiMaisItens = position.maxScrollExtent > 0;
    final bool chegouAoFim = position.pixels >= position.maxScrollExtent - 4;
    final bool deveExibirFade = possuiMaisItens && !chegouAoFim;

    if (deveExibirFade != _showBottomFade) {
      setState(() => _showBottomFade = deveExibirFade);
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_atualizarFade);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.5)),
        boxShadow: const [BoxShadow(color: AppColors.ambientShadow, blurRadius: 12, offset: Offset(0, 4))],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        child: Stack(
          children: [
            Positioned.fill(
              child: SingleChildScrollView(
                controller: _scrollController,
                padding: const EdgeInsets.all(AppSpacing.s4),
                child: Wrap(
                  spacing: AppSpacing.s2,
                  runSpacing: AppSpacing.s2,
                  children: widget.items
                      .map(
                        (PestLotCropInfo item) => Chip(
                          label: Text(item.rotuloExibicao, style: AppTextStyles.bodySmall),
                          backgroundColor: AppColors.primaryContainer.withValues(alpha: 0.45),
                          deleteIcon: Icon(Icons.close, size: 18, color: colorScheme.onSurfaceVariant),
                          onDeleted: () => widget.onRemove(item),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusFull)),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: _fadeHeight,
              child: IgnorePointer(
                child: AnimatedOpacity(
                  opacity: _showBottomFade ? 1 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          _backgroundColor.withValues(alpha: 0),
                          _backgroundColor.withValues(alpha: 0.75),
                          _backgroundColor,
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
