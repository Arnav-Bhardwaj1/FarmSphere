import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
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
        apiKey: geminiApiKey,
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
    _scrollController.dispose();
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
      _showTypingIndicator = true;
    });
    
    _scrollToBottom();

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
        _showTypingIndicator = false;
      });
      
      _scrollToBottom();
    } catch (e) {
      print('Error sending message: $e');
      setState(() {
        messages.add({
          'text': 'Sorry, I encountered an error. Please try again.',
          'isUser': false,
          'timestamp': DateTime.now(),
        });
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
              // Custom App Bar with gradient
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [widget.appBarColor, widget.appBarColor.withOpacity(0.9)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
                    Expanded(
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.smart_toy,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
          widget.title,
          style: widget.titleStyle ?? const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
          ),
        ),
                  ],
                ),
      ),
              
              // Messages area with glass effect
          Expanded(
            child: ListView.builder(
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
                            SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                  const SizedBox(width: 12),
                            const Text(
                    'AI is thinking...',
                    style: TextStyle(
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
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: widget.hintText,
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
                  ),
                ),
                      const SizedBox(width: 8),
                GestureDetector(
                  onTap: _sendMessage,
                  child: Container(
                          width: 56,
                          height: 56,
                    decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                widget.sendButtonColor,
                                widget.sendButtonColor.withOpacity(0.8),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(28),
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
                      size: 24,
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
              borderRadius: BorderRadius.circular(20),
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
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
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
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: Colors.grey[600],
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
                borderRadius: BorderRadius.circular(20),
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
                              Text(
                text,
                style: TextStyle(
                                  fontSize: 15,
                  color: isUser ? Colors.white : Colors.black87,
                                  height: 1.4,
                                  fontWeight: isUser ? FontWeight.w400 : FontWeight.w500,
                                ),
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