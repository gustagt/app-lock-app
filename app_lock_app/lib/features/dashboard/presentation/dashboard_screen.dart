import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_spacing.dart';
import '../data/models/blocked_app_model.dart';
import '../widgets/add_app_button.dart';
import '../widgets/app_bottom_nav.dart';
import '../widgets/blocked_app_card.dart';
import '../widgets/focus_hero_card.dart';
import '../widgets/focus_mode_toggle.dart';
import '../widgets/greeting_section.dart';
import '../widgets/section_header.dart';
import 'controllers/controllers.dart';
import 'placeholder_screens.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserPreferencesNotifier>().load();
      context.read<FocusNotifier>().load();
      context.read<BlockedAppsNotifier>().load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      _buildDashboard(),
      StatsScreen(
        currentIndex: _currentIndex,
        onTabChanged: _onTabChanged,
      ),
      SettingsScreen(
        currentIndex: _currentIndex,
        onTabChanged: _onTabChanged,
      ),
      ProfileScreen(
        currentIndex: _currentIndex,
        onTabChanged: _onTabChanged,
      ),
    ];

    return IndexedStack(
      index: _currentIndex,
      children: pages,
    );
  }

  void _onTabChanged(int index) {
    setState(() => _currentIndex = index);
  }

  Widget _buildDashboard() {
    return Consumer3<UserPreferencesNotifier, FocusNotifier, BlockedAppsNotifier>(
      builder: (context, userPrefs, focus, blockedApps, _) {
        if (userPrefs.isLoading || focus.isLoading || blockedApps.isLoading) {
          return Scaffold(
            body: const Center(child: CircularProgressIndicator()),
            bottomNavigationBar: AppBottomNav(
              currentIndex: _currentIndex,
              onTap: _onTabChanged,
            ),
          );
        }

        if (userPrefs.error != null || userPrefs.prefs == null) {
          return Scaffold(
            body: const Center(child: Text('Erro ao carregar preferências')),
            bottomNavigationBar: AppBottomNav(
              currentIndex: _currentIndex,
              onTap: _onTabChanged,
            ),
          );
        }

        final name = userPrefs.userName!;
        final focusActive = userPrefs.focusModeActive!;
        final goal = userPrefs.dailyGoalMinutes!;

        return Scaffold(
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              children: [
                const SizedBox(height: AppSpacing.sm),
                GreetingSection(name: name),
                const SizedBox(height: AppSpacing.lg),
                FocusHeroCard(
                  time: focus.todayDurationFormatted,
                  progress: focus.progress(goal),
                  percentageChange: focus.percentageChangeFormatted,
                  metaLabel: focus.metaLabel(goal),
                ),
                const SizedBox(height: AppSpacing.lg),
                FocusModeToggle(
                  isActive: focusActive,
                  onChanged: (_) async {
                    final wasActive = focusActive;
                    await userPrefs.toggleFocusMode();
                    if (wasActive) {
                      focus.stopActiveTracking();
                      await focus.loadSilently();
                    } else {
                      await focus.loadSilently();
                      final startedAt =
                          userPrefs.prefs?.focusSessionStartedAt;
                      if (startedAt != null) {
                        focus.startActiveTracking(startedAt);
                      }
                    }
                  },
                ),
                const SizedBox(height: AppSpacing.lg),
                SectionHeader(
                  title: 'Apps bloqueados',
                  count: blockedApps.blockedCount,
                ),
                const SizedBox(height: AppSpacing.sm),
                ...blockedApps.blockedApps.map(
                  (app) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: BlockedAppCard(
                      appIcon: _iconFromCodePoint(app.iconCodePoint),
                      appName: app.appName,
                      timeRemaining: _formatTimeRemaining(app),
                      isBlocked: app.isBlocked,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                AddAppButton(onPressed: () {}),
                const SizedBox(height: AppSpacing.xxl),
              ],
            ),
          ),
          bottomNavigationBar: AppBottomNav(
            currentIndex: _currentIndex,
            onTap: _onTabChanged,
          ),
        );
      },
    );
  }

  static IconData _iconFromCodePoint(int codePoint) =>
      // ignore: non_const_argument_for_const_parameter
      IconData(codePoint);

  String _formatTimeRemaining(BlockedAppModel app) {
    final remainingSeconds =
        app.dailyLimitMinutes * 60 - app.timeUsedTodaySeconds;
    if (remainingSeconds <= 0) return 'Bloqueio expirado';
    final hours = remainingSeconds ~/ 3600;
    final minutes = (remainingSeconds % 3600) ~/ 60;
    if (hours > 0) return 'Restam ${hours}h ${minutes}min';
    return 'Restam ${minutes}min';
  }
}
