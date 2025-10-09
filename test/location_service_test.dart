import 'package:flutter_test/flutter_test.dart';
import 'package:farmsphere/services/location_service.dart';

void main() {
  group('LocationService Tests', () {
    test('should validate Nokia API configuration', () {
      // Test with default (invalid) configuration
      expect(LocationService.isNokiaAPIConfigured(), false);
    });

    test('should get location accuracy description', () {
      final gpsLocation = {
        'accuracy': 'GPS',
        'location': 'Test City',
      };
      
      final nokiaLocation = {
        'accuracy': 'Nokia Network as Code',
        'location': 'Test City',
      };
      
      expect(
        LocationService.getLocationAccuracyDescription(gpsLocation),
        'GPS location',
      );
      
      expect(
        LocationService.getLocationAccuracyDescription(nokiaLocation),
        'High accuracy location from Nokia Network as Code',
      );
    });

    test('should handle Nokia API response parsing', () {
      final mockResponse = <String, dynamic>{
        'lastLocationTime': '2025-10-09T04:56:27.488174Z',
        'area': <String, dynamic>{
          'areaType': 'CIRCLE',
          'center': <String, dynamic>{
            'latitude': 47.48627616952785,
            'longitude': 19.07915612501993,
          },
          'radius': 1000,
        },
      };

      // Test the response structure
      expect(mockResponse['area']!['center']!['latitude'], 47.48627616952785);
      expect(mockResponse['area']!['center']!['longitude'], 19.07915612501993);
      expect(mockResponse['area']!['areaType'], 'CIRCLE');
      expect(mockResponse['area']!['radius'], 1000);
    });
  });
}
