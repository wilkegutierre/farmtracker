import 'package:flutter/material.dart';

class CustomItemCardEditDelete extends StatelessWidget {
  final String title;
  final String? detail;
  final bool showButtons;
  final void Function()? onPressedCard;
  final void Function()? onPressedEdit;
  final void Function()? onPressedDelete;

  const CustomItemCardEditDelete({
    super.key,
    required this.title,
    this.detail,
    this.onPressedCard,
    this.onPressedEdit,
    this.onPressedDelete,
    this.showButtons = true,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 0,
      color: scheme.surfaceContainer,
      child: Row(
        children: [
          Expanded(
            child: ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: Text(title, style: TextStyle(color: scheme.onSurface))),
                  Container(),
                ],
              ),
              subtitle: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [Flexible(child: detail != null ? Text(detail!) : Container())],
              ),
              onTap: onPressedCard,
            ),
          ),
          if (showButtons)
            Row(
              children: [
                IconButton(
                  onPressed: onPressedEdit,
                  icon: Icon(Icons.mode_edit_rounded, size: 25, color: scheme.primary),
                ),
                IconButton(
                  onPressed: onPressedDelete,
                  icon: Icon(Icons.delete_forever, color: scheme.error, size: 25),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
