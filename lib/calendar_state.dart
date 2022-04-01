class CalendarState {
  final DateTime focusedDay;
  final DateTime? selectedDay;
  final DateTime pickerDate;

  const CalendarState({
    required this.focusedDay,
    this.selectedDay,
    required this.pickerDate,
  });

  CalendarState copyWith({
    int? offset,
    DateTime? focusedDay,
    DateTime? selectedDay,
    DateTime? pickerDate,
  }) {
    return CalendarState(
      focusedDay: focusedDay ?? this.focusedDay,
      selectedDay: selectedDay ?? this.selectedDay,
      pickerDate: pickerDate ?? this.pickerDate,
    );
  }
}
