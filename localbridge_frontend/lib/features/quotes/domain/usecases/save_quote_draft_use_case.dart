import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failure_error.dart';
import '../../../../core/usecase/use_case.dart';
import '../entities/quote.dart';
import '../repo_contract/quotes_repository.dart';

/// Stores an editable draft. Incomplete drafts are allowed.
class SaveQuoteDraftUseCase implements UseCase<Quote, Quote> {
  final QuotesRepository _repository;

  SaveQuoteDraftUseCase(this._repository);

  @override
  Future<Either<FailureError, Quote>> call(Quote params) =>
      _repository.saveDraft(params);
}
