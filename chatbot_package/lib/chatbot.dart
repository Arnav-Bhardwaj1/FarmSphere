import 'package:flutter/material.dart';
import 'package:dialog_flowtter/dialog_flowtter.dart';

/// A reusable AI chatbot widget using Google Dialogflow
/// 
/// This widget provides a complete chat interface with:
/// - Message display with user/bot message bubbles
/// - Text input field with send button
/// - Integration with Google Dialogflow for AI responses
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
    Key? key,
    this.title = 'AI Assistant',
    this.backgroundColor = const Color(0xFFF9F3CC),
    this.appBarColor = const Color(0xFF285352),
    this.inputContainerColor = const Color(0xFF36946F),
    this.sendButtonColor = const Color(0xFF36946F),
    this.hintText = 'Ask to AI',
    this.titleStyle,
    this.hintStyle,
  }) : super(key: key);

  @override
  _AIChatbotState createState() => _AIChatbotState();
}

class _AIChatbotState extends State<AIChatbot> {
  late DialogFlowtter dialogFlowtter;
  final TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> messages = [];

  @override
  void initState() {
    super.initState();
    _initializeDialogflow();
  }

  /// Initialize Dialogflow connection
  Future<void> _initializeDialogflow() async {
    try {
      dialogFlowtter = await DialogFlowtter.fromFile();
    } catch (e) {
      print('Error initializing Dialogflow: $e');
      // You might want to show an error dialog or handle this gracefully
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.backgroundColor,
      appBar: AppBar(
        title: Text(
          widget.title,
          style: widget.titleStyle,
        ),
        backgroundColor: widget.appBarColor,
        elevation: 0,
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: MessagesScreen(
                messages: messages,
                backgroundColor: widget.backgroundColor,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              color: widget.inputContainerColor,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      style: const TextStyle(color: Colors.white),
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                        hintText: widget.hintText,
                        hintStyle: widget.hintStyle ?? 
                          const TextStyle(color: Colors.black54),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      onSubmitted: (text) => _sendMessage(),
                    ),
                  ),
                  IconButton(
                    onPressed: _sendMessage,
                    icon: const Icon(
                      Icons.send,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Send message to Dialogflow and handle response
  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) {
      return;
    }

    // Clear input field
    _controller.clear();

    // Add user message to UI
    setState(() {
      addMessage(Message(text: DialogText(text: [text])), true);
    });

    try {
      // Send message to Dialogflow
      DetectIntentResponse response = await dialogFlowtter.detectIntent(
        queryInput: QueryInput(text: TextInput(text: text)),
      );

      if (response.message != null) {
        setState(() {
          addMessage(response.message!);
        });
      }
    } catch (e) {
      print('Error sending message: $e');
      // You might want to show an error message to the user
      setState(() {
        addMessage(
          Message(text: DialogText(text: ['Sorry, I encountered an error. Please try again.'])),
        );
      });
    }
  }

  /// Add a message to the messages list
  void addMessage(Message message, [bool isUserMessage = false]) {
    messages.add({
      'message': message,
      'isUserMessage': isUserMessage,
    });
  }
}

/// Widget to display the chat messages
class MessagesScreen extends StatefulWidget {
  final List messages;
  final Color backgroundColor;

  const MessagesScreen({
    Key? key,
    required this.messages,
    this.backgroundColor = const Color(0xFFF9F3CC),
  }) : super(key: key);

  @override
  _MessagesScreenState createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    
    return ListView.separated(
      padding: const EdgeInsets.all(8),
      itemBuilder: (context, index) {
        final messageData = widget.messages[index];
        final isUserMessage = messageData['isUserMessage'] as bool;
        final message = messageData['message'] as Message;
        
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            mainAxisAlignment: isUserMessage
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: const Radius.circular(20),
                    topRight: const Radius.circular(20),
                    bottomRight: Radius.circular(isUserMessage ? 0 : 20),
                    topLeft: Radius.circular(isUserMessage ? 20 : 0),
                  ),
                  color: isUserMessage
                      ? Colors.grey.shade50
                      : Colors.grey.shade50.withOpacity(0.8),
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
                  message.text.text[0],
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
        );
      },
      separatorBuilder: (_, i) => const SizedBox(height: 8),
      itemCount: widget.messages.length,
    );
  }
}

/// Simple wrapper widget for easy integration
/// 
/// Usage:
/// ```dart
/// Navigator.push(
///   context,
///   MaterialPageRoute(builder: (context) => ChatbotPage()),
/// );
/// ```
class ChatbotPage extends StatelessWidget {
  const ChatbotPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const AIChatbot();
  }
}