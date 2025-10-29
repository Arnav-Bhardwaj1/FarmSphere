// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Urdu (`ur`).
class AppLocalizationsUr extends AppLocalizations {
  AppLocalizationsUr([String locale = 'ur']) : super(locale);

  @override
  String get appTitle => 'FarmSphere';

  @override
  String get tagline => 'اے آئی پر مبنی زرعی معاون';

  @override
  String get welcomeTitle => 'فارم سفیئر میں خوش آمدید';

  @override
  String get welcomeSubtitle => 'آپ کا اے آئی زرعی ساتھی';

  @override
  String get fullName => 'پورا نام';

  @override
  String get email => 'ای میل';

  @override
  String get phoneNumber => 'فون نمبر';

  @override
  String get location => 'مقام (شہر، ریاست)';

  @override
  String get locationHint => 'مقام درج کریں یا نوکیا API ڈیٹیکشن استعمال کریں';

  @override
  String get detect => 'کھوجیں';

  @override
  String get getStarted => 'شروع کریں';

  @override
  String get verifyPhoneNumber => 'فون نمبر کی توثیق کریں';

  @override
  String get featuresHeading => 'آپ کو ملے گا:';

  @override
  String get feature_ai_scanner => 'اے آئی فصل صحت اسکینر';

  @override
  String get feature_weather => 'موسم اور انتباہات';

  @override
  String get feature_market => 'مارکیٹ قیمتیں اور اسکیمیں';

  @override
  String get feature_voice_local => 'آواز اور مقامی زبان کی مدد';

  @override
  String get feature_activity => 'سرگرمی لاگنگ اور تجزیہ';

  @override
  String get feature_community => 'کسان کمیونٹی پلیٹ فارم';

  @override
  String get selectLanguage => 'زبان منتخب کریں';

  @override
  String get chooseLanguageToContinue =>
      'جاری رکھنے کے لیے اپنی زبان منتخب کریں';

  @override
  String get rContinue => 'جاری رکھیں';

  @override
  String changeLanguageSuccess(Object language) {
    return 'زبان $language میں تبدیل ہوگئی';
  }

  @override
  String get logout => 'لاگ آؤٹ';

  @override
  String get logoutConfirmTitle => 'لاگ آؤٹ';

  @override
  String get logoutConfirmBody => 'کیا آپ واقعی لاگ آؤٹ کرنا چاہتے ہیں؟';

  @override
  String get ok => 'ٹھیک ہے';

  @override
  String get cancel => 'منسوخ';

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
