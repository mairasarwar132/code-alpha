import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fitness_tracker/core/constants/app_routes.dart';
import 'package:fitness_tracker/core/constants/app_strings.dart';

/// Three quick-action buttons: Add Activity, View History, Edit Profile.
class QuickActionsBar extends StatelessWidget {
  const QuickActionsBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: _QuickActionButton(
            buttonKey: const Key('btn_add_activity'),
            label: AppStrings.dashboardAddActivity,
            icon: Icons.add_circle_rounded,
            isPrimary: true,
            onTap: () => context.push(AppRoutes.addActivity),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _QuickActionButton(
            buttonKey: const Key('btn_view_history'),
            label: AppStrings.dashboardViewHistory,
            icon: Icons.history_rounded,
            isPrimary: false,
            onTap: () => context.push(AppRoutes.history),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _QuickActionButton(
            buttonKey: const Key('btn_edit_profile'),
            label: AppStrings.dashboardEditProfile,
            icon: Icons.person_rounded,
            isPrimary: false,
            onTap: () => context.push(AppRoutes.profile),
          ),
        ),
      ],
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  const _QuickActionButton({
    required this.buttonKey,
    required this.label,
    required this.icon,
    required this.isPrimary,
    required this.onTap,
  });

  final Key buttonKey;
  final String label;
  final IconData icon;
  final bool isPrimary;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    if (isPrimary) {
      return FilledButton.icon(
        key: buttonKey,
        onPressed: onTap,
        icon: Icon(icon, size: 18),
        label: Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      );
    }

    return OutlinedButton(
      key: buttonKey,
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        side: BorderSide(color: primary.withAlpha(120)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20, color: primary),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: primary,
            ),
          ),
        ],
      ),
    );
  }
}
