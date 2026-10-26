import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failure_error.dart';
import '../../../../core/usecase/use_case.dart';
import '../entities/quote.dart';
import '../repo_contract/quotes_repository.dart';

/// Submits a draft to the buyer. Params are the quote id.
class SubmitQuoteUseCase implements UseCase<Quote, String> {
  final QuotesRepository _repository;

  SubmitQuoteUseCase(this._repository);

  @override
  Future<Either<FailureError, Quote>> call(String params) =>
      _repository.submitQuote(params);
}
