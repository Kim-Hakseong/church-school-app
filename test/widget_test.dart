// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:church_school_app/main.dart';

void main() {
  testWidgets('Church School App loads', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ChurchSchoolApp());

    // Verify that the app loads with initialization screen
    expect(find.text('교회학교 암송 어플'), findsOneWidget);
  });
}
