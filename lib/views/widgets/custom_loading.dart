import 'package:flutter/material.dart';

class CustomLoading extends StatelessWidget {
  final String? message;
  const CustomLoading({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 10),
          if (message != null) Text(message!)
        ],
      ),
    );
  }
}
