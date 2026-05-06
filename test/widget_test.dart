// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:smart_emergency_app/main.dart';

void main() {
  testWidgets('Emergency App loads smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const EmergencyAdminApp());

    // Verify that the Emergency Response header is displayed.
    expect(find.text('Emergency Response'), findsOneWidget);
    expect(find.text('All systems operational'), findsOneWidget);

    // Verify that the navigation bar is present.
    expect(find.byType(NavigationBar), findsOneWidget);

    // Verify that the OVERVIEW section is displayed.
    expect(find.text('OVERVIEW'), findsOneWidget);
  });
}
