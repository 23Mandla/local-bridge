import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failure_error.dart';
import '../../../../core/usecase/use_case.dart';
import '../entities/quote.dart';
import '../entities/quote_draft_request.dart';
import '../repo_contract/quotes_repository.dart';

/// Opens the entrepreneur's draft for an opportunity, reusing an existing one.
class GetOrCreateQuoteDraftUseCase
    implements UseCase<Quote, QuoteDraftRequest> {
  final QuotesRepository _repository;

  GetOrCreateQuoteDraftUseCase(this._repository);

  @override
  Future<Either<FailureError, Quote>> call(QuoteDraftRequest params) =>
      _repository.getOrCreateDraft(params);
}
