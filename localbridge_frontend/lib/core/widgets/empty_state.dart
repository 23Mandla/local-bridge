import 'package:flutter/material.dart';

import 'package:localbridge_frontend/app/theme/app_palette.dart';

/// Friendly placeholder for empty lists and empty detail sections.
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.message,
    this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
  });

  final IconData icon;
  final String title;
  final String? message;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: padding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 40, color: const Color(0xFF9AA8A0)),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppPalette.ink,
              ),
            ),
            if (message != null) ...[
              const SizedBox(height: 6),
              Text(
                message!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  height: 1.4,
                  color: AppPalette.mutedInk,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
