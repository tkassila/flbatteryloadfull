// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flbatteryloadfull/main.dart';

void main() {
  testWidgets('App renders battery monitor screen smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.byType(BatteryMonitorScreen), findsOneWidget);
  });

  testWidgets('Before use button exists and can be tapped', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    final buttonFinder = find.descendant(
      of: find.byType(AppBar),
      matching: find.byType(OutlinedButton),
    );
    expect(buttonFinder, findsOneWidget);
    await tester.tap(buttonFinder);
    await tester.pumpAndSettle();
  });
}
