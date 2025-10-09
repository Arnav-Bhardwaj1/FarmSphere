# Nokia Network as Code API Configuration Guide

## Overview
This guide explains how to configure the Nokia Network as Code API for enhanced location detection in FarmSphere.

## Prerequisites
1. Nokia Network as Code account
2. RapidAPI account
3. Valid API key and Application ID

## Configuration Steps

### 1. Get Nokia API Credentials
1. Visit [Nokia Network as Code on RapidAPI](https://rapidapi.com/nokia-network-as-code/api/network-as-code/)
2. Subscribe to the API plan
3. Get your RapidAPI Key from the dashboard
4. Get your Application ID from Nokia Network as Code console

### 2. Update Configuration
Edit `lib/services/location_service.dart` and update the following constants:

```dart
// Replace with your actual RapidAPI key
static const String _rapidApiKey = 'YOUR_RAPIDAPI_KEY_HERE';

// Replace with your actual Nokia Application ID
static const String _appId = 'YOUR_APPLICATION_ID_HERE';
```

### 3. API Endpoint Details
- **Base URL**: `https://network-as-code.p.rapidapi.com`
- **Endpoint**: `/location/retrieveLocation`
- **Method**: POST
- **Headers**:
  - `Content-Type: application/json`
  - `X-RapidAPI-Key: YOUR_RAPIDAPI_KEY`
  - `X-RapidAPI-Host: network-as-code.p.rapidapi.com`

### 4. Request Body Format
```json
{
  "app": "YOUR_APPLICATION_ID"
}
```

### 5. Response Format
```json
{
  "lastLocationTime": "2025-10-09T04:56:27.488174Z",
  "area": {
    "areaType": "CIRCLE",
    "center": {
      "latitude": 47.48627616952785,
      "longitude": 19.07915612501993
    },
    "radius": 1000
  }
}
```

## Features
- **Enhanced Accuracy**: Nokia Network as Code provides high-accuracy location data
- **Fallback Support**: Falls back to GPS if Nokia API is unavailable
- **Real-time Detection**: Gets current location with timestamp
- **Area Information**: Provides location area type and radius

## Testing
1. Ensure location permissions are granted
2. Tap the "Detect" button on the login screen
3. Check the success message for Nokia API confirmation
4. Verify location accuracy in the detected location

## Troubleshooting
- **API Key Invalid**: Verify your RapidAPI key is correct
- **Application ID Invalid**: Check your Nokia Application ID
- **Network Error**: Ensure internet connectivity
- **Permission Denied**: Grant location permissions in device settings

## Security Notes
- Never commit API keys to version control
- Use environment variables for production
- Consider implementing API key rotation
- Monitor API usage and limits

## Support
- Nokia Network as Code Documentation
- RapidAPI Support
- FarmSphere GitHub Issues
