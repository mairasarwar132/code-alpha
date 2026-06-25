import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitness_tracker/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: FitTrackApp()));

    // Verify that the app launches and shows the splash screen placeholder.
    expect(find.text('Splash Screen'), findsOneWidget);
  });
}
