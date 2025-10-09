# FarmSphere API Configuration Guide

## Weather API Setup

### ✅ **wttr.in API (RECOMMENDED - 100% FREE!)**
- **No registration required**
- **No API key needed**
- **No credit card required**
- **Unlimited requests**
- **Already configured in the app!**

The app now uses wttr.in which is completely free and doesn't require any setup!

### Alternative Free APIs (if needed):
1. **WeatherAPI.com** - 1,000 calls/day free (no credit card required)
2. **Visual Crossing Weather** - 1,000 records/day free
3. **Weatherstack** - 250 calls/month free

### Previous APIs (require credit card):
- ~~OpenWeatherMap~~ - Requires credit card even for free tier
- ~~WeatherAPI~~ - Some plans require credit card

## MSP API Setup

### ✅ **Data.gov.in API (CONFIGURED!)**
- **API Key**: Already configured in the app
- **Resource ID**: 9ef84268-d588-465a-a308-a864a43d0070
- **Status**: ✅ Ready to use!

The app now uses the official Indian Government MSP API from data.gov.in!

### Alternative APIs (if needed):
1. **Agmarknet API** - For market prices (no API key required)
2. **FCI API** - Food Corporation of India data

## Location Permissions

The app requires location permissions for:
- Automatic weather detection
- Location-based MSP and market prices

### Android Permissions (Already configured)
- `ACCESS_FINE_LOCATION`
- `ACCESS_COARSE_LOCATION`

### iOS Permissions (Add to Info.plist)
```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>This app needs location access to provide weather information and local market prices.</string>
<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
<string>This app needs location access to provide weather information and local market prices.</string>
```

## Features Implemented

### Weather API Integration
- ✅ Real-time weather data using OpenWeatherMap API
- ✅ 7-day weather forecast
- ✅ Weather alerts and notifications
- ✅ Location-based weather detection
- ✅ Detailed weather information (humidity, wind, pressure, UV index, visibility)

### MSP (Minimum Support Price) API Integration
- ✅ Government MSP rates for all major crops
- ✅ Market prices from various mandis
- ✅ Government schemes and subsidies information
- ✅ Crop-wise MSP and market price comparison
- ✅ Season-wise pricing information

### Location Services
- ✅ GPS-based location detection
- ✅ Location permission handling
- ✅ Automatic location detection in login screen
- ✅ Location-based weather and price data

### UI Improvements
- ✅ Enhanced weather card with detailed information
- ✅ Improved forecast cards with humidity and precipitation
- ✅ Enhanced price cards distinguishing MSP vs Market prices
- ✅ Separate tabs for MSP, Market prices, and Government schemes
- ✅ Visual indicators for MSP vs Market prices

## Usage Instructions

1. **Weather API**: ✅ **Already configured!** Uses wttr.in (100% free)
2. **MSP API**: ✅ **Already configured!** Uses data.gov.in with your API key
3. **Location Permission**: Grant location permission when prompted
4. **Login**: Use the "Detect" button to automatically detect your location
5. **Weather**: View real-time weather data and forecasts
6. **Market Prices**: Check MSP rates and current market prices
7. **Government Schemes**: Browse available schemes and subsidies

## Fallback Data

The app includes comprehensive mock data that will be used if:
- API services are temporarily unavailable
- Network connection is poor
- API rate limits are exceeded

**Note**: Both weather and MSP APIs are now configured, so you'll get real data!

## Support

For any issues or questions:
1. Check the API key configuration
2. Verify internet connectivity
3. Ensure location permissions are granted
4. Check the console for error messages

## API Rate Limits

- **OpenWeatherMap Free**: 1,000 calls/day
- **WeatherAPI Free**: 1,000 calls/day
- **Data.gov.in**: Varies by dataset

The app is designed to minimize API calls and includes caching mechanisms.
