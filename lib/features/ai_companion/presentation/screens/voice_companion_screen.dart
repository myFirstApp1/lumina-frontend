import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class VoiceCompanionScreen extends StatefulWidget {
  const VoiceCompanionScreen({super.key});

  @override
  State<VoiceCompanionScreen> createState() =>
      _VoiceCompanionScreenState();
}

class _VoiceCompanionScreenState extends State<VoiceCompanionScreen>
    with SingleTickerProviderStateMixin {
  static const Color _pink = Color(0xFFB52D67);
  static const Color _brightPink = Color(0xFFEF5798);
  static const Color _darkPink = Color(0xFF9D315F);
  static const Color _background = Color(0xFFFFF5F5);

  final stt.SpeechToText _speech = stt.SpeechToText();

  late final AnimationController _animationController;

  bool _speechAvailable = false;
  bool _isListening = false;
  bool _isInitializing = true;

  String _recognizedText = '';
  String _statusMessage = 'Tap the microphone when you are ready.';

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );

    _initializeSpeech();
  }

  Future<void> _initializeSpeech() async {
    try {
      final available = await _speech.initialize(
        onStatus: _onSpeechStatus,
        onError: _onSpeechError,
      );

      if (!mounted) return;

      setState(() {
        _speechAvailable = available;
        _isInitializing = false;

        if (!available) {
          _statusMessage =
          'Speech recognition is unavailable on this device.';
        } else {
          _statusMessage = 'Hey there! How is your day going?';
        }
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _isInitializing = false;
        _speechAvailable = false;
        _statusMessage =
        'Unable to initialize speech recognition. Please try again.';
      });
    }
  }

  void _onSpeechStatus(String status) {
    if (!mounted) return;

    if (status == 'done' || status == 'notListening') {
      setState(() {
        _isListening = false;

        if (_recognizedText.trim().isNotEmpty) {
          _statusMessage = 'Here is what I heard:';
        } else if (_speechAvailable) {
          _statusMessage = 'Tap the microphone when you are ready.';
        }
      });

      _animationController.stop();
    }
  }

  void _onSpeechError(dynamic error) {
    if (!mounted) return;

    setState(() {
      _isListening = false;
      _statusMessage =
      'I couldn\'t hear that clearly. Please try again.';
    });

    _animationController.stop();

    debugPrint('Voice recognition error: $error');
  }

  Future<void> _toggleListening() async {
    if (_isInitializing) return;

    if (_isListening) {
      await _stopListening();
    } else {
      await _startListening();
    }
  }

  Future<void> _startListening() async {
    if (!_speechAvailable) {
      await _initializeSpeech();

      if (!_speechAvailable) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Speech recognition is unavailable. '
                  'Check your device settings and try again.',
            ),
            behavior: SnackBarBehavior.floating,
          ),
        );

        return;
      }
    }

    if (!mounted) return;

    setState(() {
      _isListening = true;
      _recognizedText = '';
      _statusMessage = 'I\'m listening...';
    });

    _animationController.repeat();

    try {
      await _speech.listen(
        onResult: (result) {
          if (!mounted) return;

          setState(() {
            _recognizedText = result.recognizedWords;

            if (_recognizedText.trim().isNotEmpty) {
              _statusMessage = 'I can hear you...';
            }
          });
        },
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 4),
        partialResults: true,
        cancelOnError: false,
      );
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _isListening = false;
        _statusMessage =
        'Could not start the microphone. Please try again.';
      });

      _animationController.stop();

      debugPrint('Could not start speech recognition: $error');
    }
  }

  Future<void> _stopListening() async {
    await _speech.stop();

    if (!mounted) return;

    _animationController.stop();

    setState(() {
      _isListening = false;

      _statusMessage = _recognizedText.trim().isNotEmpty
          ? 'Here is what I heard:'
          : 'Tap the microphone when you are ready.';
    });
  }

  void _clearTranscript() {
    setState(() {
      _recognizedText = '';
      _statusMessage = _isListening
          ? 'I\'m listening...'
          : 'Tap the microphone when you are ready.';
    });
  }

  void _goBackToChat() {
    // The voice screen is opened using context.push().
    // Pop returns to the existing AI chat screen.
    if (_isListening) {
      _speech.stop();
    }

    _animationController.stop();

    if (context.canPop()) {
      context.pop();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _speech.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFE8EF),
              Color(0xFFFFFAF6),
              Color(0xFFFFEAF0),
            ],
            stops: [0.0, 0.52, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 22,
                      ),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: constraints.maxHeight * 0.06,
                            ),

                            Text(
                              _isListening
                                  ? 'I\'m listening'
                                  : 'Talk to Lumina',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.5,
                                color: Color(0xFF211D20),
                              ),
                            ),

                            const SizedBox(height: 14),

                            Text(
                              _isListening
                                  ? 'Go ahead. I\'m here with you.'
                                  : 'A calm space to talk through what you need.',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 15,
                                height: 1.5,
                                color: Color(0xFF756A72),
                              ),
                            ),

                            const SizedBox(height: 30),

                            _buildListeningAnimation(),

                            const SizedBox(height: 24),

                            _buildMessageCard(),

                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              _buildBottomControls(),
            ],
          ),
        ),
      ),
    );
  }

  // ----------------------------------------------------------
  // HEADER
  // ----------------------------------------------------------

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
      child: SizedBox(
        height: 54,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: _roundButton(
                icon: Icons.arrow_back_rounded,
                tooltip: 'Back to chat',
                onPressed: _goBackToChat,
              ),
            ),

            const Text(
              'VOICE COMPANION',
              style: TextStyle(
                color: _darkPink,
                fontSize: 14,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.8,
              ),
            ),

            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                tooltip: 'Close voice companion',
                onPressed: _goBackToChat,
                icon: const Icon(
                  Icons.close_rounded,
                  color: Color(0xFF211D20),
                  size: 28,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _roundButton({
    required IconData icon,
    required String tooltip,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: 44,
      height: 44,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        tooltip: tooltip,
        onPressed: onPressed,
        icon: Icon(
          icon,
          color: const Color(0xFF211D20),
          size: 23,
        ),
      ),
    );
  }

  // ----------------------------------------------------------
  // ANIMATED DOTTED LISTENING CIRCLE
  // ----------------------------------------------------------

  Widget _buildListeningAnimation() {
    return SizedBox(
      width: 300,
      height: 300,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              // Soft outer glow.
              Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: _brightPink.withOpacity(
                        _isListening ? 0.22 : 0.10,
                      ),
                      blurRadius: _isListening ? 65 : 45,
                      spreadRadius: _isListening ? 12 : 4,
                    ),
                  ],
                ),
              ),

              // Rotating pink dots.
              CustomPaint(
                size: const Size(270, 270),
                painter: _ListeningDotsPainter(
                  progress: _animationController.value,
                  isListening: _isListening,
                ),
              ),

              // Glowing centre.
              AnimatedContainer(
                duration: const Duration(milliseconds: 350),
                width: _isListening ? 130 : 112,
                height: _isListening ? 130 : 112,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFFFF79B5).withOpacity(0.70),
                      const Color(0xFFFFB7D5).withOpacity(0.38),
                      Colors.white.withOpacity(0.05),
                    ],
                  ),
                ),
                child: Center(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: Text(
                      _isListening ? 'I\'m\nlistening' : 'Tap to\nbegin',
                      key: ValueKey(_isListening),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: _darkPink,
                        fontSize: _isListening ? 18 : 16,
                        fontWeight: FontWeight.w600,
                        height: 1.4,
                      ),
                    ),
                  ),
                ),
              ),

              // Microphone action.
              Positioned.fill(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: _toggleListening,
                    child: const SizedBox.expand(),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ----------------------------------------------------------
  // RECOGNIZED SPEECH / STATUS CARD
  // ----------------------------------------------------------

  Widget _buildMessageCard() {
    final hasTranscript = _recognizedText.trim().isNotEmpty;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 22,
        vertical: 24,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.96),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: _pink.withOpacity(0.045),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            hasTranscript ? 'Your words' : 'Voice companion',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF282329),
              fontSize: 19,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 12),

          Text(
            hasTranscript ? _recognizedText : _statusMessage,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF756A72),
              fontSize: 15,
              height: 1.6,
            ),
          ),

          if (_isInitializing) ...[
            const SizedBox(height: 16),
            const SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: _pink,
              ),
            ),
          ],

          if (hasTranscript && !_isListening) ...[
            const SizedBox(height: 16),
            TextButton.icon(
              onPressed: _clearTranscript,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Try again'),
              style: TextButton.styleFrom(
                foregroundColor: _darkPink,
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  // BOTTOM CONTROLS
  // ----------------------------------------------------------

  Widget _buildBottomControls() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 12, 30, 22),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Clear transcript.
          _bottomCircleButton(
            icon: Icons.calendar_month_rounded,
            tooltip: 'Clear transcript',
            onPressed: _clearTranscript,
            size: 42,
          ),

          // Main microphone button.
          GestureDetector(
            onTap: _toggleListening,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    _pink,
                    _brightPink,
                  ],
                ),
                border: Border.all(
                  color: const Color(0xFFF5C8D8),
                  width: 5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: _pink.withOpacity(
                      _isListening ? 0.30 : 0.15,
                    ),
                    blurRadius: _isListening ? 30 : 18,
                    spreadRadius: _isListening ? 5 : 1,
                  ),
                ],
              ),
              child: Icon(
                _isListening ? Icons.stop_rounded : Icons.mic_rounded,
                color: Colors.white,
                size: 32,
              ),
            ),
          ),

          // Close voice companion.
          _bottomCircleButton(
            icon: Icons.close_rounded,
            tooltip: 'Close voice companion',
            onPressed: _goBackToChat,
            size: 42,
          ),
        ],
      ),
    );
  }

  Widget _bottomCircleButton({
    required IconData icon,
    required String tooltip,
    required VoidCallback onPressed,
    required double size,
  }) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.white.withOpacity(0.55),
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onPressed,
          child: SizedBox(
            width: size,
            height: size,
            child: Icon(
              icon,
              color: _darkPink,
              size: 21,
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// CUSTOM PAINTER: ORBITING PINK DOTS
// ============================================================

class _ListeningDotsPainter extends CustomPainter {
  final double progress;
  final bool isListening;

  const _ListeningDotsPainter({
    required this.progress,
    required this.isListening,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.39;

    const dotCount = 48;

    final rotation = isListening ? progress * 2 * math.pi : 0.0;
    final pulse = isListening
        ? 1.0 + 0.045 * math.sin(progress * 2 * math.pi)
        : 1.0;

    for (int i = 0; i < dotCount; i++) {
      final angle =
          (i / dotCount) * 2 * math.pi + rotation;

      final wave = math.sin(
        (i / dotCount) * 2 * math.pi +
            progress * 2 * math.pi,
      );

      final adjustedRadius = radius * pulse + (wave * 2.0);

      final position = Offset(
        center.dx + math.cos(angle) * adjustedRadius,
        center.dy + math.sin(angle) * adjustedRadius,
      );

      final dotSize = isListening
          ? 2.0 + ((wave + 1) / 2) * 2.2
          : 2.0 + ((math.sin(i * 0.7) + 1) / 2) * 1.8;

      final opacity = isListening
          ? 0.55 + ((wave + 1) / 2) * 0.45
          : 0.65 + ((math.sin(i * 0.7) + 1) / 2) * 0.35;

      final paint = Paint()
        ..color = Color.lerp(
          const Color(0xFFFF91C1),
          const Color(0xFFEC3F91),
          (wave + 1) / 2,
        )!.withOpacity(opacity)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(position, dotSize, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ListeningDotsPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.isListening != isListening;
  }
}
