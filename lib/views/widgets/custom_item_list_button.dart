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
    return Card(
      child: Row(
        children: [
          Expanded(
            child: ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Text(title), Container()],
              ),
              subtitle: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [Flexible(child: detail != null ? Text(detail!) : Container())],
              ),
              onTap: onPressedCard,
            ),
          ),
          showButtons
              ? Row(
                  children: [
                    IconButton(
                      onPressed: onPressedEdit,
                      icon: const Icon(
                        Icons.mode_edit_rounded,
                        size: 25,
                      ),
                      color: Colors.blue,
                    ),
                    IconButton(
                      onPressed: onPressedDelete,
                      icon: const Icon(
                        Icons.delete_forever,
                        color: Colors.red,
                        size: 25,
                      ),
                      color: Colors.blue,
                    ),
                  ],
                )
              : Container(),
        ],
      ),
    );
  }
}
