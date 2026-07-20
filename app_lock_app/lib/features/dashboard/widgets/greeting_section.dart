import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';

class GreetingSection extends StatelessWidget {
  final String name;

  const GreetingSection({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 22,
          backgroundColor: AppColors.primary.withValues(alpha: 0.15),
          child: Text(
            name.characters.first,
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Olá, $name',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Text(
                'Seu foco hoje',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
            ],
          ),
        ),
        IconButton(
          icon: Icon(
            Icons.notifications_outlined,
            color: AppColors.textPrimary.withValues(alpha: 0.6),
          ),
          onPressed: () {},
          tooltip: 'Notificações',
        ),
      ],
    );
  }
}
