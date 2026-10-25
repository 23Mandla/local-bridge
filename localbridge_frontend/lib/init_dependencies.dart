import 'package:dio/dio.dart';
import 'package:localbridge_frontend/utils/mock_interceptor.dart';
import 'package:get_it/get_it.dart';
import 'features/opportunities/bloc/opportunities_bloc.dart';
import 'features/opportunities/data/datasource/opportunities_api_client.dart';
import 'features/opportunities/data/repository/opportunities_repository_impl.dart';
import 'features/opportunities/domain/repo_contract/opportunities_repository.dart';
import 'features/opportunities/domain/usecases/get_opportunities_use_case.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  // mock responses
  const bool isMocking = true;

  serviceLocator.registerLazySingleton<Dio>(
    () =>
        Dio(BaseOptions(baseUrl: 'http://192.168.43.84:8080/'))
          ..interceptors.addAll([
            if (isMocking) MockInterceptor(),
            //Todo add headers
            LogInterceptor(
              requestBody: true,
              responseBody: true,
              responseHeader: true,
              error: true,
            ),
          ]),
  );

  await _initOpportunities();
}

// Opportunities dependency injection
Future<void> _initOpportunities() async {
  serviceLocator.registerLazySingleton<OpportunitiesApiClient>(
    () => OpportunitiesApiClient(serviceLocator<Dio>()),
  );

  serviceLocator.registerLazySingleton<OpportunitiesRepository>(
    () => OpportunitiesRepositoryImpl(
      apiClient: serviceLocator<OpportunitiesApiClient>(),
    ),
  );

  serviceLocator.registerFactory<GetOpportunitiesUseCase>(
    () => GetOpportunitiesUseCase(serviceLocator<OpportunitiesRepository>()),
  );

  serviceLocator.registerFactory<OpportunitiesBloc>(
    () => OpportunitiesBloc(
      getOpportunitiesUseCase: serviceLocator<GetOpportunitiesUseCase>(),
    ),
  );
}
