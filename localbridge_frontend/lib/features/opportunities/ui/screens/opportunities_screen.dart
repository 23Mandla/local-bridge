import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/opportunity.dart';
import '../widgets/opportunity_card.dart';

const Color pageBackground = Color(0xFFF3F7F4);

class OpportunitiesScreen extends StatelessWidget {
  final List<Opportunity> opportunities;

  const OpportunitiesScreen({super.key, required this.opportunities});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(18, 24, 18, 24),
      itemCount: opportunities.length,
      separatorBuilder: (_, _) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        return OpportunityCard(
          opportunity: opportunities[index],
          onTap: () {
            // Navigate to opportunity details.
          },
        );
      },
    );
  }
}
