import 'package:flutter/material.dart';

class ItemListCultureClient extends StatelessWidget {
  final String? description;
  final String? area;
  final void Function()? onPressed;

  const ItemListCultureClient({super.key, this.description, this.area, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Cultura: $description',
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          'Área: $area',
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        IconButton(
          onPressed: onPressed,
          icon: Icon(
            Icons.remove_circle_outline_rounded,
            color: Colors.red.shade600,
          ),
        ),
      ],
    );
  }
}
