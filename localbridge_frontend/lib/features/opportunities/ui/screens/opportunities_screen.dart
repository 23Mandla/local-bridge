import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/opportunity.dart';
import '../widgets/opportunity_card.dart';

const Color pageBackground = Color(0xFFF3F7F4);

class OpportunitiesScreen extends StatelessWidget {
  const OpportunitiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final opportunities = <Opportunity>[
      const Opportunity(
        title: 'Cleaning a community venue',
        description:
            'A full deep clean of the community sports centre before an upcoming tournament weekend.',
        location: 'Khutsong Sports Centre',
        category: 'Cleaning',
        deadline: 'Closes in 3 days',
        budget: 'R 4 500,00',
        requirements: 5,
        status: 'Submitted',
      ),
      const Opportunity(
        title: 'Catering for 100 meals',
        description:
            'A one-day community event needs 100 individually boxed hot meals delivered and served.',
        location: 'Khutsong Community Hall',
        category: 'Catering',
        deadline: 'Closes in 5 days',
        budget: 'R 7 000,00',
        requirements: 7,
        status: 'Draft',
      ),
      const Opportunity(
        title: 'Printing workshop materials',
        description:
            'Printed workshop manuals and posters for a three-day business skills workshop at the Khutsong Skills Centre.',
        location: 'Khutsong Skills Centre',
        category: 'Printing',
        deadline: 'Closes in 7 days',
        budget: 'R 3 200,00',
        requirements: 4,
        status: 'Open',
      ),
    ];

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(18, 24, 18, 24),
      itemCount: opportunities.length,
      separatorBuilder: (_, __) => const SizedBox(height: 26),
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
