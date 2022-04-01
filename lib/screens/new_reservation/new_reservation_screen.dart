import 'package:calendar01/screens/re_reservation_bottom_sheet/re_reservation_bottom_sheet_cubit.dart';
import 'package:calendar01/widgets/widgets.dart';
import 'package:flutter/material.dart';

class NewReservationScreen extends StatefulWidget {
  const NewReservationScreen({Key? key}) : super(key: key);

  @override
  _NewReservationScreenState createState() => _NewReservationScreenState();
}

class _NewReservationScreenState extends State<NewReservationScreen> {
  final _screenCubit = ReReservationBottomSheetCubit();

  @override
  void initState() {
    _screenCubit.loadInitialData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ReservationBottomSheetTemplate(
      title: '새로운 일정',
      canSave: false,
      onSave: () {},
      child: body(),
    );
  }

  Widget body() {
    return ListView(
      children: [
        description(
            '클로즈 추가는 예약을 받지 않을 시간을 선택하는 기능입니다.\n의료진을 선택한 후 예약 불가한 시간을 선택해주세요.'),
        ToggleableCalendar(
          title: '클로즈 할 날짜',
          setFocusedDay: (focusedDay) {},
          setSelectedDay: (selectedDay) {},
        ),
        ToggleableTimePicker(
          title: '클로즈 할 시간',
          veterinarians: _screenCubit.state.veterinarians,
          initialSelectedVeterinarian: _screenCubit.state.selectedVeterinarian,
          onSelectVeterinarian: _screenCubit.onSelectVeterinarian,
          reserveDataSource: [],
          selectedReserves: [],
          onSelectedReserve: (reserve) {},
          noneEventStyle: TimeEventStyle(
              fontColor: const Color(0xff000000),
              backgroundColor: const Color(0x338bafd0)),
          existEventStyle: TimeEventStyle(
              fontColor: const Color(0xffcccccc),
              backgroundColor: const Color(0xfff7f7f7)),
          closedEventStyle: TimeEventStyle(
              fontColor: const Color(0xffcccccc),
              backgroundColor: const Color(0xfff7f7f7)),
        ),
      ],
    );
  }

  Widget description(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Text(
        text,
        style: const TextStyle(
            color: Color(0xff006ed4),
            fontWeight: FontWeight.w400,
            fontFamily: "NotoSansKR",
            fontStyle: FontStyle.normal,
            fontSize: 14.0),
      ),
    );
  }
}
