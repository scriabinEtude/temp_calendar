import 'package:calendar01/datasource.dart';
import 'package:calendar01/screens/re_reservation_bottom_sheet/re_reservation_bottom_sheet_child_screen.dart';
import 'package:calendar01/widgets/widgets.dart';
import 'package:flutter/material.dart';

import 'package:calendar01/screens/re_reservation_bottom_sheet/re_reservation_bottom_sheet_cubit.dart';
import 'package:calendar01/enums.dart';

typedef TestFunction = bool Function(Map<String, dynamic>);

class ReReservationBottomSheetScreen extends StatefulWidget {
  const ReReservationBottomSheetScreen({Key? key}) : super(key: key);

  @override
  _ReReservationBottomSheetScreenState createState() =>
      _ReReservationBottomSheetScreenState();
}

class _ReReservationBottomSheetScreenState
    extends State<ReReservationBottomSheetScreen> {
  final _screenCubit = ReReservationBottomSheetCubit();
  List<Reserve> _selectedReserve = [];

  @override
  void initState() {
    _screenCubit.loadInitialData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ReservationBottomSheetTemplate(
      title: '다시 예약',
      canSave: false,
      onSave: () {},
      child: ListView(
        children: [
          ToggleableCalendar(
            title: '예약할 날짜',
            setFocusedDay: _screenCubit.setFocusedDay,
            setSelectedDay: _screenCubit.setSelectedDay,
          ),
          ToggleableTimePicker(
            title: '예약할 시간',
            selectedReserves: _selectedReserve,
            onSelectedReserve: (reserve) {
              setState(() {
                _selectedReserve = [reserve];
              });
            },
            reserveDataSource: [
              TimeTableReserves(title: '오전', reserves: rs.sublist(0, 8)),
              TimeTableReserves(title: '오후', reserves: rs.sublist(8))
            ],
            veterinarians: _screenCubit.state.veterinarians,
            initialSelectedVeterinarian:
                _screenCubit.state.selectedVeterinarian,
            onSelectVeterinarian: _screenCubit.onSelectVeterinarian,
            closedEventStyle: TimeEventStyle(
                fontColor: const Color(0xffcccccc),
                backgroundColor: const Color(0xfff7f7f7)),
            existEventStyle: TimeEventStyle(
                fontColor: const Color(0xffcccccc),
                backgroundColor: const Color(0xfff7f7f7)),
            noneEventStyle: TimeEventStyle(
                fontColor: const Color(0xff000000),
                backgroundColor: const Color(0x338bafd0)),
          ),
          const SizedBox(height: 10),
          LabeledList(
            type: LabeledListType.navigation,
            children: [
              LabeledListItem(
                  label: '반려동물',
                  content: _screenCubit.state.name,
                  onTap: () => showReservationBottomSheet(context,
                      screen: const PetInfoChildScreen())),
              LabeledListItem(
                  label: '보호자 정보',
                  content: _screenCubit.state.guardianName,
                  onTap: () => showReservationBottomSheet(context,
                      screen: const GuardianInfoChildScreen())),
              LabeledListItem(
                  label: '진료유형',
                  content: _screenCubit.state.requestType.korName(),
                  onTap: () => showReservationBottomSheet(context,
                      screen: const RequestTypeSelectChildScreen())),
            ],
          ),
          const SizedBox(height: 10),
          const ReReservationMemo(),
        ],
      ),
    );
  }
}

class ReReservationMemo extends StatefulWidget {
  const ReReservationMemo({Key? key}) : super(key: key);

  @override
  State<ReReservationMemo> createState() => _ReReservationMemoState();
}

class _ReReservationMemoState extends State<ReReservationMemo> {
  final _screenCubit = ReReservationBottomSheetCubit();
  late TextEditingController _memoController;

  @override
  void initState() {
    super.initState();
    _memoController =
        TextEditingController(text: _screenCubit.state.description);
  }

  @override
  void dispose() {
    _memoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      constraints: const BoxConstraints(minHeight: 100),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(16)),
        color: Color(0xffffffff),
      ),
      child: TextField(
        controller: _memoController,
        maxLines: null,
        decoration: const InputDecoration(
          border: InputBorder.none,
          isDense: true,
          hintText: '메모',
          hintStyle: TextStyle(
              color: Color(0xff999999),
              fontWeight: FontWeight.w400,
              fontFamily: "NotoSansKR",
              fontStyle: FontStyle.normal,
              fontSize: 17.0),
        ),
        style: const TextStyle(
            color: Color(0xff000000),
            fontWeight: FontWeight.w400,
            fontFamily: "NotoSansKR",
            fontStyle: FontStyle.normal,
            fontSize: 17.0),
      ),
    );
  }
}
