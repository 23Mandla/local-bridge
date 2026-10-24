import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const Color chipBackground = Color(0xFFE4EBE5);

class DetailChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const DetailChip({super.key,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: chipBackground,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 20,
            color: Colors.grey,
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              label,
              softWrap: true,
              style: const TextStyle(
                fontSize: 10,
                color: Color(0xFF242D28),
              ),
            ),
          ),
        ],
      ),
    );
  }
}