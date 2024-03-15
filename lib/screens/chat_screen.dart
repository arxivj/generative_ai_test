import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../widget/message_widget.dart';
import '../models/chat_message.dart';
import '../providers/chat_provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  bool isLoading = false;

  late final GenerativeModel _model;
  late final ChatSession _chatSession;

  @override
  void initState() {
    super.initState();
    final apiKey = dotenv.env['API_KEY'] ?? '';
    final aiModel = dotenv.env['AI_MODEL'] ?? 'gemini-pro';
    _model = GenerativeModel(model: aiModel, apiKey: apiKey);
    _chatSession = _model.startChat();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          surfaceTintColor: Colors.white,
          title: const Center(
            child: Text(
              '잼미니',
              style: TextStyle(color: Colors.black),
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 0),
      body: ChangeNotifierProvider(
        create: (_) => ChatProvider(),
        child: Consumer<ChatProvider>(
          builder: (context, chatProvider, _) => Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: chatProvider.messages.length,
                  itemBuilder: (context, index) {
                    final message = chatProvider.messages[index];
                    return MessageWidget(
                      message: message.text,
                      inUserMessage: !message.isIncoming,
                    );
                  },
                ),
              ),
              if (isLoading) const LinearProgressIndicator(),
              _buildMessageInput(chatProvider),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessageInput(ChatProvider chatProvider) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              style: const TextStyle(fontSize: 14, color: Colors.black),
              focusNode: _focusNode,
              controller: _textController,
              decoration: const InputDecoration(
                labelText: '메시지를 입력하세요',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => _sendMessage(chatProvider),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: isLoading
                ? null
                : () {
                    if (!isLoading) {
                      _sendMessage(chatProvider);
                    }
                  },
          ),
        ],
      ),
    );
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeOutCirc,
      );
    });
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeOutCirc,
    );
  }

  void _sendMessage(ChatProvider chatProvider) async {
    final messageText = _textController.text;
    if (messageText.isEmpty) return;

    setState(() {
      isLoading = true;
      _textController.clear();
    });
    _scrollToBottom();
    _focusNode.unfocus();

    chatProvider.addMessage(ChatMessage(text: messageText, isIncoming: false));

    try {
      final response =
          await _chatSession.sendMessage(Content.text(messageText));
      if (response.candidates.isNotEmpty) {
        final candidateContent = response.candidates.first.content;
        final aiMessageText = candidateContent.parts
            .whereType<TextPart>()
            .map((part) => part.text)
            .join();

        chatProvider
            .addMessage(ChatMessage(text: aiMessageText, isIncoming: true));
      }
    } catch (e) {
      print("음...: $e");
      chatProvider
          .addMessage(ChatMessage(text: "에러에러에러에러에러에러", isIncoming: true));
    }

    setState(() {
      isLoading = false;
    });

    _scrollToBottom();
    // _focusNode.requestFocus();
  }
}

// Path: lib/screens/chat_screen.dart