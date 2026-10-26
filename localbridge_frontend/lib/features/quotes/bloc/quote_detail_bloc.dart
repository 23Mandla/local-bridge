import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/entities/quote.dart';
import '../domain/entities/quote_status.dart';
import '../domain/usecases/decide_quote_use_case.dart';
import '../domain/usecases/watch_quotes_use_cases.dart';

enum QuoteDetailStatus { loading, loaded, missing }

class QuoteDetailState extends Equatable {
  const QuoteDetailState({
    this.status = QuoteDetailStatus.loading,
    this.quote,
    this.errorMessage,
    this.infoMessage,
  });

  final QuoteDetailStatus status;
  final Quote? quote;
  final String? errorMessage;
  final String? infoMessage;

  QuoteDetailState copyWith({
    QuoteDetailStatus? status,
    Quote? quote,
    String? errorMessage,
    String? infoMessage,
    bool clearMessages = false,
  }) => QuoteDetailState(
    status: status ?? this.status,
    quote: quote ?? this.quote,
    errorMessage: clearMessages ? null : errorMessage ?? this.errorMessage,
    infoMessage: clearMessages ? null : infoMessage ?? this.infoMessage,
  );

  @override
  List<Object?> get props => [status, quote, errorMessage, infoMessage];
}

abstract class QuoteDetailEvent extends Equatable {
  const QuoteDetailEvent();

  @override
  List<Object?> get props => const [];
}

class QuoteDetailStarted extends QuoteDetailEvent {
  const QuoteDetailStarted(this.quoteId);

  final String quoteId;

  @override
  List<Object?> get props => [quoteId];
}

class QuoteDecisionRequested extends QuoteDetailEvent {
  const QuoteDecisionRequested({
    required this.quoteId,
    required this.decision,
    this.note,
  });

  final String quoteId;
  final QuoteDecision decision;
  final String? note;

  @override
  List<Object?> get props => [quoteId, decision, note];
}

/// Read-only quote view shared by both roles.
///
/// The entrepreneur opens it to review a submitted or decided quote; the buyer
/// opens it to accept or decline a submitted quote. Both read the same quote
/// from the shared quotes repository.
class QuoteDetailBloc extends Bloc<QuoteDetailEvent, QuoteDetailState> {
  QuoteDetailBloc({
    required WatchQuoteUseCase watchQuoteUseCase,
    required DecideQuoteUseCase decideQuoteUseCase,
  }) : _watchQuoteUseCase = watchQuoteUseCase,
       _decideQuoteUseCase = decideQuoteUseCase,
       super(const QuoteDetailState()) {
    on<QuoteDetailStarted>(_onStarted);
    on<QuoteDecisionRequested>(_onDecisionRequested);
  }

  final WatchQuoteUseCase _watchQuoteUseCase;
  final DecideQuoteUseCase _decideQuoteUseCase;
  StreamSubscription<Quote?>? _subscription;

  void _onStarted(QuoteDetailStarted event, Emitter<QuoteDetailState> emit) {
    _subscription?.cancel();
    _subscription = _watchQuoteUseCase(event.quoteId).listen(
      (quote) => emit(
        QuoteDetailState(
          status: quote == null
              ? QuoteDetailStatus.missing
              : QuoteDetailStatus.loaded,
          quote: quote,
        ),
      ),
      onError: (Object error) => emit(
        QuoteDetailState(
          status: QuoteDetailStatus.missing,
          errorMessage: error.toString(),
        ),
      ),
    );
  }

  Future<void> _onDecisionRequested(
    QuoteDecisionRequested event,
    Emitter<QuoteDetailState> emit,
  ) async {
    final result = await _decideQuoteUseCase(
      DecideQuoteParams(
        quoteId: event.quoteId,
        decision: event.decision,
        buyerNote: event.note,
      ),
    );

    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (quote) => emit(
        state.copyWith(
          status: QuoteDetailStatus.loaded,
          quote: quote,
          infoMessage:
              '${event.decision.resultingStatus.label} · the '
              'entrepreneur now sees this decision.',
        ),
      ),
    );
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
