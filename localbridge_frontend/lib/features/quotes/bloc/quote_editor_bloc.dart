import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:localbridge_frontend/core/ids/demo_id_generator.dart';
import 'package:localbridge_frontend/core/money/money.dart';
import 'package:localbridge_frontend/core/time/demo_clock.dart';

import '../domain/entities/quote.dart';
import '../domain/quote_submission_validator.dart';
import '../domain/usecases/save_quote_draft_use_case.dart';
import '../domain/usecases/submit_quote_use_case.dart';

enum QuoteEditorStatus {
  editing,
  saving,
  saved,
  submitting,
  submitted,
  failure,
}

class QuoteEditorState extends Equatable {
  const QuoteEditorState({
    required this.quote,
    this.status = QuoteEditorStatus.editing,
    this.message,
    this.validationIssues = const [],
  });

  final Quote quote;
  final QuoteEditorStatus status;
  final String? message;
  final List<String> validationIssues;

  bool get isBusy =>
      status == QuoteEditorStatus.saving ||
      status == QuoteEditorStatus.submitting;

  QuoteEditorState copyWith({
    Quote? quote,
    QuoteEditorStatus? status,
    String? message,
    List<String>? validationIssues,
    bool clearMessages = false,
  }) => QuoteEditorState(
    quote: quote ?? this.quote,
    status: status ?? this.status,
    message: clearMessages ? null : message ?? this.message,
    validationIssues:
        validationIssues ?? (clearMessages ? const [] : this.validationIssues),
  );

  @override
  List<Object?> get props => [quote, status, message, validationIssues];
}

abstract class QuoteEditorEvent extends Equatable {
  const QuoteEditorEvent();

  @override
  List<Object?> get props => const [];
}

class QuoteLineAdded extends QuoteEditorEvent {
  const QuoteLineAdded();
}

class QuoteLineRemoved extends QuoteEditorEvent {
  const QuoteLineRemoved(this.lineId);

  final String lineId;

  @override
  List<Object?> get props => [lineId];
}

class QuoteLineDescriptionChanged extends QuoteEditorEvent {
  const QuoteLineDescriptionChanged({
    required this.lineId,
    required this.value,
  });

  final String lineId;
  final String value;

  @override
  List<Object?> get props => [lineId, value];
}

class QuoteLineQuantityChanged extends QuoteEditorEvent {
  const QuoteLineQuantityChanged({required this.lineId, required this.value});

  final String lineId;
  final String value;

  @override
  List<Object?> get props => [lineId, value];
}

class QuoteLineUnitPriceChanged extends QuoteEditorEvent {
  const QuoteLineUnitPriceChanged({required this.lineId, required this.value});

  final String lineId;
  final String value;

  @override
  List<Object?> get props => [lineId, value];
}

class QuoteUpfrontChanged extends QuoteEditorEvent {
  const QuoteUpfrontChanged(this.value);

  final String value;

  @override
  List<Object?> get props => [value];
}

class QuoteUpfrontEstimateRequested extends QuoteEditorEvent {
  const QuoteUpfrontEstimateRequested();
}

class QuoteResponseChanged extends QuoteEditorEvent {
  const QuoteResponseChanged({
    required this.requirementId,
    required this.canMeet,
  });

  final String requirementId;
  final bool canMeet;

  @override
  List<Object?> get props => [requirementId, canMeet];
}

class QuoteBuyerMessageChanged extends QuoteEditorEvent {
  const QuoteBuyerMessageChanged(this.value);

  final String value;

  @override
  List<Object?> get props => [value];
}

class QuoteSaveRequested extends QuoteEditorEvent {
  const QuoteSaveRequested();
}

class QuoteSubmitRequested extends QuoteEditorEvent {
  const QuoteSubmitRequested();
}

/// Owns the working copy of a quotation while the entrepreneur edits it.
class QuoteEditorBloc extends Bloc<QuoteEditorEvent, QuoteEditorState> {
  QuoteEditorBloc({
    required Quote initialQuote,
    required SaveQuoteDraftUseCase saveQuoteDraftUseCase,
    required SubmitQuoteUseCase submitQuoteUseCase,
    required DemoIdGenerator idGenerator,
  }) : _saveQuoteDraftUseCase = saveQuoteDraftUseCase,
       _submitQuoteUseCase = submitQuoteUseCase,
       _idGenerator = idGenerator,
       super(QuoteEditorState(quote: initialQuote)) {
    on<QuoteLineAdded>(_onLineAdded);
    on<QuoteLineRemoved>(_onLineRemoved);
    on<QuoteLineDescriptionChanged>(_onDescriptionChanged);
    on<QuoteLineQuantityChanged>(_onQuantityChanged);
    on<QuoteLineUnitPriceChanged>(_onUnitPriceChanged);
    on<QuoteUpfrontChanged>(_onUpfrontChanged);
    on<QuoteUpfrontEstimateRequested>(_onUpfrontEstimateRequested);
    on<QuoteResponseChanged>(_onResponseChanged);
    on<QuoteBuyerMessageChanged>(_onBuyerMessageChanged);
    on<QuoteSaveRequested>(_onSaveRequested);
    on<QuoteSubmitRequested>(_onSubmitRequested);
  }

  final SaveQuoteDraftUseCase _saveQuoteDraftUseCase;
  final SubmitQuoteUseCase _submitQuoteUseCase;
  final DemoIdGenerator _idGenerator;

  void _applyLines(
    Emitter<QuoteEditorState> emit,
    List<QuoteLine> lines, {
    Quote? quote,
  }) {
    final updated = (quote ?? state.quote).copyWith(lines: lines);
    emit(
      state.copyWith(
        quote: updated,
        status: QuoteEditorStatus.editing,
        clearMessages: true,
      ),
    );
  }

  void _onLineAdded(QuoteLineAdded event, Emitter<QuoteEditorState> emit) {
    final lines = [
      ...state.quote.lines,
      QuoteLine(
        id: _idGenerator.next('line'),
        description: '',
        quantity: 1,
        unitPriceCents: 0,
      ),
    ];
    _applyLines(emit, lines);
  }

  void _onLineRemoved(QuoteLineRemoved event, Emitter<QuoteEditorState> emit) {
    if (state.quote.lines.length <= 1) return;
    final lines = state.quote.lines
        .where((line) => line.id != event.lineId)
        .toList();
    _applyLines(emit, lines);
  }

  void _onDescriptionChanged(
    QuoteLineDescriptionChanged event,
    Emitter<QuoteEditorState> emit,
  ) => _applyLines(
    emit,
    _replaceLine(
      event.lineId,
      (line) => line.copyWith(description: event.value),
    ),
  );

  void _onQuantityChanged(
    QuoteLineQuantityChanged event,
    Emitter<QuoteEditorState> emit,
  ) => _applyLines(
    emit,
    _replaceLine(
      event.lineId,
      (line) => line.copyWith(quantity: int.tryParse(event.value.trim()) ?? 0),
    ),
  );

  void _onUnitPriceChanged(
    QuoteLineUnitPriceChanged event,
    Emitter<QuoteEditorState> emit,
  ) => _applyLines(
    emit,
    _replaceLine(
      event.lineId,
      (line) =>
          line.copyWith(unitPriceCents: Money.parseToCents(event.value) ?? 0),
    ),
  );

  List<QuoteLine> _replaceLine(
    String lineId,
    QuoteLine Function(QuoteLine line) transform,
  ) => [
    for (final line in state.quote.lines)
      if (line.id == lineId) transform(line) else line,
  ];

  void _onUpfrontChanged(
    QuoteUpfrontChanged event,
    Emitter<QuoteEditorState> emit,
  ) {
    emit(
      state.copyWith(
        quote: state.quote.copyWith(
          upfrontCents: Money.parseToCents(event.value) ?? 0,
        ),
        status: QuoteEditorStatus.editing,
        clearMessages: true,
      ),
    );
  }

  void _onUpfrontEstimateRequested(
    QuoteUpfrontEstimateRequested event,
    Emitter<QuoteEditorState> emit,
  ) {
    final total = state.quote.totalCents;
    emit(
      state.copyWith(
        quote: state.quote.copyWith(upfrontCents: Money.percentOf(total, 0.60)),
        status: QuoteEditorStatus.editing,
        clearMessages: true,
      ),
    );
  }

  void _onResponseChanged(
    QuoteResponseChanged event,
    Emitter<QuoteEditorState> emit,
  ) {
    final responses = [
      for (final response in state.quote.responses)
        if (response.requirementId != event.requirementId) response,
      RequirementResponse(
        requirementId: event.requirementId,
        canMeet: event.canMeet,
        note: event.canMeet ? 'Yes, we can meet this.' : 'Not included.',
      ),
    ];
    emit(
      state.copyWith(
        quote: state.quote.copyWith(responses: responses),
        status: QuoteEditorStatus.editing,
        clearMessages: true,
      ),
    );
  }

  void _onBuyerMessageChanged(
    QuoteBuyerMessageChanged event,
    Emitter<QuoteEditorState> emit,
  ) {
    emit(
      state.copyWith(
        quote: state.quote.copyWith(buyerMessage: event.value),
        status: QuoteEditorStatus.editing,
        clearMessages: true,
      ),
    );
  }

  Future<void> _onSaveRequested(
    QuoteSaveRequested event,
    Emitter<QuoteEditorState> emit,
  ) async {
    emit(state.copyWith(status: QuoteEditorStatus.saving, clearMessages: true));
    final result = await _saveQuoteDraftUseCase(state.quote);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: QuoteEditorStatus.failure,
          message: failure.message,
        ),
      ),
      (quote) => emit(
        state.copyWith(
          quote: quote,
          status: QuoteEditorStatus.saved,
          message: 'Draft saved. Both you and the buyer keep this version.',
        ),
      ),
    );
  }

  Future<void> _onSubmitRequested(
    QuoteSubmitRequested event,
    Emitter<QuoteEditorState> emit,
  ) async {
    final issues = QuoteSubmissionValidator.validate(
      state.quote,
      now: DemoClock.now(),
    );
    if (issues.isNotEmpty) {
      emit(
        state.copyWith(
          status: QuoteEditorStatus.failure,
          message: 'The quote cannot be submitted yet.',
          validationIssues: issues,
        ),
      );
      return;
    }

    emit(
      state.copyWith(status: QuoteEditorStatus.submitting, clearMessages: true),
    );

    // Persist the working copy first so the repository validates what is on
    // screen, not the older saved version.
    final saved = await _saveQuoteDraftUseCase(state.quote);
    final savedQuote = saved.getOrElse((_) => state.quote);

    final result = await _submitQuoteUseCase(savedQuote.id);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: QuoteEditorStatus.failure,
          message: failure.message,
          validationIssues: failure.message.split('\n'),
        ),
      ),
      (quote) => emit(
        state.copyWith(
          quote: quote,
          status: QuoteEditorStatus.submitted,
          message: 'Quote submitted to the buyer.',
        ),
      ),
    );
  }
}
