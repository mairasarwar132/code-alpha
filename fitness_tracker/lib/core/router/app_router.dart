import 'package:go_router/go_router.dart';
import '../widgets/placeholder_screen.dart';
import '../constants/app_routes.dart';
import '../../features/splash/presentation/pages/splash_screen.dart';
import '../../features/onboarding/presentation/pages/onboarding_screen.dart';

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
      builder: (context, state) => const PlaceholderScreen(title: 'Dashboard'),
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
      builder: (context, state) => const PlaceholderScreen(title: 'Profile'),
    ),
    GoRoute(
      path: AppRoutes.addActivity,
      builder: (context, state) => const PlaceholderScreen(title: 'Add Activity'),
    ),
  ],
);
