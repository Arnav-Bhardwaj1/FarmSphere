import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

/// A reusable AI chatbot widget using Google Gemini API
/// 
/// This widget provides a complete chat interface with:
/// - Message display with user/bot message bubbles
/// - Text input field with send button
/// - Integration with Google Gemini for AI responses
/// - Customizable styling and colors
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
  List<Map<String, dynamic>> messages = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeGemini();
  }

  /// Initialize Gemini API connection
  Future<void> _initializeGemini() async {
    try {
      // Initialize the Gemini model with your API key
      model = GenerativeModel(
        model: 'gemini-2.5-flash',
        apiKey: 'AIzaSyA3j5nTA3w1zg81rhfTWfkvFfaLo327HZs',
        generationConfig: GenerationConfig(
          temperature: 0.7,
          topK: 40,
          topP: 0.95,
          maxOutputTokens: 1024,
        ),
      );
      
      // Add welcome message
      messages.add({
        'text': 'Hello! I\'m your FarmSphere AI assistant. How can I help you with farming today?',
        'isUser': false,
        'timestamp': DateTime.now(),
      });
    } catch (e) {
      print('Error initializing Gemini: $e');
      messages.add({
        'text': 'Sorry, I\'m having trouble connecting. Please try again later.',
        'isUser': false,
        'timestamp': DateTime.now(),
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Send message to Gemini and get response
  Future<void> _sendMessage() async {
    if (_controller.text.trim().isEmpty || _isLoading) return;

    final userMessage = _controller.text.trim();
    _controller.clear();

    // Add user message
    setState(() {
      messages.add({
        'text': userMessage,
        'isUser': true,
        'timestamp': DateTime.now(),
      });
      _isLoading = true;
    });

    try {
      // Create farming-focused prompt
      final farmingPrompt = 'You are FarmSphere AI Assistant, a helpful farming expert. '
          'You provide practical advice about agriculture, crop management, '
          'plant diseases, soil health, weather patterns, and sustainable farming practices. '
          'Always be friendly, informative, and specific in your responses. '
          'If you don\'t know something, admit it and suggest where to find more information.\n\n'
          'User question: $userMessage';
      
      // Get response from Gemini
      final content = [Content.text(farmingPrompt)];
      final response = await model.generateContent(content);
      
      final aiResponse = response.text ?? 'Sorry, I couldn\'t generate a response.';
      
      setState(() {
        messages.add({
          'text': aiResponse,
          'isUser': false,
          'timestamp': DateTime.now(),
        });
        _isLoading = false;
      });
    } catch (e) {
      print('Error sending message: $e');
      setState(() {
        messages.add({
          'text': 'Sorry, I encountered an error. Please try again.',
          'isUser': false,
          'timestamp': DateTime.now(),
        });
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    return Scaffold(
      backgroundColor: widget.backgroundColor,
      appBar: AppBar(
        backgroundColor: widget.appBarColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.title,
          style: widget.titleStyle ?? const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Messages area
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return _buildMessageBubble(message, screenWidth);
              },
            ),
          ),
          
          // Loading indicator
          if (_isLoading)
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF36946F)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'AI is thinking...',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          
          // Input area
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: widget.inputContainerColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: widget.hintText,
                      hintStyle: widget.hintStyle ?? const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.2),
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
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: _sendMessage,
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: widget.sendButtonColor,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: widget.sendButtonColor.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Build individual message bubble
  Widget _buildMessageBubble(Map<String, dynamic> message, double screenWidth) {
    final isUser = message['isUser'] as bool;
    final text = message['text'] as String;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isUser) ...[
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: widget.appBarColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.smart_toy,
                color: Colors.white,
                size: 18,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isUser ? widget.appBarColor : Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              constraints: BoxConstraints(maxWidth: screenWidth * 0.75),
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 16,
                  color: isUser ? Colors.white : Colors.black87,
                ),
              ),
            ),
          ),
          if (isUser) ...[
            const SizedBox(width: 8),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: widget.appBarColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.person,
                color: Colors.white,
                size: 18,
              ),
            ),
          ],
        ],
      ),
    );
  }
}