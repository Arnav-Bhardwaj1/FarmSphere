import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:farmsphere/l10n/app_localizations.dart';
import '../providers/app_providers.dart';
import 'auth/login_screen.dart';
import 'main_navigation.dart';

class LanguageSelectionScreen extends ConsumerWidget {
  const LanguageSelectionScreen({super.key});

  static const _languages = [
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final selected = ref.watch(appStateProvider).selectedLanguage;

    return Scaffold(
      appBar: AppBar(title: Text(t.selectLanguage)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              t.chooseLanguageToContinue,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: _languages.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final lang = _languages[index];
                final isSelected = selected == lang['code'];
                return ListTile(
                  title: Text(lang['name']!),
                  trailing: isSelected ? const Icon(Icons.check, color: Colors.green) : null,
                  onTap: () {
                    ref.read(appStateProvider.notifier).setLanguage(lang['code']!);
                  },
                );
              },
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    await ref.read(appStateProvider.notifier).setFirstLaunchComplete();
                    // Give MaterialApp time to rebuild with new locale
                    await Future.delayed(const Duration(milliseconds: 100));
                    final userState = ref.read(userProvider);
                    if (context.mounted) {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (_) => userState.isLoggedIn ? const MainNavigation() : const LoginScreen(),
                        ),
                      );
                    }
                  },
                  child: Text(t.rContinue),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


