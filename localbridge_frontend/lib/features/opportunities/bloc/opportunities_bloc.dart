import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'opportunities_event.dart';
part 'opportunities_state.dart';
part 'opportunities_bloc.freezed.dart';

class OpportunitiesBloc extends Bloc<OpportunitiesEvent, OpportunitiesState> {
  OpportunitiesBloc() : super(const OpportunitiesState.initial()) {
    on<OpportunitiesEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
