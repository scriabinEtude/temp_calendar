// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:calendar01/datasource.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:calendar01/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    rs.forEach((element) {
      try {
        print(element);
        print("\r\n");
      } catch (e) {
        print(e);
      }
    });
  });
}
