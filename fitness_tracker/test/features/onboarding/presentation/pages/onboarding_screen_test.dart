import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_tracker/core/constants/app_strings.dart';
import 'package:fitness_tracker/features/onboarding/presentation/pages/onboarding_screen.dart';
import 'package:fitness_tracker/features/onboarding/presentation/widgets/onboarding_page_widget.dart';

void main() {
  group('OnboardingScreen Widget Tests', () {
    testWidgets('renders first onboarding page content correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: OnboardingScreen(),
        ),
      );

      // Verify page title and subtitle for Page 1 are visible
      expect(find.text(AppStrings.onboardingTitle1), findsOneWidget);
      expect(find.text(AppStrings.onboardingSubtitle1), findsOneWidget);
      expect(find.byIcon(Icons.fitness_center), findsOneWidget);

      // Verify next button is visible and skip button is visible
      expect(find.byKey(const Key('onboarding_next_button')), findsOneWidget);
      expect(find.byKey(const Key('onboarding_skip_button')), findsOneWidget);

      // Verify get started is NOT visible on first page
      expect(find.byKey(const Key('onboarding_get_started_button')),
          findsNothing);
    });

    testWidgets('navigating forward using Next button updates page contents',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: OnboardingScreen(),
        ),
      );

      // --- PAGE 1 to PAGE 2 ---
      await tester.tap(find.byKey(const Key('onboarding_next_button')));
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.onboardingTitle2), findsOneWidget);
      expect(find.text(AppStrings.onboardingSubtitle2), findsOneWidget);
      expect(find.byIcon(Icons.directions_run), findsOneWidget);

      // --- PAGE 2 to PAGE 3 ---
      await tester.tap(find.byKey(const Key('onboarding_next_button')));
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.onboardingTitle3), findsOneWidget);
      expect(find.text(AppStrings.onboardingSubtitle3), findsOneWidget);
      expect(find.byIcon(Icons.insights), findsOneWidget);

      // --- PAGE 3 to PAGE 4 (Last Page) ---
      await tester.tap(find.byKey(const Key('onboarding_next_button')));
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.onboardingTitle4), findsOneWidget);
      expect(find.text(AppStrings.onboardingSubtitle4), findsOneWidget);
      expect(find.byIcon(Icons.emoji_events), findsOneWidget);

      // On final page, "Next" and "Skip" should disappear, "Get Started" appears.
      expect(find.byKey(const Key('onboarding_next_button')), findsNothing);
      expect(find.byKey(const Key('onboarding_get_started_button')),
          findsOneWidget);

      // Verify skip button is hidden (opacity is 0 and is ignored by pointers)
      final skipOpacityFinder = find.byKey(const Key('onboarding_skip_button'));
      final animatedOpacity =
          tester.widget<AnimatedOpacity>(find.ancestor(
        of: skipOpacityFinder,
        matching: find.byType(AnimatedOpacity),
      ));
      expect(animatedOpacity.opacity, 0.0);
    });

    testWidgets('tapping Skip jumps directly to the last page',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: OnboardingScreen(),
        ),
      );

      // Page 1 is currently active
      expect(find.text(AppStrings.onboardingTitle1), findsOneWidget);

      // Tap Skip
      await tester.tap(find.byKey(const Key('onboarding_skip_button')));
      await tester.pumpAndSettle();

      // Should be directly on Page 4 (Last Page)
      expect(find.text(AppStrings.onboardingTitle4), findsOneWidget);
      expect(find.text(AppStrings.onboardingSubtitle4), findsOneWidget);
      expect(find.byIcon(Icons.emoji_events), findsOneWidget);

      // Buttons check
      expect(find.byKey(const Key('onboarding_next_button')), findsNothing);
      expect(find.byKey(const Key('onboarding_get_started_button')),
          findsOneWidget);
    });

    testWidgets('responsive layout builds OnboardingPageWidget successfully',
        (WidgetTester tester) async {
      // Test different screen size to verify responsiveness
      tester.view.physicalSize = const Size(360, 640); // small phone
      tester.view.devicePixelRatio = 1.0;

      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: OnboardingScreen(),
          ),
        ),
      );

      // Verify it renders fine without layout overflows
      expect(find.byType(OnboardingPageWidget), findsOneWidget);
      expect(find.text(AppStrings.onboardingTitle1), findsOneWidget);
    });
  });
}
