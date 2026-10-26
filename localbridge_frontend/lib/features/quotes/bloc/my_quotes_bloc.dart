import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/entities/quote.dart';
import '../domain/usecases/watch_quotes_use_cases.dart';

enum MyQuotesStatus { loading, loaded, failure }

class MyQuotesState extends Equatable {
  const MyQuotesState({
    required this.status,
    this.quotes = const [],
    this.message,
  });

  const MyQuotesState.loading() : this(status: MyQuotesStatus.loading);

  const MyQuotesState.failure({required String message})
    : this(status: MyQuotesStatus.failure, message: message);

  final MyQuotesStatus status;
  final List<Quote> quotes;
  final String? message;

  List<Quote> get drafts =>
      quotes.where((quote) => quote.status.isDraft).toList(growable: false);

  @override
  List<Object?> get props => [status, quotes, message];
}

abstract class MyQuotesEvent extends Equatable {
  const MyQuotesEvent();

  @override
  List<Object?> get props => const [];
}

class MyQuotesStarted extends MyQuotesEvent {
  const MyQuotesStarted();
}

/// Every quote of the signed-in business, kept live from the shared
/// quotes repository so buyer decisions appear here immediately.
class MyQuotesBloc extends Bloc<MyQuotesEvent, MyQuotesState> {
  MyQuotesBloc({required WatchMyQuotesUseCase watchMyQuotesUseCase})
    : _watchMyQuotesUseCase = watchMyQuotesUseCase,
      super(const MyQuotesState.loading()) {
    on<MyQuotesStarted>(_onStarted);
  }

  final WatchMyQuotesUseCase _watchMyQuotesUseCase;
  StreamSubscription<List<Quote>>? _subscription;

  void _onStarted(MyQuotesStarted event, Emitter<MyQuotesState> emit) {
    _subscription?.cancel();
    _subscription = _watchMyQuotesUseCase().listen(
      (quotes) =>
          emit(MyQuotesState(status: MyQuotesStatus.loaded, quotes: quotes)),
      onError: (Object error) =>
          emit(MyQuotesState.failure(message: error.toString())),
    );
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
