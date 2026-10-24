import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localbridge_frontend/features/opportunities/ui/widgets/status_badge.dart';

import '../../domain/entities/opportunity.dart';
import 'detail_chip.dart';

const Color brandGreen = Color(0xFF246B55);

class OpportunityCard extends StatelessWidget {
  final Opportunity opportunity;
  final VoidCallback onTap;

  const OpportunityCard({
    super.key,
    required this.opportunity,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(
          color: Colors.grey,
          width: 1.5,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      opportunity.title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF17211D),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  StatusBadge(status: opportunity.status),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                opportunity.description,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.4,
                  color: Color(0xFF4E5952),
                ),
              ),
              const SizedBox(height: 24),
              Wrap(
                spacing: 20,
                runSpacing: 12,
                children: [
                  DetailChip(
                    icon: Icons.location_on_outlined,
                    label: opportunity.location,
                  ),
                  DetailChip(
                    icon: Icons.business_outlined,
                    label: opportunity.category,
                  ),
                  DetailChip(
                    icon: Icons.calendar_month_outlined,
                    label: opportunity.deadline,
                  ),
                  DetailChip(
                    icon: Icons.savings_outlined,
                    label: 'Budget ${opportunity.budget}',
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '${opportunity.requirements} requirements',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF4E5952),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: onTap,
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Open',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: brandGreen,
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(
                          Icons.chevron_right,
                          size: 16,
                          color: Color(0xFF17211D),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}