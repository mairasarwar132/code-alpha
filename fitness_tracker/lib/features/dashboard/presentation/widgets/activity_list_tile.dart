import 'package:flutter/material.dart';
import 'package:fitness_tracker/core/database/app_database.dart';

/// Activity type → icon mapping.
IconData _iconForType(String type) {
  switch (type.toLowerCase()) {
    case 'running':
      return Icons.directions_run;
    case 'cycling':
      return Icons.directions_bike;
    case 'swimming':
      return Icons.pool;
    case 'walking':
      return Icons.directions_walk;
    case 'gym':
    case 'workout':
      return Icons.fitness_center;
    case 'yoga':
      return Icons.self_improvement;
    case 'hiking':
      return Icons.terrain;
    default:
      return Icons.sports;
  }
}

/// Activity type → color mapping.
Color _colorForType(String type) {
  switch (type.toLowerCase()) {
    case 'running':
      return const Color(0xFF1565C0);
    case 'cycling':
      return const Color(0xFF2E7D32);
    case 'swimming':
      return const Color(0xFF006064);
    case 'walking':
      return const Color(0xFF4CAF50);
    case 'gym':
    case 'workout':
      return const Color(0xFFB71C1C);
    case 'yoga':
      return const Color(0xFF6A1B9A);
    case 'hiking':
      return const Color(0xFF4E342E);
    default:
      return const Color(0xFF37474F);
  }
}

/// A list tile representing a single activity entry.
class ActivityListTile extends StatelessWidget {
  const ActivityListTile({
    super.key,
    required this.activity,
  });

  final ActivitiesTableData activity;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = _colorForType(activity.activityType);
    final icon = _iconForType(activity.activityType);

    return Semantics(
      label:
          '${activity.activityType}: ${activity.duration} minutes, ${activity.calories} calories',
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
        leading: Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: color.withAlpha(30),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withAlpha(60)),
          ),
          child: Icon(icon, color: color, size: 22),
        ),
        title: Text(
          _capitalize(activity.activityType),
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        subtitle: Text(
          '${activity.duration} min  •  ${activity.steps} steps',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withAlpha(150),
          ),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${activity.calories}',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
            Text(
              'kcal',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withAlpha(130),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _capitalize(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1).toLowerCase();
}
