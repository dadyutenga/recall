import 'package:flutter/material.dart';

class RecallFab extends StatelessWidget {
  final VoidCallback onPressed;

  const RecallFab({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      child: const Icon(Icons.add, size: 28),
    );
  }
}
