import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  final String title;
  final IconData? icon;
  final Color iconColor;
  final String message;
  final String textConfirm;
  final String textCancel;
  final void Function()? onConfirm;
  final void Function()? onCancel;

  const CustomDialog({
    super.key,
    this.title = 'Atenção',
    required this.message,
    this.textConfirm = 'Sim',
    this.textCancel = 'Não',
    this.onConfirm,
    this.onCancel,
    this.icon,
    this.iconColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog(
      title: Text(
        title,
        style: theme.textTheme.titleLarge,
        textAlign: TextAlign.center,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (icon != null)
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Icon(
                icon,
                size: 40,
                color: iconColor,
              ),
            ),
          Text(
            message,
            style: theme.textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
      actions: [
        if (onCancel != null) TextButton(onPressed: onCancel, child: Text(textCancel)),
        TextButton(
            onPressed: (onConfirm != null)
                ? () => {onConfirm?.call(), Navigator.pop(context)}
                : () => Navigator.pop(context),
            child: Text((onConfirm != null) ? textConfirm : 'Entendi'))
      ],
    );
  }
}
