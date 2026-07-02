import 'package:go_router/go_router.dart';
import '../widgets/placeholder_screen.dart';
import '../constants/app_routes.dart';
import '../../features/splash/presentation/pages/splash_screen.dart';
import '../../features/onboarding/presentation/pages/onboarding_screen.dart';
import '../../features/profile/presentation/pages/profile_wizard_screen.dart';
import '../../features/dashboard/presentation/pages/dashboard_screen.dart';
import '../../features/activity/presentation/pages/activity_form_page.dart';
import '../../features/activity/presentation/pages/activity_history_page.dart';
import '../../features/activity/presentation/pages/activity_details_page.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: AppRoutes.onboarding,
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: AppRoutes.dashboard,
      builder: (context, state) => const DashboardScreen(),
    ),
    GoRoute(
      path: AppRoutes.history,
      builder: (context, state) => const ActivityHistoryPage(),
    ),
    GoRoute(
      path: AppRoutes.statistics,
      builder: (context, state) => const PlaceholderScreen(title: 'Statistics'),
    ),
    GoRoute(
      path: AppRoutes.profile,
      builder: (context, state) => const ProfileWizardScreen(),
    ),
    GoRoute(
      path: AppRoutes.addActivity,
      builder: (context, state) => const ActivityFormPage(),
    ),
    GoRoute(
      path: '${AppRoutes.history}/:id',
      builder: (context, state) {
        final id = int.tryParse(state.pathParameters['id'] ?? '');
        return ActivityDetailsPage(activityId: id ?? 0);
      },
    ),
    GoRoute(
      path: '/edit-activity/:id',
      builder: (context, state) {
        final id = int.tryParse(state.pathParameters['id'] ?? '');
        return ActivityFormPage(activityId: id);
      },
    ),
  ],
);
