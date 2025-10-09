// Test the wttr.in API
// You can test this by running: dart run test_weather.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  print('Testing wttr.in API...');
  
  try {
    // Test with Delhi, India
    final url = 'https://wttr.in/Delhi?format=j1';
    final response = await http.get(Uri.parse(url));
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print('✅ API Response received successfully!');
      print('Location: ${data['nearest_area']?[0]['areaName']?[0]['value']}');
      print('Current Temp: ${data['current_condition']?[0]['temp_C']}°C');
      print('Condition: ${data['current_condition']?[0]['weatherDesc']?[0]['value']}');
      print('Humidity: ${data['current_condition']?[0]['humidity']}%');
      print('Wind Speed: ${data['current_condition']?[0]['windspeedKmph']} km/h');
    } else {
      print('❌ API Error: ${response.statusCode}');
    }
  } catch (e) {
    print('❌ Error: $e');
  }
}

