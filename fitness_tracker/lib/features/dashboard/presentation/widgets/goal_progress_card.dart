import 'package:flutter/material.dart';
import 'package:fitness_tracker/core/constants/app_strings.dart';

/// Card displaying the circular progress indicator for the daily step goal.
class GoalProgressCard extends StatelessWidget {
  const GoalProgressCard({
    super.key,
    required this.currentSteps,
    required this.goalSteps,
    required this.progress,
    required this.remainingSteps,
    required this.isGoalComplete,
  });

  final int currentSteps;
  final int goalSteps;
  final double progress;
  final int remainingSteps;
  final bool isGoalComplete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final progressColor = isGoalComplete ? Colors.amber : primary;

    return Semantics(
      label:
          '${AppStrings.dashboardDailyGoal}: $currentSteps of $goalSteps steps',
      child: Card(
        key: const Key('goal_progress_card'),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: theme.colorScheme.outline.withAlpha(50)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              // Circular progress
              SizedBox(
                width: 90,
                height: 90,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 90,
                      height: 90,
                      child: CircularProgressIndicator(
                        value: progress,
                        strokeWidth: 8,
                        backgroundColor: theme.colorScheme.outline.withAlpha(
                          40,
                        ),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          progressColor,
                        ),
                        strokeCap: StrokeCap.round,
                      ),
                    ),
                    Text(
                      '${(progress * 100).toStringAsFixed(0)}%',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: progressColor,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              // Text info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.dashboardDailyGoal,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withAlpha(150),
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatNumber(currentSteps),
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: theme.colorScheme.onSurface,
                        letterSpacing: -1,
                      ),
                    ),
                    Text(
                      'of ${_formatNumber(goalSteps)} steps',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withAlpha(150),
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (isGoalComplete)
                      _GoalBadge(label: AppStrings.dashboardGoalComplete)
                    else
                      Text(
                        '${_formatNumber(remainingSteps)} ${AppStrings.dashboardStepsRemaining}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: progressColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatNumber(int n) {
    if (n >= 1000) {
      return '${(n / 1000).toStringAsFixed(n % 1000 == 0 ? 0 : 1)}k';
    }
    return n.toString();
  }
}

class _GoalBadge extends StatelessWidget {
  const _GoalBadge({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.amber.withAlpha(40),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.amber.withAlpha(100)),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Colors.amber.shade800,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
