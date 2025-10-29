import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/app_providers.dart';
import 'package:farmsphere/l10n/app_localizations.dart';
import '../../widgets/profile_option_tile.dart';

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
        title: Text('Profile'),
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
                      userState.name ?? 'Farmer',
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
                        userState.location ?? 'Location not set',
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
              title: 'Edit Profile',
              subtitle: 'Update your personal information',
              onTap: () {
                _showEditProfileDialog();
              },
            ),
            
            ProfileOptionTile(
              icon: Icons.notifications_outlined,
              title: 'Notifications',
              subtitle: 'Manage your notification preferences',
              onTap: () {
                _showNotificationsDialog();
              },
            ),
            
            ProfileOptionTile(
              icon: Icons.language,
              title: t.selectLanguage,
              subtitle: 'Current: ${_getLanguageName(appState.selectedLanguage)}',
              onTap: () {
                _showLanguageDialog();
              },
            ),
            
            ProfileOptionTile(
              icon: appState.isDarkMode ? Icons.dark_mode : Icons.light_mode,
              title: 'Theme',
              subtitle: appState.isDarkMode ? 'Dark Mode' : 'Light Mode',
              onTap: () {
                ref.read(appStateProvider.notifier).toggleDarkMode();
              },
            ),
            
            ProfileOptionTile(
              icon: Icons.help_outline,
              title: 'Help & Support',
              subtitle: 'Get help and contact support',
              onTap: () {
                _showHelpDialog();
              },
            ),
            
            ProfileOptionTile(
              icon: Icons.info_outline,
              title: 'About',
              subtitle: 'App version and information',
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
              'FarmSphere v1.0.0',
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

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Settings'),
        content: const Text('Settings functionality will be available soon.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showEditProfileDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Profile'),
        content: const Text('Profile editing functionality will be available soon.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showNotificationsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Notifications'),
        content: const Text('Notification settings will be available soon.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog() {
    final languages = const [
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
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: languages.map((lang) {
            return ListTile(
              title: Text(lang['name']!),
              onTap: () {
                ref.read(appStateProvider.notifier).setLanguage(lang['code']!);
                Navigator.of(context).pop();
                final t = AppLocalizations.of(context)!;
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(t.changeLanguageSuccess(lang['name']!)),
                  backgroundColor: Colors.green,
                ));
              },
            );
          }).toList(),
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
        title: const Text('Help & Support'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('For support, please contact:'),
            SizedBox(height: 8),
            Text('Email: support@farmsphere.com'),
            Text('Phone: +91 9876543210'),
            SizedBox(height: 16),
            Text('Or visit our website: www.farmsphere.com'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog() {
    showAboutDialog(
      context: context,
      applicationName: 'FarmSphere',
      applicationVersion: '1.0.0',
      applicationIcon: Icon(
        Icons.agriculture,
        size: 48,
        color: Theme.of(context).colorScheme.primary,
      ),
      children: [
        const Text('An AI-Powered Farming Assistant'),
        const SizedBox(height: 16),
        const Text('Features:'),
        const Text('• AI Crop Health Scanner'),
        const Text('• Weather & Alerts'),
        const Text('• Market Prices & Schemes'),
        const Text('• Voice & Local Language Support'),
        const Text('• Activity Logging & Analytics'),
        const Text('• Farmer Community Platform'),
      ],
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ref.read(userProvider.notifier).logout();
              Navigator.of(context).pushReplacementNamed('/login');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}

