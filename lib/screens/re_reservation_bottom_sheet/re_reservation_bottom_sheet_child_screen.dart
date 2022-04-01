import 'package:calendar01/enums.dart';
import 'package:calendar01/screens/re_reservation_bottom_sheet/re_reservation_bottom_sheet_cubit.dart';
import 'package:calendar01/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

void showReservationBottomSheet(BuildContext context,
    {bool enableDrag = true, required Widget screen}) {
  showCupertinoModalBottomSheet(
    context: context,
    isDismissible: false,
    enableDrag: enableDrag,
    duration: const Duration(milliseconds: 250),
    topRadius: const Radius.circular(20),
    barrierColor: Colors.black.withOpacity(0.35),
    builder: (context) => screen,
  );
}

class PetInfoChildScreen extends StatefulWidget {
  const PetInfoChildScreen({Key? key}) : super(key: key);

  @override
  State<PetInfoChildScreen> createState() => _PetInfoChildScreenState();
}

class _PetInfoChildScreenState extends State<PetInfoChildScreen> {
  final _screenCubit = ReReservationBottomSheetCubit();

  @override
  Widget build(BuildContext context) {
    return SimpleInfoBottomSheet(
      title: '반려동물',
      child: LabeledList(
        type: LabeledListType.simple,
        children: [
          LabeledListItem(label: '이름', content: _screenCubit.state.name),
          LabeledListItem(label: '품종', content: _screenCubit.state.kind),
          LabeledListItem(label: '나이', content: '${_screenCubit.state.age}세'),
          LabeledListItem(
              label: '성별',
              content:
                  '${_screenCubit.state.sex == 0 ? '여' : '남'}아 / 중성화${_screenCubit.state.isNeutering ? '완료' : '안함'}'),
        ],
      ),
    );
  }
}

class GuardianInfoChildScreen extends StatefulWidget {
  const GuardianInfoChildScreen({Key? key}) : super(key: key);

  @override
  State<GuardianInfoChildScreen> createState() =>
      _GuardianInfoChildScreenState();
}

class _GuardianInfoChildScreenState extends State<GuardianInfoChildScreen> {
  final _screenCubit = ReReservationBottomSheetCubit();

  @override
  Widget build(BuildContext context) {
    return SimpleInfoBottomSheet(
      title: '보호자 정보',
      child: LabeledList(
        type: LabeledListType.simple,
        children: [
          LabeledListItem(
              label: '이름', content: _screenCubit.state.guardianName),
          LabeledListItem(label: '연락처', content: _screenCubit.state.phone),
        ],
      ),
    );
  }
}

class RequestTypeSelectChildScreen extends StatefulWidget {
  const RequestTypeSelectChildScreen({Key? key}) : super(key: key);

  @override
  State<RequestTypeSelectChildScreen> createState() =>
      _RequestTypeSelectChildScreenState();
}

class _RequestTypeSelectChildScreenState
    extends State<RequestTypeSelectChildScreen> {
  final _screenCubit = ReReservationBottomSheetCubit();

  @override
  Widget build(BuildContext context) {
    return SimpleInfoBottomSheet(
      title: '진료유형',
      child: LabeledList(
        type: LabeledListType.select,
        initialSelectedItem: _screenCubit.state.requestType,
        onSelected: (selected) => _screenCubit.onSelectRequestType(selected),
        children: RequestType.values.map((requestType) {
          return LabeledListItem(
              label: requestType.korName(), content: requestType);
        }).toList(),
      ),
    );
  }
}
