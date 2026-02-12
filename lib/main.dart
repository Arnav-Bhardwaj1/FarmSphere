import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:farmsphere/l10n/app_localizations.dart';
import 'screens/splash_screen.dart';
import 'screens/agents/agent_dashboard_screen.dart';
import 'screens/agents/agent_settings_screen.dart';
import 'theme/app_theme.dart';
import 'providers/app_providers.dart';
import 'services/agent_init.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize AI Agent System
  await AgentInit.initialize();
  
  // Set preferred orientations
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  runApp(
    const ProviderScope(
      child: FarmSphereApp(),
    ),
  );
}

class FarmSphereApp extends ConsumerWidget {
  const FarmSphereApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appState = ref.watch(appStateProvider);
    final currentLocale = Locale(appState.selectedLanguage);

    return MaterialApp(
      key: ValueKey(currentLocale.languageCode),
      title: 'FarmSphere',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      locale: currentLocale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const SplashScreen(),
      routes: {
        '/agents': (context) => const AgentDashboardScreen(),
        '/agent-settings': (context) => const AgentSettingsScreen(),
      },
    );
  }
}