// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

import 'package:intl/intl.dart';

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year, kToday.month - 12, kToday.day);
final kLastDay = DateTime(kToday.year, kToday.month + 3, kToday.day);

DateTime getStartDay(date) {
  return DateTime(date.year, 1, 1);
}

DateTime getEndDay(date) {
  return DateTime(date.year, 12, 31);
}

bool isThisMonth(DateTime day, DateTime thisMonthDay) {
  return day.month == thisMonthDay.month;
}

String getFormatDate(DateTime date, String format) {
  return DateFormat(format.replaceAll('weekName', getWeekName(date)))
      .format(date);
}

bool isSameYearMonth(DateTime day1, DateTime day2) {
  return day1.year == day2.year && day1.month == day2.month;
}

bool isSameYearMonthDay(DateTime day1, DateTime day2) {
  return isSameYearMonth(day1, day2) && day1.day == day2.day;
}

bool isBeforeYearMonthDay(DateTime day, DateTime pivotDay) {
  return day.isBefore(DateTime(pivotDay.year, pivotDay.month, pivotDay.day));
}

bool isAfterYearMonthDay(DateTime day, DateTime pivotDay) {
  return day.isAfter(DateTime(pivotDay.year, pivotDay.month, pivotDay.day));
}

String getWeekName(DateTime date) {
  switch (date.weekday) {
    case 0:
      return '일';
    case 1:
      return '월';
    case 2:
      return '화';
    case 3:
      return '수';
    case 4:
      return '목';
    case 5:
      return '금';
    case 6:
      return '토';
    case 7:
      return '일';
    default:
      return "NotImplType";
  }
}
