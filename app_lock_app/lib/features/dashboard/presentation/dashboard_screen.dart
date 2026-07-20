import 'package:flutter/material.dart';
import '../../../core/theme/app_spacing.dart';
import '../widgets/add_app_button.dart';
import '../widgets/app_bottom_nav.dart';
import '../widgets/blocked_app_card.dart';
import '../widgets/focus_hero_card.dart';
import '../widgets/focus_mode_toggle.dart';
import '../widgets/greeting_section.dart';
import '../widgets/section_header.dart';

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
            const GreetingSection(name: 'Gustavo'),
            const SizedBox(height: AppSpacing.lg),
            const FocusHeroCard(),
            const SizedBox(height: AppSpacing.lg),
            const FocusModeToggle(),
            const SizedBox(height: AppSpacing.lg),
            const SectionHeader(title: 'Apps bloqueados', count: 3),
            const SizedBox(height: AppSpacing.sm),
            const BlockedAppCard(
              appIcon: Icons.camera_alt_outlined,
              appName: 'Instagram',
              timeRemaining: 'Restam 45 min',
              isBlocked: true,
            ),
            const SizedBox(height: AppSpacing.sm),
            const BlockedAppCard(
              appIcon: Icons.music_note_outlined,
              appName: 'TikTok',
              timeRemaining: 'Restam 1h 20min',
              isBlocked: true,
            ),
            const SizedBox(height: AppSpacing.sm),
            const BlockedAppCard(
              appIcon: Icons.play_circle_outline,
              appName: 'YouTube',
              timeRemaining: 'Bloqueio expirado',
              isBlocked: false,
            ),
            const SizedBox(height: AppSpacing.lg),
            const AddAppButton(),
            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
      bottomNavigationBar: const AppBottomNav(),
    );
  }
}
