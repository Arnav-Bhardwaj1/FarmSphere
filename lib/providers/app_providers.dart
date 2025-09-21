import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// App State Providers
final appStateProvider = StateNotifierProvider<AppStateNotifier, AppState>((ref) {
  return AppStateNotifier();
});

final userProvider = StateNotifierProvider<UserNotifier, UserState>((ref) {
  return UserNotifier();
});

final weatherProvider = StateNotifierProvider<WeatherNotifier, WeatherState>((ref) {
  return WeatherNotifier();
});

final marketPricesProvider = StateNotifierProvider<MarketPricesNotifier, MarketPricesState>((ref) {
  return MarketPricesNotifier();
});

final cropHealthProvider = StateNotifierProvider<CropHealthNotifier, CropHealthState>((ref) {
  return CropHealthNotifier();
});

final activityProvider = StateNotifierProvider<ActivityNotifier, ActivityState>((ref) {
  return ActivityNotifier();
});

// App State Classes
class AppState {
  final bool isDarkMode;
  final String selectedLanguage;
  final bool isFirstLaunch;

  AppState({
    this.isDarkMode = false,
    this.selectedLanguage = 'en',
    this.isFirstLaunch = true,
  });

  AppState copyWith({
    bool? isDarkMode,
    String? selectedLanguage,
    bool? isFirstLaunch,
  }) {
    return AppState(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      selectedLanguage: selectedLanguage ?? this.selectedLanguage,
      isFirstLaunch: isFirstLaunch ?? this.isFirstLaunch,
    );
  }
}

class UserState {
  final String? userId;
  final String? name;
  final String? email;
  final String? phone;
  final String? location;
  final bool isLoggedIn;

  UserState({
    this.userId,
    this.name,
    this.email,
    this.phone,
    this.location,
    this.isLoggedIn = false,
  });

  UserState copyWith({
    String? userId,
    String? name,
    String? email,
    String? phone,
    String? location,
    bool? isLoggedIn,
  }) {
    return UserState(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      location: location ?? this.location,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
    );
  }
}

class WeatherState {
  final Map<String, dynamic>? currentWeather;
  final List<Map<String, dynamic>>? forecast;
  final List<Map<String, dynamic>>? alerts;
  final bool isLoading;
  final String? error;

  WeatherState({
    this.currentWeather,
    this.forecast,
    this.alerts,
    this.isLoading = false,
    this.error,
  });

  WeatherState copyWith({
    Map<String, dynamic>? currentWeather,
    List<Map<String, dynamic>>? forecast,
    List<Map<String, dynamic>>? alerts,
    bool? isLoading,
    String? error,
  }) {
    return WeatherState(
      currentWeather: currentWeather ?? this.currentWeather,
      forecast: forecast ?? this.forecast,
      alerts: alerts ?? this.alerts,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class MarketPricesState {
  final List<Map<String, dynamic>>? prices;
  final List<Map<String, dynamic>>? schemes;
  final bool isLoading;
  final String? error;

  MarketPricesState({
    this.prices,
    this.schemes,
    this.isLoading = false,
    this.error,
  });

  MarketPricesState copyWith({
    List<Map<String, dynamic>>? prices,
    List<Map<String, dynamic>>? schemes,
    bool? isLoading,
    String? error,
  }) {
    return MarketPricesState(
      prices: prices ?? this.prices,
      schemes: schemes ?? this.schemes,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class CropHealthState {
  final Map<String, dynamic>? lastDiagnosis;
  final List<Map<String, dynamic>>? diagnosisHistory;
  final bool isAnalyzing;
  final String? error;

  CropHealthState({
    this.lastDiagnosis,
    this.diagnosisHistory,
    this.isAnalyzing = false,
    this.error,
  });

  CropHealthState copyWith({
    Map<String, dynamic>? lastDiagnosis,
    List<Map<String, dynamic>>? diagnosisHistory,
    bool? isAnalyzing,
    String? error,
  }) {
    return CropHealthState(
      lastDiagnosis: lastDiagnosis ?? this.lastDiagnosis,
      diagnosisHistory: diagnosisHistory ?? this.diagnosisHistory,
      isAnalyzing: isAnalyzing ?? this.isAnalyzing,
      error: error ?? this.error,
    );
  }
}

class ActivityState {
  final List<Map<String, dynamic>>? activities;
  final Map<String, dynamic>? analytics;
  final bool isLoading;
  final String? error;

  ActivityState({
    this.activities,
    this.analytics,
    this.isLoading = false,
    this.error,
  });

  ActivityState copyWith({
    List<Map<String, dynamic>>? activities,
    Map<String, dynamic>? analytics,
    bool? isLoading,
    String? error,
  }) {
    return ActivityState(
      activities: activities ?? this.activities,
      analytics: analytics ?? this.analytics,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

// State Notifiers
class AppStateNotifier extends StateNotifier<AppState> {
  AppStateNotifier() : super(AppState()) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    state = state.copyWith(
      isDarkMode: prefs.getBool('isDarkMode') ?? false,
      selectedLanguage: prefs.getString('selectedLanguage') ?? 'en',
      isFirstLaunch: prefs.getBool('isFirstLaunch') ?? true,
    );
  }

  Future<void> toggleDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', !state.isDarkMode);
    state = state.copyWith(isDarkMode: !state.isDarkMode);
  }

  Future<void> setLanguage(String language) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedLanguage', language);
    state = state.copyWith(selectedLanguage: language);
  }

  Future<void> setFirstLaunchComplete() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstLaunch', false);
    state = state.copyWith(isFirstLaunch: false);
  }
}

class UserNotifier extends StateNotifier<UserState> {
  UserNotifier() : super(UserState()) {
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    
    if (isLoggedIn) {
      state = state.copyWith(
        userId: prefs.getString('userId'),
        name: prefs.getString('name'),
        email: prefs.getString('email'),
        phone: prefs.getString('phone'),
        location: prefs.getString('location'),
        isLoggedIn: true,
      );
    }
  }

  Future<void> login(String name, String email, String phone, String location) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = DateTime.now().millisecondsSinceEpoch.toString();
    
    await prefs.setString('userId', userId);
    await prefs.setString('name', name);
    await prefs.setString('email', email);
    await prefs.setString('phone', phone);
    await prefs.setString('location', location);
    await prefs.setBool('isLoggedIn', true);
    
    state = state.copyWith(
      userId: userId,
      name: name,
      email: email,
      phone: phone,
      location: location,
      isLoggedIn: true,
    );
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    state = UserState();
  }
}

class WeatherNotifier extends StateNotifier<WeatherState> {
  WeatherNotifier() : super(WeatherState());

  Future<void> fetchWeatherData(String location) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      // Mock weather data - in real app, call weather API
      await Future.delayed(const Duration(seconds: 2));
      
      final mockWeather = {
        'temperature': 28,
        'humidity': 65,
        'condition': 'Partly Cloudy',
        'windSpeed': 12,
        'location': location,
      };
      
      final mockForecast = List.generate(7, (index) => {
        'date': DateTime.now().add(Duration(days: index)).toIso8601String(),
        'high': 30 + (index % 3),
        'low': 20 + (index % 2),
        'condition': ['Sunny', 'Cloudy', 'Rainy'][index % 3],
      });
      
      final mockAlerts = [
        {
          'type': 'Rain Alert',
          'message': 'Heavy rainfall expected in next 24 hours',
          'severity': 'High',
          'time': DateTime.now().add(const Duration(hours: 6)).toIso8601String(),
        },
        {
          'type': 'Pest Alert',
          'message': 'Increased pest activity detected in your area',
          'severity': 'Medium',
          'time': DateTime.now().add(const Duration(hours: 12)).toIso8601String(),
        },
      ];
      
      state = state.copyWith(
        currentWeather: mockWeather,
        forecast: mockForecast,
        alerts: mockAlerts,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }
}

class MarketPricesNotifier extends StateNotifier<MarketPricesState> {
  MarketPricesNotifier() : super(MarketPricesState());

  Future<void> fetchMarketData() async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      // Mock market data - in real app, call market API
      await Future.delayed(const Duration(seconds: 2));
      
      final mockPrices = [
        {'crop': 'Rice', 'price': 2500, 'unit': 'per quintal', 'market': 'Delhi Mandi'},
        {'crop': 'Wheat', 'price': 2200, 'unit': 'per quintal', 'market': 'Punjab Mandi'},
        {'crop': 'Tomato', 'price': 45, 'unit': 'per kg', 'market': 'Mumbai Mandi'},
        {'crop': 'Potato', 'price': 25, 'unit': 'per kg', 'market': 'Kolkata Mandi'},
      ];
      
      final mockSchemes = [
        {
          'title': 'PM-KISAN Scheme',
          'description': 'Direct income support of ₹6000 per year',
          'eligibility': 'Small and marginal farmers',
          'status': 'Active',
        },
        {
          'title': 'Soil Health Card Scheme',
          'description': 'Free soil testing and recommendations',
          'eligibility': 'All farmers',
          'status': 'Active',
        },
      ];
      
      state = state.copyWith(
        prices: mockPrices,
        schemes: mockSchemes,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }
}

class CropHealthNotifier extends StateNotifier<CropHealthState> {
  CropHealthNotifier() : super(CropHealthState());

  Future<void> analyzeCropHealth(String imagePath, String description) async {
    state = state.copyWith(isAnalyzing: true, error: null);
    
    try {
      // Mock AI analysis - in real app, call AI/ML service
      await Future.delayed(const Duration(seconds: 3));
      
      final mockDiagnosis = {
        'disease': 'Leaf Blight',
        'confidence': 0.85,
        'severity': 'Medium',
        'recommendations': [
          'Apply fungicide spray',
          'Improve air circulation',
          'Remove affected leaves',
        ],
        'prevention': [
          'Regular monitoring',
          'Proper spacing between plants',
          'Avoid overhead watering',
        ],
        'imagePath': imagePath,
        'description': description,
        'timestamp': DateTime.now().toIso8601String(),
      };
      
      final currentHistory = state.diagnosisHistory ?? [];
      currentHistory.insert(0, mockDiagnosis);
      
      state = state.copyWith(
        lastDiagnosis: mockDiagnosis,
        diagnosisHistory: currentHistory,
        isAnalyzing: false,
      );
    } catch (e) {
      state = state.copyWith(
        isAnalyzing: false,
        error: e.toString(),
      );
    }
  }
}

class ActivityNotifier extends StateNotifier<ActivityState> {
  ActivityNotifier() : super(ActivityState()) {
    loadActivities();
  }

  Future<void> loadActivities() async {
    state = state.copyWith(isLoading: true);
    
    try {
      // Mock activity data
      await Future.delayed(const Duration(seconds: 1));
      
      final mockActivities = [
        {
          'id': '1',
          'type': 'Planting',
          'crop': 'Rice',
          'date': DateTime.now().subtract(const Duration(days: 5)).toIso8601String(),
          'notes': 'Planted rice seeds in field A',
        },
        {
          'id': '2',
          'type': 'Fertilizing',
          'crop': 'Rice',
          'date': DateTime.now().subtract(const Duration(days: 3)).toIso8601String(),
          'notes': 'Applied NPK fertilizer',
        },
        {
          'id': '3',
          'type': 'Irrigation',
          'crop': 'Rice',
          'date': DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
          'notes': 'Watered field for 2 hours',
        },
      ];
      
      final mockAnalytics = {
        'totalActivities': 15,
        'thisMonth': 8,
        'cropDistribution': {
          'Rice': 40,
          'Wheat': 30,
          'Tomato': 20,
          'Potato': 10,
        },
        'productivity': 85,
      };
      
      state = state.copyWith(
        activities: mockActivities,
        analytics: mockAnalytics,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> addActivity(String type, String crop, String notes) async {
    final newActivity = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'type': type,
      'crop': crop,
      'date': DateTime.now().toIso8601String(),
      'notes': notes,
    };
    
    final currentActivities = state.activities ?? [];
    currentActivities.insert(0, newActivity);
    
    state = state.copyWith(activities: currentActivities);
  }
}

