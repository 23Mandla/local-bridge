import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../quotes/domain/entities/quote.dart';
import '../../quotes/domain/entities/quote_draft_request.dart';
import '../../quotes/domain/usecases/get_or_create_quote_draft_use_case.dart';
import '../../quotes/domain/usecases/watch_quotes_use_cases.dart';
import '../domain/entities/opportunity.dart';

/// Tracks the quotation (if any) the business has prepared for one
/// opportunity, and creates the draft when the entrepreneur prepares a quote.
class OpportunityQuoteState extends Equatable {
  const OpportunityQuoteState({
    required this.opportunity,
    this.quote,
    this.isPreparing = false,
    this.message,
    this.draft,
  });

  final Opportunity opportunity;

  /// The quote prepared for this opportunity, or `null` when none exists.
  final Quote? quote;

  final bool isPreparing;
  final String? message;

  /// Set once a draft has been created so the screen can open the editor.
  final Quote? draft;

  OpportunityQuoteState copyWith({
    Quote? quote,
    bool? isPreparing,
    String? message,
    Quote? draft,
    bool clearMessages = false,
    bool clearDraft = false,
  }) => OpportunityQuoteState(
    opportunity: opportunity,
    quote: quote ?? this.quote,
    isPreparing: isPreparing ?? this.isPreparing,
    message: clearMessages ? null : message ?? this.message,
    draft: clearDraft ? null : draft ?? this.draft,
  );

  @override
  List<Object?> get props => [opportunity, quote, isPreparing, message, draft];
}

abstract class OpportunityQuoteEvent extends Equatable {
  const OpportunityQuoteEvent();

  @override
  List<Object?> get props => const [];
}

class OpportunityQuoteStarted extends OpportunityQuoteEvent {
  const OpportunityQuoteStarted(this.opportunity);

  final Opportunity opportunity;

  @override
  List<Object?> get props => [opportunity];
}

class OpportunityQuotePrepareRequested extends OpportunityQuoteEvent {
  const OpportunityQuotePrepareRequested();
}

/// Clears the created draft after the screen has opened the quote editor.
class OpportunityQuoteDraftHandled extends OpportunityQuoteEvent {
  const OpportunityQuoteDraftHandled();
}

class OpportunityQuoteBloc
    extends Bloc<OpportunityQuoteEvent, OpportunityQuoteState> {
  OpportunityQuoteBloc({
    required Opportunity opportunity,
    required WatchOpportunityQuoteUseCase watchOpportunityQuoteUseCase,
    required GetOrCreateQuoteDraftUseCase getOrCreateQuoteDraftUseCase,
  }) : _watchOpportunityQuoteUseCase = watchOpportunityQuoteUseCase,
        _getOrCreateQuoteDraftUseCase = getOrCreateQuoteDraftUseCase,
        super(OpportunityQuoteState(opportunity: opportunity)) {
    on<OpportunityQuoteStarted>(_onStarted);
    on<OpportunityQuotePrepareRequested>(_onPrepareRequested);
    on<OpportunityQuoteDraftHandled>(
          (event, emit) =>
          emit(state.copyWith(clearDraft: true, clearMessages: true)),
    );
  }

  final WatchOpportunityQuoteUseCase _watchOpportunityQuoteUseCase;
  final GetOrCreateQuoteDraftUseCase _getOrCreateQuoteDraftUseCase;
  StreamSubscription<Quote?>? _subscription;

  void _onStarted(
      OpportunityQuoteStarted event,
      Emitter<OpportunityQuoteState> emit,
      ) {
    _subscription?.cancel();
    _subscription = _watchOpportunityQuoteUseCase(event.opportunity.id).listen(
          (quote) => emit(state.copyWith(quote: quote)),
      onError: (Object error) =>
          emit(state.copyWith(message: error.toString())),
    );
  }

  Future<void> _onPrepareRequested(
      OpportunityQuotePrepareRequested event,
      Emitter<OpportunityQuoteState> emit,
      ) async {
    emit(state.copyWith(isPreparing: true, clearMessages: true));

    final result = await _getOrCreateQuoteDraftUseCase(
      QuoteDraftRequest.fromOpportunity(state.opportunity),
    );

    result.fold(
          (failure) =>
          emit(state.copyWith(isPreparing: false, message: failure.message)),
          (quote) =>
          emit(state.copyWith(isPreparing: false, quote: quote, draft: quote)),
    );
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
