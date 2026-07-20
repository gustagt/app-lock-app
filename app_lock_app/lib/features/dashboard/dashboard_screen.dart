import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_shadows.dart';
import '../../app/theme/app_spacing.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          children: [
            const SizedBox(height: AppSpacing.sm),
            const _GreetingSection(),
            const SizedBox(height: AppSpacing.lg),
            const _FocusHeroCard(),
            const SizedBox(height: AppSpacing.lg),
            const _FocusModeToggle(),
            const SizedBox(height: AppSpacing.lg),
            const _SectionHeader(
              title: 'Apps bloqueados',
              count: 3,
            ),
            const SizedBox(height: AppSpacing.sm),
            const _BlockedAppCard(
              appIcon: Icons.camera_alt_outlined,
              appName: 'Instagram',
              timeRemaining: 'Restam 45 min',
              isActive: true,
            ),
            const SizedBox(height: AppSpacing.sm),
            const _BlockedAppCard(
              appIcon: Icons.music_note_outlined,
              appName: 'TikTok',
              timeRemaining: 'Restam 1h 20min',
              isActive: true,
            ),
            const SizedBox(height: AppSpacing.sm),
            const _BlockedAppCard(
              appIcon: Icons.play_circle_outline,
              appName: 'YouTube',
              timeRemaining: 'Bloqueado total',
              isActive: false,
            ),
            const SizedBox(height: AppSpacing.lg),
            const _AddAppButton(),
            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
      bottomNavigationBar: const _AppBottomNav(),
    );
  }
}

class _GreetingSection extends StatelessWidget {
  const _GreetingSection();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 22,
          backgroundColor: AppColors.primary.withValues(alpha: 0.15),
          child: Text(
            'G',
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
                'Olá, Gustavo',
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

class _FocusHeroCard extends StatelessWidget {
  const _FocusHeroCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppSpacing.lg),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.08),
        ),
        boxShadow: AppShadows.medium(AppColors.primary),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.xs),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppSpacing.sm),
                ),
                child: Icon(
                  Icons.timer_outlined,
                  color: AppColors.primary,
                  size: 22,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Tempo de foco',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '2h 34min',
                style: Theme.of(context).textTheme.displayLarge,
              ),
              const SizedBox(width: AppSpacing.xs),
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.xxs),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xs,
                    vertical: AppSpacing.xxs,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(AppSpacing.xxs),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.arrow_upward_rounded,
                        size: 12,
                        color: AppColors.success,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        '12%',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.success,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSpacing.xxs),
            child: LinearProgressIndicator(
              value: 0.76,
              backgroundColor: AppColors.primary.withValues(alpha: 0.12),
              valueColor: const AlwaysStoppedAnimation(AppColors.primary),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            '76% da meta diária',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textCaption,
                ),
          ),
        ],
      ),
    );
  }
}

class _FocusModeToggle extends StatelessWidget {
  const _FocusModeToggle();

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
          color: AppColors.primary.withValues(alpha: 0.08),
        ),
        boxShadow: AppShadows.small(AppColors.primary),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.xxs),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppSpacing.xs),
            ),
            child: Icon(
              Icons.shield_outlined,
              color: AppColors.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Modo Foco',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  'Ativo',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.success,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
          ),
          Switch(
            value: true,
            onChanged: (v) {},
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final int count;

  const _SectionHeader({
    required this.title,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(width: AppSpacing.xs),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xs,
            vertical: AppSpacing.xxs,
          ),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppSpacing.xxs),
          ),
          child: Text(
            '$count',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
      ],
    );
  }
}

class _BlockedAppCard extends StatelessWidget {
  final IconData appIcon;
  final String appName;
  final String timeRemaining;
  final bool isActive;

  const _BlockedAppCard({
    required this.appIcon,
    required this.appName,
    required this.timeRemaining,
    required this.isActive,
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
                        color: isActive
                            ? AppColors.textSecondary
                            : AppColors.error,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ],
            ),
          ),
          Icon(
            isActive ? Icons.lock_outline : Icons.lock_open_outlined,
            color: isActive ? AppColors.primary : AppColors.textCaption,
            size: 20,
          ),
        ],
      ),
    );
  }
}

class _AddAppButton extends StatelessWidget {
  const _AddAppButton();

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () {},
      icon: const Icon(Icons.add_rounded, size: 20),
      label: const Text('Adicionar app'),
    );
  }
}

class _AppBottomNav extends StatelessWidget {
  const _AppBottomNav();

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: 0,
      onTap: (index) {},
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.grid_view_rounded),
          activeIcon: Icon(Icons.grid_view_rounded),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.trending_up_rounded),
          activeIcon: Icon(Icons.trending_up_rounded),
          label: 'Estatísticas',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings_outlined),
          activeIcon: Icon(Icons.settings_rounded),
          label: 'Ajustes',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person_rounded),
          label: 'Perfil',
        ),
      ],
    );
  }
}
