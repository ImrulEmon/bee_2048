import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/constants_2048.dart';

class ButtonWidget extends ConsumerWidget {
  final String? text;
  final IconData? icon;
  final VoidCallback onPressed;

  const ButtonWidget({
    super.key,
    this.text,
    this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (icon != null) {
      // Button widget with icon for Undo and Restart Button
      return Container(
        decoration: BoxDecoration(
          color: scoreColor,
          borderRadius: BorderRadius.circular(paddingDft / 2),
        ),
        child: IconButton(
          onPressed: () {},
          icon: Icon(
            icon,
            size: 24,
          ),
        ),
      );
    }
    // Button Widget with text for New Game and Try Again Button
    return ElevatedButton(
        onPressed: onPressed,
        child: Text(
          text!,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ));
  }
}
