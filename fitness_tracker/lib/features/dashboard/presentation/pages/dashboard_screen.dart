import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitness_tracker/core/constants/app_strings.dart';
import 'package:fitness_tracker/features/dashboard/presentation/providers/dashboard_provider.dart';
import 'package:fitness_tracker/features/dashboard/presentation/widgets/stat_card.dart';
import 'package:fitness_tracker/features/dashboard/presentation/widgets/goal_progress_card.dart';
import 'package:fitness_tracker/features/dashboard/presentation/widgets/activity_list_tile.dart';
import 'package:fitness_tracker/features/dashboard/presentation/widgets/quick_actions_bar.dart';

/// Main dashboard / home screen.
///
/// Reads [dashboardStatsProvider] and assembles:
///   – time-of-day greeting header
///   – 2×2 stat cards grid
///   – daily goal progress card
///   – today's activities list
///   – quick-action buttons
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(dashboardStatsProvider);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(dashboardStatsProvider),
        child: statsAsync.when(
          loading: () => const _LoadingBody(),
          error: (e, _) => _ErrorBody(error: e.toString()),
          data: (stats) => _DashboardBody(stats: stats),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Loading state
// ---------------------------------------------------------------------------
class _LoadingBody extends StatelessWidget {
  const _LoadingBody();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Loading your stats…'),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Error state
// ---------------------------------------------------------------------------
class _ErrorBody extends StatelessWidget {
  const _ErrorBody({required this.error});
  final String error;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 56,
              color: theme.colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Failed to load dashboard',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Loaded body
// ---------------------------------------------------------------------------
class _DashboardBody extends StatelessWidget {
  const _DashboardBody({required this.stats});
  final DashboardStats stats;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final now = DateTime.now();
    final greeting = _greeting(now.hour);

    return CustomScrollView(
      key: const Key('dashboard_scroll_view'),
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        // ---- App Bar ----
        SliverAppBar(
          expandedHeight: 130,
          floating: true,
          snap: true,
          pinned: false,
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: theme.colorScheme.onPrimary,
          flexibleSpace: FlexibleSpaceBar(
            background: Padding(
              padding: const EdgeInsets.fromLTRB(20, 52, 20, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    greeting,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onPrimary.withAlpha(200),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    AppStrings.dashboardTitle,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: theme.colorScheme.onPrimary,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            IconButton(
              key: const Key('dashboard_refresh_btn'),
              onPressed: () {},
              icon: const Icon(Icons.notifications_none_rounded),
              tooltip: 'Notifications',
            ),
          ],
        ),

        // ---- Body padding ----
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              // ---- Stats Grid ----
              GridView.count(
                key: const Key('stats_grid'),
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.3,
                children: [
                  StatCard(
                    key: const Key('stat_steps'),
                    label: AppStrings.dashboardSteps,
                    value: _formatNumber(stats.totalSteps),
                    unit: 'steps',
                    icon: Icons.directions_walk_rounded,
                    color: const Color(0xFF1565C0),
                  ),
                  StatCard(
                    key: const Key('stat_calories'),
                    label: AppStrings.dashboardCalories,
                    value: stats.totalCalories.toString(),
                    unit: 'kcal',
                    icon: Icons.local_fire_department_rounded,
                    color: const Color(0xFFE65100),
                  ),
                  StatCard(
                    key: const Key('stat_distance'),
                    label: AppStrings.dashboardDistance,
                    value: stats.totalDistanceKm.toString(),
                    unit: 'km',
                    icon: Icons.route_rounded,
                    color: const Color(0xFF2E7D32),
                  ),
                  StatCard(
                    key: const Key('stat_active_min'),
                    label: AppStrings.dashboardActiveMinutes,
                    value: stats.totalActiveMinutes.toString(),
                    unit: 'min',
                    icon: Icons.timer_rounded,
                    color: const Color(0xFF6A1B9A),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // ---- Goal Progress ----
              GoalProgressCard(
                currentSteps: stats.totalSteps,
                goalSteps: stats.dailyStepGoal,
                progress: stats.goalProgress,
                remainingSteps: stats.remainingSteps,
                isGoalComplete: stats.isGoalComplete,
              ),

              const SizedBox(height: 20),

              // ---- Quick Actions ----
              const QuickActionsBar(key: Key('quick_actions_bar')),

              const SizedBox(height: 24),

              // ---- Today's Activities Header ----
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppStrings.dashboardTodaysActivities,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    '${stats.activities.length} logged',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withAlpha(150),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // ---- Activities List or Empty State ----
              if (stats.activities.isEmpty)
                _EmptyActivitiesState()
              else
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                      color: theme.colorScheme.outline.withAlpha(50),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: ListView.separated(
                      key: const Key('activities_list'),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: stats.activities.length,
                      separatorBuilder: (context, _) => Divider(
                        height: 1,
                        color: theme.colorScheme.outline.withAlpha(40),
                      ),
                      itemBuilder: (context, index) =>
                          ActivityListTile(activity: stats.activities[index]),
                    ),
                  ),
                ),
            ]),
          ),
        ),
      ],
    );
  }

  static String _formatNumber(int n) {
    if (n >= 1000) {
      return '${(n / 1000).toStringAsFixed(n % 1000 == 0 ? 0 : 1)}k';
    }
    return n.toString();
  }

  static String _greeting(int hour) {
    if (hour < 12) return AppStrings.dashboardGreetingMorning;
    if (hour < 17) return AppStrings.dashboardGreetingAfternoon;
    return AppStrings.dashboardGreetingEvening;
  }
}

// ---------------------------------------------------------------------------
// Empty state
// ---------------------------------------------------------------------------
class _EmptyActivitiesState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Semantics(
      label: AppStrings.dashboardNoActivities,
      child: Container(
        key: const Key('empty_activities_state'),
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          children: [
            Icon(
              Icons.fitness_center_rounded,
              size: 56,
              color: theme.colorScheme.primary.withAlpha(80),
            ),
            const SizedBox(height: 16),
            Text(
              AppStrings.dashboardNoActivities,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.onSurface.withAlpha(170),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              AppStrings.dashboardNoActivitiesSubtitle,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withAlpha(120),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
