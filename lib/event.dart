import 'package:flutter/material.dart';

class Event {
  DateTime date;
  String title;
  String? description;
  Color color;

  Event({
    required this.date,
    required this.title,
    this.description,
    required this.color,
  });
}

DateTime time =
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 9);

List<String> titles = ['라떼진료', '끼리예방접종', '벤티건강검진', '꼬북이', '두부진료', '감자예방접종'];

List<Color> colors = const [
  Color(0xffff7a20),
  Color(0xffff7a20),
  Color(0xff006ed4),
  Color(0xff13a938),
  Color(0xff006ed4),
  Color(0xffff7a20)
];

final List<Event> eventDataSource = List.generate(168, (index) {
  return Event(
      date: DateTime.now().add(Duration(days: index ~/ 6)),
      title: titles[(index % 6)],
      color: colors[(index % 6)]);
});

final evetDataSourceMap = {
  // 1: eventDataSource.where((element) => element.date.day == 1).toList(),
  // 2: eventDataSource.where((element) => element.date.day == 2).toList(),
  // 3: eventDataSource.where((element) => element.date.day == 3).toList(),
  // 4: eventDataSource.where((element) => element.date.day == 4).toList(),
  // 5: eventDataSource.where((element) => element.date.day == 5).toList(),
  // 6: eventDataSource.where((element) => element.date.day == 6).toList(),
  // 7: eventDataSource.where((element) => element.date.day == 7).toList(),
  // 8: eventDataSource.where((element) => element.date.day == 8).toList(),
  // 9: eventDataSource.where((element) => element.date.day == 9).toList(),
  10: eventDataSource.where((element) => element.date.day == 10).toList(),
  // 11: eventDataSource.where((element) => element.date.day == 11).toList(),
  // 12: eventDataSource.where((element) => element.date.day == 12).toList(),
  // 13: eventDataSource.where((element) => element.date.day == 13).toList(),
  // 14: eventDataSource.where((element) => element.date.day == 14).toList(),
  // 15: eventDataSource.where((element) => element.date.day == 15).toList(),
  // 16: eventDataSource.where((element) => element.date.day == 16).toList(),
  // 17: eventDataSource.where((element) => element.date.day == 17).toList(),
  // 18: eventDataSource.where((element) => element.date.day == 18).toList(),
  // 19: eventDataSource.where((element) => element.date.day == 19).toList(),
  // 20: eventDataSource.where((element) => element.date.day == 20).toList(),
  // 21: eventDataSource.where((element) => element.date.day == 21).toList(),
  // 22: eventDataSource.where((element) => element.date.day == 22).toList(),
  // 23: eventDataSource.where((element) => element.date.day == 23).toList(),
  // 24: eventDataSource.where((element) => element.date.day == 24).toList(),
  // 25: eventDataSource.where((element) => element.date.day == 25).toList(),
  // 26: eventDataSource.where((element) => element.date.day == 26).toList(),
  // 27: eventDataSource.where((element) => element.date.day == 27).toList(),
};
