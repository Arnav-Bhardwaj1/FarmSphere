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
  String get tagline => 'AI-Powered Farming Assistant';

  @override
  String get welcomeTitle => 'FarmSphere-க்கு வரவேற்கிறோம்';

  @override
  String get welcomeSubtitle => 'உங்கள் AI-ஆற்றல்மிக்க விவசாய துணை';

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
      'இடத்தை உள்ளிடவும் அல்லது Nokia API கண்டறிதலைப் பயன்படுத்தவும்';

  @override
  String get detect => 'கண்டறியவும்';

  @override
  String get getStarted => 'தொடங்கவும்';

  @override
  String get verifyPhoneNumber => 'தொலைபேசி எண்ணை சரிபார்க்கவும்';

  @override
  String get featuresHeading => 'நீங்கள் என்ன பெறுவீர்கள்:';

  @override
  String get feature_ai_scanner => 'AI பயிர் ஆரோக்கியம் ஸ்கேனர்';

  @override
  String get feature_weather => 'வானிலை மற்றும் எச்சரிக்கைகள்';

  @override
  String get feature_market => 'சந்தை விலைகள் மற்றும் திட்டங்கள்';

  @override
  String get feature_voice_local => 'குரல் மற்றும் உள்ளூர் மொழி ஆதரவு';

  @override
  String get feature_activity => 'நடவடிக்கை பதிவு மற்றும் பகுப்பாய்வு';

  @override
  String get feature_community => 'விவசாயி சமூக தளம்';

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
  String get logout => 'வெளியேறு';

  @override
  String get logoutConfirmTitle => 'வெளியேறு';

  @override
  String get logoutConfirmBody =>
      'நீங்கள் உண்மையிலேயே வெளியேற விரும்புகிறீர்களா?';

  @override
  String get ok => 'சரி';

  @override
  String get cancel => 'ரத்துசெய்';

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
  String get chatbotTitle => 'FarmSphere AI உதவியாளர்';

  @override
  String get chatbotHint => 'விவசாயம் பற்றி கேளுங்கள்...';

  @override
  String get listening => 'கேட்டுக்கொண்டிருக்கிறது...';

  @override
  String get tapToSpeak => 'பேச மைக்கை தட்டவும்';

  @override
  String get speaking => 'பேசுகிறது...';

  @override
  String get tapToStop => 'நிறுத்த தட்டவும்';

  @override
  String get welcomeBack => 'மீண்டும் வரவேற்கிறோம்,';

  @override
  String get quickActions => 'விரைவு செயல்கள்';

  @override
  String get scanCrop => 'பயிரை ஸ்கேன் செய்யுங்கள்';

  @override
  String get voiceHelp => 'குரல் உதவி';

  @override
  String get logActivity => 'நடவடிக்கையை பதிவு செய்யுங்கள்';

  @override
  String get aiAssistant => 'AI உதவியாளர்';

  @override
  String get community => 'சமூகம்';

  @override
  String get help => 'உதவி';

  @override
  String get features => 'அம்சங்கள்';

  @override
  String get importantAlerts => 'முக்கியமான எச்சரிக்கைகள்';

  @override
  String get recentActivities => 'சமீபத்திய நடவடிக்கைகள்';

  @override
  String get noActivitiesYet => 'இன்னும் எந்த நடவடிக்கைகளும் இல்லை';

  @override
  String get startLoggingActivities =>
      'உங்கள் பண்ணை நடவடிக்கைகளை பதிவு செய்யத் தொடங்குங்கள்';

  @override
  String get today => 'இன்று';

  @override
  String get yesterday => 'நேற்று';

  @override
  String daysAgo(Object count) {
    return '$count நாட்களுக்கு முன்பு';
  }

  @override
  String get comingSoon => 'விரைவில் வருகிறது';

  @override
  String get featureUnderDevelopment =>
      'இந்த அம்சம் வளர்ச்சியில் உள்ளது மற்றும் விரைவில் கிடைக்கும்.';

  @override
  String get aiCropHealth => 'AI பயிர் ஆரோக்கியம்';

  @override
  String get scanDiagnoseDiseases =>
      'பயிர் நோய்களை ஸ்கேன் செய்து நோய் நாடறியுங்கள்';

  @override
  String get weatherAlerts => 'வானிலை மற்றும் எச்சரிக்கைகள்';

  @override
  String get getWeatherUpdates =>
      'வானிலை புதுப்பிப்புகள் மற்றும் எச்சரிக்கைகளைப் பெறுங்கள்';

  @override
  String get marketPrices => 'சந்தை விலைகள்';

  @override
  String get checkPricesSchemes =>
      'பயிர் விலைகள் மற்றும் திட்டங்களை சரிபார்க்கவும்';

  @override
  String get analytics => 'பகுப்பாய்வு';

  @override
  String get trackActivities => 'உங்கள் பண்ணை நடவடிக்கைகளை கண்காணிக்கவும்';

  @override
  String get helpComingSoon => 'உதவி அம்சம் விரைவில் வருகிறது!';

  @override
  String get aiCropHealthScanner => 'AI பயிர் ஆரோக்கியம் ஸ்கேனர்';

  @override
  String get howToUse => 'எப்படி பயன்படுத்துவது';

  @override
  String get cropHealthInstructions =>
      'பாதிக்கப்பட்ட தாவர பகுதியின் தெளிவான புகைப்படம் எடுங்கள் அல்லது நீங்கள் கவனிக்கும் அறிகுறிகளை விவரிக்கவும். எங்கள் AI பகுப்பாய்வு செய்து நோயறிதல் மற்றும் சிகிச்சை பரிந்துரைகளை வழங்கும்.';

  @override
  String get uploadImage => 'படத்தை பதிவேற்றவும்';

  @override
  String get retake => 'மீண்டும் எடுக்கவும்';

  @override
  String get gallery => 'கேலரி';

  @override
  String get remove => 'நீக்கவும்';

  @override
  String get noImageSelected => 'எந்த படமும் தேர்ந்தெடுக்கப்படவில்லை';

  @override
  String get takePhoto => 'புகைப்படம் எடுக்கவும்';

  @override
  String get orDescribeSymptoms => 'அல்லது அறிகுறிகளை விவரிக்கவும்';

  @override
  String get describeSymptomsHint =>
      'நீங்கள் கவனிக்கும் அறிகுறிகளை விவரிக்கவும்...\n\nஎடுத்துக்காட்டு: \"இலைகளில் மஞ்சள் புள்ளிகள், வாடுதல், பழுப்பு விளிம்புகள்\"';

  @override
  String get aiDiseaseDetection => 'AI நோய் கண்டறிதல்';

  @override
  String get analyzeCropHealth => 'பயிர் ஆரோக்கியத்தை பகுப்பாய்வு செய்யுங்கள்';

  @override
  String get analyzing => 'பகுப்பாய்வு செய்கிறது...';

  @override
  String get analysisResult => 'பகுப்பாய்வு முடிவு';

  @override
  String get recentDiagnoses => 'சமீபத்திய நோயறிதல்கள்';

  @override
  String get diagnosisHistory => 'நோயறிதல் வரலாறு';

  @override
  String get noDiagnosisHistory => 'நோயறிதல் வரலாறு கிடைக்கவில்லை';

  @override
  String get pleaseProvideImageOrDescription =>
      'தயவுசெய்து ஒரு படம் அல்லது விளக்கத்தை வழங்கவும்';

  @override
  String errorPickingImage(Object error) {
    return 'படத்தைத் தேர்ந்தெடுப்பதில் பிழை: $error';
  }

  @override
  String analysisFailed(Object error) {
    return 'பகுப்பாய்வு தோல்வியடைந்தது: $error';
  }

  @override
  String get analyzingCropHealth =>
      'பயிர் ஆரோக்கியத்தை பகுப்பாய்வு செய்கிறது...\nஇது சில தருணங்கள் எடுக்கலாம்';

  @override
  String get weatherAlertsTitle => 'வானிலை மற்றும் எச்சரிக்கைகள்';

  @override
  String get retry => 'மீண்டும் முயற்சிக்கவும்';

  @override
  String get failedToLoadWeather => 'வானிலை தரவை ஏற்ற முடியவில்லை';

  @override
  String get dayForecast => '7-நாள் வானிலை முன்னறிவிப்பு';

  @override
  String get weatherAlertsSection => 'வானிலை எச்சரிக்கைகள்';

  @override
  String get weatherTips => 'வானிலை குறிப்புகள்';

  @override
  String get irrigation => 'பாசனம்';

  @override
  String get irrigationTip =>
      'ஆவியாதலை குறைக்க உங்கள் பயிர்களை காலையில் அல்லது மாலையில் நீர்ப்பாசனம் செய்யுங்கள்।';

  @override
  String get sunProtection => 'சூரிய பாதுகாப்பு';

  @override
  String get sunProtectionTip =>
      'இளம் செடிகளை பாதுகாக்க கடுமையான வெப்பத்தின் போது நிழல் வலைகளைப் பயன்படுத்தவும்।';

  @override
  String get rainManagement => 'மழை மேலாண்மை';

  @override
  String get rainManagementTip =>
      'கடும் மழையின் போது நீர் தேங்குவதைத் தடுக்க சரியான வடிகால் வசதியை உறுதி செய்யவும்।';

  @override
  String get windProtection => 'காற்று பாதுகாப்பு';

  @override
  String get windProtectionTip =>
      'வலுவான காற்றிலிருந்து பயிர்களை பாதுகாக்க காற்று தடுப்புகளை நிறுவவும்।';

  @override
  String get marketPricesSchemes => 'சந்தை விலைகள் மற்றும் திட்டங்கள்';

  @override
  String get msp => 'MSP';

  @override
  String get marketTab => 'சந்தை';

  @override
  String get schemesTab => 'திட்டங்கள்';

  @override
  String get minimumSupportPrice => 'குறைந்தபட்ச ஆதரவு விலை (MSP)';

  @override
  String get mspDescription =>
      'விவசாய பொருட்களுக்கான அரசு உத்தரவாத குறைந்தபட்ச விலைகள். விவசாயிகள் தகவலறிந்த முடிவுகளை எடுக்க உதவுவதற்காக ஒவ்வொரு விதைப்பு பருவத்திற்கு முன்பும் இந்த விலைகள் அறிவிக்கப்படுகின்றன।';

  @override
  String get currentMSPRates => 'தற்போதைய MSP விலைகள் (2024-25)';

  @override
  String get failedToLoadMSP => 'MSP தரவை ஏற்ற முடியவில்லை';

  @override
  String get noMSPData => 'MSP தரவு கிடைக்கவில்லை';

  @override
  String get marketPricesTitle => 'சந்தை விலைகள்';

  @override
  String get marketPricesDescription =>
      'இந்தியா முழுவதும் உள்ள முக்கிய மண்டிகளில் இருந்து நேரடி பயிர் விலைகள்। விலைகள் தவறாமல் புதுப்பிக்கப்படுகின்றன மற்றும் தற்போதைய சந்தை நிலைமைகளை பிரதிபலிக்கின்றன।';

  @override
  String get currentMarketPrices => 'தற்போதைய சந்தை விலைகள்';

  @override
  String get failedToLoadMarket => 'சந்தை தரவை ஏற்ற முடியவில்லை';

  @override
  String get noMarketData => 'சந்தை தரவு கிடைக்கவில்லை';

  @override
  String get governmentSchemes => 'அரசு திட்டங்கள்';

  @override
  String get schemesDescription =>
      'விவசாயிகளுக்கு கிடைக்கும் பல்வேறு அரசு திட்டங்கள் மற்றும் மானியங்களை ஆராயுங்கள்। தகுதியை சரிபார்த்து ஆன்லைனில் விண்ணப்பிக்கவும்।';

  @override
  String get failedToLoadSchemes => 'திட்டங்கள் தரவை ஏற்ற முடியவில்லை';

  @override
  String get availableSchemes => 'கிடைக்கக்கூடிய திட்டங்கள்';

  @override
  String get noSchemesAvailable => 'திட்டங்கள் கிடைக்கவில்லை';

  @override
  String get activitiesAnalytics => 'செயல்பாடுகள் மற்றும் பகுப்பாய்வு';

  @override
  String get activities => 'செயல்பாடுகள்';

  @override
  String get analyticsTab => 'பகுப்பாய்வு';

  @override
  String get totalActivities => 'மொத்த செயல்பாடுகள்';

  @override
  String get thisMonth => 'இந்த மாதம்';

  @override
  String get failedToLoadActivities => 'செயல்பாடுகளை ஏற்ற முடியவில்லை';

  @override
  String get addActivity => 'செயல்பாட்டைச் சேர்க்கவும்';

  @override
  String get productivityOverview => 'உற்பத்தித்திறன் கண்ணோட்டம்';

  @override
  String get overallProductivityLabel => 'Overall Productivity';

  @override
  String get cropDistribution => 'பயிர் விநியோகம்';

  @override
  String get activityTips => 'செயல்பாட்டு குறிப்புகள்';

  @override
  String get regularLogging => 'வழக்கமான பதிவு';

  @override
  String get regularLoggingTip =>
      'சிறந்த நுண்ணறிவு மற்றும் பரிந்துரைகளுக்காக தினமும் செயல்பாடுகளை பதிவு செய்யுங்கள்।';

  @override
  String get photoDocumentation => 'புகைப்பட ஆவணப்படுத்தல்';

  @override
  String get photoDocumentationTip =>
      'காட்சி கண்காணிப்புக்காக உங்கள் செயல்பாடுகளின் புகைப்படங்களை எடுக்கவும்।';

  @override
  String get reviewAnalytics => 'பகுப்பாய்வை மதிப்பாய்வு செய்யவும்';

  @override
  String get reviewAnalyticsTip =>
      'உங்கள் உற்பத்தித்திறன் போக்குகளை சரிபார்த்து அதன்படி மேம்படுத்தவும்।';

  @override
  String get chatGeneralDiscussion => 'பொது விவாதம்';

  @override
  String get chatCropHealthHelp => 'பயிர் சுகாதார உதவி';

  @override
  String get chatMarketPrices => 'சந்தை விலைகள்';

  @override
  String get alertMessageColdWave =>
      'வெப்பநிலை வீழ்ச்சி எதிர்பார்க்கப்படுகிறது. உணர்திறன் பயிர்களை சரியான அடுக்கு மூலம் பாதுகாக்கவும்.';

  @override
  String get alertMessageFog =>
      'காலையில் அடர்ந்த மூடுபனி எதிர்பார்க்கப்படுகிறது. குறைந்த பார்வையின் போது வயல் நடவடிக்கைகளைத் தவிர்க்கவும்.';

  @override
  String get alertMessageHeavyRain =>
      'அடுத்த 24 மணி நேரத்தில் கன மழை எதிர்பார்க்கப்படுகிறது. வயல் வேலையைத் தவிர்க்கவும் மற்றும் அறுவடை செய்யப்பட்ட பயிர்களை பாதுகாக்கவும்.';

  @override
  String get alertMessageFlood =>
      'தாழ்வான பகுதிகளில் நீர் தேங்குதல் சாத்தியம். உங்கள் வயல்களுக்கு சரியான வடிகால் உறுதி செய்யவும்.';

  @override
  String get alertMessageHeatWave =>
      'உயர் வெப்பநிலை எதிர்பார்க்கப்படுகிறது (40°C க்கு மேல்). உங்கள் பயிர்களுக்கு போதுமான நீர்ப்பாசனம் உறுதி செய்யவும்.';

  @override
  String get alertMessageWaterScarcity =>
      'குறைந்த ஈரப்பதம் கண்டறியப்பட்டது. உணர்திறன் பயிர்களுக்கு நீர்ப்பாசன அதிர்வெண்ணை அதிகரிக்கவும்.';

  @override
  String get alertMessageFrost =>
      'இன்று இரவு உறைபனி நிலைமைகள் எதிர்பார்க்கப்படுகிறது. சேதத்தைத் தடுக்க உணர்திறன் பயிர்களை மூடவும்.';

  @override
  String get alertMessageColdWeather =>
      '10°C க்கும் கீழே வெப்பநிலை எதிர்பார்க்கப்படுகிறது. சரியான பயிர் பாதுகாப்பு நடவடிக்கைகளை உறுதி செய்யவும்.';

  @override
  String get conditionMist => 'மூடுபனி';

  @override
  String get addActivityTitle => 'செயல்பாட்டைச் சேர்க்கவும்';

  @override
  String get save => 'சேமிக்கவும்';

  @override
  String get activityType => 'செயல்பாட்டு வகை';

  @override
  String get selectActivityType => 'செயல்பாட்டு வகையைத் தேர்ந்தெடுக்கவும்';

  @override
  String get pleaseSelectActivityType =>
      'தயவுசெய்து செயல்பாட்டு வகையைத் தேர்ந்தெடுக்கவும்';

  @override
  String get crop => 'பயிர்';

  @override
  String get selectCrop => 'பயிரைத் தேர்ந்தெடுக்கவும்';

  @override
  String get pleaseSelectCrop => 'தயவுசெய்து பயிரைத் தேர்ந்தெடுக்கவும்';

  @override
  String get notesOptional => 'குறிப்புகள் (விருப்பமானது)';

  @override
  String get addNotesHint =>
      'இந்த செயல்பாட்டைப் பற்றிய கூடுதல் குறிப்புகளைச் சேர்க்கவும்...';

  @override
  String get quickTips => 'விரைவு குறிப்புகள்';

  @override
  String get tipBeSpecific =>
      'செய்யப்பட்ட செயல்பாட்டைப் பற்றி குறிப்பிட்டு கூறுங்கள்';

  @override
  String get tipIncludeQuantities =>
      'அளவுகள், அளவீடுகள் அல்லது செலவழித்த நேரத்தைச் சேர்க்கவும்';

  @override
  String get tipNoteWeather =>
      'தொடர்புடையதாக இருந்தால் வானிலை நிலைகளைக் கவனிக்கவும்';

  @override
  String get tipAddPhotos =>
      'சிறந்த கண்காணிப்புக்காக முடிந்தால் புகைப்படங்களைச் சேர்க்கவும்';

  @override
  String get activityAddedSuccess => 'செயல்பாடு வெற்றிகரமாக சேர்க்கப்பட்டது';

  @override
  String failedToAddActivity(Object error) {
    return 'செயல்பாட்டைச் சேர்க்க முடியவில்லை: $error';
  }

  @override
  String get farmerCommunity => 'விவசாயி சமூகம்';

  @override
  String get posts => 'இடுகைகள்';

  @override
  String get chat => 'அரட்டை';

  @override
  String get experts => 'நிபுணர்கள்';

  @override
  String get activeFarmers => 'செயலில் உள்ள விவசாயிகள்';

  @override
  String get postsToday => 'இன்றைய இடுகைகள்';

  @override
  String get questionsSolved => 'தீர்க்கப்பட்ட கேள்விகள்';

  @override
  String get createPost => 'இடுகையை உருவாக்கவும்';

  @override
  String get postCreationComingSoon =>
      'இடுகை உருவாக்கும் செயல்பாடு விரைவில் கிடைக்கும்.';

  @override
  String get close => 'மூடு';

  @override
  String get consultationComingSoon => 'பரிந்துரை அம்சம் விரைவில் வருகிறது';

  @override
  String get startConsultation => 'பரிந்துரையைத் தொடங்கவும்';

  @override
  String get specialization => 'சிறப்பு';

  @override
  String get experience => 'அனுபவம்';

  @override
  String get rating => 'மதிப்பீடு';

  @override
  String get reviews => 'மதிப்பீடுகள்';

  @override
  String get consult => 'பரிந்துரை';

  @override
  String get profile => 'சுயவிவரம்';

  @override
  String get editProfile => 'சுயவிவரத்தைத் திருத்தவும்';

  @override
  String get updatePersonalInfo => 'உங்கள் தனிப்பட்ட தகவலைப் புதுப்பிக்கவும்';

  @override
  String get notifications => 'அறிவிப்புகள்';

  @override
  String get manageNotifications =>
      'உங்கள் அறிவிப்பு விருப்பங்களை நிர்வகிக்கவும்';

  @override
  String get language => 'மொழி';

  @override
  String get theme => 'தீம்';

  @override
  String get darkMode => 'இரவு மோட்';

  @override
  String get lightMode => 'வெளிச்ச மோட்';

  @override
  String get helpSupport => 'உதவி மற்றும் ஆதரவு';

  @override
  String get getHelp => 'உதவியைப் பெற்று ஆதரவைத் தொடர்பு கொள்ளவும்';

  @override
  String get about => 'பற்றி';

  @override
  String get appVersion => 'ஆப் பதிப்பு மற்றும் தகவல்';

  @override
  String get settings => 'அமைப்புகள்';

  @override
  String get settingsComingSoon => 'அமைப்புகள் செயல்பாடு விரைவில் கிடைக்கும்.';

  @override
  String get editProfileComingSoon =>
      'சுயவிவர திருத்தம் செயல்பாடு விரைவில் கிடைக்கும்.';

  @override
  String get notificationsComingSoon =>
      'அறிவிப்பு அமைப்புகள் விரைவில் கிடைக்கும்.';

  @override
  String get helpContent => 'ஆதரவுக்காக, தயவுசெய்து தொடர்பு கொள்ளவும்:';

  @override
  String get helpEmail => 'மின்னஞ்சல்: support@farmsphere.com';

  @override
  String get helpPhone => 'தொலைபேசி: +91 9876543210';

  @override
  String get helpWebsite =>
      'அல்லது எங்கள் வலைத்தளத்தை பார்வையிடவும்: www.farmsphere.com';

  @override
  String get aboutContent => 'ஒரு AI-ஆற்றல்மிக்க விவசாய உதவியாளர்';

  @override
  String get aboutFeatures => 'அம்சங்கள்:';

  @override
  String get refresh => 'புதுப்பிக்கவும்';

  @override
  String get currentWeatherTitle => 'தற்போதைய வானிலை';

  @override
  String get yourLocation => 'உங்கள் இருப்பிடம்';

  @override
  String get humidityLabel => 'ஈரப்பதம்';

  @override
  String get windLabel => 'காற்று';

  @override
  String get visibilityLabel => 'தெளிவு';

  @override
  String get uvIndexLabel => 'யூவி குறியீடு';

  @override
  String get conditionSunny => 'வெயில்';

  @override
  String get conditionPartlyCloudy => 'பகுதியாக மேகமூட்டம்';

  @override
  String get conditionCloudy => 'மேகமூட்டம்';

  @override
  String get conditionRainy => 'மழை';

  @override
  String get conditionStormy => 'புயல்';

  @override
  String get conditionHaze => 'மூடுபனி';

  @override
  String get conditionFog => 'அம்லமூடல்';

  @override
  String get conditionUnknown => 'தெரியாது';

  @override
  String get dayMon => 'தி';

  @override
  String get dayTue => 'செ';

  @override
  String get dayWed => 'பு';

  @override
  String get dayThu => 'வி';

  @override
  String get dayFri => 'வெ';

  @override
  String get daySat => 'ச';

  @override
  String get daySun => 'ஞா';

  @override
  String get alertGeneric => 'எச்சரிக்கை';

  @override
  String get alertTypeColdWave => 'குளிர் அலை எச்சரிக்கை';

  @override
  String get alertTypeFogWarning => 'மூடுபனி எச்சரிக்கை';

  @override
  String get alertTypeRain => 'மழை எச்சரிக்கை';

  @override
  String get alertTypeHeavyRain => 'கன மழை எச்சரிக்கை';

  @override
  String get alertTypeFlood => 'வெள்ள எச்சரிக்கை';

  @override
  String get alertTypeHeatWave => 'வெப்ப அலை எச்சரிக்கை';

  @override
  String get alertTypeWaterScarcity => 'நீர் பற்றாக்குறை எச்சரிக்கை';

  @override
  String get alertTypeFrost => 'உறைபனி எச்சரிக்கை';

  @override
  String get alertTypeColdWeather => 'குளிர் வானிலை எச்சரிக்கை';

  @override
  String get alertTypePest => 'பூச்சி எச்சரிக்கை';

  @override
  String get alertTypeWeather => 'வானிலை எச்சரிக்கை';

  @override
  String get alertTypeDisease => 'நோய் எச்சரிக்கை';

  @override
  String get alertNow => 'இப்போது';

  @override
  String get alertSoon => 'விரைவில்';

  @override
  String alertInHours(Object count) {
    return '$countமணிநேரத்தில்';
  }

  @override
  String alertInMinutes(Object count) {
    return '$countநிமிடங்களில்';
  }

  @override
  String get labelSeason => 'பருவம்';

  @override
  String get labelCategory => 'வகை';

  @override
  String get labelVariety => 'இன வகை';

  @override
  String get labelArrival => 'வருகை';

  @override
  String get governmentMSP => 'அரசு MSP';

  @override
  String get schemeDetails => 'திட்ட விவரங்கள்';

  @override
  String get description => 'விளக்கம்';

  @override
  String get eligibility => 'தகுதி';

  @override
  String get benefits => 'நன்மைகள்';

  @override
  String get howToApply => 'விண்ணப்பிப்பது எப்படி';

  @override
  String get officialWebsite => 'அதிகாரப்பூர்வ இணையதளம்';

  @override
  String get status => 'நிலை';

  @override
  String get learnMore => 'மேலும் அறிக';

  @override
  String get visitWebsite => 'இணையதளத்திற்கு செல்லவும்';

  @override
  String get activityPlanting => 'நடவு';

  @override
  String get activityFertilizing => 'உரமிடல்';

  @override
  String get activityIrrigation => 'நீர்ப்பாசனம்';

  @override
  String get cropRice => 'அரிசி';

  @override
  String get cropWheat => 'கோதுமை';

  @override
  String get cropMaize => 'சோளம்';

  @override
  String get severityHigh => 'உயர்';

  @override
  String get severityMedium => 'மத்திய';

  @override
  String get severityLow => 'குறைந்த';

  @override
  String get seasonKharif => 'காரீப்பு';

  @override
  String get seasonRabi => 'ரபி';

  @override
  String get categoryCereals => 'தானியங்கள்';

  @override
  String get categoryPulses => 'பருப்பு வகைகள்';

  @override
  String get categoryOilseeds => 'எண்ணெய் வித்துக்கள்';

  @override
  String get categoryCommercialCrops => 'வணிகப் பயிர்கள்';

  @override
  String get stateAllIndia => 'முழு இந்தியா';

  @override
  String get cropPaddy => 'நெல்';

  @override
  String get cropJowar => 'சோளம்';

  @override
  String get cropBajra => 'கம்பு';

  @override
  String get cropRagi => 'ராகி';

  @override
  String get cropArhar => 'துவரை';

  @override
  String get cropMoong => 'பச்சை பயறு';

  @override
  String get cropUrad => 'உளுந்து';

  @override
  String get cropChana => 'கொண்டைக்கடலை';

  @override
  String get cropMasur => 'மசூர்';

  @override
  String get cropGroundnut => 'நிலக்கடலை';

  @override
  String get cropSesamum => 'எள்ளு';

  @override
  String get cropSunflower => 'சூரியகாந்தி';

  @override
  String get cropSoyabean => 'சோயாபீன்ஸ்';

  @override
  String get cropMustard => 'கடுகு';

  @override
  String get cropCotton => 'பருத்தி';

  @override
  String get cropSugarcane => 'கரும்பு';

  @override
  String get cropJute => 'சணல்';

  @override
  String get cropTomato => 'தக்காளி';

  @override
  String get cropPotato => 'உருளைக்கிழங்கு';

  @override
  String get cropOnion => 'வெங்காயம்';

  @override
  String get share => 'பகிர்';

  @override
  String get saveAction => 'சேமி';

  @override
  String get reportPost => 'இடுகையைப் புகாரளி';

  @override
  String get blockUser => 'பயனரைத் தடு';

  @override
  String get copyLink => 'இணைப்பை நகலெடு';

  @override
  String get members => 'உறுப்பினர்கள்';

  @override
  String get joinChat => 'அரட்டையில் சேர்';

  @override
  String get chatFeatureComingSoon => 'அரட்டை அம்சம் விரைவில் வருகிறது';

  @override
  String get schemeActive => 'செயலில்';

  @override
  String get schemeInactive => 'செயலற்ற';

  @override
  String get schemeUpcoming => 'வரவிருக்கும்';

  @override
  String get postContent => 'Post Content';

  @override
  String get postContentHint =>
      'Share your farming experience, ask questions, or help other farmers...';

  @override
  String get tags => 'Tags';

  @override
  String get tagsHint =>
      'Add tags (e.g., Wheat, Harvest, Disease) - separate with commas';

  @override
  String get postCreatedSuccess => 'Post created successfully!';

  @override
  String get pleaseEnterContent => 'Please enter post content';

  @override
  String get addComment => 'Add Comment';

  @override
  String get commentHint => 'Write a comment...';

  @override
  String get comment => 'Comment';

  @override
  String get comments => 'Comments';

  @override
  String get like => 'Like';

  @override
  String get unlike => 'Unlike';

  @override
  String get liked => 'Liked';

  @override
  String get postSaved => 'Post saved';

  @override
  String get postUnsaved => 'Post removed from saved';

  @override
  String get linkCopied => 'Link copied to clipboard';

  @override
  String get userBlocked => 'User blocked successfully';

  @override
  String get postReported =>
      'Post reported. Thank you for keeping the community safe.';

  @override
  String get sendMessage => 'Send Message';

  @override
  String get messageHint => 'Type your message...';

  @override
  String get noCommentsYet => 'No comments yet. Be the first to comment!';

  @override
  String consultationStarted(String expertName) {
    return 'Consultation started with $expertName';
  }

  @override
  String get typeYourMessage => 'Type your message here...';

  @override
  String get noMessagesYet => 'No messages yet. Start the conversation!';

  @override
  String get postDeleted => 'Post deleted successfully';
}
