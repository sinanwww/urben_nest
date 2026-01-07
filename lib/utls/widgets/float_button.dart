import 'package:flutter/material.dart';
import 'package:urben_nest/utls/app_theme.dart';

class FloatButton extends StatelessWidget {
  final VoidCallback? onPressed;
  const FloatButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        onPressed: onPressed,
        backgroundColor: AppTheme.primary,
        child: const Icon(Icons.add, color: Colors.white),
      );
  }
}