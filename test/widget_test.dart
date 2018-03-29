// This is a basic Flutter widget test.
// To perform an interaction with a widget in your test, use the WidgetTester utility that Flutter
// provides. For example, you can send tap and scroll gestures. You can also use WidgetTester to
// find child widgets in the widget tree, read text, and verify that the values of widget properties
// are correct.

import 'package:flutter_test/flutter_test.dart';

import '../lib/board.dart';
import '../lib/counter.dart';
import '../lib/main.dart';

void main() {
  testWidgets('Game has a board and two counters', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(new MinesApp());

    // Verify that our counter starts at 0.
    expect(find.byType(Board), findsOneWidget);
    expect(find.byType(Counter), findsNWidgets(2));

//    // Tap the '+' icon and trigger a frame.
//    await tester.tap(find.byIcon(Icons.add));
//    await tester.pump();
//
//    // Verify that our counter has incremented.
//    expect(find.text('0'), findsNothing);
//    expect(find.text('1'), findsOneWidget);
  });
}
