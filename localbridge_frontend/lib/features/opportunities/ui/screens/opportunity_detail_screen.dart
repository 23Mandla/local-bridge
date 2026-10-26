import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/theme/app_palette.dart';
import '../../../../core/money/money.dart';
import '../../../../core/time/date_lables.dart';
import '../../../../core/time/demo_clock.dart';
import '../../../../core/widgets/confirm_dialog.dart';
import '../../../../core/widgets/key_value_row.dart';
import '../../../../core/widgets/section_card.dart';
import '../../../../init_dependencies.dart';
import '../../../quotes/domain/entities/quote.dart';
import '../../../quotes/domain/usecases/get_or_create_quote_draft_use_case.dart';
import '../../../quotes/domain/usecases/watch_quotes_use_cases.dart';
import '../../../quotes/ui/screens/quote_detail_screen.dart';
import '../../../quotes/ui/screens/quote_editor_screen.dart';
import '../../../quotes/ui/widgets/quote_status_chip.dart';
import '../../bloc/opportunity_quote_bloc.dart';
import '../../domain/entities/opportunity.dart';

Route<void> opportunityDetailRoute({required Opportunity opportunity}) =>
    MaterialPageRoute<void>(
      builder: (_) => BlocProvider<OpportunityQuoteBloc>(
        create: (_) => OpportunityQuoteBloc(
          opportunity: opportunity,
          watchOpportunityQuoteUseCase:
          serviceLocator<WatchOpportunityQuoteUseCase>(),
          getOrCreateQuoteDraftUseCase:
          serviceLocator<GetOrCreateQuoteDraftUseCase>(),
        )..add(OpportunityQuoteStarted(opportunity)),
        child: OpportunityDetailScreen(opportunity: opportunity),
      ),
    );

class OpportunityDetailScreen extends StatelessWidget {
  const OpportunityDetailScreen({super.key, required this.opportunity});

  final Opportunity opportunity;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPalette.background,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text('Opportunity'),
        ),
      body: BlocConsumer<OpportunityQuoteBloc, OpportunityQuoteState>(
        listener: (context, state) {
          if (state.message != null) {
            showFeedbackMessage(context, state.message!);
          }
          final draft = state.draft;
          if (draft != null) {
            context.read<OpportunityQuoteBloc>().add(
              const OpportunityQuoteDraftHandled(),
            );
            Navigator.of(context).push(quoteEditorRoute(quote: draft));
          }
        },
        builder: (context, state) {
          final isOpen = opportunity.isOpenAt(DemoClock.today);
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
            children: [
              _OpportunitySummary(opportunity: opportunity),
              const SizedBox(height: 16),
              _QuoteProgressCard(
                quote: state.quote,
                isOpen: isOpen,
                isPreparing: state.isPreparing,
                onAction: () {
                  final current = state.quote;
                  if (current != null && !current.canBeEdited) {
                    Navigator.of(context).push(
                      quoteDetailRoute(quoteId: current.id, buyerMode: false),
                    );
                    return;
                  }
                  context.read<OpportunityQuoteBloc>().add(
                    const OpportunityQuotePrepareRequested(),
                  );
                },
              ),
              const SizedBox(height: 16),
              SectionCard(
                title: 'Buyer requirements',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final requirement in opportunity.requirements)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              requirement.isMandatory
                                  ? Icons.priority_high_rounded
                                  : Icons.check_circle_outline,
                              size: 16,
                              color: requirement.isMandatory
                                  ? AppPalette.brandGreen
                                  : const Color(0xFF9AA8A0),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                requirement.text,
                                style: const TextStyle(
                                  fontSize: 13,
                                  height: 1.35,
                                  color: AppPalette.ink,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              requirement.isMandatory
                                  ? 'Mandatory'
                                  : 'Optional',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: requirement.isMandatory
                                    ? AppPalette.brandGreen
                                    : const Color(0xFF9AA8A0),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _OpportunitySummary extends StatelessWidget {
  const _OpportunitySummary({required this.opportunity});

  final Opportunity opportunity;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: opportunity.title,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            opportunity.description,
            style: const TextStyle(
              fontSize: 13,
              height: 1.45,
              color: AppPalette.mutedInk,
            ),
          ),
          const Divider(height: 24),
          KeyValueRow(label: 'Buyer', value: opportunity.buyerName),
          KeyValueRow(
            label: 'Organisation',
            value: opportunity.buyerOrganisation,
          ),
          KeyValueRow(label: 'Location', value: opportunity.location),
          KeyValueRow(label: 'Category', value: opportunity.category),
          KeyValueRow(
            label: 'Closing date',
            value:
            '${formatDemoDate(opportunity.closingDate)} · '
                '${relativeClosingLabel(opportunity.closingDate, now: DemoClock.today)}',
          ),
          KeyValueRow(
            label: 'Delivery date',
            value: formatDemoDate(opportunity.deliveryDate),
          ),
          KeyValueRow(
            label: 'Budget',
            value: Money.format(opportunity.budgetCents),
          ),
          KeyValueRow(
            label: 'Status',
            value: opportunity.status.label,
            valueColor: opportunity.isOpenAt(DemoClock.today)
                ? AppPalette.brandGreen
                : const Color(0xFFB3261E),
          ),
        ],
      ),
    );
  }
}

class _QuoteProgressCard extends StatelessWidget {
  const _QuoteProgressCard({
    required this.quote,
    required this.isOpen,
    required this.isPreparing,
    required this.onAction,
  });

  final Quote? quote;
  final bool isOpen;
  final bool isPreparing;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    final current = quote;
    final hasQuote = current != null;
    final canAct =
        (isOpen && (current == null || current.canBeEdited)) ||
            (hasQuote && !current.canBeEdited);

    return SectionCard(
      title: 'Your quote',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (current == null)
            const Text(
              'No quote prepared yet. Answer the buyer requirements and price '
                  'your lines before submitting.',
              style: TextStyle(
                fontSize: 13,
                height: 1.4,
                color: AppPalette.mutedInk,
              ),
            )
          else ...[
            Row(
              children: [
                QuoteStatusChip(status: current.status),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    '${current.answeredRequirementCount} of '
                        '${current.requirements.length} requirements answered',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppPalette.mutedInk,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            KeyValueRow(
              label: 'Quote total',
              value: Money.format(current.totalCents),
            ),
            KeyValueRow(
              label: 'Upfront cash',
              value:
              '${Money.format(current.upfrontCents)} '
                  '(${Money.formatPercentage(current.upfrontShare)})',
            ),
          ],
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: AppPalette.brandGreen,
              ),
              onPressed: !canAct || isPreparing ? null : onAction,
              child: Text(_buttonLabel(current, isOpen, isPreparing)),
            ),
          ),
          if (!isOpen)
            const Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text(
                'This opportunity has closed and can no longer receive quotes.',
                style: TextStyle(fontSize: 12, color: Color(0xFFB3261E)),
              ),
            ),
        ],
      ),
    );
  }

  static String _buttonLabel(Quote? quote, bool isOpen, bool isPreparing) {
    if (isPreparing) return 'Preparing…';
    if (quote == null) {
      return isOpen ? 'Prepare quote' : 'Closed';
    }
    if (quote.canBeEdited) return 'Continue editing draft';
    return 'View submitted quote';
  }
}
