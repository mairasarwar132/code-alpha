import 'package:go_router/go_router.dart';
import '../widgets/placeholder_screen.dart';
import '../constants/app_routes.dart';
import '../../features/splash/presentation/pages/splash_screen.dart';
import '../../features/onboarding/presentation/pages/onboarding_screen.dart';
import '../../features/profile/presentation/pages/profile_wizard_screen.dart';
import '../../features/dashboard/presentation/pages/dashboard_screen.dart';

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
      builder: (context, state) => const PlaceholderScreen(title: 'History'),
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
      builder: (context, state) => const PlaceholderScreen(title: 'Add Activity'),
    ),
  ],
);
