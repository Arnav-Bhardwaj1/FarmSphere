// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Marathi (`mr`).
class AppLocalizationsMr extends AppLocalizations {
  AppLocalizationsMr([String locale = 'mr']) : super(locale);

  @override
  String get appTitle => 'FarmSphere';

  @override
  String get tagline => 'एआय-संचालित शेती सहाय्यक';

  @override
  String get welcomeTitle => 'FarmSphere मध्ये आपले स्वागत आहे';

  @override
  String get welcomeSubtitle => 'आपला एआय-संचालित शेती साथी';

  @override
  String get fullName => 'पूर्ण नाव';

  @override
  String get email => 'ईमेल';

  @override
  String get phoneNumber => 'फोन नंबर';

  @override
  String get location => 'स्थान (शहर, राज्य)';

  @override
  String get locationHint =>
      'स्थान प्रविष्ट करा किंवा Nokia API डिटेक्शन वापरा';

  @override
  String get detect => 'ओळखा';

  @override
  String get getStarted => 'सुरू करा';

  @override
  String get verifyPhoneNumber => 'फोन नंबर सत्यापित करा';

  @override
  String get featuresHeading => 'आपल्याला मिळेल:';

  @override
  String get feature_ai_scanner => 'एआय पिक स्वास्थ्य स्कॅनर';

  @override
  String get feature_weather => 'हवामान आणि अलर्ट';

  @override
  String get feature_market => 'बाजार भाव आणि योजना';

  @override
  String get feature_voice_local => 'आवाज आणि स्थानिक भाषा समर्थन';

  @override
  String get feature_activity => 'क्रियाकलाप लॉगिंग आणि विश्लेषण';

  @override
  String get feature_community => 'शेतकरी समुदाय प्लॅटफॉर्म';

  @override
  String get selectLanguage => 'भाषा निवडा';

  @override
  String get chooseLanguageToContinue => 'पुढे जाण्यासाठी आपली भाषा निवडा';

  @override
  String get rContinue => 'पुढे';

  @override
  String changeLanguageSuccess(Object language) {
    return 'भाषा $language मध्ये बदलली';
  }

  @override
  String get logout => 'लॉगआउट';

  @override
  String get logoutConfirmTitle => 'लॉगआउट';

  @override
  String get logoutConfirmBody => 'आपण खरोखर लॉगआउट करू इच्छिता?';

  @override
  String get ok => 'ठीक';

  @override
  String get cancel => 'रद्द';

  @override
  String get navHome => 'मुख्यपृष्ठ';

  @override
  String get navCropHealth => 'पीक आरोग्य';

  @override
  String get navWeather => 'हवामान';

  @override
  String get navMarket => 'बाजार';

  @override
  String get navActivities => 'क्रियाकलाप';

  @override
  String get navCommunity => 'समुदाय';

  @override
  String get navProfile => 'प्रोफाइल';

  @override
  String get chatbotTitle => 'FarmSphere एआय सहाय्यक';

  @override
  String get chatbotHint => 'शेतीबद्दल विचारा...';
}
