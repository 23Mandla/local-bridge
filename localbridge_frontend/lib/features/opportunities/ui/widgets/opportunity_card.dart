import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localbridge_frontend/features/opportunities/ui/widgets/status_badge.dart';

import '../../../../app/theme/app_palette.dart';
import '../../../../core/money/money.dart';
import '../../../../core/time/date_lables.dart';
import '../../../../core/time/demo_clock.dart';
import '../../domain/entities/opportunity.dart';
import 'detail_chip.dart';

const Color brandGreen = AppPalette.primary;

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
    final isOpen = opportunity.isOpenAt(DemoClock.today);

    return Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: Colors.grey, width: 1.5),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
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
                        color: Colors.green,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  StatusBadge(status: opportunity.status.label),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                opportunity.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.4,
                  color: Color(0xFF4E5952), //TODO subject to change
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
                    label: relativeClosingLabel(
                      opportunity.closingDate,
                      now: DemoClock.today,
                    ),
                  ),
                  DetailChip(
                    icon: Icons.savings_outlined,
                    label: 'Budget ${Money.format(opportunity.budgetCents)}',
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '${opportunity.requirementCount} requirements '
                      '(${opportunity.mandatoryRequirementCount} mandatory)',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF4E5952), //TODO subject to change
                      ),
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        isOpen ? 'Prepare quote' : 'Open',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: brandGreen,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.chevron_right,
                        size: 16,
                        color: Color(0xFF17211D), //TODO subject to change
                      ),
                    ],
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
