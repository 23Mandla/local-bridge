import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localbridge_frontend/app/theme/app_palette.dart';
import 'package:localbridge_frontend/core/money/money.dart';
import 'package:localbridge_frontend/core/widgets/confirm_dialog.dart';
import 'package:localbridge_frontend/core/widgets/empty_state.dart';
import 'package:localbridge_frontend/core/widgets/key_value_row.dart';
import 'package:localbridge_frontend/core/widgets/section_card.dart';
import 'package:localbridge_frontend/init_dependencies.dart';

import '../../../../core/time/date_lables.dart';
import '../../bloc/quote_detail_bloc.dart';
import '../../domain/entities/quote.dart';
import '../../domain/entities/quote_status.dart';
import '../../domain/usecases/decide_quote_use_case.dart';
import '../../domain/usecases/watch_quotes_use_cases.dart';
import '../widgets/quote_status_chip.dart';
import '../widgets/upfront_warning.dart';

/// Opens the read-only quote view.
///
/// [buyerMode] is `true` for the buyer's procurement inbox, which is the only
/// place where a submitted quote can be accepted or declined.
Route<void> quoteDetailRoute({
  required String quoteId,
  required bool buyerMode,
}) => MaterialPageRoute<void>(
  builder: (_) => BlocProvider<QuoteDetailBloc>(
    create: (_) => QuoteDetailBloc(
      watchQuoteUseCase: serviceLocator<WatchQuoteUseCase>(),
      decideQuoteUseCase: serviceLocator<DecideQuoteUseCase>(),
    )..add(QuoteDetailStarted(quoteId)),
    child: QuoteDetailScreen(quoteId: quoteId, buyerMode: buyerMode),
  ),
);

class QuoteDetailScreen extends StatelessWidget {
  const QuoteDetailScreen({
    super.key,
    required this.quoteId,
    required this.buyerMode,
  });

  final String quoteId;
  final bool buyerMode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPalette.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(buyerMode ? 'Quote for review' : 'Your quote'),
      ),
      body: BlocConsumer<QuoteDetailBloc, QuoteDetailState>(
        listener: (context, state) {
          final message = state.errorMessage ?? state.infoMessage;
          if (message != null) showFeedbackMessage(context, message);
        },
        builder: (context, state) {
          final quote = state.quote;
          if (quote == null) {
            if (state.status == QuoteDetailStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            return const EmptyState(
              icon: Icons.search_off,
              title: 'Quote not found',
              message: 'This quote is no longer available in the demo store.',
            );
          }

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
            children: [
              _OverviewCard(quote: quote, buyerMode: buyerMode),
              const SizedBox(height: 16),
              _PricedLinesCard(quote: quote),
              const SizedBox(height: 16),
              _TotalsCard(quote: quote),
              const SizedBox(height: 16),
              _ResponsesCard(quote: quote),
              if (buyerMode && quote.canBeDecided) ...[
                const SizedBox(height: 20),
                _DecisionActions(quote: quote),
              ],
              if (!buyerMode && quote.canBeDecided) ...[
                const SizedBox(height: 16),
                const Text(
                  'Waiting for the buyer to accept or decline this quote.',
                  style: TextStyle(fontSize: 12, color: AppPalette.mutedInk),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _OverviewCard extends StatelessWidget {
  const _OverviewCard({required this.quote, required this.buyerMode});

  final Quote quote;
  final bool buyerMode;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: quote.opportunityTitle,
      trailing: QuoteStatusChip(status: quote.status),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          KeyValueRow(
            label: buyerMode ? 'Quoting business' : 'Your business',
            value: quote.businessName,
          ),
          KeyValueRow(label: 'Quote ID', value: quote.id),
          KeyValueRow(label: 'Opportunity ID', value: quote.opportunityId),
          KeyValueRow(
            label: 'Prepared',
            value: formatDemoDate(quote.preparedAt),
          ),
          if (quote.submittedAt != null)
            KeyValueRow(
              label: 'Submitted',
              value: formatDemoDate(quote.submittedAt!),
            ),
          if (quote.decidedAt != null)
            KeyValueRow(
              label: 'Decision recorded',
              value: formatDemoDate(quote.decidedAt!),
            ),
          if (quote.buyerMessage.trim().isNotEmpty) ...[
            const Divider(height: 24),
            const Text(
              'Message from the business',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppPalette.ink,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              quote.buyerMessage,
              style: const TextStyle(
                fontSize: 13,
                height: 1.4,
                color: AppPalette.mutedInk,
              ),
            ),
          ],
          if (quote.buyerNote != null) ...[
            const Divider(height: 24),
            const Text(
              'Buyer note',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppPalette.ink,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              quote.buyerNote!,
              style: const TextStyle(
                fontSize: 13,
                height: 1.4,
                color: AppPalette.mutedInk,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _PricedLinesCard extends StatelessWidget {
  const _PricedLinesCard({required this.quote});

  final Quote quote;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'Priced lines',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (quote.lines.isEmpty)
            const Text(
              'No lines were priced on this quote.',
              style: TextStyle(fontSize: 13, color: AppPalette.mutedInk),
            )
          else
            for (var index = 0; index < quote.lines.length; index++) ...[
              if (index > 0) const Divider(height: 20),
              _LineRow(line: quote.lines[index]),
            ],
        ],
      ),
    );
  }
}

class _LineRow extends StatelessWidget {
  const _LineRow({required this.line});

  final QuoteLine line;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          line.description.trim().isEmpty ? 'Untitled line' : line.description,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppPalette.ink,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${line.quantity} × ${Money.format(line.unitPriceCents)}  =  '
          '${Money.format(line.lineTotalCents)}',
          style: const TextStyle(fontSize: 12, color: AppPalette.mutedInk),
        ),
      ],
    );
  }
}

class _TotalsCard extends StatelessWidget {
  const _TotalsCard({required this.quote});

  final Quote quote;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'Totals',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          KeyValueRow(
            label: 'Quote total',
            value: Money.format(quote.totalCents),
            emphasise: true,
          ),
          KeyValueRow(
            label: 'Upfront cash',
            value: Money.format(quote.upfrontCents),
          ),
          KeyValueRow(
            label: 'Upfront share',
            value: Money.formatPercentage(quote.upfrontShare),
            emphasise: true,
          ),
          if (quote.upfrontExceedsThreshold) ...[
            const SizedBox(height: 8),
            const UpfrontWarning(),
          ],
        ],
      ),
    );
  }
}

class _ResponsesCard extends StatelessWidget {
  const _ResponsesCard({required this.quote});

  final Quote quote;

  @override
  Widget build(BuildContext context) {
    if (quote.requirements.isEmpty) return const SizedBox.shrink();

    return SectionCard(
      title: 'Requirement responses',
      trailing: Text(
        '${quote.answeredRequirementCount}/${quote.requirements.length}',
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: AppPalette.mutedInk,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final requirement in quote.requirements)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    quote.responseFor(requirement.id) == null
                        ? Icons.remove_circle_outline
                        : quote.responseFor(requirement.id)!.canMeet
                        ? Icons.check_circle
                        : Icons.cancel_outlined,
                    size: 16,
                    color: quote.responseFor(requirement.id)?.canMeet ?? false
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
                    quote.responseFor(requirement.id) == null
                        ? 'Not answered'
                        : quote.responseFor(requirement.id)!.canMeet
                        ? 'Can meet'
                        : 'Cannot meet',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppPalette.mutedInk,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _DecisionActions extends StatelessWidget {
  const _DecisionActions({required this.quote});

  final Quote quote;

  Future<void> _decide(BuildContext context, QuoteDecision decision) async {
    final noteController = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('${decision.label}?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              decision == QuoteDecision.accept
                  ? 'The business will be told this quote was accepted.'
                  : 'The business will be told this quote was declined.',
            ),
            const SizedBox(height: 12),
            TextField(
              controller: noteController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Note for the business (optional)',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: decision == QuoteDecision.accept
                  ? AppPalette.brandGreen
                  : const Color(0xFFB3261E),
            ),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(decision.label),
          ),
        ],
      ),
    );

    final note = noteController.text;
    noteController.dispose();

    if ((confirmed ?? false) && context.mounted) {
      context.read<QuoteDetailBloc>().add(
        QuoteDecisionRequested(
          quoteId: quote.id,
          decision: decision,
          note: note,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => _decide(context, QuoteDecision.decline),
            child: const Text('Decline'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppPalette.brandGreen,
            ),
            onPressed: () => _decide(context, QuoteDecision.accept),
            child: const Text('Accept'),
          ),
        ),
      ],
    );
  }
}
