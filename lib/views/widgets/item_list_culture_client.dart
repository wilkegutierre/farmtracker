import 'package:farmtracker/views/core/style/app_text_styles.dart';
import 'package:flutter/material.dart';

class ItemListCultureClient extends StatelessWidget {
  final String? description;
  final String? area;
  final void Function()? onPressed;

  const ItemListCultureClient({super.key, this.description, this.area, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            'Cultura: $description',
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: scheme.onSurface,
            ),
          ),
        ),
        Text(
          'Área: $area',
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: scheme.onSurfaceVariant,
          ),
        ),
        IconButton(
          onPressed: onPressed,
          icon: Icon(Icons.remove_circle_outline_rounded, color: scheme.error),
        ),
      ],
    );
  }
}
