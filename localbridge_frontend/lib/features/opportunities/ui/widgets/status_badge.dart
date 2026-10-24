import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StatusBadge extends StatelessWidget {
  final String status;

  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final isSubmitted = status == 'Submitted';

    final backgroundColor = isSubmitted
        ? const Color(0xFFA5EED0)
        : status == 'Draft'
        ? const Color(0xFFE0E7E2)
        : const Color(0xFFCDEBDD);

    final icon = isSubmitted
        ? Icons.upload_file_outlined
        : status == 'Draft'
        ? Icons.edit_note
        : Icons.check_circle_outline;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 19, color: const Color(0xFF35463D)),
          const SizedBox(width: 6),
          Text(
            status,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF35463D),
            ),
          ),
        ],
      ),
    );
  }
}