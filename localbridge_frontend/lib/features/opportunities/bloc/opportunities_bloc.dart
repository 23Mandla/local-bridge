import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/usecase/no_params.dart';
import '../domain/entities/opportunity.dart';
import '../domain/usecases/get_opportunities_use_case.dart';

part 'opportunities_event.dart';
part 'opportunities_state.dart';
part 'opportunities_bloc.freezed.dart';

class OpportunitiesBloc extends Bloc<OpportunitiesEvent, OpportunitiesState> {
  final GetOpportunitiesUseCase _getOpportunitiesUseCase;

  OpportunitiesBloc({required GetOpportunitiesUseCase getOpportunitiesUseCase})
    : _getOpportunitiesUseCase = getOpportunitiesUseCase,
      super(const OpportunitiesState.initial()) {
    on<GetOpportunities>(_onGetOpportunities);
  }

  Future<void> _onGetOpportunities(
    GetOpportunities event,
    Emitter<OpportunitiesState> emit,
  ) async {
    emit(OpportunitiesLoading());

    final results = await _getOpportunitiesUseCase(const NoParams());

    results.fold(
      (onLeft) => emit(OpportunitiesError(message: onLeft.message)),
      (opportunities) =>
          emit(OpportunitiesLoaded(opportunities: opportunities)),
    );
  }
}
