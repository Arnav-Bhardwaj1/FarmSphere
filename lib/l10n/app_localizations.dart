import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_as.dart';
import 'app_localizations_bn.dart';
import 'app_localizations_brx.dart';
import 'app_localizations_doi.dart';
import 'app_localizations_en.dart';
import 'app_localizations_gu.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_kn.dart';
import 'app_localizations_kok.dart';
import 'app_localizations_ks.dart';
import 'app_localizations_mai.dart';
import 'app_localizations_ml.dart';
import 'app_localizations_mni.dart';
import 'app_localizations_mr.dart';
import 'app_localizations_ne.dart';
import 'app_localizations_or.dart';
import 'app_localizations_pa.dart';
import 'app_localizations_sa.dart';
import 'app_localizations_sat.dart';
import 'app_localizations_sd.dart';
import 'app_localizations_ta.dart';
import 'app_localizations_te.dart';
import 'app_localizations_ur.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('as'),
    Locale('bn'),
    Locale('brx'),
    Locale('doi'),
    Locale('en'),
    Locale('gu'),
    Locale('hi'),
    Locale('kn'),
    Locale('kok'),
    Locale('ks'),
    Locale('mai'),
    Locale('ml'),
    Locale('mni'),
    Locale('mr'),
    Locale('ne'),
    Locale('or'),
    Locale('pa'),
    Locale('sa'),
    Locale('sat'),
    Locale('sd'),
    Locale('ta'),
    Locale('te'),
    Locale('ur')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'FarmSphere'**
  String get appTitle;

  /// No description provided for @tagline.
  ///
  /// In en, this message translates to:
  /// **'AI-Powered Farming Assistant'**
  String get tagline;

  /// No description provided for @welcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to FarmSphere'**
  String get welcomeTitle;

  /// No description provided for @welcomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your AI-powered farming companion'**
  String get welcomeSubtitle;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location (City, State)'**
  String get location;

  /// No description provided for @locationHint.
  ///
  /// In en, this message translates to:
  /// **'Enter location or use Nokia API detection'**
  String get locationHint;

  /// No description provided for @detect.
  ///
  /// In en, this message translates to:
  /// **'Detect'**
  String get detect;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @verifyPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Verify phone number'**
  String get verifyPhoneNumber;

  /// No description provided for @featuresHeading.
  ///
  /// In en, this message translates to:
  /// **'What you\'ll get:'**
  String get featuresHeading;

  /// No description provided for @feature_ai_scanner.
  ///
  /// In en, this message translates to:
  /// **'AI Crop Health Scanner'**
  String get feature_ai_scanner;

  /// No description provided for @feature_weather.
  ///
  /// In en, this message translates to:
  /// **'Weather & Alerts'**
  String get feature_weather;

  /// No description provided for @feature_market.
  ///
  /// In en, this message translates to:
  /// **'Market Prices & Schemes'**
  String get feature_market;

  /// No description provided for @feature_voice_local.
  ///
  /// In en, this message translates to:
  /// **'Voice & Local Language Support'**
  String get feature_voice_local;

  /// No description provided for @feature_activity.
  ///
  /// In en, this message translates to:
  /// **'Activity Logging & Analytics'**
  String get feature_activity;

  /// No description provided for @feature_community.
  ///
  /// In en, this message translates to:
  /// **'Farmer Community Platform'**
  String get feature_community;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @chooseLanguageToContinue.
  ///
  /// In en, this message translates to:
  /// **'Choose your language to continue'**
  String get chooseLanguageToContinue;

  /// No description provided for @rContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get rContinue;

  /// No description provided for @changeLanguageSuccess.
  ///
  /// In en, this message translates to:
  /// **'Language changed to {language}'**
  String changeLanguageSuccess(Object language);

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @logoutConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logoutConfirmTitle;

  /// No description provided for @logoutConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get logoutConfirmBody;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navCropHealth.
  ///
  /// In en, this message translates to:
  /// **'Crop Health'**
  String get navCropHealth;

  /// No description provided for @navWeather.
  ///
  /// In en, this message translates to:
  /// **'Weather'**
  String get navWeather;

  /// No description provided for @navMarket.
  ///
  /// In en, this message translates to:
  /// **'Market'**
  String get navMarket;

  /// No description provided for @navActivities.
  ///
  /// In en, this message translates to:
  /// **'Activities'**
  String get navActivities;

  /// No description provided for @navCommunity.
  ///
  /// In en, this message translates to:
  /// **'Community'**
  String get navCommunity;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @chatbotTitle.
  ///
  /// In en, this message translates to:
  /// **'FarmSphere AI Assistant'**
  String get chatbotTitle;

  /// No description provided for @chatbotHint.
  ///
  /// In en, this message translates to:
  /// **'Ask me about farming...'**
  String get chatbotHint;

  /// No description provided for @listening.
  ///
  /// In en, this message translates to:
  /// **'Listening...'**
  String get listening;

  /// No description provided for @tapToSpeak.
  ///
  /// In en, this message translates to:
  /// **'Tap microphone to speak'**
  String get tapToSpeak;

  /// No description provided for @speaking.
  ///
  /// In en, this message translates to:
  /// **'Speaking...'**
  String get speaking;

  /// No description provided for @tapToStop.
  ///
  /// In en, this message translates to:
  /// **'Tap to stop'**
  String get tapToStop;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back,'**
  String get welcomeBack;

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// No description provided for @scanCrop.
  ///
  /// In en, this message translates to:
  /// **'Scan Crop'**
  String get scanCrop;

  /// No description provided for @voiceHelp.
  ///
  /// In en, this message translates to:
  /// **'Voice Help'**
  String get voiceHelp;

  /// No description provided for @logActivity.
  ///
  /// In en, this message translates to:
  /// **'Log Activity'**
  String get logActivity;

  /// No description provided for @aiAssistant.
  ///
  /// In en, this message translates to:
  /// **'AI Assistant'**
  String get aiAssistant;

  /// No description provided for @community.
  ///
  /// In en, this message translates to:
  /// **'Community'**
  String get community;

  /// No description provided for @help.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get help;

  /// No description provided for @features.
  ///
  /// In en, this message translates to:
  /// **'Features'**
  String get features;

  /// No description provided for @importantAlerts.
  ///
  /// In en, this message translates to:
  /// **'Important Alerts'**
  String get importantAlerts;

  /// No description provided for @recentActivities.
  ///
  /// In en, this message translates to:
  /// **'Recent Activities'**
  String get recentActivities;

  /// No description provided for @noActivitiesYet.
  ///
  /// In en, this message translates to:
  /// **'No activities yet'**
  String get noActivitiesYet;

  /// No description provided for @startLoggingActivities.
  ///
  /// In en, this message translates to:
  /// **'Start logging your farm activities'**
  String get startLoggingActivities;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @daysAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} days ago'**
  String daysAgo(Object count);

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming Soon'**
  String get comingSoon;

  /// No description provided for @featureUnderDevelopment.
  ///
  /// In en, this message translates to:
  /// **'This feature is under development and will be available soon.'**
  String get featureUnderDevelopment;

  /// No description provided for @aiCropHealth.
  ///
  /// In en, this message translates to:
  /// **'AI Crop Health'**
  String get aiCropHealth;

  /// No description provided for @scanDiagnoseDiseases.
  ///
  /// In en, this message translates to:
  /// **'Scan and diagnose crop diseases'**
  String get scanDiagnoseDiseases;

  /// No description provided for @weatherAlerts.
  ///
  /// In en, this message translates to:
  /// **'Weather & Alerts'**
  String get weatherAlerts;

  /// No description provided for @getWeatherUpdates.
  ///
  /// In en, this message translates to:
  /// **'Get weather updates and alerts'**
  String get getWeatherUpdates;

  /// No description provided for @marketPrices.
  ///
  /// In en, this message translates to:
  /// **'Market Prices'**
  String get marketPrices;

  /// No description provided for @checkPricesSchemes.
  ///
  /// In en, this message translates to:
  /// **'Check crop prices and schemes'**
  String get checkPricesSchemes;

  /// No description provided for @analytics.
  ///
  /// In en, this message translates to:
  /// **'Analytics'**
  String get analytics;

  /// No description provided for @trackActivities.
  ///
  /// In en, this message translates to:
  /// **'Track your farm activities'**
  String get trackActivities;

  /// No description provided for @helpComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Help feature coming soon!'**
  String get helpComingSoon;

  /// No description provided for @aiCropHealthScanner.
  ///
  /// In en, this message translates to:
  /// **'AI Crop Health Scanner'**
  String get aiCropHealthScanner;

  /// No description provided for @howToUse.
  ///
  /// In en, this message translates to:
  /// **'How to use'**
  String get howToUse;

  /// No description provided for @cropHealthInstructions.
  ///
  /// In en, this message translates to:
  /// **'Take a clear photo of the affected plant part or describe the symptoms you\'re observing. Our AI will analyze and provide diagnosis and treatment recommendations.'**
  String get cropHealthInstructions;

  /// No description provided for @uploadImage.
  ///
  /// In en, this message translates to:
  /// **'Upload Image'**
  String get uploadImage;

  /// No description provided for @retake.
  ///
  /// In en, this message translates to:
  /// **'Retake'**
  String get retake;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @noImageSelected.
  ///
  /// In en, this message translates to:
  /// **'No image selected'**
  String get noImageSelected;

  /// No description provided for @takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take Photo'**
  String get takePhoto;

  /// No description provided for @orDescribeSymptoms.
  ///
  /// In en, this message translates to:
  /// **'Or Describe Symptoms'**
  String get orDescribeSymptoms;

  /// No description provided for @describeSymptomsHint.
  ///
  /// In en, this message translates to:
  /// **'Describe the symptoms you\'re observing...\n\nExample: \"Yellow spots on leaves, wilting, brown edges\"'**
  String get describeSymptomsHint;

  /// No description provided for @aiDiseaseDetection.
  ///
  /// In en, this message translates to:
  /// **'AI Disease Detection'**
  String get aiDiseaseDetection;

  /// No description provided for @analyzeCropHealth.
  ///
  /// In en, this message translates to:
  /// **'Analyze Crop Health'**
  String get analyzeCropHealth;

  /// No description provided for @analyzing.
  ///
  /// In en, this message translates to:
  /// **'Analyzing...'**
  String get analyzing;

  /// No description provided for @analysisResult.
  ///
  /// In en, this message translates to:
  /// **'Analysis Result'**
  String get analysisResult;

  /// No description provided for @recentDiagnoses.
  ///
  /// In en, this message translates to:
  /// **'Recent Diagnoses'**
  String get recentDiagnoses;

  /// No description provided for @diagnosisHistory.
  ///
  /// In en, this message translates to:
  /// **'Diagnosis History'**
  String get diagnosisHistory;

  /// No description provided for @noDiagnosisHistory.
  ///
  /// In en, this message translates to:
  /// **'No diagnosis history available'**
  String get noDiagnosisHistory;

  /// No description provided for @pleaseProvideImageOrDescription.
  ///
  /// In en, this message translates to:
  /// **'Please provide an image or description'**
  String get pleaseProvideImageOrDescription;

  /// No description provided for @errorPickingImage.
  ///
  /// In en, this message translates to:
  /// **'Error picking image: {error}'**
  String errorPickingImage(Object error);

  /// No description provided for @analysisFailed.
  ///
  /// In en, this message translates to:
  /// **'Analysis failed: {error}'**
  String analysisFailed(Object error);

  /// No description provided for @analyzingCropHealth.
  ///
  /// In en, this message translates to:
  /// **'Analyzing crop health...\nThis may take a few moments'**
  String get analyzingCropHealth;

  /// No description provided for @weatherAlertsTitle.
  ///
  /// In en, this message translates to:
  /// **'Weather & Alerts'**
  String get weatherAlertsTitle;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @failedToLoadWeather.
  ///
  /// In en, this message translates to:
  /// **'Failed to load weather data'**
  String get failedToLoadWeather;

  /// No description provided for @dayForecast.
  ///
  /// In en, this message translates to:
  /// **'7-Day Forecast'**
  String get dayForecast;

  /// No description provided for @weatherAlertsSection.
  ///
  /// In en, this message translates to:
  /// **'Weather Alerts'**
  String get weatherAlertsSection;

  /// No description provided for @weatherTips.
  ///
  /// In en, this message translates to:
  /// **'Weather Tips'**
  String get weatherTips;

  /// No description provided for @irrigation.
  ///
  /// In en, this message translates to:
  /// **'Irrigation'**
  String get irrigation;

  /// No description provided for @irrigationTip.
  ///
  /// In en, this message translates to:
  /// **'Water your crops early morning or late evening to reduce evaporation.'**
  String get irrigationTip;

  /// No description provided for @sunProtection.
  ///
  /// In en, this message translates to:
  /// **'Sun Protection'**
  String get sunProtection;

  /// No description provided for @sunProtectionTip.
  ///
  /// In en, this message translates to:
  /// **'Use shade nets during extreme heat to protect young plants.'**
  String get sunProtectionTip;

  /// No description provided for @rainManagement.
  ///
  /// In en, this message translates to:
  /// **'Rain Management'**
  String get rainManagement;

  /// No description provided for @rainManagementTip.
  ///
  /// In en, this message translates to:
  /// **'Ensure proper drainage to prevent waterlogging during heavy rains.'**
  String get rainManagementTip;

  /// No description provided for @windProtection.
  ///
  /// In en, this message translates to:
  /// **'Wind Protection'**
  String get windProtection;

  /// No description provided for @windProtectionTip.
  ///
  /// In en, this message translates to:
  /// **'Install windbreaks to protect crops from strong winds.'**
  String get windProtectionTip;

  /// No description provided for @marketPricesSchemes.
  ///
  /// In en, this message translates to:
  /// **'Market Prices & Schemes'**
  String get marketPricesSchemes;

  /// No description provided for @msp.
  ///
  /// In en, this message translates to:
  /// **'MSP'**
  String get msp;

  /// No description provided for @marketTab.
  ///
  /// In en, this message translates to:
  /// **'Market'**
  String get marketTab;

  /// No description provided for @schemesTab.
  ///
  /// In en, this message translates to:
  /// **'Schemes'**
  String get schemesTab;

  /// No description provided for @minimumSupportPrice.
  ///
  /// In en, this message translates to:
  /// **'Minimum Support Price (MSP)'**
  String get minimumSupportPrice;

  /// No description provided for @mspDescription.
  ///
  /// In en, this message translates to:
  /// **'Government guaranteed minimum prices for agricultural commodities. These prices are announced before each sowing season to help farmers make informed decisions.'**
  String get mspDescription;

  /// No description provided for @currentMSPRates.
  ///
  /// In en, this message translates to:
  /// **'Current MSP Rates (2024-25)'**
  String get currentMSPRates;

  /// No description provided for @failedToLoadMSP.
  ///
  /// In en, this message translates to:
  /// **'Failed to load MSP data'**
  String get failedToLoadMSP;

  /// No description provided for @noMSPData.
  ///
  /// In en, this message translates to:
  /// **'No MSP data available'**
  String get noMSPData;

  /// No description provided for @marketPricesTitle.
  ///
  /// In en, this message translates to:
  /// **'Market Prices'**
  String get marketPricesTitle;

  /// No description provided for @marketPricesDescription.
  ///
  /// In en, this message translates to:
  /// **'Real-time crop prices from major mandis across India. Prices are updated regularly and reflect current market conditions.'**
  String get marketPricesDescription;

  /// No description provided for @currentMarketPrices.
  ///
  /// In en, this message translates to:
  /// **'Current Market Prices'**
  String get currentMarketPrices;

  /// No description provided for @failedToLoadMarket.
  ///
  /// In en, this message translates to:
  /// **'Failed to load market data'**
  String get failedToLoadMarket;

  /// No description provided for @noMarketData.
  ///
  /// In en, this message translates to:
  /// **'No market data available'**
  String get noMarketData;

  /// No description provided for @governmentSchemes.
  ///
  /// In en, this message translates to:
  /// **'Government Schemes'**
  String get governmentSchemes;

  /// No description provided for @schemesDescription.
  ///
  /// In en, this message translates to:
  /// **'Explore various government schemes and subsidies available for farmers. Check eligibility and apply online.'**
  String get schemesDescription;

  /// No description provided for @failedToLoadSchemes.
  ///
  /// In en, this message translates to:
  /// **'Failed to load schemes data'**
  String get failedToLoadSchemes;

  /// No description provided for @availableSchemes.
  ///
  /// In en, this message translates to:
  /// **'Available Schemes'**
  String get availableSchemes;

  /// No description provided for @noSchemesAvailable.
  ///
  /// In en, this message translates to:
  /// **'No schemes available'**
  String get noSchemesAvailable;

  /// No description provided for @activitiesAnalytics.
  ///
  /// In en, this message translates to:
  /// **'Activities & Analytics'**
  String get activitiesAnalytics;

  /// No description provided for @activities.
  ///
  /// In en, this message translates to:
  /// **'Activities'**
  String get activities;

  /// No description provided for @analyticsTab.
  ///
  /// In en, this message translates to:
  /// **'Analytics'**
  String get analyticsTab;

  /// No description provided for @totalActivities.
  ///
  /// In en, this message translates to:
  /// **'Total Activities'**
  String get totalActivities;

  /// No description provided for @thisMonth.
  ///
  /// In en, this message translates to:
  /// **'This Month'**
  String get thisMonth;

  /// No description provided for @failedToLoadActivities.
  ///
  /// In en, this message translates to:
  /// **'Failed to load activities'**
  String get failedToLoadActivities;

  /// No description provided for @addActivity.
  ///
  /// In en, this message translates to:
  /// **'Add Activity'**
  String get addActivity;

  /// No description provided for @productivityOverview.
  ///
  /// In en, this message translates to:
  /// **'Productivity Overview'**
  String get productivityOverview;

  /// No description provided for @overallProductivityLabel.
  ///
  /// In en, this message translates to:
  /// **'Overall Productivity'**
  String get overallProductivityLabel;

  /// No description provided for @cropDistribution.
  ///
  /// In en, this message translates to:
  /// **'Crop Distribution'**
  String get cropDistribution;

  /// No description provided for @activityTips.
  ///
  /// In en, this message translates to:
  /// **'Activity Tips'**
  String get activityTips;

  /// No description provided for @regularLogging.
  ///
  /// In en, this message translates to:
  /// **'Regular Logging'**
  String get regularLogging;

  /// No description provided for @regularLoggingTip.
  ///
  /// In en, this message translates to:
  /// **'Log activities daily for better insights and recommendations.'**
  String get regularLoggingTip;

  /// No description provided for @photoDocumentation.
  ///
  /// In en, this message translates to:
  /// **'Photo Documentation'**
  String get photoDocumentation;

  /// No description provided for @photoDocumentationTip.
  ///
  /// In en, this message translates to:
  /// **'Take photos of your activities for visual tracking.'**
  String get photoDocumentationTip;

  /// No description provided for @reviewAnalytics.
  ///
  /// In en, this message translates to:
  /// **'Review Analytics'**
  String get reviewAnalytics;

  /// No description provided for @reviewAnalyticsTip.
  ///
  /// In en, this message translates to:
  /// **'Check your productivity trends and optimize accordingly.'**
  String get reviewAnalyticsTip;

  /// No description provided for @chatGeneralDiscussion.
  ///
  /// In en, this message translates to:
  /// **'General Discussion'**
  String get chatGeneralDiscussion;

  /// No description provided for @chatCropHealthHelp.
  ///
  /// In en, this message translates to:
  /// **'Crop Health Help'**
  String get chatCropHealthHelp;

  /// No description provided for @chatMarketPrices.
  ///
  /// In en, this message translates to:
  /// **'Market Prices'**
  String get chatMarketPrices;

  /// No description provided for @alertMessageColdWave.
  ///
  /// In en, this message translates to:
  /// **'Temperature drop expected. Protect sensitive crops with proper covering.'**
  String get alertMessageColdWave;

  /// No description provided for @alertMessageFog.
  ///
  /// In en, this message translates to:
  /// **'Dense fog expected in early morning. Avoid field operations during low visibility.'**
  String get alertMessageFog;

  /// No description provided for @alertMessageHeavyRain.
  ///
  /// In en, this message translates to:
  /// **'Heavy rainfall expected in next 24 hours. Avoid field work and protect harvested crops.'**
  String get alertMessageHeavyRain;

  /// No description provided for @alertMessageFlood.
  ///
  /// In en, this message translates to:
  /// **'Waterlogging possible in low-lying areas. Ensure proper drainage for your fields.'**
  String get alertMessageFlood;

  /// No description provided for @alertMessageHeatWave.
  ///
  /// In en, this message translates to:
  /// **'High temperature expected (above 40°C). Ensure adequate irrigation for your crops.'**
  String get alertMessageHeatWave;

  /// No description provided for @alertMessageWaterScarcity.
  ///
  /// In en, this message translates to:
  /// **'Low humidity levels detected. Increase irrigation frequency for sensitive crops.'**
  String get alertMessageWaterScarcity;

  /// No description provided for @alertMessageFrost.
  ///
  /// In en, this message translates to:
  /// **'Frost conditions expected tonight. Cover sensitive crops to prevent damage.'**
  String get alertMessageFrost;

  /// No description provided for @alertMessageColdWeather.
  ///
  /// In en, this message translates to:
  /// **'Temperatures below 10°C expected. Ensure proper crop protection measures.'**
  String get alertMessageColdWeather;

  /// No description provided for @conditionMist.
  ///
  /// In en, this message translates to:
  /// **'Mist'**
  String get conditionMist;

  /// No description provided for @addActivityTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Activity'**
  String get addActivityTitle;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @activityType.
  ///
  /// In en, this message translates to:
  /// **'Activity Type'**
  String get activityType;

  /// No description provided for @selectActivityType.
  ///
  /// In en, this message translates to:
  /// **'Select activity type'**
  String get selectActivityType;

  /// No description provided for @pleaseSelectActivityType.
  ///
  /// In en, this message translates to:
  /// **'Please select an activity type'**
  String get pleaseSelectActivityType;

  /// No description provided for @crop.
  ///
  /// In en, this message translates to:
  /// **'Crop'**
  String get crop;

  /// No description provided for @selectCrop.
  ///
  /// In en, this message translates to:
  /// **'Select crop'**
  String get selectCrop;

  /// No description provided for @pleaseSelectCrop.
  ///
  /// In en, this message translates to:
  /// **'Please select a crop'**
  String get pleaseSelectCrop;

  /// No description provided for @notesOptional.
  ///
  /// In en, this message translates to:
  /// **'Notes (Optional)'**
  String get notesOptional;

  /// No description provided for @addNotesHint.
  ///
  /// In en, this message translates to:
  /// **'Add any additional notes about this activity...'**
  String get addNotesHint;

  /// No description provided for @quickTips.
  ///
  /// In en, this message translates to:
  /// **'Quick Tips'**
  String get quickTips;

  /// No description provided for @tipBeSpecific.
  ///
  /// In en, this message translates to:
  /// **'Be specific about the activity performed'**
  String get tipBeSpecific;

  /// No description provided for @tipIncludeQuantities.
  ///
  /// In en, this message translates to:
  /// **'Include quantities, measurements, or time spent'**
  String get tipIncludeQuantities;

  /// No description provided for @tipNoteWeather.
  ///
  /// In en, this message translates to:
  /// **'Note weather conditions if relevant'**
  String get tipNoteWeather;

  /// No description provided for @tipAddPhotos.
  ///
  /// In en, this message translates to:
  /// **'Add photos if possible for better tracking'**
  String get tipAddPhotos;

  /// No description provided for @activityAddedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Activity added successfully'**
  String get activityAddedSuccess;

  /// No description provided for @failedToAddActivity.
  ///
  /// In en, this message translates to:
  /// **'Failed to add activity: {error}'**
  String failedToAddActivity(Object error);

  /// No description provided for @farmerCommunity.
  ///
  /// In en, this message translates to:
  /// **'Farmer Community'**
  String get farmerCommunity;

  /// No description provided for @posts.
  ///
  /// In en, this message translates to:
  /// **'Posts'**
  String get posts;

  /// No description provided for @chat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get chat;

  /// No description provided for @experts.
  ///
  /// In en, this message translates to:
  /// **'Experts'**
  String get experts;

  /// No description provided for @activeFarmers.
  ///
  /// In en, this message translates to:
  /// **'Active Farmers'**
  String get activeFarmers;

  /// No description provided for @postsToday.
  ///
  /// In en, this message translates to:
  /// **'Posts Today'**
  String get postsToday;

  /// No description provided for @questionsSolved.
  ///
  /// In en, this message translates to:
  /// **'Questions Solved'**
  String get questionsSolved;

  /// No description provided for @createPost.
  ///
  /// In en, this message translates to:
  /// **'Create Post'**
  String get createPost;

  /// No description provided for @postCreationComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Post creation functionality will be available soon.'**
  String get postCreationComingSoon;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @consultationComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Consultation feature coming soon'**
  String get consultationComingSoon;

  /// No description provided for @startConsultation.
  ///
  /// In en, this message translates to:
  /// **'Start Consultation'**
  String get startConsultation;

  /// No description provided for @specialization.
  ///
  /// In en, this message translates to:
  /// **'Specialization'**
  String get specialization;

  /// No description provided for @experience.
  ///
  /// In en, this message translates to:
  /// **'Experience'**
  String get experience;

  /// No description provided for @rating.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get rating;

  /// No description provided for @reviews.
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get reviews;

  /// No description provided for @consult.
  ///
  /// In en, this message translates to:
  /// **'Consult'**
  String get consult;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @updatePersonalInfo.
  ///
  /// In en, this message translates to:
  /// **'Update your personal information'**
  String get updatePersonalInfo;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @manageNotifications.
  ///
  /// In en, this message translates to:
  /// **'Manage your notification preferences'**
  String get manageNotifications;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @lightMode.
  ///
  /// In en, this message translates to:
  /// **'Light Mode'**
  String get lightMode;

  /// No description provided for @helpSupport.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpSupport;

  /// No description provided for @getHelp.
  ///
  /// In en, this message translates to:
  /// **'Get help and contact support'**
  String get getHelp;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @appVersion.
  ///
  /// In en, this message translates to:
  /// **'App version and information'**
  String get appVersion;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @settingsComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Settings functionality will be available soon.'**
  String get settingsComingSoon;

  /// No description provided for @editProfileComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Profile editing functionality will be available soon.'**
  String get editProfileComingSoon;

  /// No description provided for @notificationsComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Notification settings will be available soon.'**
  String get notificationsComingSoon;

  /// No description provided for @helpContent.
  ///
  /// In en, this message translates to:
  /// **'For support, please contact:'**
  String get helpContent;

  /// No description provided for @helpEmail.
  ///
  /// In en, this message translates to:
  /// **'Email: support@farmsphere.com'**
  String get helpEmail;

  /// No description provided for @helpPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone: +91 9876543210'**
  String get helpPhone;

  /// No description provided for @helpWebsite.
  ///
  /// In en, this message translates to:
  /// **'Or visit our website: www.farmsphere.com'**
  String get helpWebsite;

  /// No description provided for @aboutContent.
  ///
  /// In en, this message translates to:
  /// **'An AI-Powered Farming Assistant'**
  String get aboutContent;

  /// No description provided for @aboutFeatures.
  ///
  /// In en, this message translates to:
  /// **'Features:'**
  String get aboutFeatures;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @currentWeatherTitle.
  ///
  /// In en, this message translates to:
  /// **'Current Weather'**
  String get currentWeatherTitle;

  /// No description provided for @yourLocation.
  ///
  /// In en, this message translates to:
  /// **'Your Location'**
  String get yourLocation;

  /// No description provided for @humidityLabel.
  ///
  /// In en, this message translates to:
  /// **'Humidity'**
  String get humidityLabel;

  /// No description provided for @windLabel.
  ///
  /// In en, this message translates to:
  /// **'Wind'**
  String get windLabel;

  /// No description provided for @visibilityLabel.
  ///
  /// In en, this message translates to:
  /// **'Visibility'**
  String get visibilityLabel;

  /// No description provided for @uvIndexLabel.
  ///
  /// In en, this message translates to:
  /// **'UV Index'**
  String get uvIndexLabel;

  /// No description provided for @conditionSunny.
  ///
  /// In en, this message translates to:
  /// **'Sunny'**
  String get conditionSunny;

  /// No description provided for @conditionPartlyCloudy.
  ///
  /// In en, this message translates to:
  /// **'Partly Cloudy'**
  String get conditionPartlyCloudy;

  /// No description provided for @conditionCloudy.
  ///
  /// In en, this message translates to:
  /// **'Cloudy'**
  String get conditionCloudy;

  /// No description provided for @conditionRainy.
  ///
  /// In en, this message translates to:
  /// **'Rainy'**
  String get conditionRainy;

  /// No description provided for @conditionStormy.
  ///
  /// In en, this message translates to:
  /// **'Stormy'**
  String get conditionStormy;

  /// No description provided for @conditionHaze.
  ///
  /// In en, this message translates to:
  /// **'Haze'**
  String get conditionHaze;

  /// No description provided for @conditionFog.
  ///
  /// In en, this message translates to:
  /// **'Fog'**
  String get conditionFog;

  /// No description provided for @conditionUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get conditionUnknown;

  /// No description provided for @dayMon.
  ///
  /// In en, this message translates to:
  /// **'Mon'**
  String get dayMon;

  /// No description provided for @dayTue.
  ///
  /// In en, this message translates to:
  /// **'Tue'**
  String get dayTue;

  /// No description provided for @dayWed.
  ///
  /// In en, this message translates to:
  /// **'Wed'**
  String get dayWed;

  /// No description provided for @dayThu.
  ///
  /// In en, this message translates to:
  /// **'Thu'**
  String get dayThu;

  /// No description provided for @dayFri.
  ///
  /// In en, this message translates to:
  /// **'Fri'**
  String get dayFri;

  /// No description provided for @daySat.
  ///
  /// In en, this message translates to:
  /// **'Sat'**
  String get daySat;

  /// No description provided for @daySun.
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get daySun;

  /// No description provided for @alertGeneric.
  ///
  /// In en, this message translates to:
  /// **'Alert'**
  String get alertGeneric;

  /// No description provided for @alertTypeColdWave.
  ///
  /// In en, this message translates to:
  /// **'Cold Wave Alert'**
  String get alertTypeColdWave;

  /// No description provided for @alertTypeFogWarning.
  ///
  /// In en, this message translates to:
  /// **'Fog Warning'**
  String get alertTypeFogWarning;

  /// No description provided for @alertTypeRain.
  ///
  /// In en, this message translates to:
  /// **'Rain Alert'**
  String get alertTypeRain;

  /// No description provided for @alertTypeHeavyRain.
  ///
  /// In en, this message translates to:
  /// **'Heavy Rain Alert'**
  String get alertTypeHeavyRain;

  /// No description provided for @alertTypeFlood.
  ///
  /// In en, this message translates to:
  /// **'Flood Warning'**
  String get alertTypeFlood;

  /// No description provided for @alertTypeHeatWave.
  ///
  /// In en, this message translates to:
  /// **'Heat Wave Alert'**
  String get alertTypeHeatWave;

  /// No description provided for @alertTypeWaterScarcity.
  ///
  /// In en, this message translates to:
  /// **'Water Scarcity Warning'**
  String get alertTypeWaterScarcity;

  /// No description provided for @alertTypeFrost.
  ///
  /// In en, this message translates to:
  /// **'Frost Warning'**
  String get alertTypeFrost;

  /// No description provided for @alertTypeColdWeather.
  ///
  /// In en, this message translates to:
  /// **'Cold Weather Alert'**
  String get alertTypeColdWeather;

  /// No description provided for @alertTypePest.
  ///
  /// In en, this message translates to:
  /// **'Pest Alert'**
  String get alertTypePest;

  /// No description provided for @alertTypeWeather.
  ///
  /// In en, this message translates to:
  /// **'Weather Alert'**
  String get alertTypeWeather;

  /// No description provided for @alertTypeDisease.
  ///
  /// In en, this message translates to:
  /// **'Disease Alert'**
  String get alertTypeDisease;

  /// No description provided for @alertNow.
  ///
  /// In en, this message translates to:
  /// **'Now'**
  String get alertNow;

  /// No description provided for @alertSoon.
  ///
  /// In en, this message translates to:
  /// **'Soon'**
  String get alertSoon;

  /// No description provided for @alertInHours.
  ///
  /// In en, this message translates to:
  /// **'In {count}h'**
  String alertInHours(Object count);

  /// No description provided for @alertInMinutes.
  ///
  /// In en, this message translates to:
  /// **'In {count}m'**
  String alertInMinutes(Object count);

  /// No description provided for @labelSeason.
  ///
  /// In en, this message translates to:
  /// **'Season'**
  String get labelSeason;

  /// No description provided for @labelCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get labelCategory;

  /// No description provided for @labelVariety.
  ///
  /// In en, this message translates to:
  /// **'Variety'**
  String get labelVariety;

  /// No description provided for @labelArrival.
  ///
  /// In en, this message translates to:
  /// **'Arrival'**
  String get labelArrival;

  /// No description provided for @governmentMSP.
  ///
  /// In en, this message translates to:
  /// **'Government MSP'**
  String get governmentMSP;

  /// No description provided for @schemeDetails.
  ///
  /// In en, this message translates to:
  /// **'Scheme Details'**
  String get schemeDetails;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @eligibility.
  ///
  /// In en, this message translates to:
  /// **'Eligibility'**
  String get eligibility;

  /// No description provided for @benefits.
  ///
  /// In en, this message translates to:
  /// **'Benefits'**
  String get benefits;

  /// No description provided for @howToApply.
  ///
  /// In en, this message translates to:
  /// **'How to Apply'**
  String get howToApply;

  /// No description provided for @officialWebsite.
  ///
  /// In en, this message translates to:
  /// **'Official Website'**
  String get officialWebsite;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @learnMore.
  ///
  /// In en, this message translates to:
  /// **'Learn More'**
  String get learnMore;

  /// No description provided for @visitWebsite.
  ///
  /// In en, this message translates to:
  /// **'Visit Website'**
  String get visitWebsite;

  /// No description provided for @activityPlanting.
  ///
  /// In en, this message translates to:
  /// **'Planting'**
  String get activityPlanting;

  /// No description provided for @activityFertilizing.
  ///
  /// In en, this message translates to:
  /// **'Fertilizing'**
  String get activityFertilizing;

  /// No description provided for @activityIrrigation.
  ///
  /// In en, this message translates to:
  /// **'Irrigation'**
  String get activityIrrigation;

  /// No description provided for @cropRice.
  ///
  /// In en, this message translates to:
  /// **'Rice'**
  String get cropRice;

  /// No description provided for @cropWheat.
  ///
  /// In en, this message translates to:
  /// **'Wheat'**
  String get cropWheat;

  /// No description provided for @cropMaize.
  ///
  /// In en, this message translates to:
  /// **'Maize'**
  String get cropMaize;

  /// No description provided for @severityHigh.
  ///
  /// In en, this message translates to:
  /// **'HIGH'**
  String get severityHigh;

  /// No description provided for @severityMedium.
  ///
  /// In en, this message translates to:
  /// **'MEDIUM'**
  String get severityMedium;

  /// No description provided for @severityLow.
  ///
  /// In en, this message translates to:
  /// **'LOW'**
  String get severityLow;

  /// No description provided for @seasonKharif.
  ///
  /// In en, this message translates to:
  /// **'Kharif'**
  String get seasonKharif;

  /// No description provided for @seasonRabi.
  ///
  /// In en, this message translates to:
  /// **'Rabi'**
  String get seasonRabi;

  /// No description provided for @categoryCereals.
  ///
  /// In en, this message translates to:
  /// **'Cereals'**
  String get categoryCereals;

  /// No description provided for @categoryPulses.
  ///
  /// In en, this message translates to:
  /// **'Pulses'**
  String get categoryPulses;

  /// No description provided for @categoryOilseeds.
  ///
  /// In en, this message translates to:
  /// **'Oilseeds'**
  String get categoryOilseeds;

  /// No description provided for @categoryCommercialCrops.
  ///
  /// In en, this message translates to:
  /// **'Commercial Crops'**
  String get categoryCommercialCrops;

  /// No description provided for @stateAllIndia.
  ///
  /// In en, this message translates to:
  /// **'All India'**
  String get stateAllIndia;

  /// No description provided for @cropPaddy.
  ///
  /// In en, this message translates to:
  /// **'Paddy'**
  String get cropPaddy;

  /// No description provided for @cropJowar.
  ///
  /// In en, this message translates to:
  /// **'Jowar'**
  String get cropJowar;

  /// No description provided for @cropBajra.
  ///
  /// In en, this message translates to:
  /// **'Bajra'**
  String get cropBajra;

  /// No description provided for @cropRagi.
  ///
  /// In en, this message translates to:
  /// **'Ragi'**
  String get cropRagi;

  /// No description provided for @cropArhar.
  ///
  /// In en, this message translates to:
  /// **'Arhar (Tur)'**
  String get cropArhar;

  /// No description provided for @cropMoong.
  ///
  /// In en, this message translates to:
  /// **'Moong'**
  String get cropMoong;

  /// No description provided for @cropUrad.
  ///
  /// In en, this message translates to:
  /// **'Urad'**
  String get cropUrad;

  /// No description provided for @cropChana.
  ///
  /// In en, this message translates to:
  /// **'Chana'**
  String get cropChana;

  /// No description provided for @cropMasur.
  ///
  /// In en, this message translates to:
  /// **'Masur (Lentil)'**
  String get cropMasur;

  /// No description provided for @cropGroundnut.
  ///
  /// In en, this message translates to:
  /// **'Groundnut'**
  String get cropGroundnut;

  /// No description provided for @cropSesamum.
  ///
  /// In en, this message translates to:
  /// **'Sesamum'**
  String get cropSesamum;

  /// No description provided for @cropSunflower.
  ///
  /// In en, this message translates to:
  /// **'Sunflower'**
  String get cropSunflower;

  /// No description provided for @cropSoyabean.
  ///
  /// In en, this message translates to:
  /// **'Soyabean'**
  String get cropSoyabean;

  /// No description provided for @cropMustard.
  ///
  /// In en, this message translates to:
  /// **'Mustard'**
  String get cropMustard;

  /// No description provided for @cropCotton.
  ///
  /// In en, this message translates to:
  /// **'Cotton'**
  String get cropCotton;

  /// No description provided for @cropSugarcane.
  ///
  /// In en, this message translates to:
  /// **'Sugarcane'**
  String get cropSugarcane;

  /// No description provided for @cropJute.
  ///
  /// In en, this message translates to:
  /// **'Jute'**
  String get cropJute;

  /// No description provided for @cropTomato.
  ///
  /// In en, this message translates to:
  /// **'Tomato'**
  String get cropTomato;

  /// No description provided for @cropPotato.
  ///
  /// In en, this message translates to:
  /// **'Potato'**
  String get cropPotato;

  /// No description provided for @cropOnion.
  ///
  /// In en, this message translates to:
  /// **'Onion'**
  String get cropOnion;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @saveAction.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get saveAction;

  /// No description provided for @reportPost.
  ///
  /// In en, this message translates to:
  /// **'Report Post'**
  String get reportPost;

  /// No description provided for @blockUser.
  ///
  /// In en, this message translates to:
  /// **'Block User'**
  String get blockUser;

  /// No description provided for @copyLink.
  ///
  /// In en, this message translates to:
  /// **'Copy Link'**
  String get copyLink;

  /// No description provided for @members.
  ///
  /// In en, this message translates to:
  /// **'members'**
  String get members;

  /// No description provided for @joinChat.
  ///
  /// In en, this message translates to:
  /// **'Join Chat'**
  String get joinChat;

  /// No description provided for @chatFeatureComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Chat feature coming soon'**
  String get chatFeatureComingSoon;

  /// No description provided for @schemeActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get schemeActive;

  /// No description provided for @schemeInactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get schemeInactive;

  /// No description provided for @schemeUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get schemeUpcoming;

  /// No description provided for @postContent.
  ///
  /// In en, this message translates to:
  /// **'Post Content'**
  String get postContent;

  /// No description provided for @postContentHint.
  ///
  /// In en, this message translates to:
  /// **'Share your farming experience, ask questions, or help other farmers...'**
  String get postContentHint;

  /// No description provided for @tags.
  ///
  /// In en, this message translates to:
  /// **'Tags'**
  String get tags;

  /// No description provided for @tagsHint.
  ///
  /// In en, this message translates to:
  /// **'Add tags (e.g., Wheat, Harvest, Disease) - separate with commas'**
  String get tagsHint;

  /// No description provided for @postCreatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Post created successfully!'**
  String get postCreatedSuccess;

  /// No description provided for @pleaseEnterContent.
  ///
  /// In en, this message translates to:
  /// **'Please enter post content'**
  String get pleaseEnterContent;

  /// No description provided for @addComment.
  ///
  /// In en, this message translates to:
  /// **'Add Comment'**
  String get addComment;

  /// No description provided for @commentHint.
  ///
  /// In en, this message translates to:
  /// **'Write a comment...'**
  String get commentHint;

  /// No description provided for @comment.
  ///
  /// In en, this message translates to:
  /// **'Comment'**
  String get comment;

  /// No description provided for @comments.
  ///
  /// In en, this message translates to:
  /// **'Comments'**
  String get comments;

  /// No description provided for @like.
  ///
  /// In en, this message translates to:
  /// **'Like'**
  String get like;

  /// No description provided for @unlike.
  ///
  /// In en, this message translates to:
  /// **'Unlike'**
  String get unlike;

  /// No description provided for @liked.
  ///
  /// In en, this message translates to:
  /// **'Liked'**
  String get liked;

  /// No description provided for @postSaved.
  ///
  /// In en, this message translates to:
  /// **'Post saved'**
  String get postSaved;

  /// No description provided for @postUnsaved.
  ///
  /// In en, this message translates to:
  /// **'Post removed from saved'**
  String get postUnsaved;

  /// No description provided for @linkCopied.
  ///
  /// In en, this message translates to:
  /// **'Link copied to clipboard'**
  String get linkCopied;

  /// No description provided for @userBlocked.
  ///
  /// In en, this message translates to:
  /// **'User blocked successfully'**
  String get userBlocked;

  /// No description provided for @postReported.
  ///
  /// In en, this message translates to:
  /// **'Post reported. Thank you for keeping the community safe.'**
  String get postReported;

  /// No description provided for @sendMessage.
  ///
  /// In en, this message translates to:
  /// **'Send Message'**
  String get sendMessage;

  /// No description provided for @messageHint.
  ///
  /// In en, this message translates to:
  /// **'Type your message...'**
  String get messageHint;

  /// No description provided for @noCommentsYet.
  ///
  /// In en, this message translates to:
  /// **'No comments yet. Be the first to comment!'**
  String get noCommentsYet;

  /// No description provided for @consultationStarted.
  ///
  /// In en, this message translates to:
  /// **'Consultation started with {expertName}'**
  String consultationStarted(String expertName);

  /// No description provided for @typeYourMessage.
  ///
  /// In en, this message translates to:
  /// **'Type your message here...'**
  String get typeYourMessage;

  /// No description provided for @noMessagesYet.
  ///
  /// In en, this message translates to:
  /// **'No messages yet. Start the conversation!'**
  String get noMessagesYet;

  /// No description provided for @postDeleted.
  ///
  /// In en, this message translates to:
  /// **'Post deleted successfully'**
  String get postDeleted;

  /// No description provided for @emailRequired.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get emailRequired;

  /// No description provided for @emailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get emailInvalid;

  /// No description provided for @passwordRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get passwordRequired;

  /// No description provided for @passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordTooShort;

  /// No description provided for @phoneRequired.
  ///
  /// In en, this message translates to:
  /// **'Phone number is required'**
  String get phoneRequired;

  /// No description provided for @phoneTooShort.
  ///
  /// In en, this message translates to:
  /// **'Phone number must be at least 10 digits'**
  String get phoneTooShort;

  /// No description provided for @locationRequired.
  ///
  /// In en, this message translates to:
  /// **'Location is required'**
  String get locationRequired;

  /// No description provided for @agentDashboard.
  ///
  /// In en, this message translates to:
  /// **'AI Agents'**
  String get agentDashboard;

  /// No description provided for @manageAIAgents.
  ///
  /// In en, this message translates to:
  /// **'Manage your AI farming assistants'**
  String get manageAIAgents;

  /// No description provided for @agentSettings.
  ///
  /// In en, this message translates to:
  /// **'Agent Settings'**
  String get agentSettings;

  /// No description provided for @agentInsights.
  ///
  /// In en, this message translates to:
  /// **'AI Insights'**
  String get agentInsights;

  /// No description provided for @agentRecommendations.
  ///
  /// In en, this message translates to:
  /// **'Recommendations'**
  String get agentRecommendations;

  /// No description provided for @agentStatistics.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get agentStatistics;

  /// No description provided for @agentStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get agentStatus;

  /// No description provided for @agentEnabled.
  ///
  /// In en, this message translates to:
  /// **'Enabled'**
  String get agentEnabled;

  /// No description provided for @agentDisabled.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get agentDisabled;

  /// No description provided for @toggleAgent.
  ///
  /// In en, this message translates to:
  /// **'Toggle Agent'**
  String get toggleAgent;

  /// No description provided for @runAgentsNow.
  ///
  /// In en, this message translates to:
  /// **'Run Analysis Now'**
  String get runAgentsNow;

  /// No description provided for @checkNotifications.
  ///
  /// In en, this message translates to:
  /// **'Check Notifications'**
  String get checkNotifications;

  /// No description provided for @testNotification.
  ///
  /// In en, this message translates to:
  /// **'Send Test Notification'**
  String get testNotification;

  /// No description provided for @agentWeather.
  ///
  /// In en, this message translates to:
  /// **'Weather Intelligence'**
  String get agentWeather;

  /// No description provided for @agentCropHealth.
  ///
  /// In en, this message translates to:
  /// **'Crop Health Monitor'**
  String get agentCropHealth;

  /// No description provided for @agentActivity.
  ///
  /// In en, this message translates to:
  /// **'Activity Scheduler'**
  String get agentActivity;

  /// No description provided for @agentMarket.
  ///
  /// In en, this message translates to:
  /// **'Market Intelligence'**
  String get agentMarket;

  /// No description provided for @agentResource.
  ///
  /// In en, this message translates to:
  /// **'Resource Optimizer'**
  String get agentResource;

  /// No description provided for @agentDescription.
  ///
  /// In en, this message translates to:
  /// **'AI-powered farming assistant'**
  String get agentDescription;

  /// No description provided for @weatherAgentDesc.
  ///
  /// In en, this message translates to:
  /// **'Monitors weather and provides alerts'**
  String get weatherAgentDesc;

  /// No description provided for @cropHealthAgentDesc.
  ///
  /// In en, this message translates to:
  /// **'Tracks crop health patterns'**
  String get cropHealthAgentDesc;

  /// No description provided for @activityAgentDesc.
  ///
  /// In en, this message translates to:
  /// **'Schedules and reminds farming tasks'**
  String get activityAgentDesc;

  /// No description provided for @marketAgentDesc.
  ///
  /// In en, this message translates to:
  /// **'Analyzes market trends and prices'**
  String get marketAgentDesc;

  /// No description provided for @resourceAgentDesc.
  ///
  /// In en, this message translates to:
  /// **'Optimizes water and fertilizer usage'**
  String get resourceAgentDesc;

  /// No description provided for @acknowledge.
  ///
  /// In en, this message translates to:
  /// **'Acknowledge'**
  String get acknowledge;

  /// No description provided for @dismiss.
  ///
  /// In en, this message translates to:
  /// **'Dismiss'**
  String get dismiss;

  /// No description provided for @viewDetails.
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get viewDetails;

  /// No description provided for @priority.
  ///
  /// In en, this message translates to:
  /// **'Priority'**
  String get priority;

  /// No description provided for @priorityLow.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get priorityLow;

  /// No description provided for @priorityMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get priorityMedium;

  /// No description provided for @priorityHigh.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get priorityHigh;

  /// No description provided for @priorityCritical.
  ///
  /// In en, this message translates to:
  /// **'Critical'**
  String get priorityCritical;

  /// No description provided for @createdAt.
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get createdAt;

  /// No description provided for @expiresAt.
  ///
  /// In en, this message translates to:
  /// **'Expires'**
  String get expiresAt;

  /// No description provided for @noInsightsYet.
  ///
  /// In en, this message translates to:
  /// **'No insights yet. AI agents are analyzing your farm data.'**
  String get noInsightsYet;

  /// No description provided for @noRecommendationsYet.
  ///
  /// In en, this message translates to:
  /// **'No recommendations yet. Keep using the app for personalized insights.'**
  String get noRecommendationsYet;

  /// No description provided for @agentAnalyzing.
  ///
  /// In en, this message translates to:
  /// **'Analyzing...'**
  String get agentAnalyzing;

  /// No description provided for @agentReady.
  ///
  /// In en, this message translates to:
  /// **'Ready'**
  String get agentReady;

  /// No description provided for @generalSettings.
  ///
  /// In en, this message translates to:
  /// **'General Settings'**
  String get generalSettings;

  /// No description provided for @enableNotifications.
  ///
  /// In en, this message translates to:
  /// **'Enable Notifications'**
  String get enableNotifications;

  /// No description provided for @enableAgents.
  ///
  /// In en, this message translates to:
  /// **'Enable AI Agents'**
  String get enableAgents;

  /// No description provided for @agentManagement.
  ///
  /// In en, this message translates to:
  /// **'Agent Management'**
  String get agentManagement;

  /// No description provided for @advancedSettings.
  ///
  /// In en, this message translates to:
  /// **'Advanced Settings'**
  String get advancedSettings;

  /// No description provided for @dataRetention.
  ///
  /// In en, this message translates to:
  /// **'Data Retention'**
  String get dataRetention;

  /// No description provided for @clearAgentData.
  ///
  /// In en, this message translates to:
  /// **'Clear All Agent Data'**
  String get clearAgentData;

  /// No description provided for @clearAgentDataWarning.
  ///
  /// In en, this message translates to:
  /// **'This will delete all AI insights, recommendations, and historical data. This action cannot be undone.'**
  String get clearAgentDataWarning;

  /// No description provided for @dataCleared.
  ///
  /// In en, this message translates to:
  /// **'Agent data cleared successfully'**
  String get dataCleared;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
        'as',
        'bn',
        'brx',
        'doi',
        'en',
        'gu',
        'hi',
        'kn',
        'kok',
        'ks',
        'mai',
        'ml',
        'mni',
        'mr',
        'ne',
        'or',
        'pa',
        'sa',
        'sat',
        'sd',
        'ta',
        'te',
        'ur'
      ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'as':
      return AppLocalizationsAs();
    case 'bn':
      return AppLocalizationsBn();
    case 'brx':
      return AppLocalizationsBrx();
    case 'doi':
      return AppLocalizationsDoi();
    case 'en':
      return AppLocalizationsEn();
    case 'gu':
      return AppLocalizationsGu();
    case 'hi':
      return AppLocalizationsHi();
    case 'kn':
      return AppLocalizationsKn();
    case 'kok':
      return AppLocalizationsKok();
    case 'ks':
      return AppLocalizationsKs();
    case 'mai':
      return AppLocalizationsMai();
    case 'ml':
      return AppLocalizationsMl();
    case 'mni':
      return AppLocalizationsMni();
    case 'mr':
      return AppLocalizationsMr();
    case 'ne':
      return AppLocalizationsNe();
    case 'or':
      return AppLocalizationsOr();
    case 'pa':
      return AppLocalizationsPa();
    case 'sa':
      return AppLocalizationsSa();
    case 'sat':
      return AppLocalizationsSat();
    case 'sd':
      return AppLocalizationsSd();
    case 'ta':
      return AppLocalizationsTa();
    case 'te':
      return AppLocalizationsTe();
    case 'ur':
      return AppLocalizationsUr();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
