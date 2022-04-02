import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:calendar01/datasource.dart';
import 'package:calendar01/enums.dart';
import 'package:calendar01/screens/re_reservation_bottom_sheet/re_reservation_bottom_sheet_state.dart';
import 'package:calendar01/utils.dart';

TextStyle _labelStyle = const TextStyle(
    color: Color(0xff000000),
    fontWeight: FontWeight.w400,
    fontFamily: "NotoSansKR",
    fontStyle: FontStyle.normal,
    fontSize: 17.0);

TextStyle _highlightTextStyle = const TextStyle(
  color: Color(0xff006ed4),
  fontWeight: FontWeight.w400,
  fontFamily: "NotoSansKR",
  fontStyle: FontStyle.normal,
  fontSize: 17.0,
);

Widget blueBasicButton() {
  return Container(
    width: 80,
    height: 42,
    decoration: const BoxDecoration(
        color: Color(0xff006ed4),
        borderRadius: BorderRadius.all(Radius.circular(10))),
    child: Center(
      child: InkWell(
        onTap: () {
          print('검색');
        },
        child: const Text("검색",
            style: TextStyle(
                color: Color(0xffffffff),
                fontWeight: FontWeight.w500,
                fontFamily: "NotoSansKR",
                fontStyle: FontStyle.normal,
                fontSize: 16.0),
            textAlign: TextAlign.center),
      ),
    ),
  );
}

class ToggleableTimePicker extends StatefulWidget {
  const ToggleableTimePicker(
      {Key? key,
      required this.title,
      this.toggleButton = false,
      this.toggleButtonText,
      this.onToggled,
      this.toggleOnOff = false,
      required this.veterinarians,
      required this.initialSelectedVeterinarian,
      required this.onSelectVeterinarian,
      required this.reserveDataSource,
      required this.selectedReserves,
      required this.onSelectedReserve,
      required this.noneEventStyle,
      required this.existEventStyle,
      required this.closedEventStyle})
      : super(key: key);
  final String title;
  final bool toggleButton;
  final String? toggleButtonText;
  final Future<void> Function(bool)? onToggled;
  final bool toggleOnOff;
  final List<Veterinarian> veterinarians;
  final Veterinarian initialSelectedVeterinarian;
  final void Function(Veterinarian) onSelectVeterinarian;
  final List<TimeTableReserves> reserveDataSource;
  final List<Reserve> selectedReserves;
  final Function(Reserve) onSelectedReserve;
  final TimeEventStyle noneEventStyle;
  final TimeEventStyle existEventStyle;
  final TimeEventStyle closedEventStyle;

  @override
  State<ToggleableTimePicker> createState() => _ToggleableTimePickerState();
}

class _ToggleableTimePickerState extends State<ToggleableTimePicker> {
  late Veterinarian _selectedVeterinarian;
  late List<Veterinarian> _veterinarians;

  bool _showVetList = false;

  @override
  void initState() {
    super.initState();
    _selectedVeterinarian = widget.initialSelectedVeterinarian;
    _veterinarians = widget.veterinarians;
  }

  final TextStyle _vetTextStyle = const TextStyle(
      color: Color(0xff000000),
      fontWeight: FontWeight.w400,
      fontFamily: "NotoSansKR",
      fontStyle: FontStyle.normal,
      fontSize: 17.0);

  @override
  Widget build(BuildContext context) {
    return ToggleableHeader(
      title: widget.title,
      child: child(),
      childHeight: 465,
      content: widget.selectedReserves.isNotEmpty
          ? widget.selectedReserves.first.time
          : '선택',
      toggleButton: widget.toggleButton,
      toggleButtonText: widget.toggleButtonText,
      onToggled: widget.onToggled,
      toggleOnOff: widget.toggleOnOff,
    );
  }

  Widget child() {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 15, 20, 20),
          child: Column(
            children: [
              veterinarianProfiles(),
              ...widget.reserveDataSource.map((reserveList) {
                return Column(
                  children: [
                    const SizedBox(height: 10),
                    TimeTableBuilder(
                        title: reserveList.title,
                        source: reserveList.reserves,
                        selectedReserves: widget.selectedReserves,
                        onSelectedReserve: widget.onSelectedReserve,
                        noneEventStyle: widget.noneEventStyle,
                        existEventStyle: widget.existEventStyle,
                        closedEventStyle: widget.closedEventStyle),
                  ],
                );
              }),
            ],
          ),
        ),
        _showVetList
            ? Positioned(
                top: 55,
                child: Container(
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                      boxShadow: [
                        BoxShadow(
                            color: Color(0x1a000000),
                            offset: Offset(0, 2),
                            blurRadius: 20,
                            spreadRadius: 0)
                      ],
                      color: Color(0xffffffff)),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(16)),
                    child: Column(
                        children: _veterinarians
                            .where(
                                (vet) => vet.name != _selectedVeterinarian.name)
                            .toList()
                            .map((vet) => InkWell(
                                  onTap: () {
                                    widget.onSelectVeterinarian(vet);
                                    setState(() {
                                      _selectedVeterinarian = vet;
                                      _showVetList = false;
                                    });
                                  },
                                  child: SizedBox(
                                    width: 200,
                                    height: 60,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Row(
                                          children: [
                                            const SizedBox(width: 20),
                                            SizedBox(
                                                width: 30,
                                                height: 30,
                                                child: vet.profileImage),
                                            const SizedBox(width: 5),
                                            Text(
                                              '${vet.name} 원장',
                                              style: _vetTextStyle,
                                            ),
                                          ],
                                        ),
                                        Container(
                                          width: 192,
                                          height: 1,
                                          margin:
                                              const EdgeInsets.only(top: 15),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: const Color(0xfff7f7f7),
                                                width: 1),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ))
                            .toList()),
                  ),
                ),
              )
            : Container()
      ],
    );
  }

  Widget veterinarianProfiles() {
    return InkWell(
      onTap: () {
        setState(() {
          if (_veterinarians.length >= 2) {
            _showVetList = !_showVetList;
          }
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 30,
              width: 30,
              child: _selectedVeterinarian.profileImage,
            ),
            const SizedBox(width: 5),
            Text(
              _selectedVeterinarian.name + " 원장",
              style: _vetTextStyle,
            ),
            const SizedBox(width: 10),
            _veterinarians.length >= 2
                ? Image.asset(
                    'assets/images/iconDefaultEnter2PxGreyDropdown.png')
                : Container(),
          ],
        ),
      ),
    );
  }
}

class TimeTableReserves {
  final String title;
  final List<Reserve> reserves;

  TimeTableReserves({
    required this.title,
    required this.reserves,
  });
}

class TimeTableBuilder extends StatelessWidget {
  const TimeTableBuilder(
      {Key? key,
      required this.title,
      required this.source,
      required this.selectedReserves,
      required this.onSelectedReserve,
      required this.noneEventStyle,
      required this.existEventStyle,
      required this.closedEventStyle})
      : super(key: key);
  final String title;
  final List<Reserve> source;
  final List<Reserve> selectedReserves;
  final void Function(Reserve) onSelectedReserve;
  final TimeEventStyle noneEventStyle;
  final TimeEventStyle existEventStyle;
  final TimeEventStyle closedEventStyle;

  @override
  Widget build(BuildContext context) {
    final tabledSource = <List<Widget>>[];
    const int col = 4;

    final cnt = source.length;
    for (var i = 0; i < cnt; i++) {
      if (i % col == 0) {
        tabledSource.add([timeEvent(source[i])]);
      } else {
        tabledSource[i ~/ 4].add(timeEvent(source[i]));
      }
    }

    // 마지막 배열의 길이
    final lastChildrenLength = tabledSource[tabledSource.length - 1].length;
    final spacingChildren = List.generate(
        col - lastChildrenLength, (index) => const SizedBox(width: 84));
    tabledSource[tabledSource.length - 1].addAll(spacingChildren);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
              color: Color(0xff999999),
              fontWeight: FontWeight.w400,
              fontFamily: "NotoSansKR",
              fontStyle: FontStyle.normal,
              fontSize: 17.0),
        ),
        Column(
          children: tabledSource.map((row) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: row,
            );
          }).toList(),
        )
      ],
    );
  }

  Widget timeEvent(Reserve reserve) {
    if (selectedReserves.contains(reserve)) {
      return timeEventTemplateWidget(
          reserve, const Color(0xffffffff), const Color(0xff006ed4));
    } else {
      switch (reserve.reserveType) {
        case ReserveType.none:
          return timeEventTemplateWidget(
            reserve,
            noneEventStyle.fontColor,
            noneEventStyle.backgroundColor,
          );

        case ReserveType.reserved:
          return timeEventTemplateWidget(
            reserve,
            existEventStyle.fontColor,
            existEventStyle.backgroundColor,
          );
        case ReserveType.closed:
          return timeEventTemplateWidget(
            reserve,
            closedEventStyle.fontColor,
            closedEventStyle.backgroundColor,
          );
        default:
          return Container();
      }
    }
  }

  Widget timeEventTemplateWidget(
      Reserve event, Color fontColor, Color backgroundColor) {
    return InkWell(
      onTap: () => onSelectedReserve(event),
      child: Container(
        width: 82,
        height: 40,
        margin: const EdgeInsets.fromLTRB(0, 4, 0, 0),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          color: backgroundColor,
        ),
        child: Center(
          child: Text(
            event.time,
            style: TextStyle(
                color: fontColor,
                fontWeight: FontWeight.w400,
                fontFamily: "NotoSansKR",
                fontStyle: FontStyle.normal,
                fontSize: 17.0),
          ),
        ),
      ),
    );
  }
}

class TimeEventStyle {
  final Color fontColor;
  final Color backgroundColor;

  TimeEventStyle({required this.fontColor, required this.backgroundColor});
}

class ToggleableCalendar extends StatefulWidget {
  const ToggleableCalendar(
      {Key? key,
      required this.title,
      required this.setFocusedDay,
      required this.setSelectedDay})
      : super(key: key);
  final String title;
  final void Function(DateTime) setFocusedDay;
  final void Function(DateTime) setSelectedDay;

  @override
  State<ToggleableCalendar> createState() => _ToggleableCalendarState();
}

class _ToggleableCalendarState extends State<ToggleableCalendar> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final DateTime _firstDay =
      DateTime(DateTime.now().year, DateTime.now().month);
  final DateTime _lastDay = DateTime.now().add(
    const Duration(days: 365),
  );
  void setFocusedDay(DateTime focusedDay) {
    setState(() {
      _focusedDay = focusedDay;
      widget.setFocusedDay(focusedDay);
    });
  }

  void setSelectedDay(DateTime selectedDay) {
    setState(() {
      _selectedDay = selectedDay;
      widget.setSelectedDay(selectedDay);
    });
  }

  Widget divider() {
    return Container(
        margin: const EdgeInsets.fromLTRB(20, 5, 0, 5),
        height: 1,
        decoration: BoxDecoration(
            border: Border.all(color: const Color(0xfff2f4f6), width: 1)));
  }

  Widget calendarPicker() {
    return SizedBox(
      height: 325,
      width: MediaQuery.of(context).size.width - 50,
      child: TableCalendar(
        availableCalendarFormats: const {CalendarFormat.month: 'Month'},
        availableGestures: AvailableGestures.horizontalSwipe,
        shouldFillViewport: true,
        focusedDay: _focusedDay,
        firstDay: _firstDay,
        lastDay: _lastDay,
        selectedDayPredicate: (day) {
          return isSameDay(_selectedDay, day);
        },
        onDaySelected: (selectedDay, focusedDay) {
          if (!isSameDay(_selectedDay, selectedDay) &&
              isSameYearMonth(
                  selectedDay, _focusedDay) && // 전달이나 다음달의 날짜는 선택 불가능
              isAfterYearMonthDay(selectedDay, DateTime.now() // 오늘 이후로만 선택 가능
                  )) {
            setFocusedDay(focusedDay);
            setSelectedDay(selectedDay);
          }
        },
        onPageChanged: (focusedDay) {
          setFocusedDay(focusedDay);
        },
        headerStyle: HeaderStyle(
          titleTextFormatter: (date, locale) => getFormatDate(date, 'yyyy년 M월'),
          titleTextStyle: const TextStyle(
              color: Color(0xff000000),
              fontWeight: FontWeight.w500,
              fontFamily: "NotoSansKR",
              fontStyle: FontStyle.normal,
              fontSize: 17.0),
          titleCentered: true,
          headerPadding: const EdgeInsets.fromLTRB(70, 0, 70, 10),
          leftChevronIcon: isSameYearMonth(_focusedDay, _firstDay)
              ? const Icon(
                  Icons.chevron_left,
                  color: Colors.transparent,
                )
              : const Icon(Icons.chevron_left),
          rightChevronIcon: isSameYearMonth(_focusedDay, _lastDay)
              ? const Icon(
                  Icons.chevron_left,
                  color: Colors.transparent,
                )
              : const Icon(Icons.chevron_right),
        ),
        calendarBuilders: CalendarBuilders(
          dowBuilder: (context, day) {
            return Center(
              child: Text(
                getWeekName(day),
                style: const TextStyle(
                    color: Color(0xffb2b2b2),
                    fontWeight: FontWeight.w500,
                    fontFamily: "NotoSansKR",
                    fontStyle: FontStyle.normal,
                    fontSize: 13.0),
              ),
            );
          },
          disabledBuilder: _noneBuilder,
          outsideBuilder: _noneBuilder,
          defaultBuilder: (context, day, selectedDay) {
            if (isBeforeYearMonthDay(day, DateTime.now())) {
              return Center(
                child: Text(
                  day.day.toString(),
                  style: const TextStyle(
                      color: Color(0xffcccccc),
                      fontWeight: FontWeight.w400,
                      fontFamily: "NotoSansKR",
                      fontStyle: FontStyle.normal,
                      fontSize: 20.0),
                ),
              );
            } else {
              return Center(
                child: Text(
                  day.day.toString(),
                  style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      fontFamily: "NotoSansKR",
                      fontStyle: FontStyle.normal,
                      fontSize: 20.0),
                ),
              );
            }
          },
          selectedBuilder: _outsideNoneBuilder(
              Colors.white, const Color(0xff006ed4), const Color(0xff006ed4)),
          todayBuilder: _outsideNoneBuilder(
              Colors.black, const Color(0xff006ed4), Colors.white),
        ),
      ),
    );
  }

  Widget _noneBuilder(
      BuildContext context, DateTime day, DateTime selectedDay) {
    return Container();
  }

  Widget? Function(BuildContext context, DateTime day, DateTime selectedDay)
      _outsideNoneBuilder(
          Color fontColor, Color borderColor, Color backgroundColor) {
    return (BuildContext context, DateTime day, DateTime selectedDay) {
      return isSameYearMonth(day, selectedDay)
          ? Center(
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(100)),
                    border: Border.all(color: borderColor, width: 1),
                    color: backgroundColor),
                child: Center(
                  child: Text(
                    day.day.toString(),
                    style: TextStyle(
                        color: fontColor,
                        fontWeight: FontWeight.w500,
                        fontFamily: "NotoSansKR",
                        fontStyle: FontStyle.normal,
                        fontSize: 20.0),
                  ),
                ),
              ),
            )
          : Container();
    };
  }

  @override
  Widget build(BuildContext context) {
    return ToggleableHeader(
      title: widget.title,
      child: calendarPicker(),
      childHeight: 390,
      content: _selectedDay != null
          ? getFormatDate(_selectedDay!, 'yyyy. M. dd ') +
              "(" +
              getWeekName(_selectedDay!) +
              ")"
          : "선택",
    );
  }
}

class ReservationBottomSheetTemplate extends StatefulWidget {
  const ReservationBottomSheetTemplate(
      {Key? key,
      required this.title,
      required this.canSave,
      required this.onSave,
      required this.child})
      : super(key: key);

  final String title;
  final bool canSave;
  final void Function() onSave;
  final Widget child;

  @override
  State<ReservationBottomSheetTemplate> createState() =>
      _ReservationBottomSheetTemplateState();
}

class _ReservationBottomSheetTemplateState
    extends State<ReservationBottomSheetTemplate> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        leading: confirmCancel(),
        actions: [submitReservation()],
        foregroundColor: Colors.black,
        backgroundColor: const Color(0xfff2f4f6),
        elevation: 0,
      ),
      body: body(),
    );
  }

  Widget submitReservation() {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 20, 0),
      child: InkWell(
        onTap: () {
          if (widget.canSave) {
            widget.onSave();
          }
        },
        child: Center(
          child: Text(
            '완료',
            style: TextStyle(
                color: widget.canSave
                    ? const Color(0xff006ed4)
                    : const Color(0xffb2b2b2),
                fontWeight: FontWeight.w500,
                fontFamily: "NotoSansKR",
                fontStyle: FontStyle.normal,
                fontSize: 17.0),
          ),
        ),
      ),
    );
  }

  Widget confirmCancel() {
    return InkWell(
      onTap: () async {
        final action = await showModalActionSheet(
          context: context,
          title: '이 ${widget.title}을 삭제하시겠습니까?',
          cancelLabel: '계속 예약하기',
          actions: <SheetAction<dynamic>>[
            const SheetAction(
              label: '변경 사항 삭제하기',
              key: 'delete',
            )
          ],
        );

        if (action == 'delete') {
          Navigator.of(context).pop();
        }
      },
      child: Container(
        margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
        child: Center(
          child: Text(
            '취소',
            style: _highlightTextStyle,
          ),
        ),
      ),
    );
  }

  Widget body() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      color: const Color(0xfff2f4f6),
      child: widget.child,
    );
  }
}

enum LabeledListType { simple, navigation, select }

class LabeledListItem {
  final String label;
  final dynamic content;
  final void Function()? onTap;

  LabeledListItem({
    required this.label,
    required this.content,
    this.onTap,
  });
}

class LabeledList extends StatefulWidget {
  const LabeledList(
      {Key? key,
      this.title,
      required this.children,
      required this.type,
      this.initialSelectedItem,
      this.onSelected})
      : super(key: key);
  final String? title;
  final List<LabeledListItem> children;
  final LabeledListType type;
  final dynamic initialSelectedItem;
  final void Function(dynamic selectedItem)? onSelected;

  @override
  State<LabeledList> createState() => _LabeledListState();
}

class _LabeledListState extends State<LabeledList> {
  dynamic _selectedItem;
  int index = 0;

  @override
  void initState() {
    super.initState();
    _selectedItem = widget.initialSelectedItem;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.title == null
            ? Container()
            : Container(
                padding: const EdgeInsets.fromLTRB(20, 0, 0, 7),
                child: Text(
                  widget.title!,
                  style: const TextStyle(
                      color: Color(0xff7f7f7f),
                      fontWeight: FontWeight.w400,
                      fontFamily: "NotoSansKR",
                      fontStyle: FontStyle.normal,
                      fontSize: 13.0),
                ),
              ),
        ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          child: Container(
            color: Colors.white,
            child: Column(
              children: widget.children.map((item) {
                index += 1;
                return InkWell(
                  onTap: widget.type == LabeledListType.select
                      ? () {
                          setState(() {
                            _selectedItem = item.content;
                          });
                          if (widget.onSelected != null) {
                            widget.onSelected!(_selectedItem);
                          }
                        }
                      : item.onTap,
                  child: SizedBox(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          height: index != widget.children.length ? 49 : 50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(item.label,
                                  style: const TextStyle(
                                      color: Color(0xff000000),
                                      fontWeight: FontWeight.w400,
                                      fontFamily: "NotoSansKR",
                                      fontStyle: FontStyle.normal,
                                      fontSize: 17.0)),
                              Row(
                                children: [
                                  widget.type != LabeledListType.select
                                      ? Text(
                                          item.content,
                                          style: const TextStyle(
                                              color: Color(0xff999999),
                                              fontWeight: FontWeight.w400,
                                              fontFamily: "NotoSansKR",
                                              fontStyle: FontStyle.normal,
                                              fontSize: 17.0),
                                        )
                                      : Container(),
                                  widget.type == LabeledListType.navigation
                                      ? Container(
                                          margin:
                                              const EdgeInsets.only(left: 5),
                                          child: Image.asset(
                                              'assets/images/iconDefaultEnter2PxGrey.png'),
                                        )
                                      : Container(),
                                  widget.type == LabeledListType.select &&
                                          _selectedItem == item.content
                                      ? Image.asset(
                                          'assets/images/iconDefaultCheck14PxSelectedBlue.png')
                                      : Container(),
                                ],
                              ),
                            ],
                          ),
                        ),
                        index != widget.children.length
                            ? Container(
                                width: 369,
                                height: 1,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: const Color(0xfff2f4f6), width: 1),
                                ),
                              )
                            : Container()
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}

class ToggleableHeader extends StatefulWidget {
  const ToggleableHeader({
    Key? key,
    required this.title,
    required this.child,
    required this.childHeight,
    required this.content,
    this.toggleButton = false,
    this.toggleButtonText,
    this.onToggled,
    this.toggleOnOff = false,
  }) : super(key: key);
  final String title;
  final Widget child;
  final double childHeight;
  final String content;

  final bool toggleButton;
  final String? toggleButtonText;
  final Future<void> Function(bool)? onToggled;
  final bool toggleOnOff;

  @override
  State<ToggleableHeader> createState() => _ToggleableHeaderState();
}

class _ToggleableHeaderState extends State<ToggleableHeader> {
  late bool _expandSize;
  late bool _showChild;
  // late bool _isOn;

  @override
  void initState() {
    super.initState();
    _expandSize = widget.toggleButton;
    _showChild = widget.toggleButton;
    // _isOn = widget.initialToggleState;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      onEnd: () {
        setState(() {
          _showChild = _expandSize;
        });
      },
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOutQuint,
      height: _expandSize ? widget.childHeight : 50,
      width: MediaQuery.of(context).size.width - 40,
      margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
      padding: const EdgeInsets.symmetric(vertical: 5),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(16)),
        color: Color(0xffffffff),
      ),
      child: Column(
        children: [
          header(),
          _showChild ? divider() : Container(),
          _showChild ? widget.child : Container(),
        ],
      ),
    );
  }

  Widget header() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(widget.title, style: _labelStyle),
          widget.toggleButton
              ? SizedBox(
                  height: 40,
                  child: Row(
                    children: [
                      Text(
                        widget.toggleButtonText!,
                        style: _highlightTextStyle,
                      ),
                      const SizedBox(width: 10),
                      CupertinoSwitch(
                        // value: _isOn,
                        // onChanged: (isOn) async {
                        //   isOn = await widget.onToggled!(isOn);
                        //   setState(() {
                        //     _isOn = isOn;
                        //   });
                        // },
                        value: widget.toggleOnOff,
                        onChanged: widget.onToggled,
                      )
                    ],
                  ))
              : InkWell(
                  onTap: () {
                    setState(() {
                      if (_expandSize) {
                        _showChild = false;
                      }
                      _expandSize = !_expandSize;
                    });
                  },
                  child: Container(
                    width: 140,
                    height: 40,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      color: Color(0xfff7f7f7),
                    ),
                    child: Center(
                      child: Text(
                        widget.content,
                        style: _highlightTextStyle,
                      ),
                    ),
                  ),
                )
        ],
      ),
    );
  }

  Widget divider() {
    return Container(
        margin: const EdgeInsets.fromLTRB(20, 5, 0, 5),
        height: 1,
        decoration: BoxDecoration(
            border: Border.all(color: const Color(0xfff2f4f6), width: 1)));
  }
}

class SimpleInfoBottomSheet extends StatefulWidget {
  const SimpleInfoBottomSheet({Key? key, this.title = "", required this.child})
      : super(key: key);
  final String title;
  final Widget child;

  @override
  State<SimpleInfoBottomSheet> createState() => _SimpleInfoBottomSheetState();
}

class _SimpleInfoBottomSheetState extends State<SimpleInfoBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        leadingWidth: 200,
        leading: goBack(),
        foregroundColor: Colors.black,
        backgroundColor: const Color(0xfff2f4f6),
        elevation: 0,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        color: const Color(0xfff2f4f6),
        child: Container(
            margin: const EdgeInsets.only(top: 20), child: widget.child),
      ),
    );
  }

  Widget goBack() {
    return InkWell(
      onTap: () => Navigator.of(context).pop(),
      child: Container(
        margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
        child: Row(
          children: [
            Image.asset('assets/images/iconNaviBlue.png'),
            Text(
              '다시 예약',
              style: _highlightTextStyle,
            ),
          ],
        ),
      ),
    );
  }
}
