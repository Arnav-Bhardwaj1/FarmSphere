// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Telugu (`te`).
class AppLocalizationsTe extends AppLocalizations {
  AppLocalizationsTe([String locale = 'te']) : super(locale);

  @override
  String get appTitle => 'FarmSphere';

  @override
  String get tagline => 'ఏఐ ఆధారిత వ్యవసాయ సహాయకుడు';

  @override
  String get welcomeTitle => 'FarmSphere కు స్వాగతం';

  @override
  String get welcomeSubtitle => 'మీ ఏఐ ఆధారిత వ్యవసాయ సహచరుడు';

  @override
  String get fullName => 'పూర్తి పేరు';

  @override
  String get email => 'ఈమెయిల్';

  @override
  String get phoneNumber => 'ఫోన్ నంబర్';

  @override
  String get location => 'స్థానం (నగరం, రాష్ట్రం)';

  @override
  String get locationHint =>
      'స్థానాన్ని నమోదు చేయండి లేదా Nokia API డిటెక్షన్ ఉపయోగించండి';

  @override
  String get detect => 'కనుగొనండి';

  @override
  String get getStarted => 'ప్రారంభించండి';

  @override
  String get verifyPhoneNumber => 'ఫోన్ నంబర్‌ను ధృవీకరించండి';

  @override
  String get featuresHeading => 'మీకు దొరకేది:';

  @override
  String get feature_ai_scanner => 'ఏఐ పంట ఆరోగ్య స్కానర్';

  @override
  String get feature_weather => 'వాతావరణం & హెచ్చరికలు';

  @override
  String get feature_market => 'మార్కెట్ ధరలు & పథకాలు';

  @override
  String get feature_voice_local => 'వాయిస్ & స్థానిక భాష మద్దతు';

  @override
  String get feature_activity => 'చర్యల లాగింగ్ & విశ్లేషణ';

  @override
  String get feature_community => 'రైతుల కమ్యూనిటీ ప్లాట్‌ఫారమ్';

  @override
  String get selectLanguage => 'భాషను ఎంచుకోండి';

  @override
  String get chooseLanguageToContinue => 'కొనసాగడానికి మీ భాషను ఎంచుకోండి';

  @override
  String get rContinue => 'కొనసాగించండి';

  @override
  String changeLanguageSuccess(Object language) {
    return 'భాష $language గా మార్చబడింది';
  }

  @override
  String get logout => 'లాగ్ అవుట్';

  @override
  String get logoutConfirmTitle => 'లాగ్ అవుట్';

  @override
  String get logoutConfirmBody => 'మీరు నిజంగా లాగ్ అవుట్ కావాలనుకుంటున్నారా?';

  @override
  String get ok => 'సరే';

  @override
  String get cancel => 'రద్దు';

  @override
  String get navHome => 'హోమ్';

  @override
  String get navCropHealth => 'పంట ఆరోగ్యం';

  @override
  String get navWeather => 'వాతావరణం';

  @override
  String get navMarket => 'మార్కెట్';

  @override
  String get navActivities => 'చర్యలు';

  @override
  String get navCommunity => 'సమాజం';

  @override
  String get navProfile => 'ప్రొఫైల్';

  @override
  String get chatbotTitle => 'FarmSphere ఏఐ సహాయకుడు';

  @override
  String get chatbotHint => 'వ్యవసాయం గురించి అడగండి...';
}
