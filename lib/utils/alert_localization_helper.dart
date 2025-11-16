import 'package:farmsphere/l10n/app_localizations.dart';

class AlertLocalizationHelper {
  /// Get localized alert message based on alert type
  static String getLocalizedMessage(AppLocalizations t, String alertType, String defaultMessage) {
    final lowerType = alertType.toLowerCase();
    
    if (lowerType.contains('cold wave')) {
      return t.alertMessageColdWave;
    } else if (lowerType.contains('fog')) {
      return t.alertMessageFog;
    } else if (lowerType.contains('heavy rain')) {
      return t.alertMessageHeavyRain;
    } else if (lowerType.contains('flood')) {
      return t.alertMessageFlood;
    } else if (lowerType.contains('heat wave')) {
      return t.alertMessageHeatWave;
    } else if (lowerType.contains('water scarcity')) {
      return t.alertMessageWaterScarcity;
    } else if (lowerType.contains('frost')) {
      return t.alertMessageFrost;
    } else if (lowerType.contains('cold weather')) {
      return t.alertMessageColdWeather;
    } else if (lowerType.contains('rain')) {
      return t.alertMessageHeavyRain;
    }
    
    // Return default if no match
    return defaultMessage;
  }
}

