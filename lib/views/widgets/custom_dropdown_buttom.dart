import 'package:farmtracker/views/core/style/app_text_styles.dart';
import 'package:flutter/material.dart';

class CustomDropdownButtom extends StatefulWidget {
  final String value;
  final List<String> listVisit;
  final void Function(String?)? onChanged;

  const CustomDropdownButtom({
    super.key,
    required this.value,
    required this.listVisit,
    this.onChanged,
  });

  @override
  State<CustomDropdownButtom> createState() => _CustomDropdownButtomState();
}

class _CustomDropdownButtomState extends State<CustomDropdownButtom> {
  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return Material(
      color: scheme.surfaceContainer,
      borderRadius: BorderRadius.circular(12),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: widget.value,
            isExpanded: true,
            icon: Icon(Icons.arrow_drop_down, color: scheme.onSurfaceVariant),
            elevation: 2,
            dropdownColor: scheme.surfaceContainerHigh,
            style: AppTextStyles.bodyMedium.copyWith(color: scheme.onSurface),
            onChanged: widget.onChanged,
            items: widget.listVisit.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
