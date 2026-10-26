import 'package:flutter/material.dart';

import 'package:localbridge_frontend/app/theme/app_palette.dart';
import 'package:localbridge_frontend/core/money/money.dart';

import '../../../../core/time/date_lables.dart';
import '../../domain/entities/quote.dart';
import 'quote_status_chip.dart';
import 'upfront_warning.dart';

/// Summary card used by both the entrepreneur's "My quotes" list and the
/// buyer's procurement inbox.
class QuoteCard extends StatelessWidget {
  const QuoteCard({
    super.key,
    required this.quote,
    required this.onTap,
    this.showBusinessName = false,
  });

  final Quote quote;
  final VoidCallback onTap;

  /// The buyer needs to see which business quoted; the entrepreneur does not.
  final bool showBusinessName;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: Color(0xFFDDE4DF)),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      quote.opportunityTitle,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppPalette.ink,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  QuoteStatusChip(status: quote.status),
                ],
              ),
              if (showBusinessName) ...[
                const SizedBox(height: 6),
                Text(
                  quote.businessName,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppPalette.brandGreen,
                  ),
                ),
              ],
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _Fact(
                      label: 'Quote total',
                      value: Money.format(quote.totalCents),
                    ),
                  ),
                  Expanded(
                    child: _Fact(
                      label: 'Upfront',
                      value:
                          '${Money.format(quote.upfrontCents)} '
                          '(${Money.formatPercentage(quote.upfrontShare)})',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                _dateLabel(quote),
                style: const TextStyle(
                  fontSize: 12,
                  color: AppPalette.mutedInk,
                ),
              ),
              if (quote.upfrontExceedsThreshold) ...[
                const SizedBox(height: 12),
                const UpfrontWarning(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  static String _dateLabel(Quote quote) {
    if (quote.decidedAt != null) {
      return 'Decision recorded ${formatDemoDate(quote.decidedAt!)}';
    }
    if (quote.submittedAt != null) {
      return 'Submitted ${formatDemoDate(quote.submittedAt!)}';
    }
    return 'Draft prepared ${formatDemoDate(quote.preparedAt)}';
  }
}

class _Fact extends StatelessWidget {
  const _Fact({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: AppPalette.mutedInk),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: AppPalette.ink,
          ),
        ),
      ],
    );
  }
}
