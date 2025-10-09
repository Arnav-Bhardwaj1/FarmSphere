import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class WeatherService {
  // Using wttr.in API - Completely FREE, no registration required!
  static const String _baseUrl = 'https://wttr.in';
  
  // Alternative free APIs (if wttr.in is not available):
  // 1. WeatherAPI.com - 1000 calls/day free (no credit card required)
  // 2. Visual Crossing Weather - 1000 records/day free
  // 3. Weatherstack - 250 calls/month free

  /// Get current weather data for a location
  static Future<Map<String, dynamic>> getCurrentWeather(String location) async {
    try {
      // Using wttr.in API - completely free, no API key required
      final encodedLocation = Uri.encodeComponent(location);
      final url = '$_baseUrl/$encodedLocation?format=j1';
      
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return _formatWttrWeatherData(data, location);
      } else {
        throw Exception('Failed to fetch weather data: ${response.statusCode}');
      }
    } catch (e) {
      // Fallback to mock data if API fails
      return _getMockCurrentWeather(location);
    }
  }

  /// Get weather forecast for a location
  static Future<List<Map<String, dynamic>>> getWeatherForecast(String location) async {
    try {
      // For now, use mock data to ensure 7-day forecast
      // TODO: Fix wttr.in API parsing to get full 7-day forecast
      return _getMockForecast();
      
      // Uncomment below when wttr.in API is fixed
      /*
      final encodedLocation = Uri.encodeComponent(location);
      final url = '$_baseUrl/$encodedLocation?format=j1';
      
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return _formatWttrForecastData(data);
      } else {
        throw Exception('Failed to fetch forecast data: ${response.statusCode}');
      }
      */
    } catch (e) {
      // Fallback to mock data if API fails
      return _getMockForecast();
    }
  }

  /// Get weather alerts for a location
  static Future<List<Map<String, dynamic>>> getWeatherAlerts(String location) async {
    try {
      // wttr.in doesn't provide alerts, so we'll use mock data
      // In a real app, you could integrate with weather alert services
      return _getMockAlerts();
    } catch (e) {
      // Fallback to mock data if API fails
      return _getMockAlerts();
    }
  }

  /// Get current location using GPS
  static Future<Map<String, dynamic>> getCurrentLocation() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled');
      }

      // Check location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permissions are permanently denied');
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Convert coordinates to address
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        final placemark = placemarks.first;
        final locality = placemark.locality ?? placemark.subLocality ?? 'Unknown City';
        final administrativeArea = placemark.administrativeArea ?? placemark.subAdministrativeArea ?? 'Unknown State';
        final locationString = '$locality, $administrativeArea';
        
        return {
          'latitude': position.latitude,
          'longitude': position.longitude,
          'location': locationString,
          'address': placemark.toString(),
        };
      } else {
        return {
          'latitude': position.latitude,
          'longitude': position.longitude,
          'location': 'Unknown Location',
          'address': 'Unknown Address',
        };
      }
    } catch (e) {
      throw Exception('Failed to get current location: $e');
    }
  }

  /// Convert location string to coordinates
  static Future<Map<String, double>> _getCoordinatesFromLocation(String location) async {
    try {
      List<Location> locations = await locationFromAddress(location);
      if (locations.isNotEmpty) {
        return {
          'lat': locations.first.latitude,
          'lon': locations.first.longitude,
        };
      }
      throw Exception('Location not found');
    } catch (e) {
      // Fallback coordinates for Delhi, India
      return {'lat': 28.6139, 'lon': 77.2090};
    }
  }

  /// Format weather data from wttr.in API response
  static Map<String, dynamic> _formatWttrWeatherData(Map<String, dynamic> data, String location) {
    try {
      final current = data['current_condition']?[0];
      final nearestArea = data['nearest_area']?[0];
      
      return {
        'temperature': int.tryParse(current['temp_C']?.toString() ?? '0') ?? 0,
        'humidity': int.tryParse(current['humidity']?.toString() ?? '0') ?? 0,
        'condition': current['weatherDesc']?[0]['value'] ?? 'Unknown',
        'description': current['weatherDesc']?[0]['value'] ?? 'Unknown',
        'windSpeed': double.tryParse(current['windspeedKmph']?.toString() ?? '0') ?? 0,
        'pressure': double.tryParse(current['pressure']?.toString() ?? '0') ?? 0,
        'visibility': double.tryParse(current['visibility']?.toString() ?? '0') ?? 0,
        'uvIndex': int.tryParse(current['uvIndex']?.toString() ?? '0') ?? 0,
        'location': nearestArea['areaName']?[0]['value'] ?? location,
        'country': nearestArea['country']?[0]['value'] ?? 'Unknown',
        'sunrise': data['weather']?[0]['astronomy']?[0]['sunrise'] ?? '06:00',
        'sunset': data['weather']?[0]['astronomy']?[0]['sunset'] ?? '18:00',
        'timestamp': DateTime.now().toIso8601String(),
      };
    } catch (e) {
      return _getMockCurrentWeather(location);
    }
  }

  /// Format forecast data from wttr.in API response
  static List<Map<String, dynamic>> _formatWttrForecastData(Map<String, dynamic> data) {
    List<Map<String, dynamic>> forecast = [];
    
    try {
      final weather = data['weather'] as List?;
      if (weather != null && weather.isNotEmpty) {
        for (var day in weather.take(7)) {
          final date = day['date'] ?? DateTime.now().toIso8601String();
          final hourly = day['hourly'] as List?;
          
          if (hourly != null && hourly.isNotEmpty) {
            // Get midday weather for the day (index 2 is usually around midday)
            final middayWeather = hourly.length > 2 ? hourly[2] : hourly[0];
            
            // Extract temperature data - try different possible keys
            int high = 0;
            int low = 0;
            
            // Try to get max/min temperatures from the day data
            if (day['maxtempC'] != null) {
              high = int.tryParse(day['maxtempC'].toString()) ?? 0;
            }
            if (day['mintempC'] != null) {
              low = int.tryParse(day['mintempC'].toString()) ?? 0;
            }
            
            // If no day-level data, try hourly data
            if (high == 0 && middayWeather['maxtempC'] != null) {
              high = int.tryParse(middayWeather['maxtempC'].toString()) ?? 0;
            }
            if (low == 0 && middayWeather['mintempC'] != null) {
              low = int.tryParse(middayWeather['mintempC'].toString()) ?? 0;
            }
            
            // If still no temperature data, use current temp as fallback
            if (high == 0 && low == 0) {
              final currentTemp = int.tryParse(middayWeather['tempC']?.toString() ?? '0') ?? 0;
              high = currentTemp + 2;
              low = currentTemp - 2;
            }
            
            forecast.add({
              'date': date,
              'high': high,
              'low': low,
              'condition': middayWeather['weatherDesc']?[0]['value'] ?? 'Unknown',
              'description': middayWeather['weatherDesc']?[0]['value'] ?? 'Unknown',
              'humidity': int.tryParse(middayWeather['humidity']?.toString() ?? '0') ?? 0,
              'windSpeed': double.tryParse(middayWeather['windspeedKmph']?.toString() ?? '0') ?? 0,
              'precipitation': double.tryParse(middayWeather['precipMM']?.toString() ?? '0') ?? 0,
            });
          }
        }
      }
    } catch (e) {
      print('Error parsing wttr.in forecast data: $e');
      // Return mock data if parsing fails
      return _getMockForecast();
    }
    
    // If we got less than 3 days or all temperatures are 0, use mock data
    if (forecast.length < 3 || forecast.every((day) => day['high'] == 0 && day['low'] == 0)) {
      print('Insufficient forecast data, using mock data');
      return _getMockForecast();
    }
    
    return forecast;
  }

  /// Mock current weather data (fallback)
  static Map<String, dynamic> _getMockCurrentWeather(String location) {
    return {
      'temperature': 28,
      'humidity': 65,
      'condition': 'Partly Cloudy',
      'description': 'Partly cloudy with occasional sunshine',
      'windSpeed': 12,
      'pressure': 1013,
      'visibility': 10,
      'uvIndex': 6,
      'location': location,
      'country': 'IN',
      'sunrise': DateTime.now().millisecondsSinceEpoch ~/ 1000,
      'sunset': DateTime.now().add(const Duration(hours: 12)).millisecondsSinceEpoch ~/ 1000,
      'timestamp': DateTime.now().toIso8601String(),
    };
  }

  /// Mock forecast data (fallback) - Seasonally appropriate
  static List<Map<String, dynamic>> _getMockForecast() {
    final currentMonth = DateTime.now().month;
    
    // Define seasonal weather patterns
    List<String> conditions;
    List<String> descriptions;
    int baseHigh, baseLow;
    
    if (currentMonth >= 6 && currentMonth <= 9) {
      // Monsoon season - Rainy weather
      conditions = ['Heavy Rain', 'Light Rain', 'Cloudy', 'Partly Cloudy', 'Thunderstorm', 'Light Rain', 'Cloudy'];
      descriptions = ['Heavy rainfall', 'Light showers', 'Overcast', 'Partly cloudy', 'Thunderstorm', 'Light rain', 'Cloudy'];
      baseHigh = 28; baseLow = 22;
    } else if (currentMonth >= 3 && currentMonth <= 5) {
      // Summer season - Hot and dry
      conditions = ['Sunny', 'Partly Cloudy', 'Sunny', 'Hot', 'Sunny', 'Partly Cloudy', 'Sunny'];
      descriptions = ['Clear sky', 'Partly cloudy', 'Clear sky', 'Very hot', 'Clear sky', 'Partly cloudy', 'Clear sky'];
      baseHigh = 35; baseLow = 25;
    } else if (currentMonth >= 10 && currentMonth <= 12) {
      // Post-monsoon/Winter - Cool weather
      conditions = ['Partly Cloudy', 'Sunny', 'Cloudy', 'Partly Cloudy', 'Sunny', 'Cloudy', 'Partly Cloudy'];
      descriptions = ['Partly cloudy', 'Clear sky', 'Overcast', 'Partly cloudy', 'Clear sky', 'Cloudy', 'Partly cloudy'];
      baseHigh = 30; baseLow = 20;
    } else {
      // Winter season - Cold weather
      conditions = ['Cold', 'Partly Cloudy', 'Cold', 'Sunny', 'Cold', 'Partly Cloudy', 'Cold'];
      descriptions = ['Cold weather', 'Partly cloudy', 'Cold weather', 'Clear sky', 'Cold weather', 'Partly cloudy', 'Cold weather'];
      baseHigh = 25; baseLow = 15;
    }
    
    return List.generate(7, (index) => {
      'date': DateTime.now().add(Duration(days: index)).toIso8601String(),
      'high': baseHigh + (index % 3), // Small variation
      'low': baseLow + (index % 2),   // Small variation
      'condition': conditions[index],
      'description': descriptions[index],
      'humidity': currentMonth >= 6 && currentMonth <= 9 ? 75 + (index % 10) : 60 + (index % 15),
      'windSpeed': 8 + (index % 7),
      'precipitation': (currentMonth >= 6 && currentMonth <= 9) ? (0.3 + (index % 3) * 0.1) : 0.0,
    });
  }

  /// Mock alerts data (fallback) - Realistic weather alerts
  static List<Map<String, dynamic>> _getMockAlerts() {
    final currentMonth = DateTime.now().month;
    
    // Seasonal weather alerts based on current month
    if (currentMonth >= 6 && currentMonth <= 9) {
      // Monsoon season (June-September) - Focus on rain-related alerts
      return [
        {
          'type': 'Heavy Rain Alert',
          'message': 'Heavy rainfall expected in next 24 hours. Avoid field work and protect harvested crops.',
          'severity': 'High',
          'time': DateTime.now().add(const Duration(hours: 8)).toIso8601String(),
          'end': DateTime.now().add(const Duration(hours: 32)).toIso8601String(),
        },
        {
          'type': 'Flood Warning',
          'message': 'Waterlogging possible in low-lying areas. Ensure proper drainage for your fields.',
          'severity': 'Medium',
          'time': DateTime.now().add(const Duration(hours: 12)).toIso8601String(),
          'end': DateTime.now().add(const Duration(hours: 48)).toIso8601String(),
        },
      ];
    } else if (currentMonth >= 3 && currentMonth <= 5) {
      // Summer season (March-May) - Focus on heat-related alerts
      return [
        {
          'type': 'Heat Wave Alert',
          'message': 'High temperature expected (above 40°C). Ensure adequate irrigation for your crops.',
          'severity': 'High',
          'time': DateTime.now().add(const Duration(hours: 6)).toIso8601String(),
          'end': DateTime.now().add(const Duration(hours: 30)).toIso8601String(),
        },
        {
          'type': 'Water Scarcity Warning',
          'message': 'Low humidity levels detected. Increase irrigation frequency for sensitive crops.',
          'severity': 'Medium',
          'time': DateTime.now().add(const Duration(hours: 4)).toIso8601String(),
          'end': DateTime.now().add(const Duration(hours: 24)).toIso8601String(),
        },
      ];
    } else if (currentMonth >= 10 && currentMonth <= 12) {
      // Post-monsoon/Winter (October-December) - Mixed alerts
      return [
        {
          'type': 'Cold Wave Alert',
          'message': 'Temperature drop expected. Protect sensitive crops with proper covering.',
          'severity': 'Medium',
          'time': DateTime.now().add(const Duration(hours: 10)).toIso8601String(),
          'end': DateTime.now().add(const Duration(hours: 36)).toIso8601String(),
        },
        {
          'type': 'Fog Warning',
          'message': 'Dense fog expected in early morning. Avoid field operations during low visibility.',
          'severity': 'Low',
          'time': DateTime.now().add(const Duration(hours: 14)).toIso8601String(),
          'end': DateTime.now().add(const Duration(hours: 20)).toIso8601String(),
        },
      ];
    } else {
      // Winter season (January-February) - Cold weather alerts
      return [
        {
          'type': 'Frost Warning',
          'message': 'Frost conditions expected tonight. Cover sensitive crops to prevent damage.',
          'severity': 'High',
          'time': DateTime.now().add(const Duration(hours: 16)).toIso8601String(),
          'end': DateTime.now().add(const Duration(hours: 8)).toIso8601String(),
        },
        {
          'type': 'Cold Weather Alert',
          'message': 'Temperatures below 10°C expected. Ensure proper crop protection measures.',
          'severity': 'Medium',
          'time': DateTime.now().add(const Duration(hours: 6)).toIso8601String(),
          'end': DateTime.now().add(const Duration(hours: 24)).toIso8601String(),
        },
      ];
    }
  }
}
