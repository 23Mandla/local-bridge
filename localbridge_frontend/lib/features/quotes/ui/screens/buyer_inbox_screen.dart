import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localbridge_frontend/app/theme/app_palette.dart';
import 'package:localbridge_frontend/core/widgets/empty_state.dart';

import '../../bloc/buyer_inbox_bloc.dart';
import '../widgets/quote_card.dart';
import 'quote_detail_screen.dart';

/// Buyer destination: submitted quotations waiting for a decision.
class BuyerInboxScreen extends StatelessWidget {
  const BuyerInboxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(18, 16, 18, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Procurement inbox',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: AppPalette.ink,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Quotes submitted by local businesses',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppPalette.mutedInk,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: BlocBuilder<BuyerInboxBloc, BuyerInboxState>(
                builder: (context, state) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _CountsRow(state: state),
                      const SizedBox(height: 12),
                      _FilterRow(state: state),
                      const SizedBox(height: 4),
                      _QuoteList(state: state),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CountsRow extends StatelessWidget {
  const _CountsRow({required this.state});

  final BuyerInboxState state;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Row(
        children: [
          _CountTile(
            label: 'Awaiting',
            value: state.awaitingCount,
            emphasised: true,
          ),
          const SizedBox(width: 10),
          _CountTile(label: 'Decided', value: state.decidedCount),
          const SizedBox(width: 10),
          _CountTile(label: 'Total', value: state.totalCount),
        ],
      ),
    );
  }
}

class _CountTile extends StatelessWidget {
  const _CountTile({
    required this.label,
    required this.value,
    this.emphasised = false,
  });

  final String label;
  final int value;
  final bool emphasised;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          color: emphasised ? const Color(0xFFE8F3EC) : const Color(0xFFF2F4F2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$value',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: emphasised ? AppPalette.brandGreen : AppPalette.ink,
              ),
            ),
            Text(
              label,
              style: const TextStyle(fontSize: 11, color: AppPalette.mutedInk),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterRow extends StatelessWidget {
  const _FilterRow({required this.state});

  final BuyerInboxState state;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Wrap(
        spacing: 8,
        children: [
          for (final filter in QuoteInboxFilter.values)
            ChoiceChip(
              label: Text(filter.label),
              selected: state.filter == filter,
              onSelected: (_) => context.read<BuyerInboxBloc>().add(
                BuyerInboxFilterChanged(filter),
              ),
            ),
        ],
      ),
    );
  }
}

class _QuoteList extends StatelessWidget {
  const _QuoteList({required this.state});

  final BuyerInboxState state;

  @override
  Widget build(BuildContext context) {
    if (state.status == BuyerInboxStatus.loading) {
      return const Padding(
        padding: EdgeInsets.only(top: 48),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (state.status == BuyerInboxStatus.failure) {
      return EmptyState(
        icon: Icons.error_outline,
        title: 'Inbox could not be loaded',
        message: state.message,
      );
    }

    final quotes = state.visibleQuotes;
    if (quotes.isEmpty) {
      return EmptyState(
        icon: Icons.inbox_outlined,
        title: 'Nothing here',
        message: switch (state.filter) {
          QuoteInboxFilter.awaiting =>
            'No submitted quotes are waiting for a decision.',
          QuoteInboxFilter.decided => 'No quotes have been decided yet.',
          QuoteInboxFilter.all => 'No quotes have been submitted yet.',
        },
      );
    }

    return Expanded(
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
        itemCount: quotes.length,
        separatorBuilder: (_, _) => const SizedBox(height: 14),
        itemBuilder: (context, index) {
          final quote = quotes[index];
          return QuoteCard(
            quote: quote,
            showBusinessName: true,
            onTap: () => Navigator.of(
              context,
            ).push(quoteDetailRoute(quoteId: quote.id, buyerMode: true)),
          );
        },
      ),
    );
  }
}
