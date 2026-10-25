part of 'opportunities_bloc.dart';

@freezed
class OpportunitiesState with _$OpportunitiesState {
  const factory OpportunitiesState.initial() = _Initial;

  const factory OpportunitiesState.loading() = OpportunitiesLoading;

  const factory OpportunitiesState.loaded({
    required List<Opportunity> opportunities,
  }) = OpportunitiesLoaded;

  const factory OpportunitiesState.error({required String message}) =
      OpportunitiesError;

}
