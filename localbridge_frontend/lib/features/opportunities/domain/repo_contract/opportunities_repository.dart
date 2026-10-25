import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failure_error.dart';
import '../entities/opportunity.dart';

abstract interface class OpportunitiesRepository {
  Future<Either<FailureError, List<Opportunity>>> getOpportunities();
}