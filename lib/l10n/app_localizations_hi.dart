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
  String get tagline => 'AI-Powered Farming Assistant';

  @override
  String get welcomeTitle => 'FarmSphere में आपका स्वागत है';

  @override
  String get welcomeSubtitle => 'आपका AI-संचालित कृषि साथी';

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
      'स्थान दर्ज करें या Nokia API डिटेक्शन का उपयोग करें';

  @override
  String get detect => 'डिटेक्ट करें';

  @override
  String get getStarted => 'शुरू करें';

  @override
  String get verifyPhoneNumber => 'फोन नंबर सत्यापित करें';

  @override
  String get featuresHeading => 'आपको क्या मिलेगा:';

  @override
  String get feature_ai_scanner => 'AI फसल स्वास्थ्य स्कैनर';

  @override
  String get feature_weather => 'मौसम और अलर्ट';

  @override
  String get feature_market => 'बाजार कीमतें और योजनाएं';

  @override
  String get feature_voice_local => 'आवाज और स्थानीय भाषा समर्थन';

  @override
  String get feature_activity => 'गतिविधि लॉगिंग और विश्लेषण';

  @override
  String get feature_community => 'किसान समुदाय प्लेटफॉर्म';

  @override
  String get selectLanguage => 'भाषा चुनें';

  @override
  String get chooseLanguageToContinue => 'जारी रखने के लिए अपनी भाषा चुनें';

  @override
  String get rContinue => 'जारी रखें';

  @override
  String changeLanguageSuccess(Object language) {
    return 'भाषा $language में बदल गई';
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
  String get navActivities => 'गतिविधियां';

  @override
  String get navCommunity => 'समुदाय';

  @override
  String get navProfile => 'प्रोफ़ाइल';

  @override
  String get chatbotTitle => 'FarmSphere AI सहायक';

  @override
  String get chatbotHint => 'खेती के बारे में पूछें...';

  @override
  String get listening => 'सुन रहे हैं...';

  @override
  String get tapToSpeak => 'बोलने के लिए माइक्रोफ़ोन पर टैप करें';

  @override
  String get speaking => 'बोल रहे हैं...';

  @override
  String get tapToStop => 'रोकने के लिए टैप करें';

  @override
  String get welcomeBack => 'वापस स्वागत है,';

  @override
  String get quickActions => 'त्वरित कार्य';

  @override
  String get scanCrop => 'फसल स्कैन करें';

  @override
  String get voiceHelp => 'आवाज़ सहायता';

  @override
  String get logActivity => 'गतिविधि लॉग करें';

  @override
  String get aiAssistant => 'AI सहायक';

  @override
  String get community => 'समुदाय';

  @override
  String get help => 'मदद';

  @override
  String get features => 'विशेषताएं';

  @override
  String get importantAlerts => 'महत्वपूर्ण अलर्ट';

  @override
  String get recentActivities => 'हाल की गतिविधियां';

  @override
  String get noActivitiesYet => 'अभी तक कोई गतिविधि नहीं';

  @override
  String get startLoggingActivities =>
      'अपनी खेत की गतिविधियों को लॉग करना शुरू करें';

  @override
  String get today => 'आज';

  @override
  String get yesterday => 'कल';

  @override
  String daysAgo(Object count) {
    return '$count दिन पहले';
  }

  @override
  String get comingSoon => 'Coming Soon';

  @override
  String get featureUnderDevelopment =>
      'This feature is under development and will be available soon.';

  @override
  String get aiCropHealth => 'AI फसल स्वास्थ्य';

  @override
  String get scanDiagnoseDiseases => 'फसल रोगों को स्कैन करें और निदान करें';

  @override
  String get weatherAlerts => 'मौसम और अलर्ट';

  @override
  String get getWeatherUpdates => 'मौसम अपडेट और अलर्ट प्राप्त करें';

  @override
  String get marketPrices => 'बाजार कीमतें';

  @override
  String get checkPricesSchemes => 'फसल कीमतों और योजनाओं को देखें';

  @override
  String get analytics => 'विश्लेषण';

  @override
  String get trackActivities => 'अपनी खेत की गतिविधियों को ट्रैक करें';

  @override
  String get helpComingSoon => 'मदद सुविधा जल्द ही आ रही है!';

  @override
  String get aiCropHealthScanner => 'AI फसल स्वास्थ्य स्कैनर';

  @override
  String get howToUse => 'कैसे उपयोग करें';

  @override
  String get cropHealthInstructions =>
      'प्रभावित पौधे के हिस्से की स्पष्ट तस्वीर लें या आप जो लक्षण देख रहे हैं उनका वर्णन करें। हमारी AI विश्लेषण करेगी और निदान और उपचार सुझाव प्रदान करेगी।';

  @override
  String get uploadImage => 'छवि अपलोड करें';

  @override
  String get retake => 'फिर से लें';

  @override
  String get gallery => 'गैलरी';

  @override
  String get remove => 'हटाएं';

  @override
  String get noImageSelected => 'कोई छवि चयनित नहीं';

  @override
  String get takePhoto => 'फोटो लें';

  @override
  String get orDescribeSymptoms => 'या लक्षणों का वर्णन करें';

  @override
  String get describeSymptomsHint =>
      'आप जो लक्षण देख रहे हैं उनका वर्णन करें...\n\nउदाहरण: \"पत्तियों पर पीले धब्बे, मुरझाना, भूरे किनारे\"';

  @override
  String get aiDiseaseDetection => 'AI रोग पहचान';

  @override
  String get analyzeCropHealth => 'फसल स्वास्थ्य विश्लेषण करें';

  @override
  String get analyzing => 'विश्लेषण कर रहे हैं...';

  @override
  String get analysisResult => 'विश्लेषण परिणाम';

  @override
  String get recentDiagnoses => 'हाल के निदान';

  @override
  String get diagnosisHistory => 'निदान इतिहास';

  @override
  String get noDiagnosisHistory => 'कोई निदान इतिहास उपलब्ध नहीं';

  @override
  String get pleaseProvideImageOrDescription =>
      'कृपया एक छवि या विवरण प्रदान करें';

  @override
  String errorPickingImage(Object error) {
    return 'छवि चुनने में त्रुटि: $error';
  }

  @override
  String analysisFailed(Object error) {
    return 'विश्लेषण विफल: $error';
  }

  @override
  String get analyzingCropHealth =>
      'फसल स्वास्थ्य का विश्लेषण कर रहे हैं...\nइसमें कुछ क्षण लग सकते हैं';

  @override
  String get weatherAlertsTitle => 'मौसम और अलर्ट';

  @override
  String get retry => 'पुनः प्रयास करें';

  @override
  String get failedToLoadWeather => 'मौसम डेटा लोड करने में विफल';

  @override
  String get dayForecast => '7-दिवसीय पूर्वानुमान';

  @override
  String get weatherAlertsSection => 'मौसम अलर्ट';

  @override
  String get weatherTips => 'मौसम युक्तियां';

  @override
  String get irrigation => 'सिंचाई';

  @override
  String get irrigationTip =>
      'वाष्पीकरण कम करने के लिए अपनी फसलों को सुबह जल्दी या शाम देर से पानी दें।';

  @override
  String get sunProtection => 'सूर्य संरक्षण';

  @override
  String get sunProtectionTip =>
      'युवा पौधों की रक्षा के लिए अत्यधिक गर्मी के दौरान छाया जाल का उपयोग करें।';

  @override
  String get rainManagement => 'बारिश प्रबंधन';

  @override
  String get rainManagementTip =>
      'भारी बारिश के दौरान जलभराव को रोकने के लिए उचित जल निकासी सुनिश्चित करें।';

  @override
  String get windProtection => 'हवा संरक्षण';

  @override
  String get windProtectionTip =>
      'मजबूत हवाओं से फसलों की रक्षा के लिए हवा रोधक स्थापित करें।';

  @override
  String get marketPricesSchemes => 'बाजार कीमतें और योजनाएं';

  @override
  String get msp => 'एमएसपी';

  @override
  String get marketTab => 'बाजार';

  @override
  String get schemesTab => 'योजनाएं';

  @override
  String get minimumSupportPrice => 'न्यूनतम समर्थन मूल्य (एमएसपी)';

  @override
  String get mspDescription =>
      'कृषि वस्तुओं के लिए सरकार द्वारा गारंटीशुदा न्यूनतम मूल्य। ये मूल्य किसानों को सूचित निर्णय लेने में मदद करने के लिए प्रत्येक बुआई सीजन से पहले घोषित किए जाते हैं।';

  @override
  String get currentMSPRates => 'वर्तमान एमएसपी दरें (2024-25)';

  @override
  String get failedToLoadMSP => 'एमएसपी डेटा लोड करने में विफल';

  @override
  String get noMSPData => 'कोई एमएसपी डेटा उपलब्ध नहीं';

  @override
  String get marketPricesTitle => 'बाजार कीमतें';

  @override
  String get marketPricesDescription =>
      'भारत भर के प्रमुख मंडियों से रीयल-टाइम फसल कीमतें। कीमतें नियमित रूप से अपडेट होती हैं और वर्तमान बाजार स्थितियों को दर्शाती हैं।';

  @override
  String get currentMarketPrices => 'वर्तमान बाजार कीमतें';

  @override
  String get failedToLoadMarket => 'बाजार डेटा लोड करने में विफल';

  @override
  String get noMarketData => 'कोई बाजार डेटा उपलब्ध नहीं';

  @override
  String get governmentSchemes => 'सरकारी योजनाएं';

  @override
  String get schemesDescription =>
      'किसानों के लिए उपलब्ध विभिन्न सरकारी योजनाओं और सब्सिडी का अन्वेषण करें। पात्रता जांचें और ऑनलाइन आवेदन करें।';

  @override
  String get failedToLoadSchemes => 'योजना डेटा लोड करने में विफल';

  @override
  String get availableSchemes => 'उपलब्ध योजनाएं';

  @override
  String get noSchemesAvailable => 'कोई योजना उपलब्ध नहीं';

  @override
  String get activitiesAnalytics => 'गतिविधियां और विश्लेषण';

  @override
  String get activities => 'गतिविधियां';

  @override
  String get analyticsTab => 'विश्लेषण';

  @override
  String get totalActivities => 'कुल गतिविधियां';

  @override
  String get thisMonth => 'इस महीने';

  @override
  String get failedToLoadActivities => 'गतिविधियां लोड करने में विफल';

  @override
  String get addActivity => 'गतिविधि जोड़ें';

  @override
  String get productivityOverview => 'उत्पादकता अवलोकन';

  @override
  String get overallProductivityLabel => 'समग्र उत्पादकता';

  @override
  String get cropDistribution => 'फसल वितरण';

  @override
  String get activityTips => 'गतिविधि युक्तियां';

  @override
  String get regularLogging => 'नियमित लॉगिंग';

  @override
  String get regularLoggingTip =>
      'बेहतर अंतर्दृष्टि और सुझावों के लिए प्रतिदिन गतिविधियां लॉग करें।';

  @override
  String get photoDocumentation => 'फोटो दस्तावेज़ीकरण';

  @override
  String get photoDocumentationTip =>
      'दृश्य ट्रैकिंग के लिए अपनी गतिविधियों की तस्वीरें लें।';

  @override
  String get reviewAnalytics => 'विश्लेषण की समीक्षा करें';

  @override
  String get reviewAnalyticsTip =>
      'अपने उत्पादकता रुझानों की जांच करें और तदनुसार अनुकूलन करें।';

  @override
  String get chatGeneralDiscussion => 'सामान्य चर्चा';

  @override
  String get chatCropHealthHelp => 'फसल स्वास्थ्य सहायता';

  @override
  String get chatMarketPrices => 'बाजार मूल्य';

  @override
  String get alertMessageColdWave =>
      'तापमान में गिरावट की उम्मीद। संवेदनशील फसलों को उचित आवरण से सुरक्षित करें।';

  @override
  String get alertMessageFog =>
      'सुबह के समय घना कोहरा होने की उम्मीद। कम दृश्यता के दौरान खेत के काम से बचें।';

  @override
  String get alertMessageHeavyRain =>
      'अगले 24 घंटों में भारी बारिश की उम्मीद। खेत के काम से बचें और कटाई वाली फसलों को सुरक्षित रखें।';

  @override
  String get alertMessageFlood =>
      'निचले इलाकों में जलभराव संभव। अपने खेतों के लिए उचित जल निकासी सुनिश्चित करें।';

  @override
  String get alertMessageHeatWave =>
      'उच्च तापमान की उम्मीद (40°C से ऊपर)। अपनी फसलों के लिए पर्याप्त सिंचाई सुनिश्चित करें।';

  @override
  String get alertMessageWaterScarcity =>
      'कम आर्द्रता स्तर का पता चला। संवेदनशील फसलों के लिए सिंचाई की आवृत्ति बढ़ाएं।';

  @override
  String get alertMessageFrost =>
      'आज रात पाला की स्थिति की उम्मीद। नुकसान को रोकने के लिए संवेदनशील फसलों को ढकें।';

  @override
  String get alertMessageColdWeather =>
      '10°C से नीचे तापमान की उम्मीद। उचित फसल सुरक्षा उपाय सुनिश्चित करें।';

  @override
  String get conditionMist => 'कोहरा';

  @override
  String get addActivityTitle => 'गतिविधि जोड़ें';

  @override
  String get save => 'सेव करें';

  @override
  String get activityType => 'गतिविधि प्रकार';

  @override
  String get selectActivityType => 'गतिविधि प्रकार चुनें';

  @override
  String get pleaseSelectActivityType => 'कृपया गतिविधि प्रकार चुनें';

  @override
  String get crop => 'फसल';

  @override
  String get selectCrop => 'फसल चुनें';

  @override
  String get pleaseSelectCrop => 'कृपया फसल चुनें';

  @override
  String get notesOptional => 'नोट्स (वैकल्पिक)';

  @override
  String get addNotesHint =>
      'इस गतिविधि के बारे में कोई अतिरिक्त नोट्स जोड़ें...';

  @override
  String get quickTips => 'त्वरित युक्तियां';

  @override
  String get tipBeSpecific => 'किए गए कार्य के बारे में विशिष्ट रहें';

  @override
  String get tipIncludeQuantities =>
      'मात्रा, माप या खर्च किए गए समय शामिल करें';

  @override
  String get tipNoteWeather => 'यदि प्रासंगिक हो तो मौसम की स्थिति नोट करें';

  @override
  String get tipAddPhotos => 'बेहतर ट्रैकिंग के लिए यदि संभव हो तो फोटो जोड़ें';

  @override
  String get activityAddedSuccess => 'गतिविधि सफलतापूर्वक जोड़ी गई';

  @override
  String failedToAddActivity(Object error) {
    return 'गतिविधि जोड़ने में विफल: $error';
  }

  @override
  String get farmerCommunity => 'किसान समुदाय';

  @override
  String get posts => 'पोस्ट';

  @override
  String get chat => 'चैट';

  @override
  String get experts => 'विशेषज्ञ';

  @override
  String get activeFarmers => 'सक्रिय किसान';

  @override
  String get postsToday => 'आज की पोस्ट';

  @override
  String get questionsSolved => 'हल किए गए प्रश्न';

  @override
  String get createPost => 'पोस्ट बनाएं';

  @override
  String get postCreationComingSoon =>
      'पोस्ट निर्माण कार्यक्षमता जल्द ही उपलब्ध होगी।';

  @override
  String get close => 'बंद करें';

  @override
  String get consultationComingSoon => 'परामर्श सुविधा जल्द ही आ रही है';

  @override
  String get startConsultation => 'परामर्श शुरू करें';

  @override
  String get specialization => 'विशेषज्ञता';

  @override
  String get experience => 'अनुभव';

  @override
  String get rating => 'रेटिंग';

  @override
  String get reviews => 'समीक्षाएं';

  @override
  String get consult => 'परामर्श';

  @override
  String get profile => 'प्रोफ़ाइल';

  @override
  String get editProfile => 'प्रोफ़ाइल संपादित करें';

  @override
  String get updatePersonalInfo => 'अपनी व्यक्तिगत जानकारी अपडेट करें';

  @override
  String get notifications => 'सूचनाएं';

  @override
  String get manageNotifications => 'अपनी सूचना प्राथमिकताओं को प्रबंधित करें';

  @override
  String get language => 'भाषा';

  @override
  String get theme => 'थीम';

  @override
  String get darkMode => 'डार्क मोड';

  @override
  String get lightMode => 'लाइट मोड';

  @override
  String get helpSupport => 'मदद और सहायता';

  @override
  String get getHelp => 'मदद प्राप्त करें और सहायता से संपर्क करें';

  @override
  String get about => 'के बारे में';

  @override
  String get appVersion => 'ऐप संस्करण और जानकारी';

  @override
  String get settings => 'सेटिंग्स';

  @override
  String get settingsComingSoon => 'सेटिंग्स कार्यक्षमता जल्द ही उपलब्ध होगी।';

  @override
  String get editProfileComingSoon =>
      'प्रोफ़ाइल संपादन कार्यक्षमता जल्द ही उपलब्ध होगी।';

  @override
  String get notificationsComingSoon => 'सूचना सेटिंग्स जल्द ही उपलब्ध होंगी।';

  @override
  String get helpContent => 'सहायता के लिए, कृपया संपर्क करें:';

  @override
  String get helpEmail => 'ईमेल: support@farmsphere.com';

  @override
  String get helpPhone => 'फोन: +91 9876543210';

  @override
  String get helpWebsite => 'या हमारी वेबसाइट पर जाएं: www.farmsphere.com';

  @override
  String get aboutContent => 'एक AI-संचालित कृषि सहायक';

  @override
  String get aboutFeatures => 'विशेषताएं:';

  @override
  String get refresh => 'ताज़ा करें';

  @override
  String get currentWeatherTitle => 'वर्तमान मौसम';

  @override
  String get yourLocation => 'आपका स्थान';

  @override
  String get humidityLabel => 'नमी';

  @override
  String get windLabel => 'हवा';

  @override
  String get visibilityLabel => 'दृश्यता';

  @override
  String get uvIndexLabel => 'यूवी इंडेक्स';

  @override
  String get conditionSunny => 'धूप';

  @override
  String get conditionPartlyCloudy => 'आंशिक बादल';

  @override
  String get conditionCloudy => 'बादल';

  @override
  String get conditionRainy => 'बारिश';

  @override
  String get conditionStormy => 'आंधी';

  @override
  String get conditionHaze => 'धुंध';

  @override
  String get conditionFog => 'कोहरा';

  @override
  String get conditionUnknown => 'अज्ञात';

  @override
  String get dayMon => 'सोम';

  @override
  String get dayTue => 'मंगल';

  @override
  String get dayWed => 'बुध';

  @override
  String get dayThu => 'गुरु';

  @override
  String get dayFri => 'शुक्र';

  @override
  String get daySat => 'शनि';

  @override
  String get daySun => 'रवि';

  @override
  String get alertGeneric => 'अलर्ट';

  @override
  String get alertTypeColdWave => 'शीत लहर अलर्ट';

  @override
  String get alertTypeFogWarning => 'कोहरा चेतावनी';

  @override
  String get alertTypeRain => 'बारिश अलर्ट';

  @override
  String get alertTypeHeavyRain => 'भारी बारिश अलर्ट';

  @override
  String get alertTypeFlood => 'बाढ़ चेतावनी';

  @override
  String get alertTypeHeatWave => 'गर्मी की लहर अलर्ट';

  @override
  String get alertTypeWaterScarcity => 'पानी की कमी चेतावनी';

  @override
  String get alertTypeFrost => 'पाला चेतावनी';

  @override
  String get alertTypeColdWeather => 'ठंड का मौसम अलर्ट';

  @override
  String get alertTypePest => 'कीट अलर्ट';

  @override
  String get alertTypeWeather => 'मौसम अलर्ट';

  @override
  String get alertTypeDisease => 'रोग अलर्ट';

  @override
  String get alertNow => 'अभी';

  @override
  String get alertSoon => 'जल्द';

  @override
  String alertInHours(Object count) {
    return '$countघंटे में';
  }

  @override
  String alertInMinutes(Object count) {
    return '$countमिनट में';
  }

  @override
  String get labelSeason => 'सीजन';

  @override
  String get labelCategory => 'श्रेणी';

  @override
  String get labelVariety => 'किस्म';

  @override
  String get labelArrival => 'आगमन';

  @override
  String get governmentMSP => 'सरकारी एमएसपी';

  @override
  String get schemeDetails => 'योजना विवरण';

  @override
  String get description => 'विवरण';

  @override
  String get eligibility => 'पात्रता';

  @override
  String get benefits => 'लाभ';

  @override
  String get howToApply => 'आवेदन कैसे करें';

  @override
  String get officialWebsite => 'आधिकारिक वेबसाइट';

  @override
  String get status => 'स्थिति';

  @override
  String get learnMore => 'और जानें';

  @override
  String get visitWebsite => 'वेबसाइट देखें';

  @override
  String get activityPlanting => 'रोपाई';

  @override
  String get activityFertilizing => 'उर्वरीकरण';

  @override
  String get activityIrrigation => 'सिंचाई';

  @override
  String get cropRice => 'धान';

  @override
  String get cropWheat => 'गेहूँ';

  @override
  String get cropMaize => 'मक्का';

  @override
  String get severityHigh => 'उच्च';

  @override
  String get severityMedium => 'मध्यम';

  @override
  String get severityLow => 'निम्न';

  @override
  String get seasonKharif => 'खरीफ';

  @override
  String get seasonRabi => 'रबी';

  @override
  String get categoryCereals => 'अनाज';

  @override
  String get categoryPulses => 'दालें';

  @override
  String get categoryOilseeds => 'तिलहन';

  @override
  String get categoryCommercialCrops => 'व्यावसायिक फसलें';

  @override
  String get stateAllIndia => 'सम्पूर्ण भारत';

  @override
  String get cropPaddy => 'धान';

  @override
  String get cropJowar => 'ज्वार';

  @override
  String get cropBajra => 'बाजरा';

  @override
  String get cropRagi => 'रागी';

  @override
  String get cropArhar => 'अरहर (तूर)';

  @override
  String get cropMoong => 'मूंग';

  @override
  String get cropUrad => 'उड़द';

  @override
  String get cropChana => 'चना';

  @override
  String get cropMasur => 'मसूर';

  @override
  String get cropGroundnut => 'मूंगफली';

  @override
  String get cropSesamum => 'तिल';

  @override
  String get cropSunflower => 'सूरजमुखी';

  @override
  String get cropSoyabean => 'सोयाबीन';

  @override
  String get cropMustard => 'सरसों';

  @override
  String get cropCotton => 'कपास';

  @override
  String get cropSugarcane => 'गन्ना';

  @override
  String get cropJute => 'जूट';

  @override
  String get cropTomato => 'टमाटर';

  @override
  String get cropPotato => 'आलू';

  @override
  String get cropOnion => 'प्याज';

  @override
  String get share => 'साझा करें';

  @override
  String get saveAction => 'सहेजें';

  @override
  String get reportPost => 'पोस्ट रिपोर्ट करें';

  @override
  String get blockUser => 'उपयोगकर्ता अवरुद्ध करें';

  @override
  String get copyLink => 'लिंक कॉपी करें';

  @override
  String get members => 'सदस्य';

  @override
  String get joinChat => 'चैट में शामिल हों';

  @override
  String get chatFeatureComingSoon => 'चैट सुविधा जल्द ही आ रही है';

  @override
  String get schemeActive => 'सक्रिय';

  @override
  String get schemeInactive => 'निष्क्रिय';

  @override
  String get schemeUpcoming => 'आगामी';

  @override
  String get postContent => 'पोस्ट सामग्री';

  @override
  String get postContentHint =>
      'अपने खेती के अनुभव साझा करें, प्रश्न पूछें, या अन्य किसानों की मदद करें...';

  @override
  String get tags => 'टैग';

  @override
  String get tagsHint =>
      'टैग जोड़ें (उदाहरण: गेहूँ, फसल, रोग) - अल्पविराम से अलग करें';

  @override
  String get postCreatedSuccess => 'पोस्ट सफलतापूर्वक बनाई गई!';

  @override
  String get pleaseEnterContent => 'कृपया पोस्ट सामग्री दर्ज करें';

  @override
  String get addComment => 'टिप्पणी जोड़ें';

  @override
  String get commentHint => 'एक टिप्पणी लिखें...';

  @override
  String get comment => 'टिप्पणी';

  @override
  String get comments => 'टिप्पणियां';

  @override
  String get like => 'पसंद';

  @override
  String get unlike => 'पसंद हटाएं';

  @override
  String get liked => 'पसंद किया';

  @override
  String get postSaved => 'पोस्ट सहेजी गई';

  @override
  String get postUnsaved => 'पोस्ट सहेजे गए से हटा दी गई';

  @override
  String get linkCopied => 'लिंक क्लिपबोर्ड पर कॉपी किया गया';

  @override
  String get userBlocked => 'उपयोगकर्ता सफलतापूर्वक अवरुद्ध किया गया';

  @override
  String get postReported =>
      'पोस्ट रिपोर्ट की गई। समुदाय को सुरक्षित रखने के लिए धन्यवाद।';

  @override
  String get sendMessage => 'संदेश भेजें';

  @override
  String get messageHint => 'अपना संदेश टाइप करें...';

  @override
  String get noCommentsYet =>
      'अभी तक कोई टिप्पणी नहीं। पहली टिप्पणी करने वाले बनें!';

  @override
  String consultationStarted(String expertName) {
    return '$expertName के साथ परामर्श शुरू हुआ';
  }

  @override
  String get typeYourMessage => 'अपना संदेश यहाँ टाइप करें...';

  @override
  String get noMessagesYet => 'अभी तक कोई संदेश नहीं। बातचीत शुरू करें!';

  @override
  String get postDeleted => 'पोस्ट सफलतापूर्वक हटाई गई';

  @override
  String get emailRequired => 'ईमेल आवश्यक है';

  @override
  String get emailInvalid => 'कृपया एक वैध ईमेल पता दर्ज करें';

  @override
  String get passwordRequired => 'पासवर्ड आवश्यक है';

  @override
  String get passwordTooShort => 'पासवर्ड कम से कम 6 अक्षर का होना चाहिए';

  @override
  String get phoneRequired => 'फोन नंबर आवश्यक है';

  @override
  String get phoneTooShort => 'फोन नंबर कम से कम 10 अंकों का होना चाहिए';

  @override
  String get locationRequired => 'स्थान आवश्यक है';

  @override
  String get agentDashboard => 'एआई एजेंट';

  @override
  String get manageAIAgents => 'अपने एआई खेती सहायकों को प्रबंधित करें';

  @override
  String get agentSettings => 'एजेंट सेटिंग्स';

  @override
  String get agentInsights => 'एआई अंतर्दृष्टि';

  @override
  String get agentRecommendations => 'सिफारिशें';

  @override
  String get agentStatistics => 'आंकड़े';

  @override
  String get agentStatus => 'स्थिति';

  @override
  String get agentEnabled => 'सक्षम';

  @override
  String get agentDisabled => 'अक्षम';

  @override
  String get toggleAgent => 'एजेंट टॉगल करें';

  @override
  String get runAgentsNow => 'अभी विश्लेषण चलाएं';

  @override
  String get checkNotifications => 'सूचनाएं जांचें';

  @override
  String get testNotification => 'परीक्षण सूचना भेजें';

  @override
  String get agentWeather => 'मौसम बुद्धिमत्ता';

  @override
  String get agentCropHealth => 'फसल स्वास्थ्य निगरानी';

  @override
  String get agentActivity => 'गतिविधि अनुसूचक';

  @override
  String get agentMarket => 'बाजार बुद्धिमत्ता';

  @override
  String get agentResource => 'संसाधन अनुकूलक';

  @override
  String get agentDescription => 'एआई-संचालित खेती सहायक';

  @override
  String get weatherAgentDesc =>
      'मौसम की निगरानी करता है और चेतावनी प्रदान करता है';

  @override
  String get cropHealthAgentDesc => 'फसल स्वास्थ्य पैटर्न ट्रैक करता है';

  @override
  String get activityAgentDesc =>
      'खेती के कार्यों को अनुसूचित और याद दिलाता है';

  @override
  String get marketAgentDesc => 'बाजार रुझानों और कीमतों का विश्लेषण करता है';

  @override
  String get resourceAgentDesc => 'पानी और उर्वरक उपयोग को अनुकूलित करता है';

  @override
  String get acknowledge => 'स्वीकार करें';

  @override
  String get dismiss => 'खारिज करें';

  @override
  String get viewDetails => 'विवरण देखें';

  @override
  String get priority => 'प्राथमिकता';

  @override
  String get priorityLow => 'कम';

  @override
  String get priorityMedium => 'मध्यम';

  @override
  String get priorityHigh => 'उच्च';

  @override
  String get priorityCritical => 'गंभीर';

  @override
  String get createdAt => 'बनाया गया';

  @override
  String get expiresAt => 'समाप्त होता है';

  @override
  String get noInsightsYet =>
      'अभी तक कोई अंतर्दृष्टि नहीं। एआई एजेंट आपके खेत के डेटा का विश्लेषण कर रहे हैं।';

  @override
  String get noRecommendationsYet =>
      'अभी तक कोई सिफारिश नहीं। व्यक्तिगत अंतर्दृष्टि के लिए ऐप का उपयोग जारी रखें।';

  @override
  String get agentAnalyzing => 'विश्लेषण कर रहा है...';

  @override
  String get agentReady => 'तैयार';

  @override
  String get generalSettings => 'सामान्य सेटिंग्स';

  @override
  String get enableNotifications => 'सूचनाएं सक्षम करें';

  @override
  String get enableAgents => 'एआई एजेंट सक्षम करें';

  @override
  String get agentManagement => 'एजेंट प्रबंधन';

  @override
  String get advancedSettings => 'उन्नत सेटिंग्स';

  @override
  String get dataRetention => 'डेटा प्रतिधारण';

  @override
  String get clearAgentData => 'सभी एजेंट डेटा साफ़ करें';

  @override
  String get clearAgentDataWarning =>
      'यह सभी एआई अंतर्दृष्टि, सिफारिशें और ऐतिहासिक डेटा हटा देगा। यह क्रिया पूर्ववत नहीं की जा सकती।';

  @override
  String get dataCleared => 'एजेंट डेटा सफलतापूर्वक साफ़ किया गया';
}
