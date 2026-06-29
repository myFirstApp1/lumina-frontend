import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/secure_storage/secure_storage_manager.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/onboarding_helper.dart';

class OnboardingStep1Screen extends StatefulWidget {
  const OnboardingStep1Screen({Key? key}) : super(key: key);

  @override
  State<OnboardingStep1Screen> createState() => _OnboardingStep1ScreenState();
}

class _OnboardingStep1ScreenState extends State<OnboardingStep1Screen> with TickerProviderStateMixin {
  late AnimationController _rotateController;
  late AnimationController _bounceController;

  @override
  void initState() {
    super.initState();
    // Background rings rotating
    _rotateController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 60),
    )..repeat();

    // Floating bounce for status chips
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _rotateController.dispose();
    _bounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double bounceVal = Curves.easeInOut.transform(_bounceController.value) * 8.0;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: AppTheme.background,
          gradient: LinearGradient(
            colors: [Color(0xFFFAF7F8), Color(0xFFFDF2F5)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
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
                    // Illustration Area (Upper Half)
                    Expanded(
                      flex: 5,
                      child: Center(
                        child: SizedBox(
                          width: 320,
                          height: 320,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Decorative rings rotating
                              AnimatedBuilder(
                                animation: _rotateController,
                                builder: (context, child) {
                                  return Transform.rotate(
                                    angle: _rotateController.value * 2 * math.pi,
                                    child: _buildDottedRing(radius: 280, isDashed: true),
                                  );
                                },
                              ),
                              AnimatedBuilder(
                                animation: _rotateController,
                                builder: (context, child) {
                                  return Transform.rotate(
                                    angle: -_rotateController.value * 2 * math.pi,
                                    child: _buildDottedRing(radius: 340, isDashed: false),
                                  );
                                },
                              ),

                              // Central Glowing Orb
                              Container(
                                width: 180,
                                height: 180,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFFF06292).withOpacity(0.3),
                                      blurRadius: 30,
                                      spreadRadius: 2,
                                    )
                                  ],
                                ),
                                padding: const EdgeInsets.all(4.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(9999),
                                  child: Image.network(
                                    "https://lh3.googleusercontent.com/aida-public/AB6AXuAvn1fzgYe0XBuRqX5qpfqA09YxXixRCTNv_eQN4knN25FeCrR4Dh0PkEte_NAr31E2uxkKnb5Wx8QiWl33AfG30y-RYy7R06HrtPRFZbxpoqCQb62m9I2WC4OIB_h0GxJJORRq9DL_66J-31xV9V2Wak2TxAIWwVCbknRSbp_UeQudbESvGUwGdrenH_WruA7VxNovaEsn4xUhIBIFNkyQsnbPkFXCRvJ8pFkRgDMy-51SjriINq0B9OwukUu-uJC5j--Iwbbs9xQ",
                                    fit: BoxFit.cover,
                                    loadingBuilder: (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return const Center(child: CircularProgressIndicator(color: AppTheme.primary));
                                    },
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(Icons.blur_on_rounded, color: AppTheme.primary, size: 72);
                                    },
                                  ),
                                ),
                              ),

                              // Floating status chips 1: Vitals Sync (Top-Right)
                              AnimatedBuilder(
                                animation: _bounceController,
                                builder: (context, child) {
                                  return Positioned(
                                    top: 40 - bounceVal,
                                    right: 10,
                                    child: _buildFloatingChip(Icons.favorite, "Vitals Sync"),
                                  );
                                },
                              ),

                              // Floating status chips 2: Scanning (Bottom-Left)
                              AnimatedBuilder(
                                animation: _bounceController,
                                builder: (context, child) {
                                  return Positioned(
                                    bottom: 30 - bounceVal,
                                    left: 10,
                                    child: _buildFloatingChip(Icons.radar, "Scanning"),
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
                        borderRadius: BorderRadius.circular(40.0),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.85),
                              borderRadius: BorderRadius.circular(40.0),
                              border: Border.all(color: Colors.white.withOpacity(0.8), width: 1.0),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 24.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // Progress indicators (4 dots: first one active)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _buildIndicator(isActive: true),
                                    const SizedBox(width: 6),
                                    _buildIndicator(isActive: false),
                                    const SizedBox(width: 6),
                                    _buildIndicator(isActive: false),
                                    const SizedBox(width: 6),
                                    _buildIndicator(isActive: false),
                                  ],
                                ),
                                const Spacer(),

                                // Title
                                RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    style: GoogleFonts.montserrat(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      height: 1.3,
                                      color: AppTheme.textPrimary,
                                    ),
                                    children: const [
                                      TextSpan(text: "Always Watching\n"),
                                      TextSpan(
                                        text: "Over You",
                                        style: TextStyle(color: Color(0xFFF06292)),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 12.0),

                                // Subtitle
                                Text(
                                  "Our AI companion monitors your heart rate and movement to detect danger before it happens.",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.beVietnamPro(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    height: 1.6,
                                    color: AppTheme.textSecondary,
                                  ),
                                ),
                                const Spacer(),

                                // Next button with rose gradient
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(9999),
                                    gradient: const LinearGradient(
                                      colors: [AppTheme.primary, Color(0xFFD8487B)],
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
                                    onPressed: () {
                                      context.push(AppRoutes.onboardingStep2);
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

  Widget _buildDottedRing({required double radius, required bool isDashed}) {
    return Container(
      width: radius,
      height: radius,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isDashed ? Colors.white.withOpacity(0.6) : const Color(0xFFF06292).withOpacity(0.2),
          width: 1.0,
          style: BorderStyle.solid, // Use solid custom painter for custom dashed if needed, otherwise clean solid looks stunning.
        ),
      ),
    );
  }

  Widget _buildFloatingChip(IconData icon, String label) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(9999),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.85),
            borderRadius: BorderRadius.circular(9999),
            border: Border.all(color: Colors.white.withOpacity(0.5), width: 1.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8.0,
              )
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: AppTheme.primary, size: 16),
              const SizedBox(width: 6),
              Text(
                label,
                style: GoogleFonts.beVietnamPro(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
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
