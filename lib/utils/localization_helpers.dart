import 'package:farmsphere/l10n/app_localizations.dart';

class LocalizationHelpers {
  /// Get localized crop name
  static String getLocalizedCropName(AppLocalizations t, String cropName) {
    final lowerCrop = cropName.toLowerCase();
    
    // Handle compound crop names
    if (lowerCrop.contains('paddy')) {
      if (lowerCrop.contains('grade a') || lowerCrop.contains('grade-a')) {
        return '${t.cropPaddy} (Grade A)';
      }
      return '${t.cropPaddy} (Common)';
    }
    if (lowerCrop.contains('jowar')) {
      if (lowerCrop.contains('maldandi')) {
        return '${t.cropJowar} (Maldandi)';
      }
      return '${t.cropJowar} (Hybrid)';
    }
    if (lowerCrop.contains('cotton')) {
      if (lowerCrop.contains('long')) {
        return '${t.cropCotton} (Long Staple)';
      }
      return '${t.cropCotton} (Medium Staple)';
    }
    if (lowerCrop.contains('rice')) {
      if (lowerCrop.contains('basmati')) {
        return '${t.cropRice} (Basmati)';
      }
      return '${t.cropRice} (Common)';
    }
    
    // Simple crop name mappings
    if (lowerCrop.contains('wheat')) return t.cropWheat;
    if (lowerCrop.contains('maize')) return t.cropMaize;
    if (lowerCrop.contains('bajra')) return t.cropBajra;
    if (lowerCrop.contains('ragi')) return t.cropRagi;
    if (lowerCrop.contains('arhar') || lowerCrop.contains('tur')) return t.cropArhar;
    if (lowerCrop.contains('moong')) return t.cropMoong;
    if (lowerCrop.contains('urad')) return t.cropUrad;
    if (lowerCrop.contains('chana')) return t.cropChana;
    if (lowerCrop.contains('masur') || lowerCrop.contains('lentil')) return t.cropMasur;
    if (lowerCrop.contains('groundnut')) return t.cropGroundnut;
    if (lowerCrop.contains('sesamum')) return t.cropSesamum;
    if (lowerCrop.contains('sunflower')) return t.cropSunflower;
    if (lowerCrop.contains('soyabean') || lowerCrop.contains('soya')) return t.cropSoyabean;
    if (lowerCrop.contains('mustard')) return t.cropMustard;
    if (lowerCrop.contains('sugarcane')) return t.cropSugarcane;
    if (lowerCrop.contains('jute')) return t.cropJute;
    if (lowerCrop.contains('tomato')) return t.cropTomato;
    if (lowerCrop.contains('potato')) return t.cropPotato;
    if (lowerCrop.contains('onion')) return t.cropOnion;
    
    // Return original if no match
    return cropName;
  }

  /// Get localized season name
  static String getLocalizedSeason(AppLocalizations t, String season) {
    final lowerSeason = season.toLowerCase();
    if (lowerSeason.contains('kharif')) return t.seasonKharif;
    if (lowerSeason.contains('rabi')) return t.seasonRabi;
    return season;
  }

  /// Get localized category name
  static String getLocalizedCategory(AppLocalizations t, String category) {
    final lowerCategory = category.toLowerCase();
    if (lowerCategory.contains('cereal')) return t.categoryCereals;
    if (lowerCategory.contains('pulse')) return t.categoryPulses;
    if (lowerCategory.contains('oilseed')) return t.categoryOilseeds;
    if (lowerCategory.contains('commercial')) return t.categoryCommercialCrops;
    return category;
  }

  /// Get localized status
  static String getLocalizedStatus(AppLocalizations t, String status) {
    final lowerStatus = status.toLowerCase();
    if (lowerStatus == 'active') return t.schemeActive;
    if (lowerStatus == 'inactive') return t.schemeInactive;
    if (lowerStatus == 'upcoming') return t.schemeUpcoming;
    return status;
  }
}









