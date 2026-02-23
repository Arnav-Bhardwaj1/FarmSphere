import 'dart:async';
import 'package:flutter/services.dart';

/// Windows Speech Recognition Service using platform channels
class WindowsSpeechService {
  static const MethodChannel _channel = MethodChannel('farmsphere/windows_speech');
  
  bool _isAvailable = false;
  bool _isListening = false;
  
  StreamController<String>? _resultController;
  StreamController<bool>? _statusController;
  
  /// Initialize Windows speech recognition
  Future<bool> initialize() async {
    try {
      final result = await _channel.invokeMethod('initialize');
      _isAvailable = result == true;
      
      // Set up method call handler for callbacks from native code
      _channel.setMethodCallHandler(_handleMethodCall);
      
      return _isAvailable;
    } catch (e) {
      print('Failed to initialize Windows speech: $e');
      return false;
    }
  }
  
  /// Handle method calls from native Windows code
  Future<dynamic> _handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'onRecognitionResult':
        final text = call.arguments as String?;
        if (text != null && text.isNotEmpty) {
          _resultController?.add(text);
        }
        break;
      case 'onRecognitionComplete':
        _isListening = false;
        _statusController?.add(false);
        break;
      case 'onError':
        final error = call.arguments as String?;
        print('Speech recognition error: $error');
        _isListening = false;
        _statusController?.add(false);
        break;
    }
  }
  
  /// Start listening for speech
  Future<bool> startListening({
    String locale = 'en-US',
    Function(String)? onResult,
    Function(bool)? onStatus,
  }) async {
    if (!_isAvailable || _isListening) return false;
    
    try {
      // Set up stream controllers
      _resultController = StreamController<String>.broadcast();
      _statusController = StreamController<bool>.broadcast();
      
      if (onResult != null) {
        _resultController?.stream.listen(onResult);
      }
      if (onStatus != null) {
        _statusController?.stream.listen(onStatus);
      }
      
      final result = await _channel.invokeMethod('startListening', {'locale': locale});
      _isListening = result == true;
      if (_isListening) {
        _statusController?.add(true);
      }
      return _isListening;
    } catch (e) {
      print('Failed to start listening: $e');
      return false;
    }
  }
  
  /// Stop listening
  Future<void> stopListening() async {
    if (!_isListening) return;
    
    try {
      await _channel.invokeMethod('stopListening');
      _isListening = false;
      _statusController?.add(false);
    } catch (e) {
      print('Failed to stop listening: $e');
    }
  }
  
  /// Cancel listening
  Future<void> cancel() async {
    await stopListening();
    await _resultController?.close();
    await _statusController?.close();
    _resultController = null;
    _statusController = null;
  }
  
  bool get isAvailable => _isAvailable;
  bool get isListening => _isListening;
  
  /// Dispose resources
  void dispose() {
    cancel();
  }
}
