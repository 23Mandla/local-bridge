import 'package:fpdart/fpdart.dart';
import '../errors/failure_error.dart';

abstract interface class UseCase<SuccessType, Params> {
  Future<Either<FailureError, SuccessType>> call(Params params);
}
