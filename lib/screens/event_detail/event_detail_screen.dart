import 'package:calendar01/screens/re_reservation_bottom_sheet/re_reservation_bottom_sheet_child_screen.dart';
import 'package:calendar01/screens/re_reservation_bottom_sheet/re_reservation_bottom_sheet_screen.dart';
import 'package:calendar01/utils.dart';
import 'package:flutter/material.dart';
import 'package:calendar01/screens/event_detail/event_detail_cubit.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:calendar01/enums.dart';

class EventDetailScreen extends StatefulWidget {
  const EventDetailScreen({Key? key}) : super(key: key);
  static const routeName = '/calendar/event';

  @override
  _EventDetailScreenState createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  final cb = EventDetailCubit();

  @override
  void initState() {
    cb.loadInitialData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: InkWell(
          onTap: () => Navigator.of(context).pop(),
          child: Image.asset('assets/images/iconNavi.png'),
        ),
      ),
      body: body(),
    );
  }

  Widget body() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          reservationTime(cb.state.reservationTime),
          const SizedBox(height: 5),
          title(cb.state.name + " " + cb.state.requestType.korName()),
          const SizedBox(height: 30),
          labelText('품종', cb.state.breeds),
          labelText('나이', "${cb.state.age}세"),
          labelText('성별',
              "${cb.state.sex == 1 ? '남' : '여'}아 / 중성화 ${cb.state.doesNeutering ? '' : '안'}함"),
          labelText('체중', "${cb.state.weight}kg"),
          divider(20, 30),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  labelText('보호자', cb.state.guardian),
                  labelText('연락처', cb.state.phone),
                ],
              ),
              callGuardianButton(cb.state.phone),
            ],
          ),
          description(cb.state.description),
          divider(20, 30),
          labelText('의료진', "${cb.state.veterinarian} 수의사"),
          labelText('예약번호', "${cb.state.reservationNumber}"),
          labelText('예약일자', getFormatDate(cb.state.createdAt, 'yyyy.M.dd')),
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(bottom: 37),
              alignment: Alignment.bottomCenter,
              child: cb.state.reservationTime
                      .isBefore(DateTime.now().add(const Duration(minutes: 30)))
                  // .isAfter(DateTime.now()
                  //     .add(const Duration(minutes: 30))) // for test
                  ? beforeBottomButtons()
                  : afterBottomButtons(),
            ),
          ),
        ],
      ),
    );
  }

  Widget reservationTime(DateTime reservationTime) {
    return Text(getFormatDate(reservationTime, 'M월 dd일 (weekName) hh:mm'),
        style: const TextStyle(
            color: Color(0xff006ed4),
            fontWeight: FontWeight.w400,
            fontFamily: "NotoSansKR",
            fontStyle: FontStyle.normal,
            fontSize: 16.0));
  }

  Widget title(String title) {
    return Text(title,
        style: const TextStyle(
            color: Color(0xff000000),
            fontWeight: FontWeight.w500,
            fontFamily: "NotoSansKR",
            fontStyle: FontStyle.normal,
            fontSize: 29.0));
  }

  Widget labelText(String label, String text) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
      child: Row(
        children: [
          SizedBox(
            width: 70,
            child: Text(
              label,
              style: const TextStyle(
                  color: Color(0xffb2b2b2),
                  fontWeight: FontWeight.w500,
                  fontFamily: "NotoSansKR",
                  fontStyle: FontStyle.normal,
                  fontSize: 16.0),
            ),
          ),
          Text(
            text,
            style: const TextStyle(
                color: Color(0xff000000),
                fontWeight: FontWeight.w400,
                fontFamily: "NotoSansKR",
                fontStyle: FontStyle.normal,
                fontSize: 16.0),
          ),
        ],
      ),
    );
  }

  Widget divider(double marginTop, double marginBottom) {
    return Container(
        margin: EdgeInsets.fromLTRB(0, marginTop, 0, marginBottom),
        width: 382,
        height: 1,
        decoration: BoxDecoration(
            border: Border.all(color: const Color(0xfff2f2f2), width: 1)));
  }

  Widget description(String description) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(13)),
        color: Color(0x1aa3bbd1),
      ),
      child: Text(description,
          style: const TextStyle(
              color: Color(0xff000000),
              fontWeight: FontWeight.w400,
              fontFamily: "NotoSansKR",
              fontStyle: FontStyle.normal,
              fontSize: 16.0)),
    );
  }

  Widget callGuardianButton(String phoneNumber) {
    return InkWell(
      onTap: () async {
        final canlaunch = await canLaunch('tel:82-' + phoneNumber);
        print(canlaunch);
      },
      child: Container(
        width: 140,
        height: 49,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(13)),
          color: Color(0x1a13a938),
        ),
        child: Center(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/iconHospitalDetailTabbarPhone.png'),
            const SizedBox(width: 10),
            const Text(
              '전화걸기',
              style: TextStyle(
                  color: Color(0xff13a938),
                  fontWeight: FontWeight.w500,
                  fontFamily: "NotoSansKR",
                  fontStyle: FontStyle.normal,
                  fontSize: 17.0),
            ),
          ],
        )),
      ),
    );
  }

  Widget simpleButton(
      {required String title,
      required Color backgroundColor,
      required Color fontColor,
      required void Function() onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: (MediaQuery.of(context).size.width - 48 - 10) / 2,
        height: 56,
        decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: const BorderRadius.all(Radius.circular(16))),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
                color: fontColor,
                fontWeight: FontWeight.w500,
                fontFamily: "NotoSansKR",
                fontStyle: FontStyle.normal,
                fontSize: 17.0),
          ),
        ),
      ),
    );
  }

  Widget beforeBottomButtons() {
    return Row(
      children: [
        simpleButton(
          title: "예약 취소",
          backgroundColor: const Color(0x26ff7a20),
          fontColor: const Color(0xffff7a20),
          onTap: () {},
        ),
        const SizedBox(width: 10),
        simpleButton(
          title: "그랫 운영 센터",
          backgroundColor: Colors.black,
          fontColor: Colors.white,
          onTap: () {},
        )
      ],
    );
  }

  Widget afterBottomButtons() {
    return Row(
      children: [
        simpleButton(
          title: "그랫 운영 센터",
          backgroundColor: const Color(0x1a000000),
          fontColor: const Color(0xff000000),
          onTap: () {},
        ),
        const SizedBox(width: 10),
        simpleButton(
          title: "다음 예약 잡기",
          backgroundColor: const Color(0xff006ed4),
          fontColor: Colors.white,
          onTap: () {
            showReservationBottomSheet(
              context,
              enableDrag: false,
              screen: const ReReservationBottomSheetScreen(),
            );
          },
        )
      ],
    );
  }
}
