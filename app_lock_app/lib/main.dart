import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/data/database/database_initializer.dart';
import 'core/theme/app_theme.dart';
import 'features/dashboard/data/repositories/blocked_app_repository.dart';
import 'features/dashboard/data/repositories/focus_repository.dart';
import 'features/dashboard/data/repositories/user_preferences_repository.dart';
import 'features/dashboard/presentation/controllers/controllers.dart';
import 'features/dashboard/presentation/dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseInitializer.init();
  runApp(const AppLockApp());
}

class AppLockApp extends StatelessWidget {
  const AppLockApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<UserPreferencesRepository>(
          create: (_) => UserPreferencesRepository(),
        ),
        Provider<FocusRepository>(
          create: (_) => FocusRepository(),
        ),
        Provider<BlockedAppRepository>(
          create: (_) => BlockedAppRepository(),
        ),
        ChangeNotifierProvider<UserPreferencesNotifier>(
          create: (context) => UserPreferencesNotifier(
            repository: context.read<UserPreferencesRepository>(),
            focusRepository: context.read<FocusRepository>(),
          ),
        ),
        ChangeNotifierProvider<FocusNotifier>(
          create: (context) => FocusNotifier(
            repository: context.read<FocusRepository>(),
          ),
        ),
        ChangeNotifierProvider<BlockedAppsNotifier>(
          create: (context) => BlockedAppsNotifier(
            repository: context.read<BlockedAppRepository>(),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'App Lock',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        home: const DashboardScreen(),
      ),
    );
  }
}
