import '../entities/quote.dart';
import '../repo_contract/quotes_repository.dart';

/// Streams of quote state.
///
/// These do not return `Either` because the in-memory demo source cannot fail;
/// any unexpected error travels through the stream's error channel and is
/// surfaced by the BLoC.
class WatchMyQuotesUseCase {
  final QuotesRepository _repository;

  WatchMyQuotesUseCase(this._repository);

  Stream<List<Quote>> call() => _repository.watchMyQuotes();
}

class WatchBuyerQuotesUseCase {
  final QuotesRepository _repository;

  WatchBuyerQuotesUseCase(this._repository);

  Stream<List<Quote>> call() => _repository.watchBuyerQuotes();
}

class WatchQuoteUseCase {
  final QuotesRepository _repository;

  WatchQuoteUseCase(this._repository);

  Stream<Quote?> call(String quoteId) => _repository.watchQuote(quoteId);
}

class WatchOpportunityQuoteUseCase {
  final QuotesRepository _repository;

  WatchOpportunityQuoteUseCase(this._repository);

  Stream<Quote?> call(String opportunityId) =>
      _repository.watchQuoteForOpportunity(opportunityId);
}
