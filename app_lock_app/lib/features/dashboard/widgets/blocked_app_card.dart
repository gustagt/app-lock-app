import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';

class BlockedAppCard extends StatelessWidget {
  final IconData appIcon;
  final String appName;
  final String timeRemaining;
  final bool isBlocked;

  const BlockedAppCard({
    super.key,
    required this.appIcon,
    required this.appName,
    required this.timeRemaining,
    this.isBlocked = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppSpacing.md),
        border: Border.all(
          color: AppColors.textPrimary.withValues(alpha: 0.06),
        ),
        boxShadow: AppShadows.small(AppColors.textPrimary),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.xs),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(AppSpacing.sm),
            ),
            child: Icon(
              appIcon,
              color: AppColors.primary,
              size: 22,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  appName,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  timeRemaining,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isBlocked
                            ? AppColors.textSecondary
                            : AppColors.error,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ],
            ),
          ),
          Icon(
            isBlocked ? Icons.lock_outline : Icons.lock_open_outlined,
            color: isBlocked ? AppColors.primary : AppColors.textCaption,
            size: 20,
          ),
        ],
      ),
    );
  }
}
