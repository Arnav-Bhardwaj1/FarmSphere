import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// Service for plant disease detection via local API
class PlantDiseaseService {
  // Resolve base URL dynamically to avoid mixed-content and host mismatches on web
  static String get baseUrl {
    final uri = Uri.base; // current app URL
    final scheme = (uri.scheme == 'https') ? 'https' : 'http';
    final host = (uri.host.isEmpty) ? 'localhost' : uri.host;
    return '$scheme://$host:5000';
  }
  
  /// Check if the API server is running
  static Future<bool> checkHealth() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/health'))
          .timeout(const Duration(seconds: 5));
      return response.statusCode == 200;
    } catch (e) {
      if (kDebugMode) {
        print('PlantDiseaseService: Health check failed - $e');
      }
      return false;
    }
  }
  
  /// Predict disease from image file
  static Future<List<Map<String, dynamic>>> predictDisease(
    File imageFile, {
    int maxRetries = 3,
    Duration timeout = const Duration(seconds: 30),
  }) async {
    int retryCount = 0;
    Exception? lastException;

    while (retryCount < maxRetries) {
      try {
        // Create multipart request
        final request = http.MultipartRequest('POST', Uri.parse('$baseUrl/predict'));
        
        // Add image file
        request.files.add(
          await http.MultipartFile.fromPath('file', imageFile.path),
        );
        
        // Send request with timeout
        final streamedResponse = await request.send().timeout(timeout);
        final response = await http.Response.fromStream(streamedResponse);
        
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          if (kDebugMode) {
            print('PlantDiseaseService: Successfully predicted disease');
          }
          return List<Map<String, dynamic>>.from(data['results'] ?? []);
        } else if (response.statusCode >= 500) {
          // Server error - retry
          throw SocketException('Server error: ${response.statusCode}');
        } else {
          // Client error - don't retry
          if (kDebugMode) {
            print('PlantDiseaseService: Prediction failed - ${response.statusCode}: ${response.body}');
          }
          throw Exception('Prediction failed with status ${response.statusCode}: ${response.body}');
        }
      } on TimeoutException catch (e) {
        lastException = e;
        if (kDebugMode) {
          print('PlantDiseaseService: Request timeout (attempt ${retryCount + 1}/$maxRetries)');
        }
        retryCount++;
        if (retryCount < maxRetries) {
          await Future.delayed(Duration(seconds: retryCount * 2));
        }
      } on SocketException catch (e) {
        lastException = e;
        if (kDebugMode) {
          print('PlantDiseaseService: Network error (attempt ${retryCount + 1}/$maxRetries) - $e');
        }
        retryCount++;
        if (retryCount < maxRetries) {
          await Future.delayed(Duration(seconds: retryCount * 2));
        }
      } catch (e) {
        // Don't retry for other errors
        if (kDebugMode) {
          print('PlantDiseaseService: Error predicting disease: $e');
        }
        rethrow;
      }
    }

    // All retries exhausted
    if (kDebugMode) {
      print('PlantDiseaseService: All retry attempts exhausted');
    }
    throw lastException ?? Exception('Failed to predict disease after $maxRetries attempts');
  }
  
  /// Predict disease from image bytes (for web compatibility)
  static Future<List<Map<String, dynamic>>> predictDiseaseFromBytes(
    Uint8List imageBytes, {
    int maxRetries = 3,
    Duration timeout = const Duration(seconds: 30),
  }) async {
    int retryCount = 0;
    Exception? lastException;

    while (retryCount < maxRetries) {
      try {
        // Encode to base64
        final base64Image = base64Encode(imageBytes);
        
        // Send request with timeout
        final response = await http
            .post(
              Uri.parse('$baseUrl/predict'),
              headers: {'Content-Type': 'application/json'},
              body: json.encode({'image': base64Image}),
            )
            .timeout(timeout);
        
        if (kDebugMode) {
          print('PlantDiseaseService: API Response Status: ${response.statusCode}');
        }
        
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          if (kDebugMode) {
            print('PlantDiseaseService: Successfully predicted disease from bytes');
          }
          final results = List<Map<String, dynamic>>.from(data['results'] ?? []);
          return results;
        } else if (response.statusCode >= 500) {
          // Server error - retry
          throw SocketException('Server error: ${response.statusCode}');
        } else {
          // Client error - don't retry
          if (kDebugMode) {
            print('PlantDiseaseService: Prediction failed - ${response.statusCode}: ${response.body}');
          }
          throw Exception('Prediction failed with status ${response.statusCode}: ${response.body}');
        }
      } on TimeoutException catch (e) {
        lastException = e;
        if (kDebugMode) {
          print('PlantDiseaseService: Request timeout (attempt ${retryCount + 1}/$maxRetries)');
        }
        retryCount++;
        if (retryCount < maxRetries) {
          await Future.delayed(Duration(seconds: retryCount * 2));
        }
      } on SocketException catch (e) {
        lastException = e;
        if (kDebugMode) {
          print('PlantDiseaseService: Network error (attempt ${retryCount + 1}/$maxRetries) - $e');
        }
        retryCount++;
        if (retryCount < maxRetries) {
          await Future.delayed(Duration(seconds: retryCount * 2));
        }
      } catch (e) {
        // Don't retry for other errors
        if (kDebugMode) {
          print('PlantDiseaseService: Error predicting disease from bytes: $e');
        }
        rethrow;
      }
    }

    // All retries exhausted
    if (kDebugMode) {
      print('PlantDiseaseService: All retry attempts exhausted');
    }
    throw lastException ?? Exception('Failed to predict disease after $maxRetries attempts');
  }
}

