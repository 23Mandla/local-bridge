import 'package:fpdart/src/either.dart';
import 'package:localbridge_frontend/core/errors/failure_error.dart';

import '../../../../core/usecase/no_params.dart';
import '../../../../core/usecase/use_case.dart';
import '../entities/opportunity.dart';
import '../repo_contract/opportunities_repository.dart';

class GetOpportunitiesUseCase implements UseCase<List<Opportunity>, NoParams> {
  final OpportunitiesRepository _repository;
  GetOpportunitiesUseCase(this._repository);

  @override
  Future<Either<FailureError, List<Opportunity>>> call(NoParams params) async {
    return await _repository.getOpportunities();
  }
}
