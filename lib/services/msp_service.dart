import 'dart:convert';
import 'package:http/http.dart' as http;

class MSPService {
  // Using Indian Government's MSP API from data.gov.in
  static const String _baseUrl = 'https://api.data.gov.in/resource/9ef84268-d588-465a-a308-a864a43d0070';
  static const String _apiKey = '579b464db66ec23bdd00000162207ffc29514dab55daf171d62aebee';
  
  // Alternative: Using FCI (Food Corporation of India) API
  // static const String _fciBaseUrl = 'https://fci.gov.in/api/msp';

  /// Get current MSP prices for various crops
  static Future<List<Map<String, dynamic>>> getMSPPrices() async {
    try {
      // Try to fetch from government API first
      final url = '$_baseUrl?api-key=$_apiKey&format=json&limit=100';
      
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final apiData = _formatMSPData(data);
        
        // If API returns empty or invalid data, use hardcoded values
        if (apiData.isEmpty || apiData.every((item) => (item['mspPrice'] ?? 0) == 0)) {
          print('API returned empty/invalid data, using hardcoded MSP values');
          return _getHardcodedMSPPrices();
        }
        
        return apiData;
      } else {
        throw Exception('Failed to fetch MSP data: ${response.statusCode}');
      }
    } catch (e) {
      print('MSP API error: $e, using hardcoded values');
      // Fallback to hardcoded MSP data
      return _getHardcodedMSPPrices();
    }
  }

  /// Get MSP prices for specific crop
  static Future<Map<String, dynamic>?> getMSPForCrop(String cropName) async {
    try {
      final allPrices = await getMSPPrices();
      return allPrices.firstWhere(
        (price) => price['crop']?.toLowerCase().contains(cropName.toLowerCase()) ?? false,
        orElse: () => {},
      );
    } catch (e) {
      return null;
    }
  }

  /// Get MSP prices by state
  static Future<List<Map<String, dynamic>>> getMSPByState(String state) async {
    try {
      final allPrices = await getMSPPrices();
      return allPrices.where((price) => 
        price['state']?.toLowerCase().contains(state.toLowerCase()) ?? false
      ).toList();
    } catch (e) {
      return [];
    }
  }

  /// Get government schemes related to MSP
  static Future<List<Map<String, dynamic>>> getGovernmentSchemes() async {
    try {
      // Mock implementation - in real app, this would call government schemes API
      return _getMockGovernmentSchemes();
    } catch (e) {
      return _getMockGovernmentSchemes();
    }
  }

  /// Get market prices from various mandis
  static Future<List<Map<String, dynamic>>> getMarketPrices() async {
    try {
      // Using Agmarknet API or similar service
      const marketUrl = 'https://agmarknet.gov.in/api/commodity/current';
      
      final response = await http.get(Uri.parse(marketUrl));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return _formatMarketData(data);
      } else {
        throw Exception('Failed to fetch market data: ${response.statusCode}');
      }
    } catch (e) {
      // Fallback to mock data if API fails
      return _getMockMarketPrices();
    }
  }

  /// Format MSP data from government API response
  static List<Map<String, dynamic>> _formatMSPData(Map<String, dynamic> data) {
    List<Map<String, dynamic>> mspPrices = [];
    
    if (data['records'] != null) {
      for (var record in data['records']) {
        mspPrices.add({
          'crop': record['commodity'] ?? 'Unknown',
          'mspPrice': double.tryParse(record['msp_rs_quintal']?.toString() ?? '0') ?? 0,
          'unit': 'per quintal',
          'season': record['season'] ?? 'Kharif',
          'year': record['year'] ?? DateTime.now().year,
          'state': record['state'] ?? 'All India',
          'category': record['category'] ?? 'Cereals',
          'lastUpdated': DateTime.now().toIso8601String(),
        });
      }
    }
    
    return mspPrices;
  }

  /// Format market data from API response
  static List<Map<String, dynamic>> _formatMarketData(Map<String, dynamic> data) {
    List<Map<String, dynamic>> marketPrices = [];
    
    if (data['data'] != null) {
      for (var item in data['data']) {
        marketPrices.add({
          'crop': item['commodity'] ?? 'Unknown',
          'price': double.tryParse(item['modal_price']?.toString() ?? '0') ?? 0,
          'unit': 'per quintal',
          'market': item['market'] ?? 'Unknown Mandi',
          'state': item['state'] ?? 'Unknown',
          'district': item['district'] ?? 'Unknown',
          'arrival': item['arrival_date'] ?? DateTime.now().toIso8601String(),
          'variety': item['variety'] ?? 'Common',
          'lastUpdated': DateTime.now().toIso8601String(),
        });
      }
    }
    
    return marketPrices;
  }

  /// Hardcoded MSP prices based on 2024-25 official rates
  static List<Map<String, dynamic>> _getHardcodedMSPPrices() {
    return [
      // Cereals
      {
        'crop': 'Paddy (Common)',
        'mspPrice': 2040,
        'unit': 'per quintal',
        'season': 'Kharif',
        'year': 2024,
        'state': 'All India',
        'category': 'Cereals',
        'lastUpdated': DateTime.now().toIso8601String(),
      },
      {
        'crop': 'Paddy (Grade A)',
        'mspPrice': 2060,
        'unit': 'per quintal',
        'season': 'Kharif',
        'year': 2024,
        'state': 'All India',
        'category': 'Cereals',
        'lastUpdated': DateTime.now().toIso8601String(),
      },
      {
        'crop': 'Wheat',
        'mspPrice': 2275,
        'unit': 'per quintal',
        'season': 'Rabi',
        'year': 2024,
        'state': 'All India',
        'category': 'Cereals',
        'lastUpdated': DateTime.now().toIso8601String(),
      },
      {
        'crop': 'Maize',
        'mspPrice': 2090,
        'unit': 'per quintal',
        'season': 'Kharif',
        'year': 2024,
        'state': 'All India',
        'category': 'Cereals',
        'lastUpdated': DateTime.now().toIso8601String(),
      },
      {
        'crop': 'Jowar (Hybrid)',
        'mspPrice': 2970,
        'unit': 'per quintal',
        'season': 'Kharif',
        'year': 2024,
        'state': 'All India',
        'category': 'Cereals',
        'lastUpdated': DateTime.now().toIso8601String(),
      },
      {
        'crop': 'Jowar (Maldandi)',
        'mspPrice': 2970,
        'unit': 'per quintal',
        'season': 'Kharif',
        'year': 2024,
        'state': 'All India',
        'category': 'Cereals',
        'lastUpdated': DateTime.now().toIso8601String(),
      },
      {
        'crop': 'Bajra',
        'mspPrice': 2500,
        'unit': 'per quintal',
        'season': 'Kharif',
        'year': 2024,
        'state': 'All India',
        'category': 'Cereals',
        'lastUpdated': DateTime.now().toIso8601String(),
      },
      {
        'crop': 'Ragi',
        'mspPrice': 3578,
        'unit': 'per quintal',
        'season': 'Kharif',
        'year': 2024,
        'state': 'All India',
        'category': 'Cereals',
        'lastUpdated': DateTime.now().toIso8601String(),
      },
      
      // Pulses
      {
        'crop': 'Arhar (Tur)',
        'mspPrice': 7000,
        'unit': 'per quintal',
        'season': 'Kharif',
        'year': 2024,
        'state': 'All India',
        'category': 'Pulses',
        'lastUpdated': DateTime.now().toIso8601String(),
      },
      {
        'crop': 'Moong',
        'mspPrice': 8755,
        'unit': 'per quintal',
        'season': 'Kharif',
        'year': 2024,
        'state': 'All India',
        'category': 'Pulses',
        'lastUpdated': DateTime.now().toIso8601String(),
      },
      {
        'crop': 'Urad',
        'mspPrice': 7000,
        'unit': 'per quintal',
        'season': 'Kharif',
        'year': 2024,
        'state': 'All India',
        'category': 'Pulses',
        'lastUpdated': DateTime.now().toIso8601String(),
      },
      {
        'crop': 'Chana',
        'mspPrice': 5440,
        'unit': 'per quintal',
        'season': 'Rabi',
        'year': 2024,
        'state': 'All India',
        'category': 'Pulses',
        'lastUpdated': DateTime.now().toIso8601String(),
      },
      {
        'crop': 'Masur (Lentil)',
        'mspPrice': 6425,
        'unit': 'per quintal',
        'season': 'Rabi',
        'year': 2024,
        'state': 'All India',
        'category': 'Pulses',
        'lastUpdated': DateTime.now().toIso8601String(),
      },
      
      // Oilseeds
      {
        'crop': 'Groundnut',
        'mspPrice': 5850,
        'unit': 'per quintal',
        'season': 'Kharif',
        'year': 2024,
        'state': 'All India',
        'category': 'Oilseeds',
        'lastUpdated': DateTime.now().toIso8601String(),
      },
      {
        'crop': 'Sesamum',
        'mspPrice': 7600,
        'unit': 'per quintal',
        'season': 'Kharif',
        'year': 2024,
        'state': 'All India',
        'category': 'Oilseeds',
        'lastUpdated': DateTime.now().toIso8601String(),
      },
      {
        'crop': 'Sunflower',
        'mspPrice': 6000,
        'unit': 'per quintal',
        'season': 'Kharif',
        'year': 2024,
        'state': 'All India',
        'category': 'Oilseeds',
        'lastUpdated': DateTime.now().toIso8601String(),
      },
      {
        'crop': 'Soyabean',
        'mspPrice': 4600,
        'unit': 'per quintal',
        'season': 'Kharif',
        'year': 2024,
        'state': 'All India',
        'category': 'Oilseeds',
        'lastUpdated': DateTime.now().toIso8601String(),
      },
      {
        'crop': 'Mustard',
        'mspPrice': 5650,
        'unit': 'per quintal',
        'season': 'Rabi',
        'year': 2024,
        'state': 'All India',
        'category': 'Oilseeds',
        'lastUpdated': DateTime.now().toIso8601String(),
      },
      
      // Commercial Crops
      {
        'crop': 'Cotton (Medium Staple)',
        'mspPrice': 6620,
        'unit': 'per quintal',
        'season': 'Kharif',
        'year': 2024,
        'state': 'All India',
        'category': 'Commercial Crops',
        'lastUpdated': DateTime.now().toIso8601String(),
      },
      {
        'crop': 'Cotton (Long Staple)',
        'mspPrice': 7020,
        'unit': 'per quintal',
        'season': 'Kharif',
        'year': 2024,
        'state': 'All India',
        'category': 'Commercial Crops',
        'lastUpdated': DateTime.now().toIso8601String(),
      },
      {
        'crop': 'Sugarcane',
        'mspPrice': 340,
        'unit': 'per quintal',
        'season': '2024-25',
        'year': 2024,
        'state': 'All India',
        'category': 'Commercial Crops',
        'lastUpdated': DateTime.now().toIso8601String(),
      },
      {
        'crop': 'Jute',
        'mspPrice': 5300,
        'unit': 'per quintal',
        'season': 'Kharif',
        'year': 2024,
        'state': 'All India',
        'category': 'Commercial Crops',
        'lastUpdated': DateTime.now().toIso8601String(),
      },
    ];
  }

  /// Mock market prices data (fallback)
  static List<Map<String, dynamic>> _getMockMarketPrices() {
    return [
      {
        'crop': 'Rice (Basmati)',
        'price': 3200,
        'unit': 'per quintal',
        'market': 'Delhi Mandi',
        'state': 'Delhi',
        'district': 'New Delhi',
        'arrival': DateTime.now().toIso8601String(),
        'variety': 'Basmati',
        'lastUpdated': DateTime.now().toIso8601String(),
      },
      {
        'crop': 'Rice (Common)',
        'price': 2400,
        'unit': 'per quintal',
        'market': 'Punjab Mandi',
        'state': 'Punjab',
        'district': 'Amritsar',
        'arrival': DateTime.now().toIso8601String(),
        'variety': 'Common',
        'lastUpdated': DateTime.now().toIso8601String(),
      },
      {
        'crop': 'Wheat',
        'price': 2350,
        'unit': 'per quintal',
        'market': 'Haryana Mandi',
        'state': 'Haryana',
        'district': 'Karnal',
        'arrival': DateTime.now().toIso8601String(),
        'variety': 'Durum',
        'lastUpdated': DateTime.now().toIso8601String(),
      },
      {
        'crop': 'Maize',
        'price': 2200,
        'unit': 'per quintal',
        'market': 'Karnataka Mandi',
        'state': 'Karnataka',
        'district': 'Bangalore',
        'arrival': DateTime.now().toIso8601String(),
        'variety': 'Hybrid',
        'lastUpdated': DateTime.now().toIso8601String(),
      },
      {
        'crop': 'Tomato',
        'price': 45,
        'unit': 'per kg',
        'market': 'Mumbai Mandi',
        'state': 'Maharashtra',
        'district': 'Mumbai',
        'arrival': DateTime.now().toIso8601String(),
        'variety': 'Hybrid',
        'lastUpdated': DateTime.now().toIso8601String(),
      },
      {
        'crop': 'Potato',
        'price': 25,
        'unit': 'per kg',
        'market': 'Kolkata Mandi',
        'state': 'West Bengal',
        'district': 'Kolkata',
        'arrival': DateTime.now().toIso8601String(),
        'variety': 'Kufri',
        'lastUpdated': DateTime.now().toIso8601String(),
      },
      {
        'crop': 'Onion',
        'price': 35,
        'unit': 'per kg',
        'market': 'Nashik Mandi',
        'state': 'Maharashtra',
        'district': 'Nashik',
        'arrival': DateTime.now().toIso8601String(),
        'variety': 'Red',
        'lastUpdated': DateTime.now().toIso8601String(),
      },
      {
        'crop': 'Arhar (Tur)',
        'price': 7200,
        'unit': 'per quintal',
        'market': 'Madhya Pradesh Mandi',
        'state': 'Madhya Pradesh',
        'district': 'Bhopal',
        'arrival': DateTime.now().toIso8601String(),
        'variety': 'Common',
        'lastUpdated': DateTime.now().toIso8601String(),
      },
      {
        'crop': 'Moong',
        'price': 8900,
        'unit': 'per quintal',
        'market': 'Rajasthan Mandi',
        'state': 'Rajasthan',
        'district': 'Jaipur',
        'arrival': DateTime.now().toIso8601String(),
        'variety': 'Green',
        'lastUpdated': DateTime.now().toIso8601String(),
      },
      {
        'crop': 'Groundnut',
        'price': 6100,
        'unit': 'per quintal',
        'market': 'Gujarat Mandi',
        'state': 'Gujarat',
        'district': 'Ahmedabad',
        'arrival': DateTime.now().toIso8601String(),
        'variety': 'Bold',
        'lastUpdated': DateTime.now().toIso8601String(),
      },
      {
        'crop': 'Cotton',
        'price': 6800,
        'unit': 'per quintal',
        'market': 'Telangana Mandi',
        'state': 'Telangana',
        'district': 'Hyderabad',
        'arrival': DateTime.now().toIso8601String(),
        'variety': 'Medium Staple',
        'lastUpdated': DateTime.now().toIso8601String(),
      },
      {
        'crop': 'Sugarcane',
        'price': 350,
        'unit': 'per quintal',
        'market': 'Uttar Pradesh Mandi',
        'state': 'Uttar Pradesh',
        'district': 'Lucknow',
        'arrival': DateTime.now().toIso8601String(),
        'variety': 'Co-0238',
        'lastUpdated': DateTime.now().toIso8601String(),
      },
    ];
  }

  /// Government schemes data with official website links
  static List<Map<String, dynamic>> _getMockGovernmentSchemes() {
    return [
      {
        'title': 'PM-KISAN Scheme',
        'description': 'Direct income support of ₹6000 per year to small and marginal farmers',
        'eligibility': 'Small and marginal farmers with landholding up to 2 hectares',
        'benefit': '₹6000 per year in 3 installments',
        'status': 'Active',
        'applicationProcess': 'Online application through PM-KISAN portal. Farmers can register using Aadhaar number and bank account details.',
        'website': 'https://pmkisan.gov.in',
        'lastUpdated': DateTime.now().toIso8601String(),
      },
      {
        'title': 'Soil Health Card Scheme',
        'description': 'Free soil testing and recommendations for farmers to improve soil health and crop productivity',
        'eligibility': 'All farmers across India',
        'benefit': 'Free soil testing and personalized recommendations for fertilizers and nutrients',
        'status': 'Active',
        'applicationProcess': 'Apply through Krishi Vigyan Kendra (KVK), Agriculture Department, or online portal',
        'website': 'https://soilhealth.dac.gov.in',
        'lastUpdated': DateTime.now().toIso8601String(),
      },
      {
        'title': 'Pradhan Mantri Fasal Bima Yojana (PMFBY)',
        'description': 'Crop insurance scheme to protect farmers from crop loss due to natural calamities',
        'eligibility': 'All farmers growing notified crops in notified areas',
        'benefit': 'Insurance coverage for crop loss due to natural calamities, pests, and diseases',
        'status': 'Active',
        'applicationProcess': 'Apply through insurance companies, banks, or Common Service Centers (CSC)',
        'website': 'https://pmfby.gov.in',
        'lastUpdated': DateTime.now().toIso8601String(),
      },
      {
        'title': 'Kisan Credit Card (KCC)',
        'description': 'Credit facility for farmers at low interest rates for agricultural and allied activities',
        'eligibility': 'All farmers including tenant farmers, sharecroppers, and oral lessees',
        'benefit': 'Credit up to ₹3 lakh at 4% interest rate for crop production and allied activities',
        'status': 'Active',
        'applicationProcess': 'Apply through banks, cooperative societies, Regional Rural Banks (RRBs), or online through myScheme portal',
        'website': 'https://www.myscheme.gov.in/schemes/kcc',
        'lastUpdated': DateTime.now().toIso8601String(),
      },
      {
        'title': 'Pradhan Mantri Kisan Sampada Yojana',
        'description': 'Scheme for food processing and value addition to boost farmer income',
        'eligibility': 'Food processing units, entrepreneurs, and farmer producer organizations',
        'benefit': 'Financial assistance up to 50% for setting up food processing units',
        'status': 'Active',
        'applicationProcess': 'Apply through Ministry of Food Processing Industries portal',
        'website': 'https://mofpi.gov.in',
        'lastUpdated': DateTime.now().toIso8601String(),
      },
      {
        'title': 'National Mission on Sustainable Agriculture',
        'description': 'Promotes sustainable agriculture practices and resource conservation',
        'eligibility': 'Farmers practicing sustainable agriculture and resource conservation',
        'benefit': 'Financial support for sustainable farming practices and technology adoption',
        'status': 'Active',
        'applicationProcess': 'Apply through state agriculture departments or Krishi Vigyan Kendras',
        'website': 'https://nmsa.dac.gov.in',
        'lastUpdated': DateTime.now().toIso8601String(),
      },
      {
        'title': 'Pradhan Mantri Kisan Maan Dhan Yojana',
        'description': 'Pension scheme for small and marginal farmers',
        'eligibility': 'Small and marginal farmers aged 18-40 years',
        'benefit': 'Monthly pension of ₹3000 after attaining 60 years of age',
        'status': 'Active',
        'applicationProcess': 'Apply through Common Service Centers (CSC) or online portal',
        'website': 'https://pmkmy.gov.in',
        'lastUpdated': DateTime.now().toIso8601String(),
      },
      {
        'title': 'Pradhan Mantri Kisan Urja Suraksha evam Utthaan Mahabhiyan (PM-KUSUM)',
        'description': 'Scheme for solar power generation and irrigation',
        'eligibility': 'Farmers with agricultural land and irrigation pumps',
        'benefit': 'Subsidy for solar pumps and solar power plants',
        'status': 'Active',
        'applicationProcess': 'Apply through state nodal agencies or online portal',
        'website': 'https://pmkusum.mnre.gov.in',
        'lastUpdated': DateTime.now().toIso8601String(),
      },
      {
        'title': 'National Mission for Sustainable Agriculture (NMSA)',
        'description': 'Promotes sustainable agriculture through climate-resilient practices',
        'eligibility': 'Farmers practicing climate-resilient agriculture',
        'benefit': 'Financial assistance for climate-resilient technologies and practices',
        'status': 'Active',
        'applicationProcess': 'Apply through state agriculture departments',
        'website': 'https://nmsa.dac.gov.in',
        'lastUpdated': DateTime.now().toIso8601String(),
      },
      {
        'title': 'Pradhan Mantri Krishi Sinchai Yojana (PMKSY)',
        'description': 'Scheme for irrigation and water management',
        'eligibility': 'Farmers with agricultural land requiring irrigation',
        'benefit': 'Financial assistance for irrigation infrastructure and water management',
        'status': 'Active',
        'applicationProcess': 'Apply through state irrigation departments',
        'website': 'https://pmksy.gov.in',
        'lastUpdated': DateTime.now().toIso8601String(),
      },
    ];
  }
}
