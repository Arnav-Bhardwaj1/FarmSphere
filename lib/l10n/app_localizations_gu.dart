// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Gujarati (`gu`).
class AppLocalizationsGu extends AppLocalizations {
  AppLocalizationsGu([String locale = 'gu']) : super(locale);

  @override
  String get appTitle => 'FarmSphere';

  @override
  String get tagline => 'એઆઇ સંચાલિત ખેતી સહાયક';

  @override
  String get welcomeTitle => 'FarmSphere માં આપનું સ્વાગત છે';

  @override
  String get welcomeSubtitle => 'તમારો એઆઇ સંચાલિત ખેતી સાથી';

  @override
  String get fullName => 'પૂર્ણ નામ';

  @override
  String get email => 'ઇમેઇલ';

  @override
  String get phoneNumber => 'ફોન નંબર';

  @override
  String get location => 'સ્થાન (શહેર, રાજ્ય)';

  @override
  String get locationHint => 'સ્થાન દાખલ કરો અથવા Nokia API શોધનો ઉપયોગ કરો';

  @override
  String get detect => 'શોધો';

  @override
  String get getStarted => 'શરૂ કરો';

  @override
  String get verifyPhoneNumber => 'ફોન નંબર ચકાસો';

  @override
  String get featuresHeading => 'તમે શું મેળવશો:';

  @override
  String get feature_ai_scanner => 'એઆઇ પાક આરોગ્ય સ્કેનર';

  @override
  String get feature_weather => 'હવામાન અને ચેતવણીઓ';

  @override
  String get feature_market => 'બજાર ભાવ અને યોજનાઓ';

  @override
  String get feature_voice_local => 'વોઇસ અને સ્થાનિક ભાષા સપોર્ટ';

  @override
  String get feature_activity => 'પ્રવૃત્તિ લોગિંગ અને વિશ્લેષણ';

  @override
  String get feature_community => 'ખેડૂત સમુદાય પ્લેટફોર્મ';

  @override
  String get selectLanguage => 'ભાષા પસંદ કરો';

  @override
  String get chooseLanguageToContinue => 'આગળ વધવા માટે તમારી ભાષા પસંદ કરો';

  @override
  String get rContinue => 'ચાલુ રાખો';

  @override
  String changeLanguageSuccess(Object language) {
    return 'ભાષા $language માં બદલાઈ';
  }

  @override
  String get logout => 'લોગઆઉટ';

  @override
  String get logoutConfirmTitle => 'લોગઆઉટ';

  @override
  String get logoutConfirmBody => 'શું તમે ખરેખર લોગઆઉટ કરવા માંગો છો?';

  @override
  String get ok => 'બરાબર';

  @override
  String get cancel => 'રદ કરો';

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
