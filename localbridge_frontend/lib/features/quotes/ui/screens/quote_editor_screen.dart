import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localbridge_frontend/app/theme/app_palette.dart';
import 'package:localbridge_frontend/core/ids/demo_id_generator.dart';
import 'package:localbridge_frontend/core/money/money.dart';
import 'package:localbridge_frontend/core/widgets/confirm_dialog.dart';
import 'package:localbridge_frontend/core/widgets/key_value_row.dart';
import 'package:localbridge_frontend/core/widgets/section_card.dart';
import 'package:localbridge_frontend/init_dependencies.dart';

import '../../../../core/time/date_lables.dart';
import '../../bloc/quote_editor_bloc.dart';
import '../../domain/entities/quote.dart';
import '../../domain/usecases/save_quote_draft_use_case.dart';
import '../../domain/usecases/submit_quote_use_case.dart';
import '../widgets/quote_status_chip.dart';
import '../widgets/upfront_warning.dart';

Route<void> quoteEditorRoute({required Quote quote}) => MaterialPageRoute<void>(
  builder: (_) => BlocProvider<QuoteEditorBloc>(
    create: (_) => QuoteEditorBloc(
      initialQuote: quote,
      saveQuoteDraftUseCase: serviceLocator<SaveQuoteDraftUseCase>(),
      submitQuoteUseCase: serviceLocator<SubmitQuoteUseCase>(),
      idGenerator: serviceLocator<DemoIdGenerator>(),
    ),
    child: QuoteEditorScreen(quote: quote),
  ),
);

class QuoteEditorScreen extends StatefulWidget {
  const QuoteEditorScreen({super.key, required this.quote});

  final Quote quote;

  @override
  State<QuoteEditorScreen> createState() => _QuoteEditorScreenState();
}

class _QuoteEditorScreenState extends State<QuoteEditorScreen> {
  late final TextEditingController _upfrontController;

  @override
  void initState() {
    super.initState();
    _upfrontController = TextEditingController(
      text: Money.toEditableInput(widget.quote.upfrontCents),
    );
  }

  @override
  void dispose() {
    _upfrontController.dispose();
    super.dispose();
  }

  void _syncUpfrontField(int cents) {
    final current = Money.parseToCents(_upfrontController.text) ?? 0;
    if (current == cents) return;
    final text = Money.toEditableInput(cents);
    _upfrontController.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPalette.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Prepare quote'),
      ),
      body: BlocConsumer<QuoteEditorBloc, QuoteEditorState>(
        listener: (context, state) {
          _syncUpfrontField(state.quote.upfrontCents);
          if (state.message != null) {
            showFeedbackMessage(context, state.message!);
          }
          if (state.status == QuoteEditorStatus.submitted) {
            Navigator.of(context).pop();
          }
        },
        builder: (context, state) {
          final quote = state.quote;
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
            children: [
              _HeaderCard(quote: quote),
              const SizedBox(height: 16),
              _LinesCard(
                quote: quote,
                onAdd: () =>
                    context.read<QuoteEditorBloc>().add(const QuoteLineAdded()),
                onRemove: (lineId) => context.read<QuoteEditorBloc>().add(
                  QuoteLineRemoved(lineId),
                ),
              ),
              const SizedBox(height: 16),
              _UpfrontCard(
                quote: quote,
                controller: _upfrontController,
                onChanged: (value) => context.read<QuoteEditorBloc>().add(
                  QuoteUpfrontChanged(value),
                ),
                onEstimate: () => context.read<QuoteEditorBloc>().add(
                  const QuoteUpfrontEstimateRequested(),
                ),
              ),
              const SizedBox(height: 16),
              _RequirementsCard(quote: quote),
              const SizedBox(height: 16),
              _BuyerMessageCard(
                quote: quote,
                onChanged: (value) => context.read<QuoteEditorBloc>().add(
                  QuoteBuyerMessageChanged(value),
                ),
              ),
              if (state.validationIssues.isNotEmpty) ...[
                const SizedBox(height: 16),
                _IssuesCard(issues: state.validationIssues),
              ],
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: state.isBusy
                          ? null
                          : () => context.read<QuoteEditorBloc>().add(
                              const QuoteSaveRequested(),
                            ),
                      child: const Text('Save draft'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: AppPalette.brandGreen,
                      ),
                      onPressed: state.isBusy
                          ? null
                          : () => context.read<QuoteEditorBloc>().add(
                              const QuoteSubmitRequested(),
                            ),
                      child: const Text('Submit quote'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                'Submitting runs the same checks the buyer would see: every '
                'line needs a description and a price, quantities must be at '
                'least 1 and all mandatory requirements must be answered.',
                style: TextStyle(fontSize: 11, color: AppPalette.mutedInk),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  const _HeaderCard({required this.quote});

  final Quote quote;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: quote.opportunityTitle,
      trailing: QuoteStatusChip(status: quote.status),
      child: KeyValueRow(
        label: 'Closes',
        value: relativeClosingLabel(quote.opportunityClosingDate),
      ),
    );
  }
}

class _LinesCard extends StatelessWidget {
  const _LinesCard({
    required this.quote,
    required this.onAdd,
    required this.onRemove,
  });

  final Quote quote;
  final VoidCallback onAdd;
  final ValueChanged<String> onRemove;

  @override
  Widget build(BuildContext context) {
    final canRemove = quote.lines.length > 1;

    return SectionCard(
      title: 'Quote lines',
      trailing: TextButton.icon(
        onPressed: onAdd,
        icon: const Icon(Icons.add, size: 18),
        label: const Text('Add line'),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var index = 0; index < quote.lines.length; index++) ...[
            if (index > 0) const Divider(height: 24),
            _LineEditor(
              key: ValueKey(quote.lines[index].id),
              line: quote.lines[index],
              index: index,
              canRemove: canRemove,
              onRemove: () => onRemove(quote.lines[index].id),
            ),
          ],
        ],
      ),
    );
  }
}

class _LineEditor extends StatelessWidget {
  const _LineEditor({
    super.key,
    required this.line,
    required this.index,
    required this.canRemove,
    required this.onRemove,
  });

  final QuoteLine line;
  final int index;
  final bool canRemove;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<QuoteEditorBloc>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Line ${index + 1}',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppPalette.ink,
                ),
              ),
            ),
            IconButton(
              onPressed: canRemove ? onRemove : null,
              icon: const Icon(Icons.delete_outline, size: 20),
              tooltip: 'Remove line',
            ),
          ],
        ),
        TextFormField(
          initialValue: line.description,
          decoration: const InputDecoration(
            labelText: 'Description',
            border: OutlineInputBorder(),
            isDense: true,
          ),
          onChanged: (value) => bloc.add(
            QuoteLineDescriptionChanged(lineId: line.id, value: value),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                initialValue: line.quantity.toString(),
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Quantity',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                onChanged: (value) => bloc.add(
                  QuoteLineQuantityChanged(lineId: line.id, value: value),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                initialValue: Money.toEditableInput(line.unitPriceCents),
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Unit price (R)',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                onChanged: (value) => bloc.add(
                  QuoteLineUnitPriceChanged(lineId: line.id, value: value),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Line total ${Money.format(line.lineTotalCents)}',
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppPalette.brandGreen,
          ),
        ),
      ],
    );
  }
}

class _UpfrontCard extends StatelessWidget {
  const _UpfrontCard({
    required this.quote,
    required this.controller,
    required this.onChanged,
    required this.onEstimate,
  });

  final Quote quote;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onEstimate;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'Upfront cash',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Upfront cash (R)',
              helperText: 'Cash you need before starting the work.',
              border: OutlineInputBorder(),
              isDense: true,
            ),
            onChanged: onChanged,
          ),
          const SizedBox(height: 4),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: onEstimate,
              child: const Text('Estimate 60% of the quote total'),
            ),
          ),
          KeyValueRow(
            label: 'Upfront share',
            value:
                '${Money.formatPercentage(quote.upfrontShare)} of '
                '${Money.format(quote.totalCents)}',
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

class _RequirementsCard extends StatelessWidget {
  const _RequirementsCard({required this.quote});

  final Quote quote;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<QuoteEditorBloc>();

    if (quote.requirements.isEmpty) {
      return const SectionCard(
        title: 'Buyer requirements',
        child: Text(
          'This opportunity has no requirements to answer.',
          style: TextStyle(fontSize: 13, color: AppPalette.mutedInk),
        ),
      );
    }

    return SectionCard(
      title: 'Buyer requirements',
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
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: quote.responseFor(requirement.id)?.canMeet ?? false,
              onChanged: (value) => bloc.add(
                QuoteResponseChanged(
                  requirementId: requirement.id,
                  canMeet: value,
                ),
              ),
              title: Text(
                requirement.text,
                style: const TextStyle(fontSize: 13, color: AppPalette.ink),
              ),
              subtitle: Text(
                requirement.isMandatory ? 'Mandatory' : 'Optional',
                style: TextStyle(
                  fontSize: 11,
                  color: requirement.isMandatory
                      ? AppPalette.brandGreen
                      : const Color(0xFF9AA8A0),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _BuyerMessageCard extends StatelessWidget {
  const _BuyerMessageCard({required this.quote, required this.onChanged});

  final Quote quote;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'Message to the buyer',
      child: TextFormField(
        initialValue: quote.buyerMessage,
        maxLines: 3,
        decoration: const InputDecoration(
          hintText: 'Explain timing, what is included or any assumptions.',
          border: OutlineInputBorder(),
        ),
        onChanged: onChanged,
      ),
    );
  }
}

class _IssuesCard extends StatelessWidget {
  const _IssuesCard({required this.issues});

  final List<String> issues;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFDECEA),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFF2B8B5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Fix these before submitting',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xFFB3261E),
            ),
          ),
          const SizedBox(height: 8),
          for (final issue in issues)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Text(
                '• $issue',
                style: const TextStyle(
                  fontSize: 12,
                  height: 1.35,
                  color: Color(0xFFB3261E),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
