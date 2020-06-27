import 'package:flutter_test/flutter_test.dart';

import 'package:kitchen/app.dart';

void main() {
  testWidgets('App loads', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(App());

    // Verify that our counter starts at 0.
    expect(find.text('Morning Checklist'), findsOneWidget);

    // Tap the '+' icon and trigger a frame.
    // await tester.tap(find.byIcon(Icons.add));
    // await tester.pump();
  });
}
