import 'package:calendar01/calendar_cubit.dart';
import 'package:calendar01/datasource.dart';
import 'package:calendar01/enums.dart';
import 'package:calendar01/event.dart';
import 'package:calendar01/screens/event_detail/event_detail_screen.dart';
import 'package:calendar01/screens/new_reservation/new_reservation_screen.dart';
import 'package:calendar01/screens/re_reservation_bottom_sheet/re_reservation_bottom_sheet_child_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:snapping_sheet/snapping_sheet.dart';
import 'package:table_calendar/table_calendar.dart';
import 'utils.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'enums.dart';

void main() {
  initializeDateFormatting().then((_) => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      // localizationsDelegates: const [
      //   GlobalMaterialLocalizations.delegate,
      //   GlobalWidgetsLocalizations.delegate,
      //   GlobalCupertinoLocalizations.delegate,
      //   // 한국어 설정
      // ],
      // supportedLocales: const [
      //   Locale('ko', 'KR'),
      //   // include country code too
      // ],
      routes: {
        EventDetailScreen.routeName: (context) => const EventDetailScreen(),
      },
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: const MainCalendarScreen(),
        floatingActionButton: _floatingActionButton(context),
      ),
    );
  }

  Widget _floatingActionButton(BuildContext context) {
    return Builder(builder: (context) {
      return InkWell(
        child: Container(
          width: 50,
          height: 50,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                  color: Color(0x66000000),
                  offset: Offset(0, 6),
                  blurRadius: 9,
                  spreadRadius: 0)
            ],
            color: Color(0xff000000),
          ),
          child: Center(
              child: Image.asset('assets/images/iconDefaultSchedule.png')),
        ),
        onTap: () => showReservationBottomSheet(context,
            screen: const NewReservationScreen(), enableDrag: false),
      );
    });
  }
}

class ShowMoveToday {
  final bool show;
  final bool left;
  final bool right;

  ShowMoveToday({
    required this.show,
    required this.left,
    required this.right,
  });
}

class MainCalendarScreen extends StatefulWidget {
  const MainCalendarScreen({Key? key}) : super(key: key);

  @override
  State<MainCalendarScreen> createState() => _MainCalendarScreenState();
}

class _MainCalendarScreenState extends State<MainCalendarScreen> {
  final CalendarCubit _calendarCubit = CalendarCubit();
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  bool _showDatePicker = false;
  ShowMoveToday _showMoveToday =
      ShowMoveToday(show: false, left: false, right: false);
  final ScrollController _snappingSheetScrollController = ScrollController();
  RotatedBox updownSlider = RotatedBox(
      quarterTurns: 0,
      child: Image.asset('assets/images/iconDefaultUpdown.png'));

  void setFocusedDay(DateTime focusedDay) {
    setState(() {
      _focusedDay = focusedDay;
      _calendarCubit.setFocusedDay(focusedDay);
    });
    onOffShowMoveToday(focusedDay);
  }

  void setSelectedDay(DateTime selectedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _calendarCubit.setSelectedDay(selectedDay);
    });
    onOffShowMoveToday(selectedDay);
  }

  void onOffShowMoveToday(DateTime day) {
    setState(() {
      final DateTime today = DateTime.now();
      _showMoveToday = ShowMoveToday(
          show: !(day.year == today.year &&
              day.month == today.month &&
              day.day == today.day),
          left: day.isAfter(today),
          right: day.isBefore(today));
    });
  }

  List<Event> _eventLoader(DateTime day) {
    return evetDataSourceMap[day.day] ?? [];
  }

  Widget? Function(BuildContext context, DateTime day, DateTime selectedDay)?
      _defaultTheme(
          {required Color fontColor,
          Color circleColor = Colors.transparent,
          Color circleFillColor = Colors.transparent}) {
    return (BuildContext context, DateTime day, DateTime selectedDay) {
      return Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(width: 1, color: Color(0xfff2f2f2))),
        ),
        child: SizedBox.expand(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 27,
                width: 27,
                decoration: BoxDecoration(
                  color: circleFillColor,
                  border: Border.all(color: circleColor),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${day.day}',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: fontColor),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    };
  }

  Widget _markerBuilder(
      BuildContext context, DateTime day, List<Event> events) {
    const limit = 3;
    int index = 0;
    if (events.isEmpty) {
      return const SizedBox();
    }
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 27.5, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: events.map((e) {
          if (index < limit) {
            index += 1;
            return ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: Row(
                children: [
                  Container(
                      margin: const EdgeInsets.fromLTRB(2, 0, 0, 0),
                      height: 14,
                      width: 2,
                      color: isThisMonth(day, _calendarCubit.state.focusedDay)
                          ? e.color
                          : e.color.withOpacity(0.2)),
                  SizedBox(
                    child: Container(
                      height: 14,
                      width: MediaQuery.of(context).size.width - 373,
                      margin: const EdgeInsets.fromLTRB(0, 0, 0, 1),
                      padding: const EdgeInsets.fromLTRB(2, 1, 0, 0),
                      decoration: BoxDecoration(
                          color:
                              isThisMonth(day, _calendarCubit.state.focusedDay)
                                  ? e.color.withOpacity(0.3)
                                  : e.color.withOpacity(0.06)),
                      child: Text(
                        e.title,
                        style: TextStyle(
                            color: isThisMonth(
                                    day, _calendarCubit.state.focusedDay)
                                ? Colors.black
                                : const Color(0xff000000).withOpacity(0.2),
                            fontWeight: FontWeight.w500,
                            fontFamily: "NotoSansKR",
                            fontStyle: FontStyle.normal,
                            fontSize: 11.0),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else if (index == limit) {
            index += 1;
            return Container(
              height: 15,
              margin: const EdgeInsets.fromLTRB(6, 0, 0, 0),
              child: Text('+${events.length - index}',
                  style: TextStyle(
                      color: isThisMonth(day, _calendarCubit.state.focusedDay)
                          ? const Color(0xff999999)
                          : const Color(0xff999999).withOpacity(0.2),
                      fontWeight: FontWeight.w500,
                      fontFamily: "NotoSansKR",
                      fontStyle: FontStyle.normal,
                      fontSize: 11.0)),
            );
          } else {
            index += 1;
            return Container();
          }
        }).toList(),
      ),
    );
  }

  Widget _dowMaker(String weekName, Color color) {
    return Center(
      child: Text(
        weekName,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w400,
          fontFamily: "NotoSansKR",
          fontStyle: FontStyle.normal,
          fontSize: 16.0,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          Column(
            children: [
              calendarHeader(),
              SizedBox(
                height: 560,
                width: MediaQuery.of(context).size.width,
                child: TableCalendar(
                  availableCalendarFormats: const {
                    CalendarFormat.month: 'Month',
                    CalendarFormat.week: 'Week',
                  },
                  availableGestures: AvailableGestures.horizontalSwipe,
                  shouldFillViewport: true,
                  headerVisible: false,
                  // locale: 'ko',
                  firstDay: getStartDay(kFirstDay),
                  lastDay: getEndDay(kLastDay),
                  // focusedDay: _focusedDay,
                  focusedDay: _calendarCubit.state.focusedDay,
                  calendarFormat: _calendarFormat,
                  eventLoader: _eventLoader,
                  selectedDayPredicate: (day) {
                    // return isSameDay(_selectedDay, day);
                    return isSameDay(_calendarCubit.state.selectedDay, day);
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    // if (!isSameDay(_selectedDay, selectedDay)) {
                    if (!isSameDay(
                        _calendarCubit.state.selectedDay, selectedDay)) {
                      setFocusedDay(focusedDay);
                      setSelectedDay(selectedDay);
                    }
                  },
                  onFormatChanged: (format) {
                    if (_calendarFormat != format) {
                      setState(() {
                        _calendarFormat = format;
                      });
                    }
                  },
                  onPageChanged: (focusedDay) {
                    setFocusedDay(focusedDay);
                  },
                  calendarBuilders: CalendarBuilders<Event>(
                      dowBuilder: (context, day) {
                        return day.weekday == DateTime.sunday
                            ? _dowMaker('일', Colors.red)
                            : _dowMaker(getWeekName(day), Colors.black);
                      },
                      outsideBuilder: _defaultTheme(
                          fontColor: Colors.black.withOpacity(0.2)),
                      defaultBuilder: _defaultTheme(fontColor: Colors.black),
                      selectedBuilder: _defaultTheme(
                          fontColor: Colors.white,
                          circleColor: Colors.black,
                          circleFillColor: Colors.black),
                      todayBuilder: _defaultTheme(
                        fontColor: Colors.black,
                        circleColor: Colors.black,
                      ),
                      markerBuilder: _markerBuilder,
                      disabledBuilder:
                          _defaultTheme(fontColor: Colors.transparent)),
                ),
              ),
              const SizedBox(
                width: 300,
              )
            ],
          ),
          SnappingSheet(
            lockOverflowDrag: true,
            grabbingHeight: 30,
            grabbing: Container(
              color: const Color(0xfff7f7f7),
              child: Center(
                child: updownSlider,
              ),
            ),
            snappingPositions: [
              SnappingPosition.pixels(
                positionPixels: MediaQuery.of(context).size.height - 730,
                snappingCurve: Curves.easeOutExpo,
                snappingDuration: const Duration(milliseconds: 800),
                grabbingContentOffset: GrabbingContentOffset.top,
              ),
              SnappingPosition.pixels(
                positionPixels: MediaQuery.of(context).size.height - 255,
                snappingCurve: Curves.easeOutExpo,
                snappingDuration: const Duration(milliseconds: 800),
                grabbingContentOffset: GrabbingContentOffset.bottom,
              ),
            ],
            onSnapCompleted: (sheetPosition, snappingPosition) {
              //올리는 이벤트 끝날 때
              if (snappingPosition.grabbingContentOffset == -1) {
                setState(() {
                  updownSlider = RotatedBox(
                    quarterTurns: 2,
                    child: Image.asset('assets/images/iconDefaultUpdown.png'),
                  );
                });
              }
              //내리는 이벤트 끝날 때
              if (snappingPosition.grabbingContentOffset == 1) {
                setState(() {
                  updownSlider = RotatedBox(
                    quarterTurns: 0,
                    child: Image.asset('assets/images/iconDefaultUpdown.png'),
                  );
                });
              }
            },
            onSnapStart: (sheetPosition, snappingPosition) {
              //올리는 이벤트 시작 할 때
              if (snappingPosition.grabbingContentOffset == -1) {
                setState(() {
                  _calendarFormat = CalendarFormat.week;
                });
              }
              //내리는 이벤트 시작 할 때
              if (snappingPosition.grabbingContentOffset == 1) {
                setState(() {
                  _calendarFormat = CalendarFormat.month;
                });
              }
            },
            sheetBelow: SnappingSheetContent(
              childScrollController: _snappingSheetScrollController,
              draggable: true,
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xfff7f7f7),
                ),
                child: ListView.builder(
                  controller: _snappingSheetScrollController,
                  padding: const EdgeInsets.all(0),
                  itemCount: rs.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(15, 0, 15, 3),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(rs[index].time,
                              style: const TextStyle(
                                  color: Color(0xff000000),
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "NotoSansKR",
                                  fontStyle: FontStyle.normal,
                                  fontSize: 15.0)),
                          const SizedBox(width: 11.6),
                          rs[index].reserveType == ReserveType.reserved
                              ? ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
                                  child: InkWell(
                                    onTap: () => Navigator.of(context)
                                        .pushNamed(EventDetailScreen.routeName),
                                    child: Row(
                                      children: [
                                        Container(
                                            width: 10,
                                            height: 70,
                                            decoration: BoxDecoration(
                                                color: rs[index].color)),
                                        Container(
                                          padding:
                                              const EdgeInsets.only(left: 10),
                                          height: 70,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              96,
                                          decoration: const BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Color(0x1a000000),
                                                  offset: Offset(0, 3),
                                                  blurRadius: 9,
                                                  spreadRadius: 0)
                                            ],
                                            color: Color(0xffffffff),
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  rs[index].petName! +
                                                      " " +
                                                      rs[index]
                                                          .requestType!
                                                          .korName(),
                                                  style: const TextStyle(
                                                      color: Color(0xff000000),
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontFamily: "NotoSansKR",
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontSize: 16.0)),
                                              const SizedBox(height: 5),
                                              Text(
                                                  '${rs[index].age}세, ${rs[index].breeds}, ${rs[index].genderCode}아 / ${rs[index].realName}',
                                                  style: const TextStyle(
                                                      color: Color(0x66000000),
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontFamily: "NotoSansKR",
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontSize: 14.0))
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : rs[index].reserveType == ReserveType.closed
                                  ? ClipRRect(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)),
                                      child: Row(
                                        children: [
                                          Container(
                                              width: 10,
                                              height: 70,
                                              decoration: const BoxDecoration(
                                                  color: Color(0xffe5e5e5))),
                                          Container(
                                            padding:
                                                const EdgeInsets.only(left: 10),
                                            height: 70,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                96,
                                            decoration: const BoxDecoration(
                                              color: Color(0x08000000),
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: const [
                                                Text('클로즈',
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xff999999),
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontFamily:
                                                            "NotoSansKR",
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        fontSize: 16.0)),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : Container(
                                      height: 70,
                                      padding: const EdgeInsets.only(bottom: 3),
                                    )
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          _showDatePicker
              ? SizedBox(
                  height: MediaQuery.of(context).size.height - 138,
                  child: Column(
                    children: [
                      Container(
                        color: Colors.white,
                        height: 200,
                        child: CupertinoDatePicker(
                          dateOrder: DatePickerDateOrder.ymd,
                          initialDateTime: _calendarCubit.state.focusedDay,
                          onDateTimeChanged: (DateTime newdate) {
                            _calendarCubit.setPickerDate(newdate);
                          },
                          minimumYear: kFirstDay.year,
                          maximumYear: kLastDay.year,
                          mode: CupertinoDatePickerMode.date,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            _showDatePicker = false;
                          });
                          setFocusedDay(_calendarCubit.state.pickerDate);
                          setSelectedDay(_calendarCubit.state.pickerDate);
                        },
                        child: Container(
                          height:
                              MediaQuery.of(context).size.height - 138 - 200,
                          width: double.infinity,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      )
                    ],
                  ),
                )
              : Container(),
          _showMoveToday.show
              ? Positioned(
                  bottom: 50,
                  child: InkWell(
                    onTap: () {
                      setFocusedDay(DateTime.now());
                      setSelectedDay(DateTime.now());
                    },
                    child: Container(
                      width: 65,
                      height: 36,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        boxShadow: [
                          BoxShadow(
                              color: Color(0x26000000),
                              offset: Offset(0, 3),
                              blurRadius: 10,
                              spreadRadius: 0)
                        ],
                        color: Color(0xffffffff),
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _showMoveToday.left
                                ? Image.asset('assets/images/iconDefault.png')
                                : const SizedBox(width: 10),
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 3),
                              child: const Text(
                                '오늘',
                                style: TextStyle(
                                    color: Color(0xff000000),
                                    fontWeight: FontWeight.w400,
                                    fontFamily: "NotoSansKR",
                                    fontStyle: FontStyle.normal,
                                    fontSize: 14.0),
                              ),
                            ),
                            _showMoveToday.right
                                ? RotatedBox(
                                    quarterTurns: 2,
                                    child: Image.asset(
                                        'assets/images/iconDefault.png'))
                                : const SizedBox(width: 10)
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  Widget calendarHeader() {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 60, bottom: 30),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x88757575),
                          blurRadius: 8.0,
                          spreadRadius: 0.5,
                        ),
                      ],
                      shape: BoxShape.circle,
                      border:
                          Border.all(color: const Color(0xFFFFFFFF), width: 3)),
                  child: Image.asset(
                      'assets/images/smilingAsianMaleDoctorPointingUpwards.png')),
              InkWell(
                onTap: () {
                  setState(() {
                    _showDatePicker = true;
                  });
                },
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 25, right: 13),
                        child: Text(getFormatDate(_focusedDay, 'yyyy. M'),
                            style: const TextStyle(
                                color: Color(0xff000000),
                                fontWeight: FontWeight.w700,
                                fontFamily: "NotoSansKR",
                                fontStyle: FontStyle.normal,
                                fontSize: 22.0),
                            textAlign: TextAlign.center),
                      ),
                      Image.asset('assets/images/iconDropdown.png')
                    ]),
              ),
            ]),
            Row(children: [
              InkWell(
                  onTap: () {
                    print('alert');
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 13, right: 13),
                    child: Image.asset('assets/images/iconAlarm.png'),
                  )),
              InkWell(
                  onTap: () {
                    print('list');
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 13),
                    child: Image.asset('assets/images/iconMenu.png'),
                  ))
            ])
          ]),
    );
  }
}
