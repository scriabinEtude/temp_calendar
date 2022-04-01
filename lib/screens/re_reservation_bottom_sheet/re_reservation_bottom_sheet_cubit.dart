import 'package:calendar01/enums.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:calendar01/screens/re_reservation_bottom_sheet/re_reservation_bottom_sheet_state.dart';

class ReReservationBottomSheetCubit
    extends Cubit<ReReservationBottomSheetState> {
  ReReservationBottomSheetCubit()
      : super(ReReservationBottomSheetState(
            isLoading: true,
            focusedDay: DateTime.now(),
            selectedVeterinarian: vets[0],
            veterinarians: vets,
            name: '쿠키',
            guardianName: '김유미',
            requestType: RequestType.general,
            kind: '아비니시안',
            age: 7,
            sex: 1,
            isNeutering: true,
            phone: '010-2004-3942'));

  Future<void> loadInitialData() async {
    final stableState = state;
    try {
      emit(state.copyWith(isLoading: true));
      emit(state.copyWith(isLoading: false));
    } catch (error) {
      print(error);
      emit(state.copyWith(error: error.toString()));
      emit(stableState.copyWith(isLoading: false));
    }
  }

  void setFocusedDay(DateTime newFocusedDay) {
    emit(state.copyWith(focusedDay: newFocusedDay));
  }

  void setSelectedDay(DateTime newSelectedDay) {
    emit(state.copyWith(selectedDay: newSelectedDay));
  }

  void onSelectVeterinarian(Veterinarian vet) {
    emit(state.copyWith(selectedVeterinarian: vet));
  }

  void onSelectEvent(Map<String, dynamic> event) {
    emit(state.copyWith(selectedEvent: event));
  }

  void onSelectRequestType(RequestType requestType) {
    emit(state.copyWith(requestType: requestType));
  }
}
