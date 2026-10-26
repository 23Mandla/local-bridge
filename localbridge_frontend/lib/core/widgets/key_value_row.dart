import 'package:flutter/material.dart';

import 'package:localbridge_frontend/app/theme/app_palette.dart';

/// Label on the left, value on the right.
class KeyValueRow extends StatelessWidget {
  const KeyValueRow({
    super.key,
    required this.label,
    required this.value,
    this.valueColor,
    this.emphasise = false,
  });

  final String label;
  final String value;
  final Color? valueColor;
  final bool emphasise;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: Text(
              label,
              style: const TextStyle(fontSize: 13, color: AppPalette.mutedInk),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 5,
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 13,
                fontWeight: emphasise ? FontWeight.w700 : FontWeight.w600,
                color: valueColor ?? AppPalette.ink,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
