// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Tamil (`ta`).
class AppLocalizationsTa extends AppLocalizations {
  AppLocalizationsTa([String locale = 'ta']) : super(locale);

  @override
  String get appTitle => 'FarmSphere';

  @override
  String get tagline => 'ஏஐ சார்ந்த விவசாய உதவியாளர்';

  @override
  String get welcomeTitle => 'FarmSphere-க்கு வரவேற்பு';

  @override
  String get welcomeSubtitle => 'உங்கள் ஏஐ விவசாய துணை';

  @override
  String get fullName => 'முழு பெயர்';

  @override
  String get email => 'மின்னஞ்சல்';

  @override
  String get phoneNumber => 'தொலைபேசி எண்';

  @override
  String get location => 'இடம் (நகரம், மாநிலம்)';

  @override
  String get locationHint =>
      'இருப்பிடத்தை உள்ளிடவும் அல்லது Nokia API கண்டறிதலை பயன்படுத்தவும்';

  @override
  String get detect => 'கண்டறி';

  @override
  String get getStarted => 'தொடங்கவும்';

  @override
  String get verifyPhoneNumber => 'தொலைபேசி எண்ணை சரிபார்க்கவும்';

  @override
  String get featuresHeading => 'நீங்கள் பெறுவது:';

  @override
  String get feature_ai_scanner => 'ஏஐ பயிர் ஆரோக்கிய ஸ்கேனர்';

  @override
  String get feature_weather => 'வானிலை மற்றும் எச்சரிக்கைகள்';

  @override
  String get feature_market => 'சந்தை விலை மற்றும் திட்டங்கள்';

  @override
  String get feature_voice_local => 'குரல் மற்றும் உள்ளூர் மொழி ஆதரவு';

  @override
  String get feature_activity => 'செயல்பாட்டு பதிவு மற்றும் பகுப்பாய்வு';

  @override
  String get feature_community => 'விவசாயிகள் சமூகம்';

  @override
  String get selectLanguage => 'மொழியைத் தேர்ந்தெடுக்கவும்';

  @override
  String get chooseLanguageToContinue =>
      'தொடர உங்கள் மொழியைத் தேர்ந்தெடுக்கவும்';

  @override
  String get rContinue => 'தொடரவும்';

  @override
  String changeLanguageSuccess(Object language) {
    return 'மொழி $language ஆக மாற்றப்பட்டது';
  }

  @override
  String get logout => 'லாக்அவுட்';

  @override
  String get logoutConfirmTitle => 'லாக்அவுட்';

  @override
  String get logoutConfirmBody =>
      'நீங்கள் நிச்சயமாக வெளியேற விரும்புகிறீர்களா?';

  @override
  String get ok => 'சரி';

  @override
  String get cancel => 'ரத்து';

  @override
  String get navHome => 'முகப்பு';

  @override
  String get navCropHealth => 'பயிர் ஆரோக்கியம்';

  @override
  String get navWeather => 'வானிலை';

  @override
  String get navMarket => 'சந்தை';

  @override
  String get navActivities => 'செயல்பாடுகள்';

  @override
  String get navCommunity => 'சமூகம்';

  @override
  String get navProfile => 'சுயவிவரம்';

  @override
  String get chatbotTitle => 'FarmSphere ஏஐ உதவியாளர்';

  @override
  String get chatbotHint => 'விவசாயம் குறித்து கேளுங்கள்...';
}
