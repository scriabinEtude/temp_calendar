import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:calendar01/screens/new_reservation/new_reservation_state.dart';

class NewReservationCubit extends Cubit<NewReservationState> {
  NewReservationCubit() : super(NewReservationState(isLoading: true));

  Future<void> loadInitialData() async {
    final stableState = state;
    try {
      emit(state.copyWith(isLoading: true));

      // TODO your code here

      emit(state.copyWith(isLoading: false));
    } catch (error) {
      emit(state.copyWith(error: error.toString()));
      emit(stableState.copyWith(isLoading: false));
    }
  }
}
