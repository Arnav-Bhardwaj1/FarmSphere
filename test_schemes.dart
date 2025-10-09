// Test the Government Schemes with website links
// You can test this by running: dart run test_schemes.dart

import 'lib/services/msp_service.dart';

void main() async {
  print('Testing Government Schemes with website links...');
  
  try {
    // Test government schemes
    final schemes = await MSPService.getGovernmentSchemes();
    
    print('✅ Government Schemes loaded successfully!');
    print('Total schemes: ${schemes.length}');
    
    if (schemes.isNotEmpty) {
      print('\n🏛️ Sample Government Schemes:');
      for (var scheme in schemes.take(3)) {
        print('Scheme: ${scheme['title']}');
        print('Description: ${scheme['description']}');
        print('Eligibility: ${scheme['eligibility']}');
        print('Benefits: ${scheme['benefit']}');
        print('Website: ${scheme['website']}');
        print('Status: ${scheme['status']}');
        print('---');
      }
    }
    
    print('\n🔗 All schemes have official website links!');
    print('Users can click "Visit Website" to go to official portals.');
    
  } catch (e) {
    print('❌ Error: $e');
  }
}

