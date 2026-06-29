import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/secure_storage/secure_storage_manager.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/onboarding_helper.dart';
import '../../../../core/widgets/pulsating_ring.dart';

class OnboardingStep4Screen extends StatefulWidget {
  const OnboardingStep4Screen({Key? key}) : super(key: key);

  @override
  State<OnboardingStep4Screen> createState() => _OnboardingStep4ScreenState();
}

class _OnboardingStep4ScreenState extends State<OnboardingStep4Screen> with SingleTickerProviderStateMixin {
  late AnimationController _floatController;

  @override
  void initState() {
    super.initState();
    // Floating bounce for status beacons
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: AppTheme.background,
          gradient: LinearGradient(
            colors: [
              Color(0xFFFAF9F8),
              Color(0xFFFFD9E1),
              Color(0x33F06292),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            // Top Bar
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.shield_outlined, color: AppTheme.primary, size: 24),
                          const SizedBox(width: 8),
                          Text(
                            "Lumina",
                            style: GoogleFonts.montserrat(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primary,
                            ),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () async {
                          await OnboardingHelper.skip(context);
                        },
                        child: Text(
                          "Skip",
                          style: GoogleFonts.beVietnamPro(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Main Contents
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24.0, 64.0, 24.0, 24.0),
                child: Column(
                  children: [
                    // Visual Area (Upper Half)
                    Expanded(
                      flex: 5,
                      child: Center(
                        child: SizedBox(
                          width: 280,
                          height: 280,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Central SOS Icon with pulsating glows
                              PulsatingRing(
                                pulseColor: AppTheme.primaryContainer.withOpacity(0.3),
                                maxRadius: 260.0,
                                ringsCount: 3,
                                duration: const Duration(seconds: 2),
                                child: Container(
                                  width: 128,
                                  height: 128,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppTheme.primaryContainer,
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppTheme.primaryContainer.withOpacity(0.4),
                                        blurRadius: 24,
                                        spreadRadius: 2,
                                        offset: const Offset(0, 8),
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Text(
                                      "SOS",
                                      style: GoogleFonts.montserrat(
                                        color: Colors.white,
                                        fontSize: 40,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              // Floating Element 1: Emergency (Top Left)
                              AnimatedBuilder(
                                animation: _floatController,
                                builder: (context, child) {
                                  final double bounce = Curves.easeInOut.transform(_floatController.value) * 10;
                                  return Positioned(
                                    top: 16 - bounce,
                                    left: 16,
                                    child: _buildFloatingItem(Icons.emergency_outlined),
                                  );
                                },
                              ),

                              // Floating Element 2: Location On (Top Right)
                              AnimatedBuilder(
                                animation: _floatController,
                                builder: (context, child) {
                                  final double progress = _floatController.value;
                                  final double shifted = (progress + 0.3) % 1.0;
                                  final double bounce = Curves.easeInOut.transform(
                                    shifted < 0.5 ? shifted * 2 : (1.0 - shifted) * 2,
                                  ) * 10;

                                  return Positioned(
                                    top: 40 - bounce,
                                    right: 32,
                                    child: _buildFloatingItem(Icons.location_on_outlined, size: 40),
                                  );
                                },
                              ),

                              // Floating Element 3: Phone In Talk (Bottom Left)
                              AnimatedBuilder(
                                animation: _floatController,
                                builder: (context, child) {
                                  final double progress = _floatController.value;
                                  final double shifted = (progress + 0.6) % 1.0;
                                  final double bounce = Curves.easeInOut.transform(
                                    shifted < 0.5 ? shifted * 2 : (1.0 - shifted) * 2,
                                  ) * 10;

                                  return Positioned(
                                    bottom: 32 - bounce,
                                    left: 40,
                                    child: _buildFloatingItem(Icons.phone_in_talk_outlined, size: 56),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Glassmorphic Card (Bottom Half)
                    Expanded(
                      flex: 4,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24.0),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(24.0),
                              border: Border.all(color: Colors.white.withOpacity(0.5), width: 1.0),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 28.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // Progress indicators (4 dots: fourth active)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _buildIndicator(isActive: false),
                                    const SizedBox(width: 6),
                                    _buildIndicator(isActive: false),
                                    const SizedBox(width: 6),
                                    _buildIndicator(isActive: false),
                                    const SizedBox(width: 6),
                                    _buildIndicator(isActive: true),
                                  ],
                                ),
                                const Spacer(),

                                // Title
                                Text(
                                  "Instant SOS Activation",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.montserrat(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.textPrimary,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                                const SizedBox(height: 12.0),

                                // Subtitle
                                Text(
                                  "Trigger a silent or loud alarm with a single tap. Your emergency contacts and local authorities will be notified instantly with your live location.",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.beVietnamPro(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    height: 1.6,
                                    color: AppTheme.textSecondary,
                                  ),
                                ),
                                const Spacer(),

                                // Action button with gradient
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(9999),
                                    gradient: const LinearGradient(
                                      colors: [AppTheme.primary, Color(0xFFF06292)],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppTheme.primary.withOpacity(0.2),
                                        blurRadius: 16.0,
                                        spreadRadius: 1.0,
                                        offset: const Offset(0, 6),
                                      ),
                                    ],
                                  ),
                                  child: ElevatedButton(
                                    onPressed: ()  async {
                                      final storage = SecureStorageManager();
                                      await storage.setOnboardingCompleted();
                                      context.go(AppRoutes.login);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      foregroundColor: Colors.white,
                                      shadowColor: Colors.transparent,
                                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                                      shape: const StadiumBorder(),
                                    ),
                                    child: Text(
                                      "Next",
                                      style: GoogleFonts.beVietnamPro(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
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
    );
  }

  Widget _buildFloatingItem(IconData icon, {double size = 48}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        border: Border.all(color: AppTheme.outlineVariant.withOpacity(0.3), width: 1.0),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Icon(icon, color: AppTheme.primaryContainer, size: size * 0.5),
    );
  }

  Widget _buildIndicator({required bool isActive}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: isActive ? 24.0 : 8.0,
      height: 8.0,
      decoration: BoxDecoration(
        color: isActive ? AppTheme.primary : const Color(0xFFFFB1C5).withOpacity(0.5),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
