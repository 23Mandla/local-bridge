import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/opportunity.dart';
import '../widgets/opportunity_card.dart';
import 'opportunity_detail_screen.dart';

const Color pageBackground = Color(0xFFF3F7F4);

class OpportunitiesScreen extends StatelessWidget {
  final List<Opportunity> opportunities;

  const OpportunitiesScreen({super.key, required this.opportunities});

  @override
  Widget build(BuildContext context) {

    // Soonest closing date first so urgent work is at the top.
    final sorted = [...opportunities]
      ..sort((a, b) => a.closingDate.compareTo(b.closingDate));

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(18, 24, 18, 24),
      itemCount: sorted.length,
      separatorBuilder: (_, _) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final opportunity = sorted[index];
        return OpportunityCard(
          opportunity: opportunity,
          onTap: () => Navigator.of(
            context,
          ).push(opportunityDetailRoute(opportunity: opportunity)),
        );
      },
    );
  }
}
