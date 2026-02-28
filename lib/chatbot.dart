import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:farmsphere/l10n/app_localizations.dart';
import 'providers/app_providers.dart';
import 'secrets.dart';

/// A reusable AI chatbot widget using Google Gemini API
/// 
/// This widget provides a complete chat interface with:
/// - Message display with user/bot message bubbles
/// - Text input field with send button
/// - Integration with Google Gemini for AI responses
/// - Customizable styling and colors
/// - Modern gradients and animations
class AIChatbot extends StatefulWidget {
  /// The title displayed in the app bar
  final String title;
  
  /// Background color of the main container
  final Color backgroundColor;
  
  /// Color of the app bar
  final Color appBarColor;
  
  /// Color of the input container
  final Color inputContainerColor;
  
  /// Color of the send button
  final Color sendButtonColor;
  
  /// Placeholder text for the input field
  final String hintText;
  
  /// Custom styling for the app bar title
  final TextStyle? titleStyle;
  
  /// Custom styling for the input hint text
  final TextStyle? hintStyle;

  const AIChatbot({
    super.key,
    this.title = 'AI Assistant',
    this.backgroundColor = const Color(0xFFF9F3CC),
    this.appBarColor = const Color(0xFF285352),
    this.inputContainerColor = const Color(0xFF36946F),
    this.sendButtonColor = const Color(0xFF36946F),
    this.hintText = 'Ask to AI',
    this.titleStyle,
    this.hintStyle,
  });

  @override
  _AIChatbotState createState() => _AIChatbotState();
}

class _AIChatbotState extends State<AIChatbot> {
  late GenerativeModel model;
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<Map<String, dynamic>> messages = [];
  bool _isLoading = false;
  bool _showTypingIndicator = false;
  String _targetLangCode = 'en';
  
  // Voice features
  final stt.SpeechToText _speech = stt.SpeechToText();
  final FlutterTts _flutterTts = FlutterTts();
  bool _isListening = false;
  bool _isSpeaking = false;
  bool _speechAvailable = false;

  @override
  void initState() {
    super.initState();
    _initializeGemini();
    _initializeVoiceFeatures();
  }

  /// Initialize speech-to-text and text-to-speech
  Future<void> _initializeVoiceFeatures() async {
    // Check if platform supports speech_to_text
    // speech_to_text is primarily supported on Android and iOS
    // For Windows/Desktop: Voice input is not available due to plugin limitations
    // Alternative: Users can use Windows built-in speech recognition (Win+H) and type
    bool isPlatformSupported = !kIsWeb && (Platform.isAndroid || Platform.isIOS);
    
    if (!isPlatformSupported) {
      print('Speech recognition not supported on this platform (${kIsWeb ? "Web" : Platform.operatingSystem})');
      print('Windows users: Use Win+H for Windows voice typing, or install on mobile for voice features');
      _speechAvailable = false;
      if (mounted) {
        setState(() {});
      }
    } else {
      try {
        // Initialize Speech-to-Text
        _speechAvailable = await _speech.initialize(
          onError: (error) {
            print('Speech recognition error: $error');
            if (mounted) {
              setState(() {
                _isListening = false;
              });
              _showSnackBar('Speech recognition error: ${error.errorMsg}');
            }
          },
          onStatus: (status) {
            print('Speech recognition status: $status');
            if (mounted) {
              if (status == 'done' || status == 'notListening' || status == 'canceled') {
                setState(() {
                  _isListening = false;
                });
              } else if (status == 'listening') {
                setState(() {
                  _isListening = true;
                });
              }
            }
          },
        );
        
        if (!_speechAvailable) {
          print('Speech recognition not available on this device');
          if (mounted) {
            setState(() {});
          }
        } else {
          print('Speech recognition initialized successfully');
        }
      } catch (e) {
        print('Error initializing speech recognition: $e');
        _speechAvailable = false;
        if (mounted) {
          setState(() {});
        }
      }
    }

    // Initialize Text-to-Speech
    final ttsLanguage = _getTTSLanguageCode();
    await _setTtsLanguageSafe(ttsLanguage);
    await _flutterTts.setSpeechRate(0.45); // Lowered speech rate to sound natural
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);
    
    _flutterTts.setCompletionHandler(() {
      if (mounted) {
        setState(() {
          _isSpeaking = false;
        });
      }
    });

    _flutterTts.setErrorHandler((msg) {
      print('TTS error: $msg');
      if (mounted) {
        setState(() {
          _isSpeaking = false;
        });
      }
    });
  }

  /// Safely set TTS language, matching prefixes if exact match fails
  Future<void> _setTtsLanguageSafe(String targetCode) async {
    try {
      final languages = await _flutterTts.getLanguages;
      if (languages is List) {
        final langPrefix = targetCode.split(RegExp(r'[_|-]'))[0];
        
        // 1. Try exact match
        if (languages.contains(targetCode)) {
          await _flutterTts.setLanguage(targetCode);
          return;
        }
        
        // 2. Try prefix match
        for (final lang in languages) {
          final lString = lang.toString();
          if (lString.startsWith('${langPrefix}_') || 
              lString.startsWith('${langPrefix}-') ||
              lString == langPrefix) {
            await _flutterTts.setLanguage(lString);
            return;
          }
        }
      }
      // Fallback
      await _flutterTts.setLanguage(targetCode);
    } catch (e) {
      print('Error setting TTS language: $e');
    }
  }

  /// Initialize Gemini API connection
  Future<void> _initializeGemini() async {
    try {
      // Initialize the Gemini model with your API key
      model = GenerativeModel(
        model: 'gemini-2.5-flash',
        apiKey: geminiApiKey,
        generationConfig: GenerationConfig(
          temperature: 0.7,
          topK: 40,
          topP: 0.95,
          maxOutputTokens: 1024,
        ),
      );
      
      // Wait for widget to be built before accessing provider
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _updateLanguageAndShowWelcome();
        }
      });
    } catch (e) {
      print('Error initializing Gemini: $e');
      final welcomeByLang = <String, String>{
        'en': "Sorry, I'm having trouble connecting. Please try again later.",
        'hi': 'क्षमा करें, कनेक्ट होने में समस्या हो रही है। कृपया बाद में पुनः प्रयास करें।',
        'bn': 'দুঃখিত, সংযুক্ত হতে সমস্যা হচ্ছে। অনুগ্রহ করে পরে আবার চেষ্টা করুন।',
      };
      final welcomeText = welcomeByLang[_targetLangCode] ?? welcomeByLang['en']!;
      messages.add({'text': welcomeText, 'isUser': false, 'timestamp': DateTime.now()});
    }
  }

  /// Update language from provider and show welcome message
  void _updateLanguageAndShowWelcome() {
    try {
      _targetLangCode = _getCurrentLanguage();
      // Update TTS language
      final ttsLanguage = _getTTSLanguageCode();
      _setTtsLanguageSafe(ttsLanguage);
      
      // Add welcome message in selected language
      final welcomeByLang = <String, String>{
        'en': "Hello! I'm your FarmSphere AI assistant. How can I help you with farming today?",
        'hi': 'नमस्ते! मैं आपका FarmSphere एआई सहायक हूँ। खेती में मैं आपकी कैसे मदद कर सकता/सकती हूँ?',
        'bn': 'হ্যালো! আমি আপনার FarmSphere এআই সহকারী। কৃষি বিষয়ে কীভাবে সাহায্য করতে পারি?',
        'ta': 'வணக்கம்! நான் உங்கள் FarmSphere ஏஐ உதவியாளர். விவசாயத்தில் எப்படி உதவலாம்?',
        'te': 'హలో! నేను మీ FarmSphere ఏఐ సహాయకుడు. వ్యవసాయంలో ఎలా సహాయం చేయగలను?',
        'mr': 'नमस्कार! मी तुमचा FarmSphere एआय सहाय्यक आहे. शेतीत मी कशी मदत करू?',
        'gu': 'નમસ્તે! હું તમારો FarmSphere એઆઈ સહાયક છું. ખેતીમાં કેવી રીતે મદદ કરી શકું?',
        'kn': 'ನಮಸ್ಕಾರ! ನಾನು ನಿಮ್ಮ FarmSphere ಎಐ ಸಹಾಯಕ. ಕೃಷಿಯಲ್ಲಿ ಹೇಗೆ ಸಹಾಯ ಮಾಡಲಿ?',
        'ml': 'നമസ്കാരം! ഞാൻ നിങ്ങളുടെ FarmSphere AI സഹായി. കൃഷിയിൽ എങ്ങനെ സഹായിക്കാം?',
        'pa': 'ਸਤ ਸ੍ਰੀ ਅਕਾਲ! ਮੈਂ ਤੁਹਾਡਾ FarmSphere ਏਆਈ ਸਹਾਇਕ ਹਾਂ। ਖੇਤੀ ਵਿੱਚ ਕਿਵੇਂ ਮਦਦ ਕਰ ਸਕਦਾ ਹਾਂ?',
        'ur': 'سلام! میں آپ کا FarmSphere اے آئی معاون ہوں۔ زراعت میں میں کیسے مدد کر سکتا ہوں؟',
      };
      final welcomeText = welcomeByLang[_targetLangCode] ?? welcomeByLang['en']!;
      if (messages.isEmpty || messages[0]['isUser'] == true) {
        // Only add if welcome message not already added
        messages.insert(0, {'text': welcomeText, 'isUser': false, 'timestamp': DateTime.now()});
      } else {
        // Replace existing welcome message
        messages[0] = {'text': welcomeText, 'isUser': false, 'timestamp': DateTime.now()};
      }
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      print('Error updating language: $e');
    }
  }

  /// Translate arbitrary text to the selected target language using the model
  Future<String> _translateToTarget(String text) async {
    try {
      final prompt = 'Translate the following text to language with code: $_targetLangCode. '
          'Return ONLY the translated text without quotes.\n\nText: $text';
      final res = await model.generateContent([Content.text(prompt)]);
      final out = res.text?.trim();
      if (out == null || out.isEmpty) return text;
      return out;
    } catch (_) {
      return text;
    }
  }

  /// Translate but ignore failures gracefully
  Future<String> _safeTranslate(String text) async {
    try {
      return await _translateToTarget(text);
    } catch (_) {
      return text;
    }
  }

  /// Start listening for speech input
  Future<void> _startListening() async {
    print('=== _startListening called ===');
    try {
      // Re-check availability
      print('Speech available: $_speechAvailable');
      if (!_speechAvailable) {
        // Try to re-initialize
        _speechAvailable = await _speech.initialize(
          onError: (error) {
            print('Speech recognition error: $error');
            if (mounted) {
              setState(() {
                _isListening = false;
              });
              _showSnackBar('Speech recognition error: ${error.errorMsg}');
            }
          },
          onStatus: (status) {
            print('Speech recognition status: $status');
            if (mounted && (status == 'done' || status == 'notListening')) {
              setState(() {
                _isListening = false;
              });
            }
          },
        );
        
        if (!_speechAvailable) {
          _showSnackBar('Speech recognition is not available on this device');
          return;
        }
      }

      // Check and request microphone permission
      PermissionStatus status = await Permission.microphone.status;
      if (status.isDenied || status.isRestricted) {
        status = await Permission.microphone.request();
      }
      
      if (!status.isGranted) {
        if (status.isPermanentlyDenied) {
          _showSnackBar('Microphone permission is permanently denied. Please enable it in app settings.');
        } else {
          _showSnackBar('Microphone permission is required for voice input');
        }
        return;
      }

      // Stop any ongoing listening first
      if (_isListening) {
        await _speech.stop();
      }

      setState(() {
        _isListening = true;
      });
      print('Set _isListening to true');

      // Get locale code for speech recognition
      final localeId = _getSpeechLocaleCode();
      print('Starting speech recognition with locale: $localeId');
      
      // Check available locales
      String? finalLocaleId;
      try {
        final availableLocales = await _speech.locales();
        print('Available locales: ${availableLocales.map((l) => l.localeId).toList()}');
        
        if (availableLocales.isEmpty) {
          // If no locales returned, try using the requested locale anyway
          print('No locales returned, using requested locale: $localeId');
          finalLocaleId = localeId;
        } else {
          // Try to find exact match first
          final exactMatch = availableLocales.firstWhere(
            (l) => l.localeId == localeId,
            orElse: () => availableLocales.first,
          );
          
          // Try to find partial match (same language, different country)
          if (exactMatch.localeId == localeId) {
            finalLocaleId = localeId;
          } else {
            final langCode = localeId.split('_')[0]; // Get language part (e.g., 'hi' from 'hi_IN')
            final langPrefix = '${langCode}_'; // Proper string interpolation
            final partialMatches = availableLocales.where((l) => l.localeId.startsWith(langPrefix)).toList();
            if (partialMatches.isNotEmpty) {
              finalLocaleId = partialMatches.first.localeId;
            } else {
              // Use first available locale as fallback
              finalLocaleId = exactMatch.localeId;
            }
          }
          
          print('Selected locale: $finalLocaleId');
        }
      } catch (e) {
        print('Error getting locales: $e, using requested locale: $localeId');
        // If locale checking fails, try with the requested locale anyway
        finalLocaleId = localeId;
      }
      
      // Determine if we should use a specific locale or system default
      final useSpecificLocale = finalLocaleId.isNotEmpty;
      
      if (!useSpecificLocale) {
        print('Failed to determine locale, trying system default');
      }

      // Callback handler for speech recognition results
      void onSpeechResult(dynamic result) {
        print('Speech recognition result received: $result');
        
        // Access properties safely - the result object has recognizedWords and finalResult
        String recognizedWords = '';
        bool isFinal = false;
        
        try {
          // Try different ways to access the properties
          if (result != null) {
            // Check if it has a recognizedWords getter/property
            final recognizedWordsValue = result.recognizedWords;
            recognizedWords = recognizedWordsValue?.toString() ?? '';
            
            // Check if it has a finalResult getter/property
            final finalResultValue = result.finalResult;
            isFinal = finalResultValue == true;
            
            print('Speech recognition - Words: "$recognizedWords", Final: $isFinal');
          }
        } catch (e) {
          print('Error accessing result properties: $e');
          // Try accessing as Map if it's a Map
          try {
            if (result is Map) {
              recognizedWords = (result['recognizedWords'] ?? '').toString();
              isFinal = result['finalResult'] == true;
            }
          } catch (e2) {
            print('Error accessing as Map: $e2');
          }
        }
        
        if (isFinal && recognizedWords.isNotEmpty) {
          if (mounted) {
            setState(() {
              _isListening = false;
              _controller.text = recognizedWords;
            });
            // Automatically send the message after a short delay
            Future.delayed(const Duration(milliseconds: 300), () {
              if (mounted) {
                _sendMessage();
              }
            });
          }
        } else if (!isFinal && recognizedWords.isNotEmpty) {
          // Update text field with interim results
          if (mounted) {
            setState(() {
              _controller.text = recognizedWords;
            });
          }
        }
      }

      // Start listening with appropriate locale
      bool? started;
      try {
        if (useSpecificLocale) {
          started = await _speech.listen(
            onResult: onSpeechResult,
            listenFor: const Duration(seconds: 30),
            pauseFor: const Duration(seconds: 3),
            localeId: finalLocaleId,
            listenMode: stt.ListenMode.confirmation,
            cancelOnError: true,
            partialResults: true,
          );
        } else {
          started = await _speech.listen(
            onResult: onSpeechResult,
            listenFor: const Duration(seconds: 30),
            pauseFor: const Duration(seconds: 3),
            listenMode: stt.ListenMode.confirmation,
            cancelOnError: true,
            partialResults: true,
          );
        }
        
        // Handle the result (started can be null)
        if (started == true) {
          print('Speech recognition started successfully');
        } else if (started == false) {
          print('Failed to start speech recognition');
          if (mounted) {
            setState(() {
              _isListening = false;
            });
            _showSnackBar('Failed to start speech recognition. Please try again.');
          }
        } else {
          // null case - assume it started (some platforms don't return bool)
          print('Speech recognition started (status unknown)');
        }
      } catch (e) {
        print('Exception starting speech recognition: $e');
        if (mounted) {
          setState(() {
            _isListening = false;
          });
          _showSnackBar('Failed to start speech recognition: ${e.toString()}');
        }
      }
    } catch (e) {
      print('Error starting speech recognition: $e');
      if (mounted) {
        setState(() {
          _isListening = false;
        });
        _showSnackBar('Error: ${e.toString()}');
      }
    }
  }

  /// Stop listening for speech input
  void _stopListening() {
    _speech.stop();
    setState(() {
      _isListening = false;
    });
  }

  /// Speak text using TTS
  Future<void> _speakText(String text) async {
    try {
      // Update TTS language if needed
      final ttsLanguage = _getTTSLanguageCode();
      await _setTtsLanguageSafe(ttsLanguage);
      
      setState(() {
        _isSpeaking = true;
      });
      
      await _flutterTts.speak(text);
    } catch (e) {
      print('Error speaking text: $e');
      setState(() {
        _isSpeaking = false;
      });
    }
  }

  /// Stop speaking
  void _stopSpeaking() {
    _flutterTts.stop();
    setState(() {
      _isSpeaking = false;
    });
  }

  /// Get speech recognition locale code based on selected language
  String _getSpeechLocaleCode() {
    // Map our language codes to speech recognition locale codes
    final localeMap = <String, String>{
      'en': 'en_US',
      'hi': 'hi_IN',
      'bn': 'bn_IN',
      'ta': 'ta_IN',
      'te': 'te_IN',
      'mr': 'mr_IN',
      'gu': 'gu_IN',
      'kn': 'kn_IN',
      'ml': 'ml_IN',
      'pa': 'pa_IN',
      'ur': 'ur_PK',
    };
    return localeMap[_targetLangCode] ?? 'en_US';
  }

  /// Get TTS language code based on selected language
  String _getTTSLanguageCode() {
    // Map our language codes to TTS language codes
    final ttsLanguageMap = <String, String>{
      'en': 'en-US',
      'hi': 'hi-IN',
      'bn': 'bn-IN',
      'ta': 'ta-IN',
      'te': 'te-IN',
      'mr': 'mr-IN',
      'gu': 'gu-IN',
      'kn': 'kn-IN',
      'ml': 'ml-IN',
      'pa': 'pa-IN',
      'ur': 'ur-PK',
    };
    return ttsLanguageMap[_targetLangCode] ?? 'en-US';
  }

  /// Show snackbar message
  void _showSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 3),
          action: SnackBarAction(
            label: AppLocalizations.of(context)?.ok ?? 'OK',
            onPressed: () {},
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _speech.stop();
    _flutterTts.stop();
    super.dispose();
  }

  /// Scroll to bottom
  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  /// Get current language from provider
  String _getCurrentLanguage() {
    try {
      final providerScope = ProviderScope.containerOf(context, listen: false);
      final appState = providerScope.read(appStateProvider);
      return appState.selectedLanguage;
    } catch (_) {
      return _targetLangCode;
    }
  }

  /// Get language name for prompt
  String _getLanguageName(String langCode) {
    final langNames = <String, String>{
      'en': 'English',
      'hi': 'Hindi',
      'bn': 'Bengali',
      'ta': 'Tamil',
      'te': 'Telugu',
      'mr': 'Marathi',
      'gu': 'Gujarati',
      'kn': 'Kannada',
      'ml': 'Malayalam',
      'pa': 'Punjabi',
      'ur': 'Urdu',
    };
    return langNames[langCode] ?? langCode;
  }

  /// Send message to Gemini and get response
  Future<void> _sendMessage() async {
    if (_controller.text.trim().isEmpty || _isLoading) return;

    // Get current language from provider
    final currentLang = _getCurrentLanguage();
    _targetLangCode = currentLang;
    
    // Update TTS language if changed
    final ttsLanguage = _getTTSLanguageCode();
    await _setTtsLanguageSafe(ttsLanguage);

    final rawUserMessage = _controller.text.trim();
    _controller.clear();

    // Show loading immediately
    setState(() {
      _isLoading = true;
      _showTypingIndicator = true;
    });
    
    _scrollToBottom();
    
    // Translate user message if language is not English
    String displayMessage = rawUserMessage;
    if (currentLang != 'en') {
      try {
        final prompt = 'Translate the following text to the language with code "$currentLang". '
            'If it is already in that language, return it exactly as is. '
            'Return ONLY the text without any translation notes or quotes.\n\nText: $rawUserMessage';
        final translationRes = await model.generateContent([Content.text(prompt)]);
        if (translationRes.text != null && translationRes.text!.trim().isNotEmpty) {
          displayMessage = translationRes.text!.trim();
        }
      } catch (e) {
        print('Error translating user input: $e');
      }
    }

    // Add translated user message
    setState(() {
      messages.add({'text': displayMessage, 'isUser': true, 'timestamp': DateTime.now()});
    });
    
    _scrollToBottom();

    try {
      // Get language name for better prompt
      final langName = _getLanguageName(currentLang);
      
      // Strong language-aware instruction for the model - use system instruction style
      final langInstruction = 'CRITICAL INSTRUCTION: You are communicating with a user who has selected $langName ($currentLang) as their language preference. '
          'You MUST respond ENTIRELY in $langName. '
          'Do NOT use English, Hindi, or any other language in your response. '
          'Every single word of your response must be in $langName. '
          'Even if the user writes in English, code, or mixed languages, you MUST understand and reply completely in $langName. '
          'This is a strict requirement for accessibility and user experience.\n\n';

      // Create farming-focused prompt
      final farmingPrompt = '$langInstruction'
          'You are FarmSphere AI Assistant, a helpful farming expert. '
          'Provide practical advice about agriculture, crop management, plant diseases, soil health, weather, and sustainability. '
          'Be friendly, concise, and actionable. If uncertain, say so and suggest next steps.\n\n'
          'User question: $displayMessage\n\n'
          'FINAL REMINDER: Your response MUST be 100% in $langName ($currentLang). Do NOT use English or any other language. Start your response now:';
      
      // Get response from Gemini
      final content = [Content.text(farmingPrompt)];
      final response = await model.generateContent(content);
      
      final aiResponse = response.text?.trim() ?? "Sorry, I couldn't generate a response.";
      
      setState(() {
        messages.add({
          'text': aiResponse,
          'isUser': false,
          'timestamp': DateTime.now(),
        });
        _isLoading = false;
        _showTypingIndicator = false;
      });
      
      _scrollToBottom();
      
      // Speak the response automatically
      await _speakText(aiResponse);
    } catch (e) {
      print('Error sending message: $e');
      final errorMessages = <String, String>{
        'en': 'Sorry, I encountered an error. Please try again.',
        'hi': 'क्षमा करें, मुझे एक त्रुटि मिली। कृपया पुनः प्रयास करें।',
        'bn': 'দুঃখিত, আমি একটি ত্রুটি পেয়েছি। অনুগ্রহ করে আবার চেষ্টা করুন।',
        'ta': 'மன்னிக்கவும், நான் ஒரு பிழையை எதிர்கொண்டேன்। தயவுசெய்து மீண்டும் முயற்சிக்கவும்।',
        'te': 'క్షమించండి, నేను ఒక లోపాన్ని ఎదుర్కొన్నాను. దయచేసి మళ్లీ ప్రయత్నించండి।',
        'mr': 'क्षमा करा, मला एक त्रुटी आली. कृपया पुन्हा प्रयत्न करा.',
      };
      final errText = errorMessages[currentLang] ?? errorMessages['en']!;
      setState(() {
        messages.add({'text': errText, 'isUser': false, 'timestamp': DateTime.now()});
        _isLoading = false;
        _showTypingIndicator = false;
      });
      
      _scrollToBottom();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              widget.appBarColor,
              widget.appBarColor.withOpacity(0.7),
              widget.backgroundColor,
            ],
            stops: const [0.0, 0.15, 0.3],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom App Bar with gradient and decorative elements
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [widget.appBarColor, widget.appBarColor.withOpacity(0.85)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: widget.appBarColor.withOpacity(0.3),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
                    Expanded(
                      child: Row(
                        children: [
                          // Animated bot avatar
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: Colors.white.withOpacity(0.15)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.smart_toy_rounded,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.title,
                                  style: widget.titleStyle ?? const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Row(
                                  children: [
                                    Container(
                                      width: 7,
                                      height: 7,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF4CAF50),
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color(0xFF4CAF50).withOpacity(0.5),
                                            blurRadius: 4,
                                            spreadRadius: 1,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      'Online · Ready to help',
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.7),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              // Messages area
          Expanded(
            child: messages.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                widget.appBarColor.withOpacity(0.15),
                                widget.appBarColor.withOpacity(0.08),
                              ],
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.smart_toy_rounded,
                            size: 40,
                            color: widget.appBarColor.withOpacity(0.5),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'How can I help you today?',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Ask me anything about farming!',
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                  controller: _scrollController,
              padding: const EdgeInsets.all(16),
                  itemCount: messages.length + (_showTypingIndicator ? 1 : 0),
              itemBuilder: (context, index) {
                    if (_showTypingIndicator && index == messages.length) {
                      return _buildTypingIndicator();
                    }
                final message = messages[index];
                    return _buildMessageBubble(message, screenWidth, index);
              },
            ),
          ),
          
              // Loading indicator with animation
          if (_isLoading)
            Container(
              padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              widget.sendButtonColor.withOpacity(0.8),
                              widget.sendButtonColor.withOpacity(0.7),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(30),
                        ),
              child: Row(
                children: [
                            const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                  const SizedBox(width: 12),
                            Text(
                    AppLocalizations.of(context)?.analyzing ?? 'Analyzing...',
                    style: const TextStyle(
                                color: Colors.white,
                      fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                    ),
                  ),
                ],
              ),
            ),
          
              // Input area with glassmorphism
          Container(
                margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      widget.inputContainerColor,
                      widget.inputContainerColor.withOpacity(0.8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 5),
                      spreadRadius: 2,
                ),
              ],
            ),
                child: Padding(
                  padding: const EdgeInsets.all(4),
            child: Row(
              children: [
                // Voice input button - Only show on supported platforms
                if (_speechAvailable)
                  Tooltip(
                    message: _isListening 
                        ? (AppLocalizations.of(context)?.tapToStop ?? 'Tap to stop')
                        : (AppLocalizations.of(context)?.tapToSpeak ?? 'Tap microphone to speak'),
                    child: InkWell(
                      onTap: () {
                        print('Voice button tapped. Currently listening: $_isListening');
                        if (_isListening) {
                          _stopListening();
                        } else {
                          _startListening();
                        }
                      },
                      borderRadius: BorderRadius.circular(24),
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: _isListening 
                              ? Colors.red.withOpacity(0.8)
                              : Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Icon(
                          _isListening ? Icons.mic : Icons.mic_none,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                    ),
                  ),
                if (_speechAvailable) const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: _isListening 
                          ? (AppLocalizations.of(context)?.listening ?? 'Listening...')
                          : widget.hintText,
                            hintStyle: widget.hintStyle ?? TextStyle(
                              color: Colors.white.withOpacity(0.7),
                        fontSize: 16,
                      ),
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                    maxLines: null,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => _sendMessage(),
                    enabled: !_isListening,
                  ),
                ),
                       const SizedBox(width: 8),
                GestureDetector(
                  onTap: _sendMessage,
                  child: Container(
                          width: 52,
                          height: 52,
                    decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                widget.sendButtonColor,
                                widget.sendButtonColor.withOpacity(0.8),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                                color: widget.sendButtonColor.withOpacity(0.4),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                                spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: const Icon(
                            Icons.send_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                ),
              ],
                  ),
            ),
          ),
        ],
          ),
        ),
      ),
    );
  }

  /// Build typing indicator
  Widget _buildTypingIndicator() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
            Container(
            width: 40,
            height: 40,
              decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  widget.appBarColor,
                  widget.appBarColor.withOpacity(0.7),
                ],
              ),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                  BoxShadow(
                    color: widget.appBarColor.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Icon(
              Icons.smart_toy_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            decoration: BoxDecoration(
                color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(20),
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (int i = 0; i < 3; i++)
                  TweenAnimationBuilder<double>(
                    duration: const Duration(milliseconds: 600),
                    tween: Tween(begin: 0.0, end: 1.0),
                    builder: (context, value, child) {
                      return Opacity(
                        opacity: 0.3 + (0.7 * (i == 1 ? value : i == 0 ? (value - 0.3).clamp(0.0, 1.0) : (value - 0.6).clamp(0.0, 1.0))),
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          width: 9,
                          height: 9,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                widget.appBarColor,
                                widget.appBarColor.withOpacity(0.6),
                              ],
                            ),
                            shape: BoxShape.circle,
                          ),
                        ),
                      );
                    },
                    onEnd: () {
                      if (mounted && _showTypingIndicator) {
                        setState(() {});
                      }
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Build individual message bubble with enhanced styling
  Widget _buildMessageBubble(Map<String, dynamic> message, double screenWidth, int index) {
    final isUser = message['isUser'] as bool;
    final text = message['text'] as String;
    final timestamp = message['timestamp'] as DateTime;
    
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 300 + (index * 50)),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.8 + (value * 0.2),
          child: Opacity(
            opacity: value,
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!isUser) ...[
                        Container(
                          width: 40,
                          height: 40,
              decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                widget.appBarColor,
                                widget.appBarColor.withOpacity(0.7),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                                color: widget.appBarColor.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.smart_toy_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                      ],
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                          decoration: BoxDecoration(
                            gradient: isUser
                                ? LinearGradient(
                                    colors: [
                                      widget.appBarColor,
                                      widget.appBarColor.withOpacity(0.8),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  )
                                : null,
                            color: isUser ? null : Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(isUser ? 20 : 4),
                              topRight: Radius.circular(isUser ? 4 : 20),
                              bottomLeft: const Radius.circular(20),
                              bottomRight: const Radius.circular(20),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(isUser ? 0.2 : 0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                                spreadRadius: 1,
                  ),
                ],
              ),
              constraints: BoxConstraints(maxWidth: screenWidth * 0.75),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Text(
                text,
                style: TextStyle(
                                  fontSize: 15,
                  color: isUser ? Colors.white : Colors.black87,
                                  height: 1.4,
                                  fontWeight: isUser ? FontWeight.w400 : FontWeight.w500,
                                ),
                                    ),
                                  ),
                                  // Speaker button for bot messages
                                  if (!isUser && text.isNotEmpty) ...[
                                    const SizedBox(width: 8),
                                    GestureDetector(
                                      onTap: _isSpeaking 
                                          ? _stopSpeaking 
                                          : () => _speakText(text),
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: _isSpeaking 
                                              ? Colors.green.withOpacity(0.2)
                                              : Colors.grey.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Icon(
                                          _isSpeaking ? Icons.volume_up : Icons.volume_down,
                                          size: 16,
                                          color: _isSpeaking ? Colors.green : Colors.grey[600],
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: isUser ? Colors.white70 : Colors.grey[600],
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
              ),
            ),
          ),
          if (isUser) ...[
                        const SizedBox(width: 12),
            Container(
                          width: 40,
                          height: 40,
              decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF4A90E2),
                                Color(0xFF357ABD),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF4A90E2).withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
              ),
              child: const Icon(
                            Icons.person_rounded,
                color: Colors.white,
                            size: 20,
              ),
            ),
          ],
        ],
      ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}