// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bengali Bangla (`bn`).
class AppLocalizationsBn extends AppLocalizations {
  AppLocalizationsBn([String locale = 'bn']) : super(locale);

  @override
  String get appTitle => 'FarmSphere';

  @override
  String get tagline => 'এআই-চালিত কৃষি সহায়ক';

  @override
  String get welcomeTitle => 'FarmSphere-এ স্বাগতম';

  @override
  String get welcomeSubtitle => 'আপনার এআই-চালিত কৃষি সহচর';

  @override
  String get fullName => 'পুরো নাম';

  @override
  String get email => 'ইমেইল';

  @override
  String get phoneNumber => 'ফোন নম্বর';

  @override
  String get location => 'অবস্থান (শহর, রাজ্য)';

  @override
  String get locationHint => 'অবস্থান লিখুন বা Nokia API ডিটেকশন ব্যবহার করুন';

  @override
  String get detect => 'সনাক্ত করুন';

  @override
  String get getStarted => 'শুরু করুন';

  @override
  String get verifyPhoneNumber => 'ফোন নম্বর যাচাই করুন';

  @override
  String get featuresHeading => 'আপনি যা পাবেন:';

  @override
  String get feature_ai_scanner => 'এআই ফসল স্বাস্থ্য স্ক্যানার';

  @override
  String get feature_weather => 'আবহাওয়া এবং সতর্কতা';

  @override
  String get feature_market => 'বাজার মূল্য এবং পরিকল্পনা';

  @override
  String get feature_voice_local => 'ভয়েস এবং স্থানীয় ভাষার সমর্থন';

  @override
  String get feature_activity => 'কার্যকলাপ লগিং এবং বিশ্লেষণ';

  @override
  String get feature_community => 'কৃষক সম্প্রদায় প্ল্যাটফর্ম';

  @override
  String get selectLanguage => 'ভাষা নির্বাচন করুন';

  @override
  String get chooseLanguageToContinue => 'অবিরত রাখতে আপনার ভাষা নির্বাচন করুন';

  @override
  String get rContinue => 'চালিয়ে যান';

  @override
  String changeLanguageSuccess(Object language) {
    return 'ভাষা $language এ পরিবর্তন করা হয়েছে';
  }

  @override
  String get logout => 'লগআউট';

  @override
  String get logoutConfirmTitle => 'লগআউট';

  @override
  String get logoutConfirmBody => 'আপনি কি সত্যিই লগআউট করতে চান?';

  @override
  String get ok => 'ঠিক আছে';

  @override
  String get cancel => 'বাতিল';

  @override
  String get navHome => 'হোম';

  @override
  String get navCropHealth => 'ফসলের স্বাস্থ্য';

  @override
  String get navWeather => 'আবহাওয়া';

  @override
  String get navMarket => 'বাজার';

  @override
  String get navActivities => 'কার্যকলাপ';

  @override
  String get navCommunity => 'কমিউনিটি';

  @override
  String get navProfile => 'প্রোফাইল';

  @override
  String get chatbotTitle => 'FarmSphere এআই সহকারী';

  @override
  String get chatbotHint => 'কৃষি সম্পর্কে জিজ্ঞাসা করুন...';
}
