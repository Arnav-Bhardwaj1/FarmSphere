# FarmSphere - AI-Powered Farming Assistant

FarmSphere is a comprehensive Flutter application designed to assist farmers with AI-powered crop health diagnosis, weather monitoring, market prices, and community support.

## 🌱 Features

### Core Features
- **Nokia Network as Code API** - For Location Retrieval
- **ML Crop Health Scanner** - Upload leaf photos or describe symptoms for instant disease diagnosis
- **AI Chatbot** - For advices, insights and discussions with an AI chatbot for disease prevention & handling, with farming tips and suggestions for an optimal yield.
- **Weather & Alerts** - Real-time weather updates and agricultural alerts
- **Market Prices & Schemes** - Access to current crop prices and government schemes
- **Voice & Local Language Support** - Multilingual support for better accessibility
- **Activity Logging & Analytics** - Track farm practices and get personalized insights
- **Farmer Community Platform** - Connect with fellow farmers and agricultural experts

### Technical Features
- Modern Flutter architecture with Riverpod state management
- Material Design 3 UI with dark/light theme support
- Image capture and gallery integration
- Local data persistence with SQLite
- Responsive design for various screen sizes

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.0.0 or higher)
- Dart SDK (3.0.0 or higher)
- Android Studio / VS Code
- Android SDK (API level 21 or higher)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/farmsphere.git
   cd farmsphere
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Web Deployment (GitHub Pages)

This project includes a GitHub Actions workflow that builds the Flutter web app and deploys it to GitHub Pages on each push to `main`.

Steps:
1. Push to `main`.
2. In GitHub → Settings → Pages → set Source to “GitHub Actions”.
3. After the first workflow run, your site will be available at `https://<username>.github.io/<repo>/`.

Notes:
- We use the HTML renderer to avoid CanvasKit fetch issues.
- Place `assets/model.tflite` locally only if needed; large files are ignored in git.
- Nokia Verify often requires server-side auth; the web UI calls will need a proxy or operator token.

### Building for Production

**Android APK:**
```bash
flutter build apk --release
```

**Android App Bundle:**
```bash
flutter build appbundle --release
```

## 📱 Screenshots

The app includes the following main screens:
- **Home Dashboard** - Overview of all features and quick actions
- **Crop Health Scanner** - ML-powered disease diagnosis
- **AI Chatbot** - Gemini AI powered chatbot
- **Weather Screen** - Current weather and 7-day forecast
- **Market Screen** - Crop prices and government schemes
- **Activities Screen** - Farm activity logging and analytics
- **Community Screen** - Farmer community and expert consultation
- **Profile Screen** - User settings and preferences

## 🏗️ Architecture

### State Management
- **Riverpod** for state management and dependency injection
- **Provider** for local state management
- **SharedPreferences** for user settings persistence

### Project Structure
```
lib/
├── main.dart
├── theme/
│   └── app_theme.dart
├── providers/
│   └── app_providers.dart
├── screens/
│   ├── splash_screen.dart
│   ├── auth/
│   ├── crop_health/
│   ├── weather/
│   ├── market/
│   ├── activities/
│   ├── community/
│   └── profile/
├── widgets/
│   ├── feature_card.dart
│   ├── weather_card.dart
│   ├── diagnosis_result_card.dart
│   └── ...
└── utils/
```

## 🔧 Configuration

### API Keys
For production deployment, you'll need to configure:
- Weather API (OpenWeatherMap or similar)
- Market data API
- AI/ML service for crop health analysis
- Push notification service

### Permissions
The app requires the following permissions:
- Camera (for crop health scanning)
- Storage (for image saving)
- Location (for weather data)
- Microphone (for voice features)
- Internet (for data synchronization)

## 🧪 Testing

Run tests with:
```bash
flutter test
```

## 📦 Dependencies

Key dependencies include:
- `flutter_riverpod` - State management
- `image_picker` - Camera and gallery access
- `shared_preferences` - Local storage
- `sqflite` - Database
- `http` - API calls
- `geolocator` - Location services
- `speech_to_text` - Voice input
- `flutter_tts` - Text-to-speech

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Open source community for various packages
- Farmers and agricultural experts for their valuable feedback

---

**FarmSphere** - Empowering farmers with AI technology 🌾

