// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Kannada (`kn`).
class AppLocalizationsKn extends AppLocalizations {
  AppLocalizationsKn([String locale = 'kn']) : super(locale);

  @override
  String get appTitle => 'FarmSphere';

  @override
  String get tagline => 'ಎಐ ಚಾಲಿತ ಕೃಷಿ ಸಹಾಯಕ';

  @override
  String get welcomeTitle => 'FarmSphere ಗೆ ಸ್ವಾಗತ';

  @override
  String get welcomeSubtitle => 'ನಿಮ್ಮ ಎಐ ಕೃಷಿ ಸಂಗಾತಿ';

  @override
  String get fullName => 'ಪೂರ್ಣ ಹೆಸರು';

  @override
  String get email => 'ಇಮೇಲ್';

  @override
  String get phoneNumber => 'ಫೋನ್ ಸಂಖ್ಯೆ';

  @override
  String get location => 'ಸ್ಥಳ (ನಗರ, ರಾಜ್ಯ)';

  @override
  String get locationHint => 'ಸ್ಥಳವನ್ನು ನಮೂದಿಸಿ ಅಥವಾ Nokia API ಡಿಟೆಕ್ಷನ್ ಬಳಸಿ';

  @override
  String get detect => 'ಹುಡುಕಿ';

  @override
  String get getStarted => 'ಪ್ರಾರಂಭಿಸಿ';

  @override
  String get verifyPhoneNumber => 'ಫೋನ್ ಸಂಖ್ಯೆಯನ್ನು ಪರಿಶೀಲಿಸಿ';

  @override
  String get featuresHeading => 'ನೀವು ಪಡೆಯುವುದೇನು:';

  @override
  String get feature_ai_scanner => 'ಎಐ ಬೆಳೆ ಆರೋಗ್ಯ ಸ್ಕ್ಯಾನರ್';

  @override
  String get feature_weather => 'ಹವಾಮಾನ ಮತ್ತು ಎಚ್ಚರಿಕೆಗಳು';

  @override
  String get feature_market => 'ಮಾರುಕಟ್ಟೆ ಬೆಲೆ ಮತ್ತು ಯೋಜನೆಗಳು';

  @override
  String get feature_voice_local => 'ಧ್ವನಿ ಮತ್ತು ಸ್ಥಳೀಯ ಭಾಷಾ ಬೆಂಬಲ';

  @override
  String get feature_activity => 'ಚಟುವಟಿಕೆ ಲಾಗಿಂಗ್ ಮತ್ತು ವಿಶ್ಲೇಷಣೆ';

  @override
  String get feature_community => 'ರೈತ ಸಮುದಾಯ ವೇದಿಕೆ';

  @override
  String get selectLanguage => 'ಭಾಷೆಯನ್ನು ಆರಿಸಿ';

  @override
  String get chooseLanguageToContinue => 'ಮುಂದುವರಿಸಲು ನಿಮ್ಮ ಭಾಷೆಯನ್ನು ಆರಿಸಿ';

  @override
  String get rContinue => 'ಮುಂದುವರಿಸು';

  @override
  String changeLanguageSuccess(Object language) {
    return 'ಭಾಷೆಯನ್ನು $language ಗೆ ಬದಲಾಯಿಸಲಾಗಿದೆ';
  }

  @override
  String get logout => 'ಲಾಗ್ ಔಟ್';

  @override
  String get logoutConfirmTitle => 'ಲಾಗ್ ಔಟ್';

  @override
  String get logoutConfirmBody => 'ನೀವು ಖಚಿತವಾಗಿಯೂ ಲಾಗ್ ಔಟ್ ಮಾಡಲು ಬಯಸುವಿರಾ?';

  @override
  String get ok => 'ಸರಿ';

  @override
  String get cancel => 'ರದ್ದು';

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
