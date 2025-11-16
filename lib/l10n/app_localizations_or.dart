// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Oriya (`or`).
class AppLocalizationsOr extends AppLocalizations {
  AppLocalizationsOr([String locale = 'or']) : super(locale);

  @override
  String get appTitle => 'FarmSphere';

  @override
  String get tagline => 'AI-Powered Farming Assistant';

  @override
  String get welcomeTitle => 'Welcome to FarmSphere';

  @override
  String get welcomeSubtitle => 'Your AI-powered farming companion';

  @override
  String get fullName => 'Full Name';

  @override
  String get email => 'Email';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get location => 'Location (City, State)';

  @override
  String get locationHint => 'Enter location or use Nokia API detection';

  @override
  String get detect => 'Detect';

  @override
  String get getStarted => 'Get Started';

  @override
  String get verifyPhoneNumber => 'Verify phone number';

  @override
  String get featuresHeading => 'What you\'ll get:';

  @override
  String get feature_ai_scanner => 'AI Crop Health Scanner';

  @override
  String get feature_weather => 'Weather & Alerts';

  @override
  String get feature_market => 'Market Prices & Schemes';

  @override
  String get feature_voice_local => 'Voice & Local Language Support';

  @override
  String get feature_activity => 'Activity Logging & Analytics';

  @override
  String get feature_community => 'Farmer Community Platform';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get chooseLanguageToContinue => 'Choose your language to continue';

  @override
  String get rContinue => 'Continue';

  @override
  String changeLanguageSuccess(Object language) {
    return 'Language changed to $language';
  }

  @override
  String get logout => 'Logout';

  @override
  String get logoutConfirmTitle => 'Logout';

  @override
  String get logoutConfirmBody => 'Are you sure you want to logout?';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Cancel';

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

  @override
  String get listening => 'Listening...';

  @override
  String get tapToSpeak => 'Tap microphone to speak';

  @override
  String get speaking => 'Speaking...';

  @override
  String get tapToStop => 'Tap to stop';

  @override
  String get welcomeBack => 'Welcome back,';

  @override
  String get quickActions => 'Quick Actions';

  @override
  String get scanCrop => 'Scan Crop';

  @override
  String get voiceHelp => 'Voice Help';

  @override
  String get logActivity => 'Log Activity';

  @override
  String get aiAssistant => 'AI Assistant';

  @override
  String get community => 'Community';

  @override
  String get help => 'Help';

  @override
  String get features => 'Features';

  @override
  String get importantAlerts => 'Important Alerts';

  @override
  String get recentActivities => 'Recent Activities';

  @override
  String get noActivitiesYet => 'No activities yet';

  @override
  String get startLoggingActivities => 'Start logging your farm activities';

  @override
  String get today => 'Today';

  @override
  String get yesterday => 'Yesterday';

  @override
  String daysAgo(Object count) {
    return '$count days ago';
  }

  @override
  String get comingSoon => 'Coming Soon';

  @override
  String get featureUnderDevelopment =>
      'This feature is under development and will be available soon.';

  @override
  String get aiCropHealth => 'AI Crop Health';

  @override
  String get scanDiagnoseDiseases => 'Scan and diagnose crop diseases';

  @override
  String get weatherAlerts => 'Weather & Alerts';

  @override
  String get getWeatherUpdates => 'Get weather updates and alerts';

  @override
  String get marketPrices => 'Market Prices';

  @override
  String get checkPricesSchemes => 'Check crop prices and schemes';

  @override
  String get analytics => 'Analytics';

  @override
  String get trackActivities => 'Track your farm activities';

  @override
  String get helpComingSoon => 'Help feature coming soon!';

  @override
  String get aiCropHealthScanner => 'AI Crop Health Scanner';

  @override
  String get howToUse => 'How to use';

  @override
  String get cropHealthInstructions =>
      'Take a clear photo of the affected plant part or describe the symptoms you\'re observing. Our AI will analyze and provide diagnosis and treatment recommendations.';

  @override
  String get uploadImage => 'Upload Image';

  @override
  String get retake => 'Retake';

  @override
  String get gallery => 'Gallery';

  @override
  String get remove => 'Remove';

  @override
  String get noImageSelected => 'No image selected';

  @override
  String get takePhoto => 'Take Photo';

  @override
  String get orDescribeSymptoms => 'Or Describe Symptoms';

  @override
  String get describeSymptomsHint =>
      'Describe the symptoms you\'re observing...\n\nExample: \"Yellow spots on leaves, wilting, brown edges\"';

  @override
  String get aiDiseaseDetection => 'AI Disease Detection';

  @override
  String get analyzeCropHealth => 'Analyze Crop Health';

  @override
  String get analyzing => 'Analyzing...';

  @override
  String get analysisResult => 'Analysis Result';

  @override
  String get recentDiagnoses => 'Recent Diagnoses';

  @override
  String get diagnosisHistory => 'Diagnosis History';

  @override
  String get noDiagnosisHistory => 'No diagnosis history available';

  @override
  String get pleaseProvideImageOrDescription =>
      'Please provide an image or description';

  @override
  String errorPickingImage(Object error) {
    return 'Error picking image: $error';
  }

  @override
  String analysisFailed(Object error) {
    return 'Analysis failed: $error';
  }

  @override
  String get analyzingCropHealth =>
      'Analyzing crop health...\nThis may take a few moments';

  @override
  String get weatherAlertsTitle => 'Weather & Alerts';

  @override
  String get retry => 'Retry';

  @override
  String get failedToLoadWeather => 'Failed to load weather data';

  @override
  String get dayForecast => '7-Day Forecast';

  @override
  String get weatherAlertsSection => 'Weather Alerts';

  @override
  String get weatherTips => 'Weather Tips';

  @override
  String get irrigation => 'Irrigation';

  @override
  String get irrigationTip =>
      'Water your crops early morning or late evening to reduce evaporation.';

  @override
  String get sunProtection => 'Sun Protection';

  @override
  String get sunProtectionTip =>
      'Use shade nets during extreme heat to protect young plants.';

  @override
  String get rainManagement => 'Rain Management';

  @override
  String get rainManagementTip =>
      'Ensure proper drainage to prevent waterlogging during heavy rains.';

  @override
  String get windProtection => 'Wind Protection';

  @override
  String get windProtectionTip =>
      'Install windbreaks to protect crops from strong winds.';

  @override
  String get marketPricesSchemes => 'Market Prices & Schemes';

  @override
  String get msp => 'MSP';

  @override
  String get marketTab => 'Market';

  @override
  String get schemesTab => 'Schemes';

  @override
  String get minimumSupportPrice => 'Minimum Support Price (MSP)';

  @override
  String get mspDescription =>
      'Government guaranteed minimum prices for agricultural commodities. These prices are announced before each sowing season to help farmers make informed decisions.';

  @override
  String get currentMSPRates => 'Current MSP Rates (2024-25)';

  @override
  String get failedToLoadMSP => 'Failed to load MSP data';

  @override
  String get noMSPData => 'No MSP data available';

  @override
  String get marketPricesTitle => 'Market Prices';

  @override
  String get marketPricesDescription =>
      'Real-time crop prices from major mandis across India. Prices are updated regularly and reflect current market conditions.';

  @override
  String get currentMarketPrices => 'Current Market Prices';

  @override
  String get failedToLoadMarket => 'Failed to load market data';

  @override
  String get noMarketData => 'No market data available';

  @override
  String get governmentSchemes => 'Government Schemes';

  @override
  String get schemesDescription =>
      'Explore various government schemes and subsidies available for farmers. Check eligibility and apply online.';

  @override
  String get failedToLoadSchemes => 'Failed to load schemes data';

  @override
  String get availableSchemes => 'Available Schemes';

  @override
  String get noSchemesAvailable => 'No schemes available';

  @override
  String get activitiesAnalytics => 'Activities & Analytics';

  @override
  String get activities => 'Activities';

  @override
  String get analyticsTab => 'Analytics';

  @override
  String get totalActivities => 'Total Activities';

  @override
  String get thisMonth => 'This Month';

  @override
  String get failedToLoadActivities => 'Failed to load activities';

  @override
  String get addActivity => 'Add Activity';

  @override
  String get productivityOverview => 'Productivity Overview';

  @override
  String get overallProductivityLabel => 'Overall Productivity';

  @override
  String get cropDistribution => 'Crop Distribution';

  @override
  String get activityTips => 'Activity Tips';

  @override
  String get regularLogging => 'Regular Logging';

  @override
  String get regularLoggingTip =>
      'Log activities daily for better insights and recommendations.';

  @override
  String get photoDocumentation => 'Photo Documentation';

  @override
  String get photoDocumentationTip =>
      'Take photos of your activities for visual tracking.';

  @override
  String get reviewAnalytics => 'Review Analytics';

  @override
  String get reviewAnalyticsTip =>
      'Check your productivity trends and optimize accordingly.';

  @override
  String get chatGeneralDiscussion => 'General Discussion';

  @override
  String get chatCropHealthHelp => 'Crop Health Help';

  @override
  String get chatMarketPrices => 'Market Prices';

  @override
  String get alertMessageColdWave =>
      'Temperature drop expected. Protect sensitive crops with proper covering.';

  @override
  String get alertMessageFog =>
      'Dense fog expected in early morning. Avoid field operations during low visibility.';

  @override
  String get alertMessageHeavyRain =>
      'Heavy rainfall expected in next 24 hours. Avoid field work and protect harvested crops.';

  @override
  String get alertMessageFlood =>
      'Waterlogging possible in low-lying areas. Ensure proper drainage for your fields.';

  @override
  String get alertMessageHeatWave =>
      'High temperature expected (above 40°C). Ensure adequate irrigation for your crops.';

  @override
  String get alertMessageWaterScarcity =>
      'Low humidity levels detected. Increase irrigation frequency for sensitive crops.';

  @override
  String get alertMessageFrost =>
      'Frost conditions expected tonight. Cover sensitive crops to prevent damage.';

  @override
  String get alertMessageColdWeather =>
      'Temperatures below 10°C expected. Ensure proper crop protection measures.';

  @override
  String get conditionMist => 'Mist';

  @override
  String get addActivityTitle => 'Add Activity';

  @override
  String get save => 'Save';

  @override
  String get activityType => 'Activity Type';

  @override
  String get selectActivityType => 'Select activity type';

  @override
  String get pleaseSelectActivityType => 'Please select an activity type';

  @override
  String get crop => 'Crop';

  @override
  String get selectCrop => 'Select crop';

  @override
  String get pleaseSelectCrop => 'Please select a crop';

  @override
  String get notesOptional => 'Notes (Optional)';

  @override
  String get addNotesHint => 'Add any additional notes about this activity...';

  @override
  String get quickTips => 'Quick Tips';

  @override
  String get tipBeSpecific => 'Be specific about the activity performed';

  @override
  String get tipIncludeQuantities =>
      'Include quantities, measurements, or time spent';

  @override
  String get tipNoteWeather => 'Note weather conditions if relevant';

  @override
  String get tipAddPhotos => 'Add photos if possible for better tracking';

  @override
  String get activityAddedSuccess => 'Activity added successfully';

  @override
  String failedToAddActivity(Object error) {
    return 'Failed to add activity: $error';
  }

  @override
  String get farmerCommunity => 'Farmer Community';

  @override
  String get posts => 'Posts';

  @override
  String get chat => 'Chat';

  @override
  String get experts => 'Experts';

  @override
  String get activeFarmers => 'Active Farmers';

  @override
  String get postsToday => 'Posts Today';

  @override
  String get questionsSolved => 'Questions Solved';

  @override
  String get createPost => 'Create Post';

  @override
  String get postCreationComingSoon =>
      'Post creation functionality will be available soon.';

  @override
  String get close => 'Close';

  @override
  String get consultationComingSoon => 'Consultation feature coming soon';

  @override
  String get startConsultation => 'Start Consultation';

  @override
  String get specialization => 'Specialization';

  @override
  String get experience => 'Experience';

  @override
  String get rating => 'Rating';

  @override
  String get reviews => 'Reviews';

  @override
  String get consult => 'Consult';

  @override
  String get profile => 'Profile';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get updatePersonalInfo => 'Update your personal information';

  @override
  String get notifications => 'Notifications';

  @override
  String get manageNotifications => 'Manage your notification preferences';

  @override
  String get language => 'Language';

  @override
  String get theme => 'Theme';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get lightMode => 'Light Mode';

  @override
  String get helpSupport => 'Help & Support';

  @override
  String get getHelp => 'Get help and contact support';

  @override
  String get about => 'About';

  @override
  String get appVersion => 'App version and information';

  @override
  String get settings => 'Settings';

  @override
  String get settingsComingSoon =>
      'Settings functionality will be available soon.';

  @override
  String get editProfileComingSoon =>
      'Profile editing functionality will be available soon.';

  @override
  String get notificationsComingSoon =>
      'Notification settings will be available soon.';

  @override
  String get helpContent => 'For support, please contact:';

  @override
  String get helpEmail => 'Email: support@farmsphere.com';

  @override
  String get helpPhone => 'Phone: +91 9876543210';

  @override
  String get helpWebsite => 'Or visit our website: www.farmsphere.com';

  @override
  String get aboutContent => 'An AI-Powered Farming Assistant';

  @override
  String get aboutFeatures => 'Features:';

  @override
  String get refresh => 'Refresh';

  @override
  String get currentWeatherTitle => 'Current Weather';

  @override
  String get yourLocation => 'Your Location';

  @override
  String get humidityLabel => 'Humidity';

  @override
  String get windLabel => 'Wind';

  @override
  String get visibilityLabel => 'Visibility';

  @override
  String get uvIndexLabel => 'UV Index';

  @override
  String get conditionSunny => 'Sunny';

  @override
  String get conditionPartlyCloudy => 'Partly Cloudy';

  @override
  String get conditionCloudy => 'Cloudy';

  @override
  String get conditionRainy => 'Rainy';

  @override
  String get conditionStormy => 'Stormy';

  @override
  String get conditionHaze => 'Haze';

  @override
  String get conditionFog => 'Fog';

  @override
  String get conditionUnknown => 'Unknown';

  @override
  String get dayMon => 'Mon';

  @override
  String get dayTue => 'Tue';

  @override
  String get dayWed => 'Wed';

  @override
  String get dayThu => 'Thu';

  @override
  String get dayFri => 'Fri';

  @override
  String get daySat => 'Sat';

  @override
  String get daySun => 'Sun';

  @override
  String get alertGeneric => 'Alert';

  @override
  String get alertTypeColdWave => 'Cold Wave Alert';

  @override
  String get alertTypeFogWarning => 'Fog Warning';

  @override
  String get alertTypeRain => 'Rain Alert';

  @override
  String get alertTypeHeavyRain => 'Heavy Rain Alert';

  @override
  String get alertTypeFlood => 'Flood Warning';

  @override
  String get alertTypeHeatWave => 'Heat Wave Alert';

  @override
  String get alertTypeWaterScarcity => 'Water Scarcity Warning';

  @override
  String get alertTypeFrost => 'Frost Warning';

  @override
  String get alertTypeColdWeather => 'Cold Weather Alert';

  @override
  String get alertTypePest => 'Pest Alert';

  @override
  String get alertTypeWeather => 'Weather Alert';

  @override
  String get alertTypeDisease => 'Disease Alert';

  @override
  String get alertNow => 'Now';

  @override
  String get alertSoon => 'Soon';

  @override
  String alertInHours(Object count) {
    return 'In ${count}h';
  }

  @override
  String alertInMinutes(Object count) {
    return 'In ${count}m';
  }

  @override
  String get labelSeason => 'Season';

  @override
  String get labelCategory => 'Category';

  @override
  String get labelVariety => 'Variety';

  @override
  String get labelArrival => 'Arrival';

  @override
  String get governmentMSP => 'Government MSP';

  @override
  String get schemeDetails => 'Scheme Details';

  @override
  String get description => 'Description';

  @override
  String get eligibility => 'Eligibility';

  @override
  String get benefits => 'Benefits';

  @override
  String get howToApply => 'How to Apply';

  @override
  String get officialWebsite => 'Official Website';

  @override
  String get status => 'Status';

  @override
  String get learnMore => 'Learn More';

  @override
  String get visitWebsite => 'Visit Website';

  @override
  String get activityPlanting => 'Planting';

  @override
  String get activityFertilizing => 'Fertilizing';

  @override
  String get activityIrrigation => 'Irrigation';

  @override
  String get cropRice => 'Rice';

  @override
  String get cropWheat => 'Wheat';

  @override
  String get cropMaize => 'Maize';

  @override
  String get severityHigh => 'HIGH';

  @override
  String get severityMedium => 'MEDIUM';

  @override
  String get severityLow => 'LOW';

  @override
  String get seasonKharif => 'Kharif';

  @override
  String get seasonRabi => 'Rabi';

  @override
  String get categoryCereals => 'Cereals';

  @override
  String get categoryPulses => 'Pulses';

  @override
  String get categoryOilseeds => 'Oilseeds';

  @override
  String get categoryCommercialCrops => 'Commercial Crops';

  @override
  String get stateAllIndia => 'All India';

  @override
  String get cropPaddy => 'Paddy';

  @override
  String get cropJowar => 'Jowar';

  @override
  String get cropBajra => 'Bajra';

  @override
  String get cropRagi => 'Ragi';

  @override
  String get cropArhar => 'Arhar (Tur)';

  @override
  String get cropMoong => 'Moong';

  @override
  String get cropUrad => 'Urad';

  @override
  String get cropChana => 'Chana';

  @override
  String get cropMasur => 'Masur (Lentil)';

  @override
  String get cropGroundnut => 'Groundnut';

  @override
  String get cropSesamum => 'Sesamum';

  @override
  String get cropSunflower => 'Sunflower';

  @override
  String get cropSoyabean => 'Soyabean';

  @override
  String get cropMustard => 'Mustard';

  @override
  String get cropCotton => 'Cotton';

  @override
  String get cropSugarcane => 'Sugarcane';

  @override
  String get cropJute => 'Jute';

  @override
  String get cropTomato => 'Tomato';

  @override
  String get cropPotato => 'Potato';

  @override
  String get cropOnion => 'Onion';

  @override
  String get share => 'Share';

  @override
  String get saveAction => 'Save';

  @override
  String get reportPost => 'Report Post';

  @override
  String get blockUser => 'Block User';

  @override
  String get copyLink => 'Copy Link';

  @override
  String get members => 'members';

  @override
  String get joinChat => 'Join Chat';

  @override
  String get chatFeatureComingSoon => 'Chat feature coming soon';

  @override
  String get schemeActive => 'Active';

  @override
  String get schemeInactive => 'Inactive';

  @override
  String get schemeUpcoming => 'Upcoming';

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
