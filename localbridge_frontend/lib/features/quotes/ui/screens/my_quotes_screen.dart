import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localbridge_frontend/app/theme/app_palette.dart';
import 'package:localbridge_frontend/core/widgets/empty_state.dart';

import '../../bloc/my_quotes_bloc.dart';
import '../widgets/quote_card.dart';
import 'quote_detail_screen.dart';

/// Entrepreneur tab listing every quote the business has prepared.
class MyQuotesScreen extends StatelessWidget {
  const MyQuotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyQuotesBloc, MyQuotesState>(
      builder: (context, state) {
        if (state.status == MyQuotesStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.status == MyQuotesStatus.failure) {
          return EmptyState(
            icon: Icons.error_outline,
            title: 'Quotes could not be loaded',
            message: state.message,
          );
        }

        if (state.quotes.isEmpty) {
          return const EmptyState(
            icon: Icons.description_outlined,
            title: 'No quotes yet',
            message: 'Open an opportunity and prepare a quote to see it here.',
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(18, 20, 18, 24),
          itemCount: state.quotes.length + 1,
          separatorBuilder: (_, _) => const SizedBox(height: 14),
          itemBuilder: (context, index) {
            if (index == 0) {
              return _SummaryRow(state: state);
            }
            final quote = state.quotes[index - 1];
            return QuoteCard(
              quote: quote,
              onTap: () => Navigator.of(
                context,
              ).push(quoteDetailRoute(quoteId: quote.id, buyerMode: false)),
            );
          },
        );
      },
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.state});

  final MyQuotesState state;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        '${state.drafts.length} draft(s) · ${state.quotes.length} quote(s) total',
        style: const TextStyle(fontSize: 12, color: AppPalette.mutedInk),
      ),
    );
  }
}