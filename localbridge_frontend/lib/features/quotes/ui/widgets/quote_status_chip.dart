import 'package:flutter/material.dart';

import '../../domain/entities/quote_status.dart';

/// Coloured pill showing where a quotation sits in its lifecycle.
class QuoteStatusChip extends StatelessWidget {
  const QuoteStatusChip({super.key, required this.status});

  final QuoteStatus status;

  @override
  Widget build(BuildContext context) {
    final (
      Color background,
      Color foreground,
      IconData icon,
    ) = switch (status) {
      QuoteStatus.draft => (
        const Color(0xFFE0E7E2),
        const Color(0xFF35463D),
        Icons.edit_note,
      ),
      QuoteStatus.submitted => (
        const Color(0xFFA5EED0),
        const Color(0xFF17402F),
        Icons.upload_file_outlined,
      ),
      QuoteStatus.accepted => (
        const Color(0xFFCDEBDD),
        const Color(0xFF17402F),
        Icons.check_circle_outline,
      ),
      QuoteStatus.declined => (
        const Color(0xFFF6D5D2),
        const Color(0xFF6B211B),
        Icons.cancel_outlined,
      ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: foreground),
          const SizedBox(width: 5),
          Text(
            status.label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: foreground,
            ),
          ),
        ],
      ),
    );
  }
}
