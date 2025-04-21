import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:heaaro_company/shared/constants.dart';
import 'package:intl/intl.dart';
import 'dart:math';

class ChatBotScreen extends StatefulWidget {
  const ChatBotScreen({super.key});
  @override
  State<ChatBotScreen> createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  final TextEditingController messageCont = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  static const apiKey = "AIzaSyBt_W6c2s2l4vr5qt78bGYCzs7nRQYn1qo";
  final model = GenerativeModel(model: 'gemini-2.0-flash', apiKey: apiKey);

  final List<Message> _messages = [];
  bool _isLoading = false;

  final List<String> sampleUserMessages = [
    "What should I eat for breakfast to boost energy?",
    "How much protein do I need daily?",
    "Is intermittent fasting good for weight loss?",
    "Can you give me a healthy dinner idea?",
    "What are the best foods for muscle gain?",
    "How many calories should I eat per day?",
  ];

  final List<String> sampleBotResponses = [
    "For energy, try oats with banana and peanut butter!",
    "On average, you need about 0.8 grams of protein per kilogram of body weight.",
    "Yes, intermittent fasting can support weight loss and improve insulin sensitivity.",
    "Grilled salmon with quinoa and steamed broccoli is a great healthy dinner.",
    "Chicken breast, eggs, Greek yogurt, and lentils are great for muscle gain.",
    "Daily calorie needs depend on your age, gender, and activity level. An average adult needs 2000–2500.",
  ];

  Future<void> sendMessage() async {
    final message = messageCont.text.trim();
    if (message.isEmpty) return;

    setState(() {
      _isLoading = true;
      _messages.add(Message(isUser: true, message: message, time: DateTime.now()));
    });
    messageCont.clear();
    _scrollToBottom();

    try {
      final content = [Content.text(message)];
      final response = await model.generateContent(content);
      setState(() {
        _messages.add(Message(isUser: false, message: response.text ?? "No response", time: DateTime.now()));
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _messages.add(Message(isUser: false, message: "Error: $e", time: DateTime.now()));
        _isLoading = false;
      });
    }

    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("ChatBot Info"),
        content: const Text("This screen allows you to chat with the Gemini AI bot. "
            "Ask questions about nutrition, meal plans, calories, and more."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  void _simulateChat() {
    final random = Random();
    final question = sampleUserMessages[random.nextInt(sampleUserMessages.length)];
    final answer = sampleBotResponses[random.nextInt(sampleBotResponses.length)];

    setState(() {
      _messages.add(Message(isUser: true, message: question, time: DateTime.now()));
      _messages.add(Message(isUser: false, message: answer, time: DateTime.now()));
    });

    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nutrition ChatBot'),
        actions: [
          IconButton(
            onPressed: _showInfoDialog,
            icon: const Icon(Icons.info_outline),
          ),
          IconButton(
            onPressed: _simulateChat,
            icon: const Icon(Icons.flash_on),
            tooltip: 'Simulate Chat',
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return Messages(
                  isUser: message.isUser,
                  message: message.message,
                  time: message.time,
                );
              },
            ),
          ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(10),
              child: CircularProgressIndicator(),
            ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: messageCont,
                    decoration: InputDecoration(
                      hintText: 'Ask Gemini...',
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(color: defaultColor),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  onPressed: _isLoading ? null : sendMessage,
                  icon: Icon(
                    FluentIcons.send_48_filled,
                    color: _isLoading ? Colors.grey : defaultColor,
                    size: 30,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Messages extends StatelessWidget {
  final bool isUser;
  final String message;
  final DateTime time;

  const Messages({
    super.key,
    required this.isUser,
    required this.message,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    final formattedTime = DateFormat('hh:mm a').format(time);
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: isUser ? defaultColor : Colors.grey.shade200,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isUser ? 16 : 0),
            bottomRight: Radius.circular(isUser ? 0 : 16),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message,
              style: TextStyle(
                color: isUser ? Colors.white : Colors.black87,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              formattedTime,
              style: TextStyle(
                color: isUser ? Colors.white70 : Colors.black45,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Message {
  final bool isUser;
  final String message;
  final DateTime time;

  Message({required this.isUser, required this.message, required this.time});
}
