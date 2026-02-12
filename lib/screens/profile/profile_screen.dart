import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/app_providers.dart';
import 'package:farmsphere/l10n/app_localizations.dart';
import '../../widgets/profile_option_tile.dart';
import '../auth/login_screen.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userProvider);
    final appState = ref.watch(appStateProvider);
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(t.profile),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              _showSettingsDialog();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile Header
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                      child: Text(
                        userState.name?.substring(0, 1).toUpperCase() ?? 'F',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      userState.name ?? t.profile,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      userState.email ?? '',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        userState.location ?? t.location,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Profile Options
            ProfileOptionTile(
              icon: Icons.person_outline,
              title: t.editProfile,
              subtitle: t.updatePersonalInfo,
              onTap: () {
                _showEditProfileDialog();
              },
            ),
            
            ProfileOptionTile(
              icon: Icons.notifications_outlined,
              title: t.notifications,
              subtitle: t.manageNotifications,
              onTap: () {
                _showNotificationsDialog();
              },
            ),
            
            ProfileOptionTile(
              icon: Icons.smart_toy,
              title: 'AI Agents',
              subtitle: 'Manage your AI farming assistants',
              onTap: () {
                Navigator.pushNamed(context, '/agent-settings');
              },
            ),
            
            ProfileOptionTile(
              icon: Icons.language,
              title: t.selectLanguage,
              subtitle: '${t.language}: ${_getLanguageNameLocalized(context, appState.selectedLanguage)}',
              onTap: () {
                _showLanguageDialog();
              },
            ),
            
            ProfileOptionTile(
              icon: appState.isDarkMode ? Icons.dark_mode : Icons.light_mode,
              title: t.theme,
              subtitle: appState.isDarkMode ? t.darkMode : t.lightMode,
              onTap: () {
                ref.read(appStateProvider.notifier).toggleDarkMode();
              },
            ),
            
            ProfileOptionTile(
              icon: Icons.help_outline,
              title: t.helpSupport,
              subtitle: t.getHelp,
              onTap: () {
                _showHelpDialog();
              },
            ),
            
            ProfileOptionTile(
              icon: Icons.info_outline,
              title: t.about,
              subtitle: t.appVersion,
              onTap: () {
                _showAboutDialog();
              },
            ),
            
            const SizedBox(height: 24),
            
            // Logout Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  _showLogoutDialog();
                },
                icon: const Icon(Icons.logout),
                label: Text(t.logout),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // App Info
            Text(
              '${t.appTitle} v1.0.0',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getLanguageName(String languageCode) {
    switch (languageCode) {
      case 'en':
        return 'English';
      case 'hi':
        return 'Hindi';
      case 'te':
        return 'Telugu';
      case 'ta':
        return 'Tamil';
      default:
        return 'English';
    }
  }

  String _getLanguageNameLocalized(BuildContext context, String code) {
    switch (code) {
      case 'en':
        return 'English';
      case 'hi':
        return 'हिन्दी';
      case 'ta':
        return 'தமிழ்';
      case 'te':
        return 'తెలుగు';
      case 'bn':
        return 'বাংলা';
      case 'mr':
        return 'मराठी';
      default:
        return _getLanguageName(code);
    }
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.settings),
        content: Text(AppLocalizations.of(context)!.settingsComingSoon),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppLocalizations.of(context)!.ok),
          ),
        ],
      ),
    );
  }

  void _showEditProfileDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.editProfile),
        content: Text(AppLocalizations.of(context)!.editProfileComingSoon),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppLocalizations.of(context)!.ok),
          ),
        ],
      ),
    );
  }

  void _showNotificationsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.notifications),
        content: Text(AppLocalizations.of(context)!.notificationsComingSoon),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppLocalizations.of(context)!.ok),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog() {
    const languages = [
      {'code': 'en', 'name': 'English'},
      {'code': 'hi', 'name': 'हिन्दी'},
      {'code': 'bn', 'name': 'বাংলা'},
      {'code': 'mr', 'name': 'मराठी'},
      {'code': 'ta', 'name': 'தமிழ்'},
      {'code': 'te', 'name': 'తెలుగు'},
      {'code': 'gu', 'name': 'ગુજરાતી'},
      {'code': 'ur', 'name': 'اردو'},
      {'code': 'kn', 'name': 'ಕನ್ನಡ'},
      {'code': 'ml', 'name': 'മലയാളം'},
      {'code': 'pa', 'name': 'ਪੰਜਾਬੀ'},
      {'code': 'as', 'name': 'অসমীয়া'},
      {'code': 'brx', 'name': 'बोड़ो'},
      {'code': 'doi', 'name': 'डोगरी'},
      {'code': 'ks', 'name': 'कश्मीरी'},
      {'code': 'kok', 'name': 'कोंकणी'},
      {'code': 'mai', 'name': 'मैथिली'},
      {'code': 'mni', 'name': 'মৈতৈলোন'},
      {'code': 'ne', 'name': 'नेपाली'},
      {'code': 'or', 'name': 'ଓଡ଼ିଆ'},
      {'code': 'sa', 'name': 'संस्कृतम्'},
      {'code': 'sat', 'name': 'ᱥᱟᱱᱛᱟᱲᱤ'},
      {'code': 'sd', 'name': 'سنڌي'},
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.selectLanguage),
        content: SizedBox(
          width: double.maxFinite,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.6,
            ),
            child: Scrollbar(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: languages.length,
                itemBuilder: (context, index) {
                  final lang = languages[index];
                  return ListTile(
                    title: Text(lang['name']!),
                    onTap: () async {
                      await ref.read(appStateProvider.notifier).setLanguage(lang['code']!);
                      if (context.mounted) {
                        Navigator.of(context).pop();
                        // Note: MaterialApp will rebuild automatically due to the key we set in main.dart
                        // The app UI will update to reflect the new language
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Language changed to ${lang['name']}'),
                          backgroundColor: Colors.green,
                        ));
                      }
                    },
                  );
                },
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.helpSupport),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppLocalizations.of(context)!.helpContent),
            const SizedBox(height: 8),
            Text(AppLocalizations.of(context)!.helpEmail),
            Text(AppLocalizations.of(context)!.helpPhone),
            const SizedBox(height: 16),
            Text(AppLocalizations.of(context)!.helpWebsite),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppLocalizations.of(context)!.ok),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog() {
    showAboutDialog(
      context: context,
      applicationName: AppLocalizations.of(context)!.appTitle,
      applicationVersion: '1.0.0',
      applicationIcon: Icon(
        Icons.agriculture,
        size: 48,
        color: Theme.of(context).colorScheme.primary,
      ),
      children: [
        Text(AppLocalizations.of(context)!.aboutContent),
        const SizedBox(height: 16),
        Text(AppLocalizations.of(context)!.aboutFeatures),
        Text('• ${AppLocalizations.of(context)!.feature_ai_scanner}'),
        Text('• ${AppLocalizations.of(context)!.feature_weather}'),
        Text('• ${AppLocalizations.of(context)!.feature_market}'),
        Text('• ${AppLocalizations.of(context)!.feature_voice_local}'),
        Text('• ${AppLocalizations.of(context)!.feature_activity}'),
        Text('• ${AppLocalizations.of(context)!.feature_community}'),
      ],
    );
  }

  void _showLogoutDialog() {
    final t = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(t.logoutConfirmTitle),
        content: Text(t.logoutConfirmBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(t.cancel),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await ref.read(userProvider.notifier).logout();
              if (context.mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text(t.logout),
          ),
        ],
      ),
    );
  }
}

