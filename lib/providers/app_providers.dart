import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/weather_service.dart';
import '../services/msp_service.dart';
import '../services/api_service.dart';
import 'package:flutter/foundation.dart';

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

final communityProvider = StateNotifierProvider<CommunityNotifier, CommunityState>((ref) {
  return CommunityNotifier();
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
    
    // Try to create user in backend
    try {
      final isApiAvailable = await ApiService.checkHealth();
      if (isApiAvailable) {
        await ApiService.createUser(
          userId: userId,
          name: name,
          email: email,
          phone: phone,
          location: location,
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to create user in backend: $e');
      }
      // Continue with local storage if API fails
    }
    
    // Save locally
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
      // Fetch real weather data using WeatherService
      final currentWeather = await WeatherService.getCurrentWeather(location);
      final forecast = await WeatherService.getWeatherForecast(location);
      final alerts = await WeatherService.getWeatherAlerts(location);
      
      state = state.copyWith(
        currentWeather: currentWeather,
        forecast: forecast,
        alerts: alerts,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<Map<String, dynamic>?> getCurrentLocation() async {
    try {
      return await WeatherService.getCurrentLocation();
    } catch (e) {
      return null;
    }
  }
}

class MarketPricesNotifier extends StateNotifier<MarketPricesState> {
  MarketPricesNotifier() : super(MarketPricesState());

  Future<void> fetchMarketData() async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      // Fetch real MSP and market data using MSPService
      final mspPrices = await MSPService.getMSPPrices();
      final marketPrices = await MSPService.getMarketPrices();
      final schemes = await MSPService.getGovernmentSchemes();
      
      // Combine MSP and market prices
      final allPrices = [...mspPrices, ...marketPrices];
      
      state = state.copyWith(
        prices: allPrices,
        schemes: schemes,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<List<Map<String, dynamic>>> getMSPPrices() async {
    try {
      return await MSPService.getMSPPrices();
    } catch (e) {
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getMarketPrices() async {
    try {
      return await MSPService.getMarketPrices();
    } catch (e) {
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getGovernmentSchemes() async {
    try {
      return await MSPService.getGovernmentSchemes();
    } catch (e) {
      return [];
    }
  }

  Future<Map<String, dynamic>?> getMSPForCrop(String cropName) async {
    try {
      return await MSPService.getMSPForCrop(cropName);
    } catch (e) {
      return null;
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
      
      // Try to save to backend
      try {
        final userId = state.lastDiagnosis?['userId'] ?? 'guest';
        final isApiAvailable = await ApiService.checkHealth();
        if (isApiAvailable) {
          await ApiService.saveCropHealthDiagnosis(
            diagnosisId: DateTime.now().millisecondsSinceEpoch.toString(),
            userId: userId,
            imageUrl: imagePath,
            results: [
              {
                'label': mockDiagnosis['disease'],
                'confidence': mockDiagnosis['confidence'],
              }
            ],
          );
        }
      } catch (e) {
        if (kDebugMode) {
          print('Failed to save diagnosis to backend: $e');
        }
      }
      
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

  Future<void> loadCropHealthHistory(String userId) async {
    try {
      final isApiAvailable = await ApiService.checkHealth();
      if (isApiAvailable) {
        final history = await ApiService.getCropHealthHistory(userId: userId);
        state = state.copyWith(diagnosisHistory: history);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to load crop health history: $e');
      }
    }
  }
}

class ActivityNotifier extends StateNotifier<ActivityState> {
  String? _currentUserId;

  ActivityNotifier() : super(ActivityState()) {
    // Don't auto-load, wait for userId
  }

  Future<void> loadActivities(String userId) async {
    _currentUserId = userId;
    state = state.copyWith(isLoading: true);
    
    try {
      // Try to load from API
      final isApiAvailable = await ApiService.checkHealth();
      if (isApiAvailable) {
        try {
          final activities = await ApiService.getActivities(userId: userId);
          final analytics = _calculateAnalytics(activities);
          
          state = state.copyWith(
            activities: activities,
            analytics: analytics,
            isLoading: false,
          );
          return;
        } catch (e) {
          if (kDebugMode) {
            print('Failed to load activities from API: $e');
          }
        }
      }
      
      // Fallback to mock data
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
    if (_currentUserId == null) {
      if (kDebugMode) {
        print('Cannot add activity: userId not set');
      }
      return;
    }

    final activityId = DateTime.now().millisecondsSinceEpoch.toString();
    final newActivity = {
      'id': activityId,
      'type': type,
      'crop': crop,
      'date': DateTime.now().toIso8601String(),
      'notes': notes,
    };
    
    // Try to save to API
    try {
      final isApiAvailable = await ApiService.checkHealth();
      if (isApiAvailable) {
        await ApiService.createActivity(
          activityId: activityId,
          userId: _currentUserId!,
          type: type,
          crop: crop,
          notes: notes,
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to save activity to API: $e');
      }
    }
    
    // Update local state
    final currentActivities = state.activities ?? [];
    currentActivities.insert(0, newActivity);
    
    final analytics = _calculateAnalytics(currentActivities);
    
    state = state.copyWith(
      activities: currentActivities,
      analytics: analytics,
    );
  }

  Map<String, dynamic> _calculateAnalytics(List<Map<String, dynamic>> activities) {
    final totalActivities = activities.length;
    final thisMonth = activities.where((a) {
      final date = DateTime.parse(a['date'] ?? a['timestamp'] ?? DateTime.now().toIso8601String());
      final now = DateTime.now();
      return date.year == now.year && date.month == now.month;
    }).length;

    final cropDistribution = <String, int>{};
    for (final activity in activities) {
      final crop = activity['crop'] as String? ?? 'Unknown';
      cropDistribution[crop] = (cropDistribution[crop] ?? 0) + 1;
    }

    return {
      'totalActivities': totalActivities,
      'thisMonth': thisMonth,
      'cropDistribution': cropDistribution,
      'productivity': totalActivities > 0 ? ((thisMonth / totalActivities) * 100).round() : 0,
    };
  }
}

// Community State Classes
class CommunityState {
  final List<Map<String, dynamic>> posts;
  final List<Map<String, dynamic>> chats;
  final List<Map<String, dynamic>> experts;
  final Map<String, Set<String>> likedPosts;
  final Map<String, Set<String>> savedPosts;
  final Map<String, List<Map<String, dynamic>>> postComments;
  final Map<String, List<Map<String, dynamic>>> chatMessages;
  final Set<String> blockedUsers;
  final bool isLoading;
  final String? error;

  CommunityState({
    this.posts = const [],
    this.chats = const [],
    this.experts = const [],
    this.likedPosts = const {},
    this.savedPosts = const {},
    this.postComments = const {},
    this.chatMessages = const {},
    this.blockedUsers = const {},
    this.isLoading = false,
    this.error,
  });

  CommunityState copyWith({
    List<Map<String, dynamic>>? posts,
    List<Map<String, dynamic>>? chats,
    List<Map<String, dynamic>>? experts,
    Map<String, Set<String>>? likedPosts,
    Map<String, Set<String>>? savedPosts,
    Map<String, List<Map<String, dynamic>>>? postComments,
    Map<String, List<Map<String, dynamic>>>? chatMessages,
    Set<String>? blockedUsers,
    bool? isLoading,
    String? error,
  }) {
    return CommunityState(
      posts: posts ?? this.posts,
      chats: chats ?? this.chats,
      experts: experts ?? this.experts,
      likedPosts: likedPosts ?? this.likedPosts,
      savedPosts: savedPosts ?? this.savedPosts,
      postComments: postComments ?? this.postComments,
      chatMessages: chatMessages ?? this.chatMessages,
      blockedUsers: blockedUsers ?? this.blockedUsers,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

// Community Notifier
class CommunityNotifier extends StateNotifier<CommunityState> {
  CommunityNotifier() : super(CommunityState()) {
    _loadCommunityData();
  }

  Future<void> _loadCommunityData() async {
    state = state.copyWith(isLoading: true);
    
    try {
      // Try to load from API
      final isApiAvailable = await ApiService.checkHealth();
      if (isApiAvailable) {
        try {
          final response = await ApiService.getPosts();
          final posts = List<Map<String, dynamic>>.from(response['posts'] ?? []);
          
          // Format posts for UI (add time ago, etc.)
          final formattedPosts = posts.map((post) {
            final timestamp = post['timestamp'] ?? post['createdAt'];
            final timeAgo = timestamp != null 
                ? _getTimeAgoFromTimestamp(timestamp)
                : 'Unknown';
            
            return {
              ...post,
              'time': timeAgo,
            };
          }).toList();
          
          state = state.copyWith(
            posts: formattedPosts,
            isLoading: false,
          );
          return;
        } catch (e) {
          if (kDebugMode) {
            print('Failed to load posts from API: $e');
          }
        }
      }
      
      // Fallback to mock data
      await Future.delayed(const Duration(seconds: 1));
      
      // Mock initial posts
      final mockPosts = [
        {
          'id': '1',
          'author': 'Rajesh Kumar',
          'authorId': 'user1',
          'location': 'Punjab, India',
          'time': _getTimeAgo(2),
          'content': 'Just harvested my wheat crop! The yield is 20% higher than last year. Used the new irrigation technique I learned from this community.',
          'likes': 24,
          'comments': 8,
          'image': null,
          'tags': ['Wheat', 'Harvest', 'Success'],
          'timestamp': DateTime.now().subtract(const Duration(hours: 2)).toIso8601String(),
        },
        {
          'id': '2',
          'author': 'Priya Sharma',
          'authorId': 'user2',
          'location': 'Haryana, India',
          'time': _getTimeAgo(5),
          'content': 'My tomato plants are showing signs of early blight. Any suggestions for organic treatment?',
          'likes': 12,
          'comments': 15,
          'image': null,
          'tags': ['Tomato', 'Disease', 'Help'],
          'timestamp': DateTime.now().subtract(const Duration(hours: 5)).toIso8601String(),
        },
        {
          'id': '3',
          'author': 'Amit Singh',
          'authorId': 'user3',
          'location': 'Uttar Pradesh, India',
          'time': _getTimeAgo(24),
          'content': 'Sharing some photos from my organic farm. The soil health has improved significantly after using compost.',
          'likes': 36,
          'comments': 12,
          'image': 'farm_photo.jpg',
          'tags': ['Organic', 'Soil Health', 'Compost'],
          'timestamp': DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
        },
      ];

      // Mock chats
      final mockChats = [
        {
          'id': 'chat1',
          'name': 'General Discussion',
          'lastMessage': 'Anyone tried the new organic fertilizer?',
          'time': _getTimeAgo(2),
          'unread': 3,
          'participants': 45,
        },
        {
          'id': 'chat2',
          'name': 'Crop Health Help',
          'lastMessage': 'Thanks for the advice on pest control!',
          'time': _getTimeAgo(60),
          'unread': 0,
          'participants': 23,
        },
        {
          'id': 'chat3',
          'name': 'Market Prices',
          'lastMessage': 'Rice prices are up 15% this week',
          'time': _getTimeAgo(180),
          'unread': 1,
          'participants': 67,
        },
      ];

      // Mock experts
      final mockExperts = [
        {
          'id': 'expert1',
          'name': 'Dr. Suresh Patel',
          'specialization': 'Crop Science',
          'experience': '15 years',
          'rating': 4.8,
          'reviews': 234,
          'isOnline': true,
        },
        {
          'id': 'expert2',
          'name': 'Dr. Meera Sharma',
          'specialization': 'Soil Health',
          'experience': '12 years',
          'rating': 4.9,
          'reviews': 189,
          'isOnline': false,
        },
        {
          'id': 'expert3',
          'name': 'Dr. Rajesh Kumar',
          'specialization': 'Pest Management',
          'experience': '18 years',
          'rating': 4.7,
          'reviews': 312,
          'isOnline': true,
        },
      ];

      state = state.copyWith(
        posts: mockPosts,
        chats: mockChats,
        experts: mockExperts,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  String _getTimeAgo(int minutesAgo) {
    if (minutesAgo < 60) {
      return '$minutesAgo min ago';
    } else if (minutesAgo < 1440) {
      final hours = minutesAgo ~/ 60;
      return '$hours hour${hours > 1 ? 's' : ''} ago';
    } else {
      final days = minutesAgo ~/ 1440;
      return '$days day${days > 1 ? 's' : ''} ago';
    }
  }

  String _getTimeAgoFromTimestamp(String timestamp) {
    try {
      final date = DateTime.parse(timestamp);
      final now = DateTime.now();
      final difference = now.difference(date);
      final minutesAgo = difference.inMinutes;
      return _getTimeAgo(minutesAgo);
    } catch (e) {
      return 'Unknown';
    }
  }

  Future<void> createPost(String content, String location, List<String> tags, String userId, String userName, {String? image}) async {
    final postId = DateTime.now().millisecondsSinceEpoch.toString();
    
    // Try to create in backend
    try {
      final isApiAvailable = await ApiService.checkHealth();
      if (isApiAvailable) {
        try {
          final createdPost = await ApiService.createPost(
            postId: postId,
            authorId: userId,
            author: userName,
            content: content,
            location: location,
            tags: tags,
            image: image,
          );
          
          // Format and add to local state
          final formattedPost = {
            ...createdPost,
            'time': 'Just now',
          };
          
          final currentPosts = List<Map<String, dynamic>>.from(state.posts);
          currentPosts.insert(0, formattedPost);
          
          state = state.copyWith(posts: currentPosts);
          return;
        } catch (e) {
          if (kDebugMode) {
            print('Failed to create post in API: $e');
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error checking API availability: $e');
      }
    }
    
    // Fallback to local state
    final newPost = {
      'id': postId,
      'author': userName,
      'authorId': userId,
      'location': location,
      'time': 'Just now',
      'content': content,
      'likes': 0,
      'comments': 0,
      'image': image,
      'tags': tags,
      'timestamp': DateTime.now().toIso8601String(),
    };
    
    final currentPosts = List<Map<String, dynamic>>.from(state.posts);
    currentPosts.insert(0, newPost);
    
    state = state.copyWith(posts: currentPosts);
  }

  Future<void> toggleLike(String postId, String userId) async {
    // Try to update in backend
    try {
      final isApiAvailable = await ApiService.checkHealth();
      if (isApiAvailable) {
        try {
          final response = await ApiService.toggleLike(postId: postId, userId: userId);
          final isLiked = response['liked'] as bool? ?? false;
          final likes = response['likes'] as int? ?? 0;
          
          // Update local state
          final likedPosts = Map<String, Set<String>>.from(state.likedPosts);
          if (isLiked) {
            likedPosts[postId] ??= {};
            likedPosts[postId]!.add(userId);
          } else {
            likedPosts[postId]?.remove(userId);
            if (likedPosts[postId]?.isEmpty ?? false) {
              likedPosts.remove(postId);
            }
          }
          
          final updatedPosts = state.posts.map((p) {
            if (p['id'] == postId) {
              return {...p, 'likes': likes};
            }
            return p;
          }).toList();
          
          state = state.copyWith(
            posts: updatedPosts,
            likedPosts: likedPosts,
          );
          return;
        } catch (e) {
          if (kDebugMode) {
            print('Failed to toggle like in API: $e');
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error checking API availability: $e');
      }
    }
    
    // Fallback to local state
    final likedPosts = Map<String, Set<String>>.from(state.likedPosts);
    final post = state.posts.firstWhere((p) => p['id'] == postId);
    final isLiked = likedPosts[postId]?.contains(userId) ?? false;
    
    if (isLiked) {
      likedPosts[postId]?.remove(userId);
      post['likes'] = (post['likes'] as int) - 1;
    } else {
      likedPosts[postId] ??= {};
      likedPosts[postId]!.add(userId);
      post['likes'] = (post['likes'] as int) + 1;
    }
    
    final updatedPosts = state.posts.map((p) => p['id'] == postId ? Map<String, dynamic>.from(post) : p).toList();
    
    state = state.copyWith(
      posts: updatedPosts,
      likedPosts: likedPosts,
    );
  }

  Future<void> toggleSave(String postId, String userId) async {
    // Try to update in backend
    try {
      final isApiAvailable = await ApiService.checkHealth();
      if (isApiAvailable) {
        try {
          final response = await ApiService.toggleSave(postId: postId, userId: userId);
          final isSaved = response['saved'] as bool? ?? false;
          
          // Update local state
          final savedPosts = Map<String, Set<String>>.from(state.savedPosts);
          if (isSaved) {
            savedPosts[postId] ??= {};
            savedPosts[postId]!.add(userId);
          } else {
            savedPosts[postId]?.remove(userId);
            if (savedPosts[postId]?.isEmpty ?? false) {
              savedPosts.remove(postId);
            }
          }
          
          state = state.copyWith(savedPosts: savedPosts);
          return;
        } catch (e) {
          if (kDebugMode) {
            print('Failed to toggle save in API: $e');
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error checking API availability: $e');
      }
    }
    
    // Fallback to local state
    final savedPosts = Map<String, Set<String>>.from(state.savedPosts);
    
    if (savedPosts[postId]?.contains(userId) ?? false) {
      savedPosts[postId]?.remove(userId);
      if (savedPosts[postId]?.isEmpty ?? false) {
        savedPosts.remove(postId);
      }
    } else {
      savedPosts[postId] ??= {};
      savedPosts[postId]!.add(userId);
    }
    
    state = state.copyWith(savedPosts: savedPosts);
  }

  Future<void> addComment(String postId, String userId, String? userName, String content) async {
    final commentId = DateTime.now().millisecondsSinceEpoch.toString();
    
    // Try to create in backend
    try {
      final isApiAvailable = await ApiService.checkHealth();
      if (isApiAvailable) {
        try {
          final createdComment = await ApiService.createComment(
            commentId: commentId,
            postId: postId,
            userId: userId,
            userName: userName ?? 'User',
            content: content,
          );
          
          // Update local state
          final comments = Map<String, List<Map<String, dynamic>>>.from(state.postComments);
          final formattedComment = {
            ...createdComment,
            'time': 'Just now',
          };
          
          final postComments = List<Map<String, dynamic>>.from(comments[postId] ?? []);
          postComments.add(formattedComment);
          comments[postId] = postComments;
          
          // Update post comment count
          final updatedPosts = state.posts.map((p) {
            if (p['id'] == postId) {
              return {...p, 'comments': (p['comments'] as int? ?? 0) + 1};
            }
            return p;
          }).toList();
          
          state = state.copyWith(
            posts: updatedPosts,
            postComments: comments,
          );
          return;
        } catch (e) {
          if (kDebugMode) {
            print('Failed to create comment in API: $e');
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error checking API availability: $e');
      }
    }
    
    // Fallback to local state
    final comments = Map<String, List<Map<String, dynamic>>>.from(state.postComments);
    final post = state.posts.firstWhere((p) => p['id'] == postId);
    
    final newComment = {
      'id': commentId,
      'userId': userId,
      'userName': userName ?? 'User',
      'content': content,
      'time': 'Just now',
      'timestamp': DateTime.now().toIso8601String(),
    };
    
    final postComments = List<Map<String, dynamic>>.from(comments[postId] ?? []);
    postComments.add(newComment);
    
    comments[postId] = postComments;
    post['comments'] = (post['comments'] as int) + 1;
    
    final updatedPosts = state.posts.map((p) => p['id'] == postId ? Map<String, dynamic>.from(post) : p).toList();
    
    state = state.copyWith(
      posts: updatedPosts,
      postComments: comments,
    );
  }

  Future<void> addChatMessage(String chatId, String userId, String? userName, String content) async {
    final messageId = DateTime.now().millisecondsSinceEpoch.toString();
    
    // Try to save to backend
    try {
      final isApiAvailable = await ApiService.checkHealth();
      if (isApiAvailable) {
        try {
          final createdMessage = await ApiService.createChatMessage(
            messageId: messageId,
            chatId: chatId,
            userId: userId,
            userName: userName ?? 'User',
            content: content,
          );
          
          // Update local state with created message
          final messages = Map<String, List<Map<String, dynamic>>>.from(state.chatMessages);
          final formattedMessage = {
            ...createdMessage,
            'time': DateTime.now().toIso8601String(),
          };
          
          final chatMessages = List<Map<String, dynamic>>.from(messages[chatId] ?? []);
          chatMessages.add(formattedMessage);
          messages[chatId] = chatMessages;
          
          // Update chat last message
          final chats = List<Map<String, dynamic>>.from(state.chats);
          final chatIndex = chats.indexWhere((c) => c['id'] == chatId);
          if (chatIndex != -1) {
            chats[chatIndex] = Map<String, dynamic>.from(chats[chatIndex])
              ..['lastMessage'] = content
              ..['time'] = 'Just now';
          }
          
          state = state.copyWith(
            chats: chats,
            chatMessages: messages,
          );
          return;
        } catch (e) {
          if (kDebugMode) {
            print('Failed to create chat message in API: $e');
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error checking API availability: $e');
      }
    }
    
    // Fallback to local state
    final messages = Map<String, List<Map<String, dynamic>>>.from(state.chatMessages);
    
    final newMessage = {
      'id': messageId,
      'userId': userId,
      'userName': userName ?? 'User',
      'content': content,
      'time': DateTime.now().toIso8601String(),
    };
    
    final chatMessages = List<Map<String, dynamic>>.from(messages[chatId] ?? []);
    chatMessages.add(newMessage);
    
    messages[chatId] = chatMessages;
    
    // Update chat last message
    final chats = List<Map<String, dynamic>>.from(state.chats);
    final chatIndex = chats.indexWhere((c) => c['id'] == chatId);
    if (chatIndex != -1) {
      chats[chatIndex] = Map<String, dynamic>.from(chats[chatIndex])
        ..['lastMessage'] = content
        ..['time'] = 'Just now';
    }
    
    state = state.copyWith(
      chats: chats,
      chatMessages: messages,
    );
  }

  Future<void> loadChatMessages(String chatId) async {
    // Try to load from API
    try {
      final isApiAvailable = await ApiService.checkHealth();
      if (isApiAvailable) {
        try {
          final messages = await ApiService.getChatMessages(chatId: chatId);
          
          // Format messages for UI
          final formattedMessages = messages.map((msg) {
            final timestamp = msg['timestamp'] ?? msg['createdAt'];
            return {
              ...msg,
              'time': timestamp,
            };
          }).toList();
          
          // Update local state
          final chatMessages = Map<String, List<Map<String, dynamic>>>.from(state.chatMessages);
          chatMessages[chatId] = formattedMessages;
          
          state = state.copyWith(chatMessages: chatMessages);
          return;
        } catch (e) {
          if (kDebugMode) {
            print('Failed to load chat messages from API: $e');
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error checking API availability: $e');
      }
    }
    
    // If API fails, keep existing local messages
  }

  void blockUser(String userId) {
    final blockedUsers = Set<String>.from(state.blockedUsers);
    blockedUsers.add(userId);
    
    // Remove posts from blocked users
    final filteredPosts = state.posts.where((p) => p['authorId'] != userId).toList();
    
    state = state.copyWith(
      blockedUsers: blockedUsers,
      posts: filteredPosts,
    );
  }

  void reportPost(String postId) {
    // In real app, this would send to backend
    // For now, we'll just acknowledge it
  }

  Future<void> deletePost(String postId) async {
    // Try to delete in backend
    try {
      final isApiAvailable = await ApiService.checkHealth();
      if (isApiAvailable) {
        try {
          final success = await ApiService.deletePost(postId);
          if (success) {
            final filteredPosts = state.posts.where((p) => p['id'] != postId).toList();
            state = state.copyWith(posts: filteredPosts);
            return;
          }
        } catch (e) {
          if (kDebugMode) {
            print('Failed to delete post in API: $e');
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error checking API availability: $e');
      }
    }
    
    // Fallback to local state
    final filteredPosts = state.posts.where((p) => p['id'] != postId).toList();
    state = state.copyWith(posts: filteredPosts);
  }

  Future<void> refreshPosts() async {
    await _loadCommunityData();
  }
}

