import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:calendar01/datasource.dart';
import 'package:calendar01/enums.dart';
import 'package:calendar01/screens/re_reservation_bottom_sheet/re_reservation_bottom_sheet_cubit.dart';
import 'package:calendar01/utils.dart';
import 'package:calendar01/widgets/widgets.dart';
import 'package:flutter/material.dart';

class NewReservationScreen extends StatefulWidget {
  const NewReservationScreen({Key? key}) : super(key: key);

  @override
  _NewReservationScreenState createState() => _NewReservationScreenState();
}

class _NewReservationScreenState extends State<NewReservationScreen> {
  final _screenCubit = ReReservationBottomSheetCubit();
  List<Reserve> _selectedReserve = [];
  bool _toggleOnOff = false;

  void toggleOnOff(bool onOff) {
    _toggleOnOff = onOff;
  }

  @override
  void initState() {
    _screenCubit.loadInitialData();
    _selectedReserve = rs
        .where((reserve) => reserve.reserveType == ReserveType.closed)
        .toList();
    super.initState();
  }

  final _reserveDataSource = [
    TimeTableReserves(title: '오전', reserves: rs.sublist(0, 8)),
    TimeTableReserves(title: '오후', reserves: rs.sublist(8))
  ];

  Future<void> _onToggled(isOn) async {
    if (isOn) {
      OkCancelResult result = await showOkCancelAlertDialog(
        context: context,
        title: '모든 시간 클로즈',
        message:
            '${getFormatDate(DateTime.now(), 'yyyy년 MM월 dd일 (weekName)')}\r\n해당일에 남은 모든 예약 시간을\r\n클로즈하시겠습니까?',
        okLabel: '확인',
        cancelLabel: '취소',
      );

      if (result == OkCancelResult.ok) {
        setState(() {
          _selectedReserve = rs
              .where((reserve) => reserve.reserveType != ReserveType.reserved)
              .toList();
          toggleOnOff(true);
        });
      } else {
        setState(() {
          toggleOnOff(false);
        });
      }
    } else {
      setState(() {
        _selectedReserve = rs
            .where((reserve) => reserve.reserveType == ReserveType.closed)
            .toList();
        toggleOnOff(false);
      });
    }
  }

  void _onSelectedReserve(reserve) {
    if (reserve.reserveType == ReserveType.reserved) {
      return;
    }

    setState(() {
      if (_selectedReserve.contains(reserve)) {
        _selectedReserve.remove(reserve);
      } else {
        _selectedReserve.add(reserve);
      }

      if (rs.indexWhere((reserve) =>
              (reserve.reserveType != ReserveType.reserved &&
                  !_selectedReserve.contains(reserve))) !=
          -1) {
        toggleOnOff(false);
      } else {
        toggleOnOff(true);
      }
    });
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
          toggleButton: true,
          toggleButtonText: '모두 선택',
          toggleOnOff: _toggleOnOff,
          onToggled: _onToggled,
          selectedReserves: _selectedReserve,
          onSelectedReserve: _onSelectedReserve,
          title: '클로즈 할 시간',
          veterinarians: _screenCubit.state.veterinarians,
          initialSelectedVeterinarian: _screenCubit.state.selectedVeterinarian,
          onSelectVeterinarian: _screenCubit.onSelectVeterinarian,
          reserveDataSource: _reserveDataSource,
          noneEventStyle: TimeEventStyle(
              fontColor: const Color(0xff000000),
              backgroundColor: const Color(0x338bafd0)),
          existEventStyle: TimeEventStyle(
              fontColor: const Color(0xffcccccc),
              backgroundColor: const Color(0xfff7f7f7)),
          closedEventStyle: TimeEventStyle(
              fontColor: const Color(0xff000000),
              backgroundColor: const Color(0x338bafd0)),
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
