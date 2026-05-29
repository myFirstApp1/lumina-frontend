import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/pulsating_ring.dart';

class AiCompanionScreen extends StatefulWidget {
  const AiCompanionScreen({Key? key}) : super(key: key);

  @override
  State<AiCompanionScreen> createState() => _AiCompanionScreenState();
}

class _AiCompanionScreenState extends State<AiCompanionScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [
    {
      "text": "Hello Sarah! I am your Lumina Guardian AI safety companion. I am actively keeping an eye on your coordinates and commute path in the background. Is everything okay on your walk?",
      "isUser": false,
      "time": "20:30"
    },
    {
      "text": "Yes, I am just walking back from the subway. It's a bit dark, but I feel fine.",
      "isUser": true,
      "time": "20:31"
    },
    {
      "text": "I've checked the route telemetry and noted a safe haven Police substation 0.4 miles ahead on Rose Ave. I'm listening in the background. If you need any pre-alert timer armed, just say 'Lumina Help'.",
      "isUser": false,
      "time": "20:31"
    }
  ];

  bool _isVoiceMode = false;
  bool _isListening = false;
  String _vocalInputText = "Listening for safety wake word...";

  void _handleSendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add({
        "text": text,
        "isUser": true,
        "time": "20:35",
      });
      _messageController.clear();
    });

    // Simulate AI thinking and reply
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        setState(() {
          String reply = "Understood. I have verified your GPS accuracy is high. Commuting safely.";
          if (text.toLowerCase().contains("danger") || text.toLowerCase().contains("dark")) {
            reply = "I detected potential danger parameters. I suggest arming a 5-minute Pre-Alert guard timer immediately for safety.";
          }
          _messages.add({
            "text": reply,
            "isUser": false,
            "time": "20:36",
          });
        });
      }
    });
  }

  void _toggleVoiceMode() {
    setState(() {
      _isVoiceMode = !_isVoiceMode;
      _isListening = _isVoiceMode;
      _vocalInputText = "Listening for safety wake word...";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("AI Guardian Companion"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppTheme.textPrimary,
        actions: [
          IconButton(
            icon: Icon(_isVoiceMode ? Icons.chat_bubble_outline_rounded : Icons.mic_none_outlined, color: AppTheme.primary),
            onPressed: _toggleVoiceMode,
          )
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.backgroundGradient,
        ),
        child: Stack(
          children: [
            // Standard Chat UI
            SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        final msg = _messages[index];
                        return _buildChatBubble(msg["text"], msg["isUser"], msg["time"]);
                      },
                    ),
                  ),
                  
                  // Message typing control bar
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.85),
                      border: const Border(top: BorderSide(color: AppTheme.outlineVariant, width: 0.5)),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _messageController,
                            decoration: InputDecoration(
                              hintText: "Talk to your safety guardian...",
                              fillColor: const Color(0xFFF5F3F3),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(24.0),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            onSubmitted: (_) => _handleSendMessage(),
                          ),
                        ),
                        const SizedBox(width: 12),
                        GestureDetector(
                          onTap: _handleSendMessage,
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: AppTheme.primaryGradient,
                            ),
                            child: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Immersive Glassmorphic Voice Mode Overlay (AI Guardian Voice Interaction)
            if (_isVoiceMode)
              Positioned.fill(
                child: ClipRRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
                    child: Container(
                      color: Colors.black.withOpacity(0.85),
                      padding: const EdgeInsets.all(32.0),
                      child: SafeArea(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "VOICE GUARDIAN ACTIVE",
                                  style: TextStyle(
                                    color: Colors.white54,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 2,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.close_rounded, color: Colors.white, size: 28),
                                  onPressed: _toggleVoiceMode,
                                )
                              ],
                            ),
                            const Spacer(),
                            
                            // Glowing pulsating microphone core representing safety equalizer
                            Center(
                              child: PulsatingRing(
                                pulseColor: AppTheme.primaryContainer.withOpacity(0.3),
                                maxRadius: 280,
                                ringsCount: 3,
                                duration: const Duration(milliseconds: 2000),
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _isListening = !_isListening;
                                      _vocalInputText = _isListening
                                          ? "Listening for safety wake word..."
                                          : "Voice interaction suspended.";
                                    });
                                  },
                                  child: Container(
                                    width: 150,
                                    height: 150,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: AppTheme.primaryGradient,
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppTheme.primary.withOpacity(0.4),
                                          blurRadius: 24,
                                          spreadRadius: 2,
                                        )
                                      ],
                                    ),
                                    child: Icon(
                                      _isListening ? Icons.mic_rounded : Icons.mic_off_rounded,
                                      color: Colors.white,
                                      size: 56,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            
                            const Spacer(),
                            
                            // Vocal input real-time recognized text
                            GlassCard(
                              borderRadius: 24,
                              padding: const EdgeInsets.all(24.0),
                              child: Column(
                                children: [
                                  Text(
                                    _vocalInputText,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: AppTheme.textPrimary,
                                      height: 1.4,
                                    ),
                                  ),
                                  const SizedBox(height: 12.0),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 8,
                                        height: 8,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: AppTheme.success,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      const Text(
                                        "Voice disarm: 'PIN 1234'",
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: AppTheme.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24.0),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatBubble(String text, bool isUser, String time) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16.0),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 14.0),
        decoration: BoxDecoration(
          color: isUser ? AppTheme.primary : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: Radius.circular(isUser ? 20 : 0),
            bottomRight: Radius.circular(isUser ? 0 : 20),
          ),
          border: isUser ? null : Border.all(color: AppTheme.outlineVariant.withOpacity(0.3)),
          boxShadow: isUser
              ? []
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 8.0,
                    offset: const Offset(0, 4),
                  )
                ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              text,
              style: TextStyle(
                color: isUser ? Colors.white : AppTheme.textPrimary,
                fontSize: 14,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 6),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                time,
                style: TextStyle(
                  color: isUser ? Colors.white70 : AppTheme.textSecondary.withOpacity(0.6),
                  fontSize: 10,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
