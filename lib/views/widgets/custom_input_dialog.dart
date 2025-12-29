import 'package:farmtracker/views/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';

class CustomInputDialog extends StatelessWidget {
  final String title;
  final IconData? icon;
  final Color iconColor;
  final String message;
  final String hintText;
  final String textConfirm;
  final String textCancel;
  final TextEditingController? controller;
  final void Function()? onConfirm;
  final void Function()? onCancel;

  const CustomInputDialog({
    super.key,
    this.title = 'Atenção',
    required this.message,
    required this.hintText,
    this.textConfirm = 'Gravar',
    this.textCancel = 'Cancelar',
    this.onConfirm,
    this.onCancel,
    this.controller,
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
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Text(
              message,
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ),
          CustomTextFormField(
            labelText: hintText,
            controller: controller,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
          )
        ],
      ),
      actions: [
        if (onCancel != null) TextButton(onPressed: onCancel, child: Text(textCancel)),
        TextButton(
            onPressed:
                (onConfirm != null) ? () => {onConfirm?.call(), Navigator.pop(context)} : () => Navigator.pop(context),
            child: Text((onConfirm != null) ? textConfirm : 'Entendi'))
      ],
    );
  }
}
