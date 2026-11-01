import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/routes/app_routes.dart';

class AiCompanionScreen extends StatefulWidget {
  const AiCompanionScreen({Key? key}) : super(key: key);

  @override
  State<AiCompanionScreen> createState() => _AiCompanionScreenState();
}

class _AiCompanionScreenState extends State<AiCompanionScreen> {
  final TextEditingController _messageController =
  TextEditingController();

  final ScrollController _scrollController = ScrollController();

  final List<Map<String, dynamic>> _messages = [
    {
      "text":
      "Hi! I'm Lumina, your personal safety companion. I can help you think through a situation or find the right safety feature when you need it. How are you feeling right now?",
      "isUser": false,
      "time": "20:30",
    },
    {
      "text":
      "I'm walking back home. It's a bit dark, but I feel okay.",
      "isUser": true,
      "time": "20:31",
    },
    {
      "text":
      "Thanks for telling me. Stay aware of your surroundings and choose a well-lit route when possible. If you feel unsafe, use the SOS feature in Lumina Guardian.",
      "isUser": false,
      "time": "20:31",
    },
  ];

  bool _isSending = false;

  void _openVoiceCompanion() {
    context.push(AppRoutes.voiceCompanion);
  }

  String _currentTime() {
    final now = TimeOfDay.now();

    final hour = now.hourOfPeriod == 0 ? 12 : now.hourOfPeriod;
    final minute = now.minute.toString().padLeft(2, '0');

    return '$hour:$minute';
  }

  void _handleSendMessage() {
    final text = _messageController.text.trim();

    if (text.isEmpty || _isSending) return;

    setState(() {
      _messages.add({
        "text": text,
        "isUser": true,
        "time": _currentTime(),
      });

      _messageController.clear();
      _isSending = true;
    });

    _scrollToBottom();

    // Existing simulated AI reply behavior.
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (!mounted) return;

      String reply =
          "I'm here to help. Tell me a little more about what's happening, and we can look at the available options together.";

      final lowerText = text.toLowerCase();

      if (lowerText.contains('danger') ||
          lowerText.contains('unsafe') ||
          lowerText.contains('scared')) {
        reply =
        "Your safety comes first. If you're in immediate danger, use the SOS feature in Lumina Guardian and contact emergency services.";
      } else if (lowerText.contains('dark')) {
        reply =
        "Please stay aware of your surroundings and choose a well-lit, populated route when possible. If you feel unsafe, use the SOS feature.";
      }

      setState(() {
        _messages.add({
          "text": reply,
          "isUser": false,
          "time": _currentTime(),
        });

        _isSending = false;
      });

      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_scrollController.hasClients) return;

      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F8),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFCFAF6),
              Color(0xFFFFF0F3),
              Color(0xFFFFF6F5),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              _buildSupportBanner(),
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final message = _messages[index];

                    return _buildChatBubble(
                      message['text'] as String,
                      message['isUser'] as bool,
                      message['time'] as String,
                    );
                  },
                ),
              ),
              if (_isSending) _buildTypingIndicator(),
              _buildMessageInput(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              tooltip: 'Back',
              onPressed: () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go(AppRoutes.home);
                }
              },
              icon: const Icon(
                Icons.arrow_back_rounded,
                color: Color(0xFF282329),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 66,
            height: 66,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  Color(0xFFAE285F),
                  Color(0xFFEB5793),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Color(0x22B52D67),
                  blurRadius: 18,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: const Icon(
              Icons.auto_awesome_rounded,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Lumina AI',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF211D20),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Your personal safety companion',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF756C72),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          Container(
            width: 46,
            height: 46,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              tooltip: 'Open Voice Companion',
              onPressed: _openVoiceCompanion,
              icon: const Icon(
                Icons.mic_none_rounded,
                color: Color(0xFFAC2D63),
                size: 25,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSupportBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.88),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFB52D67).withOpacity(0.035),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: const BoxDecoration(
              color: Color(0xFFF9E8EE),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.favorite_rounded,
              color: Color(0xFFAE2D63),
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'You can talk to me whenever you need support.',
              style: TextStyle(
                fontSize: 13,
                height: 1.4,
                color: Color(0xFF332C31),
              ),
            ),
          ),
          const Icon(
            Icons.more_horiz_rounded,
            color: Color(0xFFB34B77),
          ),
        ],
      ),
    );
  }

  Widget _buildChatBubble(
      String text,
      bool isUser,
      String time,
      ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment:
        isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isUser) ...[
            Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFAE285F),
                    Color(0xFFEB5793),
                  ],
                ),
              ),
              child: const Icon(
                Icons.auto_awesome_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.76,
              ),
              padding: const EdgeInsets.fromLTRB(17, 17, 17, 12),
              decoration: BoxDecoration(
                color: isUser
                    ? null
                    : Colors.white.withOpacity(0.96),
                gradient: isUser
                    ? const LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Color(0xFFAD285F),
                    Color(0xFFE9508A),
                  ],
                )
                    : null,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(23),
                  topRight: const Radius.circular(23),
                  bottomLeft: Radius.circular(isUser ? 23 : 5),
                  bottomRight: Radius.circular(isUser ? 5 : 23),
                ),
                boxShadow: [
                  BoxShadow(
                    color: isUser
                        ? const Color(0xFFB52D67).withOpacity(0.08)
                        : Colors.black.withOpacity(0.025),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    text,
                    style: TextStyle(
                      color: isUser
                          ? Colors.white
                          : const Color(0xFF292329),
                      fontSize: 15,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      time,
                      style: TextStyle(
                        color: isUser
                            ? Colors.white70
                            : const Color(0xFF958B91),
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return const Padding(
      padding: EdgeInsets.only(left: 25, bottom: 10),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Lumina is thinking...',
          style: TextStyle(
            color: Color(0xFF9A5976),
            fontSize: 12,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.96),
        border: Border(
          top: BorderSide(
            color: const Color(0xFFE8DDE1).withOpacity(0.7),
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              textCapitalization: TextCapitalization.sentences,
              minLines: 1,
              maxLines: 4,
              onSubmitted: (_) => _handleSendMessage(),
              decoration: InputDecoration(
                hintText: 'Message your safety companion...',
                hintStyle: const TextStyle(
                  color: Color(0xFF9B9298),
                  fontSize: 14,
                ),
                filled: true,
                fillColor: const Color(0xFFFFFAFA),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 17,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(
                    color: Color(0xFFB02D64),
                    width: 1.5,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(
                    color: Color(0xFFB02D64),
                    width: 2,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: _handleSendMessage,
            child: Container(
              width: 54,
              height: 54,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFAE285F),
                    Color(0xFFEB5793),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x22B52D67),
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                _isSending
                    ? Icons.hourglass_top_rounded
                    : Icons.arrow_upward_rounded,
                color: Colors.white,
                size: 25,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
