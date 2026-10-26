import 'package:flutter/material.dart';

import 'package:localbridge_frontend/app/theme/app_palette.dart';

/// Warning shown when the requested upfront cash exceeds the demo threshold.
class UpfrontWarning extends StatelessWidget {
  const UpfrontWarning({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppPalette.warningSurface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.warning_amber_rounded,
            size: 18,
            color: AppPalette.warning,
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'Upfront cash is above 60% of the quote total. Buyers may query '
              'this, so consider lowering it.',
              style: TextStyle(
                fontSize: 12,
                height: 1.35,
                color: AppPalette.warning,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
