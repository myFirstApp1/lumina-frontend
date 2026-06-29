import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/services/startup_service.dart';
import '../../../../core/secure_storage/secure_storage_manager.dart';
import '../../../../core/theme/app_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {

  /// app start flow
  late StartupService _startupService;

  // Animation Controllers
  late AnimationController _breatheController;
  late AnimationController _floatController;
  late AnimationController _fadeUpController;

  // Animations
  late Animation<double> _breatheScale;
  late Animation<double> _breatheOpacity;
  late Animation<double> _floatTranslation;
  late Animation<double> _fadeOpacity;
  late Animation<double> _fadeTranslation;

  @override
  void initState() {
    super.initState();

    _startupService = context.read<StartupService>();

    // 1. Breathing ring animation (4s cycle, easeInOut, repeats forever)
    _breatheController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
    _breatheScale = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _breatheController, curve: Curves.easeInOut),
    );
    _breatheOpacity = Tween<double>(begin: 0.5, end: 0.8).animate(
      CurvedAnimation(parent: _breatheController, curve: Curves.easeInOut),
    );
    _breatheController.repeat(reverse: true);

    // 2. Floating logo animation (6s cycle, easeInOut, repeats forever)
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    );
    _floatTranslation = Tween<double>(begin: 0.0, end: -10.0).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );
    _floatController.repeat(reverse: true);

    // 3. Fade-in-up text entrance animation (1s duration, easeOut, triggers once)
    _fadeUpController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _fadeOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeUpController, curve: Curves.easeOut),
    );
    _fadeTranslation = Tween<double>(begin: 20.0, end: 0.0).animate(
      CurvedAnimation(parent: _fadeUpController, curve: Curves.easeOut),
    );

    // Stagger text entrance slightly after screen load
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _fadeUpController.forward();
      }
    });

    // Automatically transition to the onboarding screens after 4 seconds
    Future.delayed(const Duration(milliseconds: 4200), () async {
        if (!mounted) return;

        final route =
        await _startupService.getStartupRoute();

        switch (route) {

          case StartupRoute.onboarding:

            context.go(
              AppRoutes.onboardingStep1,
            );
            break;

          case StartupRoute.login:

            context.go(
              AppRoutes.login,
            );
            break;

          case StartupRoute.home:

            context.go(
              AppRoutes.home,
            );
            break;

          case StartupRoute.activeSos:
            context.go(AppRoutes.sosActive
            );
            break;

        }

      },
    );
  }

  @override
  void dispose() {
    _breatheController.dispose();
    _floatController.dispose();
    _fadeUpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background color with soft pink radial gradient in the center fading to surface
          Container(
            decoration: const BoxDecoration(
              color: AppTheme.background,
            ),
            child: RadialGradientBackground(),
          ),

          // Central content alignment
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo container area (relative sizing matched to w-48/w-64)
                  SizedBox(
                    width: 220,
                    height: 220,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Ring 1: Glass-ring with breathing scaling & opacity
                        AnimatedBuilder(
                          animation: _breatheController,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: _breatheScale.value,
                              child: Opacity(
                                opacity: _breatheOpacity.value,
                                child: _buildGlassRing(radius: 192),
                              ),
                            );
                          },
                        ),

                        // Ring 2: Glass-ring scaled at 1.10 with 30% relative opacity and staggering phase offset
                        AnimatedBuilder(
                          animation: _breatheController,
                          builder: (context, child) {
                            // Phase-shifted breathing values using sin offset math
                            final double progress = _breatheController.value;
                            final double shiftedProgress = (progress + 0.5) % 1.0;
                            final double breatheValue = Curves.easeInOut.transform(
                              shiftedProgress < 0.5 ? shiftedProgress * 2 : (1.0 - shiftedProgress) * 2,
                            );
                            final double scale = 1.10 * (1.0 + (breatheValue * 0.05));
                            final double opacity = 0.3 * (0.5 + (breatheValue * 0.3));

                            return Transform.scale(
                              scale: scale,
                              child: Opacity(
                                opacity: opacity,
                                child: _buildGlassRing(radius: 192),
                              ),
                            );
                          },
                        ),

                        // Shield graphic logo: floating up and down with premium drop shadow
                        AnimatedBuilder(
                          animation: _floatController,
                          builder: (context, child) {
                            return Transform.translate(
                              offset: Offset(0, _floatTranslation.value),
                              child: Container(
                                width: 140,
                                height: 140,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color(0x33F06292),
                                      blurRadius: 32.0,
                                      spreadRadius: 2.0,
                                      offset: Offset(0, 16),
                                    )
                                  ],
                                ),
                                child: Image.network(
                                  "https://lh3.googleusercontent.com/aida-public/AB6AXuB4nhKQUav3XyGXwKoi4fJ--R3jsIhAjdEYaI0qVTwf70EGbnK6_Ot6HG--EUKmEpuU_IbV4z0Tn5AtB6WxXE5UGMX5Qfu-zKabQTjDqubexMvKiWUKlFQnr05ViKA75IbignFelUm6f5YUKrCJ2B5cT3wKC1vKqWWCJRl7PoKNEDjresry2_MxKPjV45eOikQXAbz7JKURsuOXRpfP9znNDPxfEoQT_wm7n5qHEftrUHkkY6UlXcEenx-i3NQAsxtYlTMYXS_UXp0",
                                  fit: BoxFit.contain,
                                  loadingBuilder: (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return const SizedBox.shrink();
                                  },
                                  errorBuilder: (context, error, stackTrace) {
                                    // Fallback shield in case of offline/network failure
                                    return const Icon(
                                      Icons.shield_outlined,
                                      color: AppTheme.primary,
                                      size: 72,
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 36.0),

                  // Title and Subtitle area with Fade-In-Up entrance
                  AnimatedBuilder(
                    animation: _fadeUpController,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _fadeOpacity.value,
                        child: Transform.translate(
                          offset: Offset(0, _fadeTranslation.value),
                          child: Column(
                            children: [
                              // Gradient masked Text header: "Lumina Guardian" (Montserrat, 48px, bold)
                              ShaderMask(
                                shaderCallback: (Rect bounds) {
                                  return const LinearGradient(
                                    colors: [
                                      Color(0xFFF06292),
                                      Color(0xFFAB2C5D),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ).createShader(bounds);
                                },
                                blendMode: BlendMode.srcIn,
                                child: Text(
                                  "Lumina\nGuardian",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.montserrat(
                                    fontSize: 48,
                                    fontWeight: FontWeight.bold,
                                    height: 1.05,
                                    letterSpacing: -0.02,
                                  ),
                                ),
                              ),
                              
                              const SizedBox(height: 16.0),
                              
                              // Body Description text: (Be Vietnam Pro, 16px, color textSecondary/on-surface-variant)
                              Text(
                                "Your intelligent safety companion.",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.beVietnamPro(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  height: 1.5,
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper builder representing glassmorphic container ring
  Widget _buildGlassRing({required double radius}) {
    return Container(
      width: radius,
      height: radius,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(0.06), // Transparent white fill
        border: Border.all(
          color: Colors.white.withOpacity(0.4), // 1px solid border matching HTML design
          width: 1.0,
        ),
        boxShadow: [
          // Outer shadow glow tinted with pink matching 'rgba(240, 98, 146, 0.15)'
          BoxShadow(
            color: const Color(0xFFF06292).withOpacity(0.15),
            blurRadius: 40.0,
            spreadRadius: 2.0,
          ),
        ],
      ),
      // Inner blur using BackdropFilter matching 'backdrop-filter: blur(10px)'
      child: ClipOval(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: Container(color: Colors.transparent),
        ),
      ),
    );
  }
}

// Custom Painter to draw soft pink radial gradient in the background matching HTML specifications
class RadialGradientBackground extends StatelessWidget {
  const RadialGradientBackground({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _RadialGradientPainter(),
      child: Container(),
    );
  }
}

class _RadialGradientPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;
    final Paint paint = Paint()
      ..shader = const RadialGradient(
        center: Alignment.center,
        radius: 0.75,
        colors: [
          Color(0x66FFD9E1), // rgba(255, 217, 225, 0.4) matching center XML
          Color(0x00FBF9F8), // Fades entirely to background surface at 70% boundary
        ],
        stops: [0.0, 0.70],
      ).createShader(rect);

    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
