

import 'package:flutter_test/flutter_test.dart';

import 'package:capstone/main.dart';

void main() {
  testWidgets('E-Sasando home smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify app bar title
    expect(find.text('E-Sasando Audio Synthesizer'), findsOneWidget);

    // Verify Sasando strings list exists
    expect(find.text('String 1'), findsOneWidget);
    expect(find.text('C'), findsOneWidget);
  });
}
