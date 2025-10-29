// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Santali (`sat`).
class AppLocalizationsSat extends AppLocalizations {
  AppLocalizationsSat([String locale = 'sat']) : super(locale);

  @override
  String get appTitle => 'FarmSphere';

  @override
  String get tagline => 'AI-Powered Farming Assistant';

  @override
  String get welcomeTitle => 'Welcome to FarmSphere';

  @override
  String get welcomeSubtitle => 'Your AI-powered farming companion';

  @override
  String get fullName => 'Full Name';

  @override
  String get email => 'Email';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get location => 'Location (City, State)';

  @override
  String get locationHint => 'Enter location or use Nokia API detection';

  @override
  String get detect => 'Detect';

  @override
  String get getStarted => 'Get Started';

  @override
  String get verifyPhoneNumber => 'Verify phone number';

  @override
  String get featuresHeading => 'What you\'ll get:';

  @override
  String get feature_ai_scanner => 'AI Crop Health Scanner';

  @override
  String get feature_weather => 'Weather & Alerts';

  @override
  String get feature_market => 'Market Prices & Schemes';

  @override
  String get feature_voice_local => 'Voice & Local Language Support';

  @override
  String get feature_activity => 'Activity Logging & Analytics';

  @override
  String get feature_community => 'Farmer Community Platform';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get chooseLanguageToContinue => 'Choose your language to continue';

  @override
  String get rContinue => 'Continue';

  @override
  String changeLanguageSuccess(Object language) {
    return 'Language changed to $language';
  }

  @override
  String get logout => 'Logout';

  @override
  String get logoutConfirmTitle => 'Logout';

  @override
  String get logoutConfirmBody => 'Are you sure you want to logout?';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Cancel';

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
