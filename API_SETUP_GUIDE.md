# API Setup Guide

## Setting up API Keys

To use the Nokia Network as Code API and other location services, you need to set up your API keys:

### 1. Create your secrets file

Copy the template file:
```bash
cp lib/secrets.dart.template lib/secrets.dart
```

### 2. Get your API keys

#### Nokia Network as Code API
1. Go to [RapidAPI Nokia Network as Code](https://rapidapi.com/nokia-network-as-code/api/network-as-code/)
2. Subscribe to the API
3. Get your RapidAPI key from the dashboard

#### Update your secrets.dart file

Replace the placeholder value in `lib/secrets.dart`:

```dart
const String rapidApiKey = 'your_actual_rapidapi_key_here';
```

### 3. Security Notes

- **Never commit `lib/secrets.dart` to version control**
- The file is already added to `.gitignore`
- Use environment variables in production
- Rotate your API keys regularly

### 4. Testing

The app will work without Nokia API keys (it will fall back to GPS), but for enhanced location accuracy, configure the Nokia API keys.

## Troubleshooting

If you see "Nokia API not configured" messages, make sure:
1. Your `lib/secrets.dart` file exists
2. The API key is correctly set
3. The Nokia API key is valid and active