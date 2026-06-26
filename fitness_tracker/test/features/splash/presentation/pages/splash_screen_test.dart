import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fitness_tracker/core/constants/app_strings.dart';
import 'package:fitness_tracker/core/constants/app_routes.dart';
import 'package:fitness_tracker/core/database/app_database.dart';
import 'package:fitness_tracker/core/providers/repository_providers.dart';
import 'package:fitness_tracker/features/profile/domain/repositories/profile_repository.dart';
import 'package:fitness_tracker/features/splash/presentation/pages/splash_screen.dart';
import 'package:fitness_tracker/features/splash/presentation/providers/splash_provider.dart';

class FakeProfileRepository implements ProfileRepository {
  final UserProfileTableData? profileToReturn;
  FakeProfileRepository(this.profileToReturn);

  @override
  Future<UserProfileTableData?> getProfile() async => profileToReturn;

  @override
  Future<void> saveProfile(UserProfileTableCompanion entry) async {}

  @override
  Future<void> updateProfile(UserProfileTableCompanion entry) async {}

  @override
  Future<void> deleteProfile() async {}
}

void main() {
  group('SplashScreen Widget Tests', () {
    testWidgets('Renders all splash screen UI components', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            splashInitializationProvider.overrideWith((ref) => Completer<String>().future),
          ],
          child: const MaterialApp(
            home: SplashScreen(),
          ),
        ),
      );

      // Verify Center Fitness Logo exists
      expect(find.byKey(const Key('splash_logo_icon')), findsOneWidget);
      expect(find.byIcon(Icons.fitness_center), findsOneWidget);

      // Verify App Title exists
      expect(find.text(AppStrings.appName), findsOneWidget);

      // Verify Tagline/Subtitle exists
      expect(find.text(AppStrings.splashSubtitle), findsOneWidget);

      // Verify CircularProgressIndicator exists
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('Navigates to onboarding when user profile is null after 3s', (WidgetTester tester) async {
      // Create a local GoRouter for test isolation
      final router = GoRouter(
        initialLocation: AppRoutes.splash,
        routes: [
          GoRoute(
            path: AppRoutes.splash,
            builder: (context, state) => const SplashScreen(),
          ),
          GoRoute(
            path: AppRoutes.onboarding,
            builder: (context, state) => const Scaffold(body: Text('Onboarding Screen')),
          ),
          GoRoute(
            path: AppRoutes.dashboard,
            builder: (context, state) => const Scaffold(body: Text('Dashboard Screen')),
          ),
        ],
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            profileRepositoryProvider.overrideWithValue(FakeProfileRepository(null)),
          ],
          child: MaterialApp.router(
            routerConfig: router,
          ),
        ),
      );

      // Verify initial route is Splash
      expect(find.byType(SplashScreen), findsOneWidget);
      expect(find.text('Onboarding Screen'), findsNothing);

      // Advance time by 3 seconds to trigger the delayed navigation
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();

      // Verify navigation redirected to Onboarding Screen
      expect(find.text('Onboarding Screen'), findsOneWidget);
      expect(find.byType(SplashScreen), findsNothing);
    });

    testWidgets('Navigates to dashboard when user profile exists after 3s', (WidgetTester tester) async {
      final mockProfile = UserProfileTableData(
        id: 1,
        name: 'Adil Test',
        height: 180.0,
        weight: 75.0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        dailyStepGoal: 10000,
      );

      final router = GoRouter(
        initialLocation: AppRoutes.splash,
        routes: [
          GoRoute(
            path: AppRoutes.splash,
            builder: (context, state) => const SplashScreen(),
          ),
          GoRoute(
            path: AppRoutes.onboarding,
            builder: (context, state) => const Scaffold(body: Text('Onboarding Screen')),
          ),
          GoRoute(
            path: AppRoutes.dashboard,
            builder: (context, state) => const Scaffold(body: Text('Dashboard Screen')),
          ),
        ],
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            profileRepositoryProvider.overrideWithValue(FakeProfileRepository(mockProfile)),
          ],
          child: MaterialApp.router(
            routerConfig: router,
          ),
        ),
      );

      // Verify initial screen is splash
      expect(find.byType(SplashScreen), findsOneWidget);
      expect(find.text('Dashboard Screen'), findsNothing);

      // Advance time by 3 seconds
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();

      // Verify navigation redirected to Dashboard Screen
      expect(find.text('Dashboard Screen'), findsOneWidget);
      expect(find.byType(SplashScreen), findsNothing);
    });
  });
}
