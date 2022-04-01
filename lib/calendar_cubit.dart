import 'package:calendar01/calendar_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CalendarCubit extends Cubit<CalendarState> {
  CalendarCubit()
      : super(CalendarState(
          focusedDay: DateTime.now(),
          pickerDate: DateTime.now(),
        ));

  void setFocusedDay(DateTime newFocusedDay) {
    emit(state.copyWith(focusedDay: newFocusedDay));
  }

  void setSelectedDay(DateTime newSelectedDay) {
    emit(state.copyWith(selectedDay: newSelectedDay));
  }

  void setPickerDate(DateTime newdate) {
    emit(state.copyWith(pickerDate: newdate));
  }
}
