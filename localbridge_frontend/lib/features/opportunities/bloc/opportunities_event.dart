part of 'opportunities_bloc.dart';

@freezed
class OpportunitiesEvent with _$OpportunitiesEvent {
  const factory OpportunitiesEvent.started() = _Started;

  const factory OpportunitiesEvent.getOpportunities() = GetOpportunities;
}
