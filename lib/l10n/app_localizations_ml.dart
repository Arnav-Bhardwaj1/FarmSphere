// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Malayalam (`ml`).
class AppLocalizationsMl extends AppLocalizations {
  AppLocalizationsMl([String locale = 'ml']) : super(locale);

  @override
  String get appTitle => 'FarmSphere';

  @override
  String get tagline => 'എഐ അധിഷ്ഠിത കൃഷി സഹായി';

  @override
  String get welcomeTitle => 'FarmSphere-ലേക്ക് സ്വാഗതം';

  @override
  String get welcomeSubtitle => 'നിങ്ങളുടെ എഐ കൃഷി കൂട്ടായി';

  @override
  String get fullName => 'പൂർണ്ണ പേര്';

  @override
  String get email => 'ഇമെയിൽ';

  @override
  String get phoneNumber => 'ഫോൺ നമ്പർ';

  @override
  String get location => 'സ്ഥാനം (നഗരം, സംസ്ഥാനം)';

  @override
  String get locationHint =>
      'സ്ഥാനം നൽകുക അല്ലെങ്കിൽ Nokia API കണ്ടെത്തൽ ഉപയോഗിക്കുക';

  @override
  String get detect => 'കണ്ടെത്തുക';

  @override
  String get getStarted => 'തുടങ്ങുക';

  @override
  String get verifyPhoneNumber => 'ഫോൺ നമ്പർ സ്ഥിരീകരിക്കുക';

  @override
  String get featuresHeading => 'നിങ്ങൾക്ക് ലഭിക്കുന്നത്:';

  @override
  String get feature_ai_scanner => 'എഐ വിള ആരോഗ്യ സ്കാനർ';

  @override
  String get feature_weather => 'കാലാവസ്ഥയും ജാഗ്രതയും';

  @override
  String get feature_market => 'മാർക്കറ്റ് വിലകളും പദ്ധതികളും';

  @override
  String get feature_voice_local => 'വോയ്സും പ്രാദേശിക ഭാഷാ പിന്തുണയും';

  @override
  String get feature_activity => 'പ്രവർത്തന ലോഗിംഗ് & വിശകലനം';

  @override
  String get feature_community => 'കർഷക സമൂഹ പ്ലാറ്റ്ഫോം';

  @override
  String get selectLanguage => 'ഭാഷ തിരഞ്ഞെടുക്കുക';

  @override
  String get chooseLanguageToContinue => 'തുടരാൻ നിങ്ങളുടെ ഭാഷ തിരഞ്ഞെടുക്കുക';

  @override
  String get rContinue => 'തുടരുക';

  @override
  String changeLanguageSuccess(Object language) {
    return 'ഭാഷ $language ആയി മാറ്റി';
  }

  @override
  String get logout => 'ലോഗ്ഔട്ട്';

  @override
  String get logoutConfirmTitle => 'ലോഗ്ഔട്ട്';

  @override
  String get logoutConfirmBody => 'നിങ്ങൾക്ക് തീർച്ചയായും ലോഗ്ഔട്ട് ചെയ്യണോ?';

  @override
  String get ok => 'ശരി';

  @override
  String get cancel => 'റദ്ദാക്കുക';

  @override
  String get navHome => 'Home';

  @override
  String get navCropHealth => 'Crop Health';

  @override
  String get navWeather => 'Weather';

  @override
  String get navMarket => 'Market';

  @override
  String get navActivities => 'Activities';

  @override
  String get navCommunity => 'Community';

  @override
  String get navProfile => 'Profile';

  @override
  String get chatbotTitle => 'FarmSphere AI Assistant';

  @override
  String get chatbotHint => 'Ask me about farming...';
}
