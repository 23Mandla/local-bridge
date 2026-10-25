import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../dto/opportunities_dto.dart';

part 'opportunities_api_client.g.dart';

@RestApi()
abstract interface class OpportunitiesApiClient {
  factory OpportunitiesApiClient(
      Dio dio, {
        String? baseUrl,
        ParseErrorLogger? errorLogger,
      }) = _OpportunitiesApiClient;

  @POST('/v1/get/opportunities')
  Future<HttpResponse<List<OpportunitiesDto>>> getOpportunities();
}