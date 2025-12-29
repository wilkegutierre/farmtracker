import 'package:flutter/material.dart';

class CustomTextError extends StatelessWidget {
  final String textError;
  final bool showIcon;
  const CustomTextError({
    Key? key,
    required this.textError,
    this.showIcon = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (showIcon)
            const Icon(
              Icons.error_outline,
              size: 40,
              color: Colors.red,
            ),
          if (showIcon) const SizedBox(height: 10),
          Text(
            textError.replaceAll('Exception:', ''),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
