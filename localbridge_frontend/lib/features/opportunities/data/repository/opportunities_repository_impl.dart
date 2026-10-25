import 'package:fpdart/src/either.dart';
import 'package:localbridge_frontend/core/errors/failure_error.dart';
import 'package:localbridge_frontend/features/opportunities/domain/entities/opportunity.dart';

import 'package:retrofit/retrofit.dart';
import 'package:fpdart/fpdart.dart';
import '../../domain/repo_contract/opportunities_repository.dart';
import '../datasource/opportunities_api_client.dart';
import '../dto/opportunities_dto.dart';

class OpportunitiesRepositoryImpl implements OpportunitiesRepository {
  final OpportunitiesApiClient _apiClient;

  OpportunitiesRepositoryImpl({required OpportunitiesApiClient apiClient})
    : _apiClient = apiClient;

  @override
  Future<Either<FailureError, List<Opportunity>>> getOpportunities() async {
    try {
      final response = await _apiClient.getOpportunities();

      print('STATUS: ${response.response.statusCode}');
      print('RUNTIME DATA TYPE: ${response.data.runtimeType}');
      print('RESPONSE DATA: ${response.data}');

      if (response.response.statusCode == 200) {
        final opportunities = response.data
            .map((dto) => dto.toDomain())
            .toList();

        print('MAPPED OPPORTUNITIES: ${opportunities.length}');

        return right(opportunities);
      }

      return left(
        FailureError(
          'Failed to get opportunities. '
          'Status code: ${response.response.statusCode}',
        ),
      );
    } catch (e) {
      return left(FailureError('Failed to get listed opportunities: $e'));
    }
  }
}
