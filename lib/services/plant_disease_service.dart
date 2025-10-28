import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
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
      final response = await http.get(Uri.parse('$baseUrl/health'));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
  
  /// Predict disease from image file
  static Future<List<Map<String, dynamic>>> predictDisease(File imageFile) async {
    try {
      // Create multipart request
      final request = http.MultipartRequest('POST', Uri.parse('$baseUrl/predict'));
      
      // Add image file
      request.files.add(
        await http.MultipartFile.fromPath('file', imageFile.path),
      );
      
      // Send request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return List<Map<String, dynamic>>.from(data['results'] ?? []);
      } else {
        throw Exception('Prediction failed: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error predicting disease: $e');
    }
  }
  
  /// Predict disease from image bytes (for web compatibility)
  static Future<List<Map<String, dynamic>>> predictDiseaseFromBytes(Uint8List imageBytes) async {
    try {
      // Encode to base64
      final base64Image = base64Encode(imageBytes);
      
      // Send request
      final response = await http.post(
        Uri.parse('$baseUrl/predict'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'image': base64Image}),
      );
      
      print('API Response Status: ${response.statusCode}');
      print('API Response Body: ${response.body}');
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Parsed data: $data');
        final results = List<Map<String, dynamic>>.from(data['results'] ?? []);
        print('Results: $results');
        return results;
      } else {
        throw Exception('Prediction failed: ${response.body}');
      }
    } catch (e) {
      print('Exception in predictDiseaseFromBytes: $e');
      throw Exception('Error predicting disease: $e');
    }
  }
}

