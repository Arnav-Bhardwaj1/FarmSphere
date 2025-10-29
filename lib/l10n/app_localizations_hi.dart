// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'FarmSphere';

  @override
  String get tagline => 'एआई-संचालित कृषि सहायक';

  @override
  String get welcomeTitle => 'फार्मस्फेयर में आपका स्वागत है';

  @override
  String get welcomeSubtitle => 'आपका एआई-संचालित खेती साथी';

  @override
  String get fullName => 'पूरा नाम';

  @override
  String get email => 'ईमेल';

  @override
  String get phoneNumber => 'फोन नंबर';

  @override
  String get location => 'स्थान (शहर, राज्य)';

  @override
  String get locationHint =>
      'स्थान दर्ज करें या नोकिया API डिटेक्शन का उपयोग करें';

  @override
  String get detect => 'डिटेक्ट';

  @override
  String get getStarted => 'शुरू करें';

  @override
  String get verifyPhoneNumber => 'फोन नंबर सत्यापित करें';

  @override
  String get featuresHeading => 'आपको यह मिलेगा:';

  @override
  String get feature_ai_scanner => 'एआई फसल स्वास्थ्य स्कैनर';

  @override
  String get feature_weather => 'मौसम और अलर्ट';

  @override
  String get feature_market => 'बाज़ार मूल्य और योजनाएँ';

  @override
  String get feature_voice_local => 'आवाज़ और स्थानीय भाषा समर्थन';

  @override
  String get feature_activity => 'गतिविधि लॉगिंग और विश्लेषण';

  @override
  String get feature_community => 'किसान समुदाय प्लेटफ़ॉर्म';

  @override
  String get selectLanguage => 'भाषा चुनें';

  @override
  String get chooseLanguageToContinue => 'जारी रखने के लिए अपनी भाषा चुनें';

  @override
  String get rContinue => 'जारी रखें';

  @override
  String changeLanguageSuccess(Object language) {
    return 'भाषा बदलकर $language कर दी गई';
  }

  @override
  String get logout => 'लॉगआउट';

  @override
  String get logoutConfirmTitle => 'लॉगआउट';

  @override
  String get logoutConfirmBody => 'क्या आप वाकई लॉगआउट करना चाहते हैं?';

  @override
  String get ok => 'ठीक है';

  @override
  String get cancel => 'रद्द करें';

  @override
  String get navHome => 'होम';

  @override
  String get navCropHealth => 'फसल स्वास्थ्य';

  @override
  String get navWeather => 'मौसम';

  @override
  String get navMarket => 'बाज़ार';

  @override
  String get navActivities => 'गतिविधियाँ';

  @override
  String get navCommunity => 'समुदाय';

  @override
  String get navProfile => 'प्रोफ़ाइल';

  @override
  String get chatbotTitle => 'FarmSphere एआई सहायक';

  @override
  String get chatbotHint => 'खेती से जुड़ा प्रश्न पूछें...';
}
