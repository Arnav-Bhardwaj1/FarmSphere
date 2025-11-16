# FarmSphere - AI-Powered Farming Assistant

FarmSphere is a comprehensive Flutter application designed to assist farmers with ML-powered crop health diagnosis, AI-powered chatbot assistance, weather monitoring, market prices, multilingual support, and community features.

## 🌱 Features

### Core Features
- **Nokia Network as Code API** - For Location Retrieval
- **ML Crop Health Scanner** - Upload leaf photos or describe symptoms for instant disease diagnosis
- **AI Chatbot** - For advices, insights and discussions with an AI chatbot for disease prevention & handling, with farming tips and suggestions for an optimal yield.
- **Weather & Alerts** - Real-time weather updates and agricultural alerts
- **Market Prices & Schemes** - Access to current crop prices and government schemes
- **Multilingual Support (Local Language Support)** - Full app and chatbot support for 22+ Indian languages like Hindi, Tamil, Marathi and more.
- **Activity Logging & Analytics** - Track farm practices and get personalized insights
- **Farmer Community Platform** - Connect with fellow farmers and agricultural experts
  - Create posts, interact with likes and comments, save/bookmark content
  - Join community chat rooms for discussions
  - Consult with agricultural experts

### Technical Features
- Modern Flutter architecture with Riverpod state management
- Material Design 3 UI with dark/light theme support
- Comprehensive multilingual support (22+ Indian languages) for entire app and AI chatbot
- Image capture and gallery integration
- Local data persistence with SQLite (offline caching)
- MongoDB backend integration for data synchronization
- Responsive design for various screen sizes
- Real-time state management for community features
- Interactive UI with smooth animations and transitions

## Getting Started:

### Prerequisites
- Flutter SDK (3.0.0 or higher)
- Dart SDK (3.0.0 or higher)
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

## Screens:

The app includes the following main screens:
- **Home Dashboard** - Overview of all features and quick actions
- **Crop Health Scanner** - ML-powered disease diagnosis
- **AI Chatbot** - Gemini AI powered chatbot
- **Weather Screen** - Current weather and 7-day forecast
- **Market Screen** - Crop prices and government schemes
- **Activities Screen** - Farm activity logging and analytics
- **Community Screen** - Farmer community platform with posts, chats, and expert consultations
- **Profile Screen** - User settings and preferences

## 🏗️ Architecture

### State Management
- **Riverpod** for state management and dependency injection
- **Provider** for local state management
- **SharedPreferences** for user settings persistence
- **CommunityProvider** for managing posts, comments, likes, chats, and expert interactions

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
│   │   └── community_screen.dart
│   └── profile/
├── widgets/
│   ├── feature_card.dart
│   ├── weather_card.dart
│   ├── diagnosis_result_card.dart
│   ├── community_post_card.dart
│   ├── community_chat_card.dart
│   └── ...
└── utils/
```

## 🔧 Configuration

### API Keys
**For production deployment, you'll need to configure:**
- Network As a Code (Location Retrieval API)
- Weather API (OpenWeatherMap or similar)
- Market data API
- AI/ML service for crop health analysis
- Push notification service
- Google Generative AI (for chatbot) - Configure in `lib/secrets.dart`

### Backend Services

#### Plant Disease Detection Server
The app includes a Python Flask backend for plant disease recognition:

1. **Setup the server:**
   ```bash
   cd server
   pip install -r requirements.txt
   python plant_disease_api.py
   ```
   
2. **Server runs on:** `http://localhost:5000`

3. **Endpoints:**
   - `GET /health` - Check server status
   - `POST /predict` - Predict plant disease from image

See [server/README.md](server/README.md) for detailed setup instructions.

#### MongoDB Backend
The app includes a MongoDB backend for data persistence:

1. **Setup MongoDB:**
   - **Option 1 (Local)**: Install MongoDB Community Server
   - **Option 2 (Cloud)**: Use MongoDB Atlas (free tier available)
   - See [server/README_MONGODB.md](server/README_MONGODB.md) for detailed setup

2. **Configure connection:**
   ```bash
   cd server
   # Copy env.example to .env and update with your MongoDB connection string
   cp env.example .env
   # Edit .env and add your MongoDB URI
   ```

3. **Install dependencies and start server:**
   ```bash
   pip install -r requirements.txt
   python plant_disease_api.py
   ```

4. **API Endpoints:**
   - Users: `/api/users`
   - Posts: `/api/posts`
   - Comments: `/api/posts/<post_id>/comments`
   - Activities: `/api/users/<user_id>/activities`
   - Crop Health: `/api/users/<user_id>/crop-health`
   - Chat: `/api/chats/<chat_id>/messages`

The Flutter app automatically connects to the backend when available and falls back to local state if the API is unavailable.

#### Community Features
Community features (posts, comments, chats) now use MongoDB backend for persistence:
- Posts, comments, likes, and saves are stored in MongoDB
- Activities and crop health history are synced to the database
- Real-time synchronization across devices when backend is available
- Offline support with local state fallback

### Language Support
The app supports 22+ Indian languages including:
- **Major Languages**: Hindi, Bengali, Tamil, Telugu, Marathi, Gujarati, Kannada, Malayalam, Urdu, Punjabi
- **Regional Languages**: Assamese, Odia, Bodo, Dogri, Konkani, Maithili, Manipuri, Nepali, Sanskrit, Santhali, Sindhi
- Language selection is available on first launch and can be changed from the profile settings
- All app screens, UI elements, and AI chatbot responses support multilingual interface

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
- `sqflite` - Local database (for offline caching)
- `http` - API calls
- `geolocator` - Location services
- `speech_to_text` - Voice input
- `flutter_tts` - Text-to-speech
- `google_generative_ai` - AI chatbot integration
- `socket_io_client` - Real-time communication
- `url_launcher` - Open external links
- `cached_network_image` - Image caching

**Backend dependencies (Python):**
- `flask` - Web framework
- `pymongo` - MongoDB driver
- `python-dotenv` - Environment variables
- `tensorflow` - ML model for plant disease detection

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

