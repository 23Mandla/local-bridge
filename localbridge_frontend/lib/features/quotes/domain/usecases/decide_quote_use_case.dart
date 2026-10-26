import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failure_error.dart';
import '../../../../core/usecase/use_case.dart';
import '../entities/quote.dart';
import '../entities/quote_status.dart';
import '../repo_contract/quotes_repository.dart';

class DecideQuoteParams {
  final String quoteId;
  final QuoteDecision decision;
  final String? buyerNote;

  const DecideQuoteParams({
    required this.quoteId,
    required this.decision,
    this.buyerNote,
  });
}

/// Records the buyer's verdict on a submitted quote.
class DecideQuoteUseCase implements UseCase<Quote, DecideQuoteParams> {
  final QuotesRepository _repository;

  DecideQuoteUseCase(this._repository);

  @override
  Future<Either<FailureError, Quote>> call(DecideQuoteParams params) =>
      _repository.decideQuote(
        quoteId: params.quoteId,
        decision: params.decision,
        buyerNote: params.buyerNote,
      );
}
