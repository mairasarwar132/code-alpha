import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitness_tracker/core/constants/app_routes.dart';
import 'package:fitness_tracker/core/providers/repository_providers.dart';

/// Provider that runs the splash screen initialization logic.
///
/// It performs a 3-second delay and checks if the user has a profile.
/// Returns the route path to navigate to.
final splashInitializationProvider = FutureProvider.autoDispose<String>((ref) async {
  // 1. Minimum 3-second delay for the splash animation
  final delayFuture = Future.delayed(const Duration(seconds: 3));

  // 2. Query the profile database
  final profileRepository = ref.watch(profileRepositoryProvider);
  final profileFuture = profileRepository.getProfile();

  // Wait for both tasks to complete concurrently
  final results = await Future.wait([
    delayFuture,
    profileFuture,
  ]);
  
  final profile = results[1];

  if (profile == null) {
    // No profile exists, navigate to onboarding
    return AppRoutes.onboarding;
  } else {
    // Profile exists, navigate straight to the dashboard
    return AppRoutes.dashboard;
  }
});
