// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Panjabi Punjabi (`pa`).
class AppLocalizationsPa extends AppLocalizations {
  AppLocalizationsPa([String locale = 'pa']) : super(locale);

  @override
  String get appTitle => 'FarmSphere';

  @override
  String get tagline => 'ਏਆਈ ਅਧਾਰਿਤ ਖੇਤੀ ਸਹਾਇਕ';

  @override
  String get welcomeTitle => 'FarmSphere ਵਿੱਚ ਸੁਆਗਤ ਹੈ';

  @override
  String get welcomeSubtitle => 'ਤੁਹਾਡਾ ਏਆਈ ਖੇਤੀ ਸਾਥੀ';

  @override
  String get fullName => 'ਪੂਰਾ ਨਾਮ';

  @override
  String get email => 'ਈਮੇਲ';

  @override
  String get phoneNumber => 'ਫ਼ੋਨ ਨੰਬਰ';

  @override
  String get location => 'ਟਿਕਾਣਾ (ਸ਼ਹਿਰ, ਰਾਜ)';

  @override
  String get locationHint => 'ਟਿਕਾਣਾ ਦਰਜ ਕਰੋ ਜਾਂ Nokia API ਡਿਟੈਕਸ਼ਨ ਵਰਤੋ';

  @override
  String get detect => 'ਖੋਜੋ';

  @override
  String get getStarted => 'ਸ਼ੁਰੂ ਕਰੋ';

  @override
  String get verifyPhoneNumber => 'ਫ਼ੋਨ ਨੰਬਰ ਦੀ ਪੁਸ਼ਟੀ ਕਰੋ';

  @override
  String get featuresHeading => 'ਤੁਹਾਨੂੰ ਕੀ ਮਿਲੇਗਾ:';

  @override
  String get feature_ai_scanner => 'ਏਆਈ ਫ਼ਸਲ ਸਿਹਤ ਸਕੈਨਰ';

  @override
  String get feature_weather => 'ਮੌਸਮ ਅਤੇ ਚੇਤਾਵਨੀਆਂ';

  @override
  String get feature_market => 'ਬਾਜ਼ਾਰ ਕੀਮਤਾਂ ਅਤੇ ਯੋਜਨਾਵਾਂ';

  @override
  String get feature_voice_local => 'ਆਵਾਜ਼ ਅਤੇ ਸਥਾਨਕ ਭਾਸ਼ਾ ਸਹਿਯੋਗ';

  @override
  String get feature_activity => 'ਗਤੀਵਿਧੀ ਲਾਗਿੰਗ ਅਤੇ ਵਿਸ਼ਲੇਸ਼ਣ';

  @override
  String get feature_community => 'ਕਿਸਾਨ ਕਮਿਉਨਿਟੀ ਪਲੇਟਫ਼ਾਰਮ';

  @override
  String get selectLanguage => 'ਭਾਸ਼ਾ ਚੁਣੋ';

  @override
  String get chooseLanguageToContinue => 'ਜਾਰੀ ਰੱਖਣ ਲਈ ਆਪਣੀ ਭਾਸ਼ਾ ਚੁਣੋ';

  @override
  String get rContinue => 'ਜਾਰੀ ਰੱਖੋ';

  @override
  String changeLanguageSuccess(Object language) {
    return 'ਭਾਸ਼ਾ $language ਵਿੱਚ ਬਦਲ ਗਈ';
  }

  @override
  String get logout => 'ਲਾਗਆਉਟ';

  @override
  String get logoutConfirmTitle => 'ਲਾਗਆਉਟ';

  @override
  String get logoutConfirmBody => 'ਕੀ ਤੁਸੀਂ ਯਕੀਨਨ ਲਾਗਆਉਟ ਕਰਨਾ ਚਾਹੁੰਦੇ ਹੋ?';

  @override
  String get ok => 'ਠੀਕ ਹੈ';

  @override
  String get cancel => 'ਰੱਦ ਕਰੋ';

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
