import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/foundation.dart';
import '../secrets.dart';

class LocationService {
  // Nokia Network as Code API configuration
  static const String _baseUrl = 'https://network-as-code.p.rapidapi.com';
  static const String _rapidApiKey = rapidApiKey;
  
  // Free reverse geocoding API (works better on web)
  static const String _reverseGeocodingUrl = 'https://api.bigdatacloud.net/data/reverse-geocode-client';
  
  /// Retrieve location using Nokia Network as Code API
  static Future<Map<String, dynamic>> retrieveLocation() async {
    try {
      // First get current GPS coordinates
      final gpsLocation = await _getCurrentGPSLocation();
      
      // Use Nokia API to get enhanced location data
      final nokiaLocation = await _callNokiaLocationAPI();
      
      // Combine GPS and Nokia data
      return {
        'latitude': gpsLocation['latitude'],
        'longitude': gpsLocation['longitude'],
        'location': gpsLocation['location'],
        'address': gpsLocation['address'],
        'nokiaData': nokiaLocation,
        'timestamp': DateTime.now().toIso8601String(),
      };
    } catch (e) {
      // Fallback to GPS-only location
      return await _getCurrentGPSLocation();
    }
  }
  
  /// Call Nokia Network as Code retrieveLocation API
  static Future<Map<String, dynamic>> _callNokiaLocationAPI() async {
    try {
      // Check if Nokia API is properly configured
      if (!isNokiaAPIConfigured()) {
        throw Exception('Nokia API not configured - using GPS fallback');
      }
      
      final url = Uri.parse('$_baseUrl/location/retrieveLocation');
      
      final headers = {
        'Content-Type': 'application/json',
        'X-RapidAPI-Key': _rapidApiKey,
        'X-RapidAPI-Host': 'network-as-code.p.rapidapi.com',
      };
      
      final body = {
        'device': {
          'phoneNumber': '+99999991000', // Placeholder phone number for testing
        },
        'maxAge': 60,
      };
      
      if (kDebugMode) {
        print('Calling Nokia API with URL: $url');
        print('Headers: $headers');
        print('Body: $body');
      }
      
      final response = await http.post(
        url,
        headers: headers,
        body: json.encode(body),
      );
      
      if (kDebugMode) {
        print('Nokia API Response Status: ${response.statusCode}');
        print('Nokia API Response Body: ${response.body}');
      }
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return _parseNokiaLocationResponse(data);
      } else {
        throw Exception('Nokia API request failed: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Nokia API Error: $e');
      }
      throw Exception('Failed to call Nokia Location API: $e');
    }
  }
  
  /// Parse Nokia API response
  static Map<String, dynamic> _parseNokiaLocationResponse(Map<String, dynamic> data) {
    try {
      final area = data['area'];
      final center = area?['center'];
      
      return {
        'lastLocationTime': data['lastLocationTime'],
        'areaType': area?['areaType'],
        'centerLatitude': center?['latitude'],
        'centerLongitude': center?['longitude'],
        'radius': area?['radius'],
        'accuracy': 'High', // Nokia provides high accuracy location
      };
    } catch (e) {
      throw Exception('Failed to parse Nokia API response: $e');
    }
  }
  
  /// Get current GPS location (fallback method)
  static Future<Map<String, dynamic>> _getCurrentGPSLocation() async {
    try {
      if (kDebugMode) {
        print('Starting GPS location detection...');
      }
      
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (kDebugMode) {
        print('Location services enabled: $serviceEnabled');
      }
      
      if (!serviceEnabled) {
        throw Exception('Location services are disabled');
      }

      // Check location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (kDebugMode) {
        print('Initial permission: $permission');
      }
      
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (kDebugMode) {
          print('Permission after request: $permission');
        }
        
        if (permission == LocationPermission.denied) {
          throw Exception('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permissions are permanently denied');
      }

      if (kDebugMode) {
        print('Getting current position...');
      }
      
      // Get current position with timeout
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );
      
      if (kDebugMode) {
        print('Position obtained: ${position.latitude}, ${position.longitude}');
      }

      // Convert coordinates to address using API (more reliable on web)
      try {
        if (kDebugMode) {
          print('Converting coordinates to address using API...');
        }
        
        return await _getLocationFromAPI(position.latitude, position.longitude);
      } catch (e) {
        if (kDebugMode) {
          print('API address conversion failed: $e');
        }
        
        // Fallback to geocoding package
        try {
          List<Placemark> placemarks = await placemarkFromCoordinates(
            position.latitude,
            position.longitude,
          );
          
          if (kDebugMode) {
            print('Placemarks found: ${placemarks.length}');
          }

          if (placemarks.isNotEmpty) {
            final placemark = placemarks.first;
            if (kDebugMode) {
              print('Placemark: ${placemark.toString()}');
            }
            
            // Safe extraction of location components
            String locality = 'Unknown City';
            String administrativeArea = 'Unknown State';
            
            try {
              locality = placemark.locality ?? placemark.subLocality ?? placemark.locality ?? 'Unknown City';
            } catch (e) {
              if (kDebugMode) print('Error extracting locality: $e');
            }
            
            try {
              administrativeArea = placemark.administrativeArea ?? placemark.subAdministrativeArea ?? placemark.administrativeArea ?? 'Unknown State';
            } catch (e) {
              if (kDebugMode) print('Error extracting administrative area: $e');
            }
            
            final locationString = '$locality, $administrativeArea';
            
            if (kDebugMode) {
              print('Location string: $locationString');
            }
            
            return {
              'latitude': position.latitude,
              'longitude': position.longitude,
              'location': locationString,
              'address': placemark.toString(),
              'accuracy': 'GPS',
            };
          }
        } catch (e) {
          if (kDebugMode) {
            print('Geocoding package also failed: $e');
          }
        }
        
        // Final fallback
        if (kDebugMode) {
          print('No placemarks found, using coordinates only');
        }
        return {
          'latitude': position.latitude,
          'longitude': position.longitude,
          'location': 'Unknown Location',
          'address': 'Unknown Address',
          'accuracy': 'GPS',
        };
      }
    } catch (e) {
      if (kDebugMode) {
        print('GPS location error: $e');
      }
      throw Exception('Failed to get GPS location: $e');
    }
  }
  
  /// Enhanced location detection with Nokia API integration
  static Future<Map<String, dynamic>> detectLocationWithNokia() async {
    try {
      if (kDebugMode) {
        print('Starting location detection with Nokia API...');
      }
      
      // Try Nokia API first
      final locationData = await retrieveLocation();
      
      if (kDebugMode) {
        print('Location data received: $locationData');
      }
      
      // If Nokia API provided additional data, use it
      if (locationData.containsKey('nokiaData')) {
        final nokiaData = locationData['nokiaData'];
        
        // Use Nokia's center coordinates if available and more accurate
        if (nokiaData['centerLatitude'] != null && nokiaData['centerLongitude'] != null) {
          // Convert Nokia coordinates to address
          try {
            if (kDebugMode) {
              print('Converting Nokia coordinates to address...');
            }
            List<Placemark> placemarks = await placemarkFromCoordinates(
              nokiaData['centerLatitude'],
              nokiaData['centerLongitude'],
            );
            
            if (placemarks.isNotEmpty) {
              final placemark = placemarks.first;
              
              // Safe extraction of location components
              String locality = 'Unknown City';
              String administrativeArea = 'Unknown State';
              
              try {
                locality = placemark.locality ?? placemark.subLocality ?? placemark.locality ?? 'Unknown City';
              } catch (e) {
                if (kDebugMode) print('Error extracting locality: $e');
              }
              
              try {
                administrativeArea = placemark.administrativeArea ?? placemark.subAdministrativeArea ?? placemark.administrativeArea ?? 'Unknown State';
              } catch (e) {
                if (kDebugMode) print('Error extracting administrative area: $e');
              }
              
              final locationString = '$locality, $administrativeArea';
              
              if (kDebugMode) {
                print('Nokia location converted: $locationString');
              }
              
              return {
                'latitude': nokiaData['centerLatitude'],
                'longitude': nokiaData['centerLongitude'],
                'location': locationString,
                'address': placemark.toString(),
                'accuracy': 'Nokia Network as Code',
                'lastLocationTime': nokiaData['lastLocationTime'],
                'areaType': nokiaData['areaType'],
                'radius': nokiaData['radius'],
              };
            }
          } catch (e) {
            // If reverse geocoding fails, use original GPS data
            if (kDebugMode) {
              print('Reverse geocoding failed for Nokia coordinates: $e');
            }
          }
        }
      }
      
      // Return the combined data
      if (kDebugMode) {
        print('Returning combined location data: $locationData');
      }
      return locationData;
    } catch (e) {
      // Fallback to GPS-only location
      if (kDebugMode) {
        print('Nokia API failed, falling back to GPS: $e');
      }
      return await _getCurrentGPSLocation();
    }
  }
  
  /// Validate Nokia API configuration
  static bool isNokiaAPIConfigured() {
    return rapidApiKey.isNotEmpty && 
           rapidApiKey != '60749d29c4msh9d8ede71b91ba2ep11f0dfjsn0044285422af';
  }
  
  /// Get location accuracy description
  static String getLocationAccuracyDescription(Map<String, dynamic> locationData) {
    if (locationData['accuracy'] == 'Nokia Network as Code') {
      return 'High accuracy location from Nokia Network as Code';
    } else if (locationData['accuracy'] == 'GPS') {
      return 'GPS location';
    } else {
      return 'Location detected';
    }
  }
  
  /// Get location using free reverse geocoding API (works better on web)
  static Future<Map<String, dynamic>> _getLocationFromAPI(double latitude, double longitude) async {
    try {
      if (kDebugMode) {
        print('Getting location from reverse geocoding API...');
      }
      
      final url = '$_reverseGeocodingUrl?latitude=$latitude&longitude=$longitude&localityLanguage=en';
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (kDebugMode) {
          print('Reverse geocoding API response: $data');
        }
        
        final city = data['city'] ?? data['locality'] ?? 'Unknown City';
        final state = data['principalSubdivision'] ?? data['administrativeArea'] ?? 'Unknown State';
        final country = data['countryName'] ?? 'Unknown Country';
        
        final locationString = '$city, $state';
        
        return {
          'latitude': latitude,
          'longitude': longitude,
          'location': locationString,
          'address': '$city, $state, $country',
          'accuracy': 'API',
          'city': city,
          'state': state,
          'country': country,
        };
      } else {
        throw Exception('Reverse geocoding API failed: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Reverse geocoding API error: $e');
      }
      throw Exception('Failed to get location from API: $e');
    }
  }
  
  /// Simple GPS-only location detection for testing
  static Future<Map<String, dynamic>> getSimpleLocation() async {
    try {
      if (kDebugMode) {
        print('Getting simple GPS location...');
      }
      
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
        desiredAccuracy: LocationAccuracy.medium,
        timeLimit: const Duration(seconds: 5),
      );
      
      if (kDebugMode) {
        print('Simple position obtained: ${position.latitude}, ${position.longitude}');
      }

      // Convert coordinates to address using API (more reliable on web)
      try {
        if (kDebugMode) {
          print('Converting coordinates to address using API...');
        }
        
        return await _getLocationFromAPI(position.latitude, position.longitude);
      } catch (e) {
        if (kDebugMode) {
          print('API address conversion failed: $e');
        }
        
        // Fallback to geocoding package
        try {
          List<Placemark> placemarks = await placemarkFromCoordinates(
            position.latitude,
            position.longitude,
          );
          
          if (placemarks.isNotEmpty) {
            final placemark = placemarks.first;
            
            // Safe extraction of location components
            String locality = 'Unknown City';
            String administrativeArea = 'Unknown State';
            
            try {
              locality = placemark.locality ?? placemark.subLocality ?? placemark.locality ?? 'Unknown City';
            } catch (e) {
              if (kDebugMode) print('Error extracting locality: $e');
            }
            
            try {
              administrativeArea = placemark.administrativeArea ?? placemark.subAdministrativeArea ?? placemark.administrativeArea ?? 'Unknown State';
            } catch (e) {
              if (kDebugMode) print('Error extracting administrative area: $e');
            }
            
            final locationString = '$locality, $administrativeArea';
            
            if (kDebugMode) {
              print('Simple location converted: $locationString');
            }
            
            return {
              'latitude': position.latitude,
              'longitude': position.longitude,
              'location': locationString,
              'address': placemark.toString(),
              'accuracy': 'GPS',
            };
          }
        } catch (e) {
          if (kDebugMode) {
            print('Geocoding package also failed: $e');
          }
        }
      }

      // Fallback if address conversion fails
      return {
        'latitude': position.latitude,
        'longitude': position.longitude,
        'location': 'Unknown Location',
        'address': 'Unknown Address',
        'accuracy': 'GPS',
      };
    } catch (e) {
      if (kDebugMode) {
        print('Simple GPS location error: $e');
      }
      throw Exception('Failed to get simple GPS location: $e');
    }
  }
}