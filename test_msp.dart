// Test the MSP service with hardcoded values
// You can test this by running: dart run test_msp.dart

import 'lib/services/msp_service.dart';

void main() async {
  print('Testing MSP Service with hardcoded values...');
  
  try {
    // Test hardcoded MSP prices
    final mspPrices = await MSPService.getMSPPrices();
    
    print('✅ MSP Service working successfully!');
    print('Total MSP records: ${mspPrices.length}');
    
    if (mspPrices.isNotEmpty) {
      print('\n📊 Sample MSP Data:');
      for (var price in mspPrices.take(5)) {
        print('Crop: ${price['crop']}');
        print('MSP Price: ₹${price['mspPrice']}/${price['unit']}');
        print('Season: ${price['season']}');
        print('Category: ${price['category']}');
        print('---');
      }
    }
    
    // Test market prices
    print('\n🛒 Testing Market Prices...');
    final marketPrices = await MSPService.getMarketPrices();
    print('Total Market records: ${marketPrices.length}');
    
    if (marketPrices.isNotEmpty) {
      print('\n📈 Sample Market Data:');
      for (var price in marketPrices.take(3)) {
        print('Crop: ${price['crop']}');
        print('Price: ₹${price['price']}/${price['unit']}');
        print('Market: ${price['market']}');
        print('State: ${price['state']}');
        print('---');
      }
    }
    
  } catch (e) {
    print('❌ Error: $e');
  }
}
