import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/entities/quote.dart';
import '../domain/entities/quote_status.dart';
import '../domain/usecases/watch_quotes_use_cases.dart';

/// Inbox filters offered to the buyer.
enum QuoteInboxFilter {
  awaiting('Awaiting'),
  decided('Decided'),
  all('All');

  const QuoteInboxFilter(this.label);

  final String label;
}

enum BuyerInboxStatus { loading, loaded, failure }

class BuyerInboxState extends Equatable {
  const BuyerInboxState({
    required this.status,
    this.quotes = const [],
    this.message,
    this.filter = QuoteInboxFilter.awaiting,
  });

  const BuyerInboxState.loading() : this(status: BuyerInboxStatus.loading);

  const BuyerInboxState.failure({required String message})
    : this(status: BuyerInboxStatus.failure, message: message);

  final BuyerInboxStatus status;
  final List<Quote> quotes;
  final String? message;
  final QuoteInboxFilter filter;

  int get awaitingCount =>
      quotes.where((quote) => quote.status.isSubmitted).length;

  int get decidedCount =>
      quotes.where((quote) => quote.status.isDecided).length;

  int get totalCount => quotes.length;

  List<Quote> get visibleQuotes => switch (filter) {
    QuoteInboxFilter.awaiting =>
      quotes.where((quote) => quote.status == QuoteStatus.submitted).toList(),
    QuoteInboxFilter.decided =>
      quotes.where((quote) => quote.status.isDecided).toList(),
    QuoteInboxFilter.all => quotes,
  };

  BuyerInboxState copyWith({QuoteInboxFilter? filter}) => BuyerInboxState(
    status: status,
    quotes: quotes,
    message: message,
    filter: filter ?? this.filter,
  );

  @override
  List<Object?> get props => [status, quotes, message, filter];
}

abstract class BuyerInboxEvent extends Equatable {
  const BuyerInboxEvent();

  @override
  List<Object?> get props => const [];
}

class BuyerInboxStarted extends BuyerInboxEvent {
  const BuyerInboxStarted();
}

class BuyerInboxFilterChanged extends BuyerInboxEvent {
  const BuyerInboxFilterChanged(this.filter);

  final QuoteInboxFilter filter;

  @override
  List<Object?> get props => [filter];
}

/// Submitted quotations waiting for a buyer decision, kept live from the shared
/// quotes repository.
class BuyerInboxBloc extends Bloc<BuyerInboxEvent, BuyerInboxState> {
  BuyerInboxBloc({required WatchBuyerQuotesUseCase watchBuyerQuotesUseCase})
    : _watchBuyerQuotesUseCase = watchBuyerQuotesUseCase,
      super(const BuyerInboxState.loading()) {
    on<BuyerInboxStarted>(_onStarted);
    on<BuyerInboxFilterChanged>(_onFilterChanged);
  }

  final WatchBuyerQuotesUseCase _watchBuyerQuotesUseCase;
  StreamSubscription<List<Quote>>? _subscription;

  void _onStarted(BuyerInboxStarted event, Emitter<BuyerInboxState> emit) {
    _subscription?.cancel();
    _subscription = _watchBuyerQuotesUseCase().listen(
      (quotes) => emit(
        BuyerInboxState(
          status: BuyerInboxStatus.loaded,
          quotes: quotes,
          filter: state.filter,
        ),
      ),
      onError: (Object error) =>
          emit(BuyerInboxState.failure(message: error.toString())),
    );
  }

  void _onFilterChanged(
    BuyerInboxFilterChanged event,
    Emitter<BuyerInboxState> emit,
  ) {
    if (state.status == BuyerInboxStatus.loaded) {
      emit(state.copyWith(filter: event.filter));
    }
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
