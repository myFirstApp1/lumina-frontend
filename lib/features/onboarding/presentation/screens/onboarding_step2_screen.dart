import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/secure_storage/secure_storage_manager.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/onboarding_helper.dart';

class OnboardingStep2Screen extends StatefulWidget {
  const OnboardingStep2Screen({Key? key}) : super(key: key);

  @override
  State<OnboardingStep2Screen> createState() => _OnboardingStep2ScreenState();
}

class _OnboardingStep2ScreenState extends State<OnboardingStep2Screen> with SingleTickerProviderStateMixin {
  late AnimationController _lineController;

  @override
  void initState() {
    super.initState();
    // Flow line dash offsets
    _lineController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _lineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: AppTheme.background,
          gradient: LinearGradient(
            colors: [Color(0xFFFBF9F8), Color(0xFFFFD9E1)],
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
                    // Visual Presentation Area (Upper Half)
                    Expanded(
                      flex: 5,
                      child: Center(
                        child: SizedBox(
                          width: 320,
                          height: 320,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Glassmorphic background blur sphere
                              Container(
                                width: 256,
                                height: 256,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withOpacity(0.4),
                                  border: Border.all(color: Colors.white.withOpacity(0.5), width: 1.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFFF06292).withOpacity(0.15),
                                      blurRadius: 40,
                                      spreadRadius: 2,
                                    )
                                  ],
                                ),
                                child: ClipOval(
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
                                    child: Container(color: Colors.transparent),
                                  ),
                                ),
                              ),

                              // SVG Connecting lines custom painter
                              AnimatedBuilder(
                                animation: _lineController,
                                builder: (context, child) {
                                  return CustomPaint(
                                    size: const Size(256, 256),
                                    painter: NetworkLinesPainter(progress: _lineController.value),
                                  );
                                },
                              ),

                              // Nodes: Top Node Avatar
                              Positioned(
                                top: 20,
                                child: _buildNodeAvatar(
                                  "https://lh3.googleusercontent.com/aida-public/AB6AXuBlX5fIcpMLNB2Pt3JqbIFj-38vKtGkAtFMonwAV2-xZIS5ffNDYMxNC7GMWX616mKwTUqXQ9iOmdtk7El7NdTS5_EjWXY_RITrqgT9HPd4Rj6Pmbz1xq46ROBT3bdcKCRLhpp0YhY8wwGDgqGWkYrq1hGV1qTvl9dAgXjojKzLf2pbCXvajvzceunJVhzK83qqpQNaXbJOp-JSjWXevkaJeECf8xR3NlOhGYbJnG23D7WJpIIh-PhAvtDnMLwnVHRDftG2T2HU7Es",
                                  size: 64,
                                ),
                              ),

                              // Nodes: Bottom-Right Node Avatar
                              Positioned(
                                bottom: 44,
                                right: 32,
                                child: _buildNodeAvatar(
                                  "https://lh3.googleusercontent.com/aida-public/AB6AXuDeqbJ1JBeEtdwOpFSmBWOv6zjIfMb8zy-cGQMO_xk58mq7hOy_gWR3m-tlae5J7rkuIPfOixlr253Bgta-or3iO7ksDXEeFbv1KOXjlXCVi1v-ooX3DKWyovo94Q7wXSA7ioGMt7ylpDsKlWNaDRLRncV3qz_co1BB4v5LtxCBnFWwS9o1Nl8G5jFPhJz9Qfmlga_2NI0H-tEHIhigZFMQ54dsWrYseWU9dLtu_vfKyP7qSoaEQ1kgtszBXpjoQpn5EBz4wSZ5m5w",
                                  size: 56,
                                ),
                              ),

                              // Nodes: Bottom-Left Person Add Node
                              Positioned(
                                bottom: 44,
                                left: 32,
                                child: Container(
                                  width: 56,
                                  height: 56,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                    border: Border.all(color: AppTheme.primaryContainer, width: 2.0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.08),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: const Icon(Icons.person_add_outlined, color: AppTheme.primaryContainer, size: 28),
                                ),
                              ),

                              // Center Shield Core
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppTheme.primaryContainer,
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFFF06292).withOpacity(0.6),
                                      blurRadius: 20.0,
                                    )
                                  ],
                                ),
                                child: const Icon(Icons.shield_rounded, color: Colors.white, size: 20),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Content Card (Bottom Half)
                    Expanded(
                      flex: 4,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(24.0),
                          border: Border.all(color: Colors.white.withOpacity(0.5), width: 1.0),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFF06292).withOpacity(0.15),
                              blurRadius: 40,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 28.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Progress indicators (4 dots: second active)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _buildIndicator(isActive: false),
                                const SizedBox(width: 6),
                                _buildIndicator(isActive: true),
                                const SizedBox(width: 6),
                                _buildIndicator(isActive: false),
                                const SizedBox(width: 6),
                                _buildIndicator(isActive: false),
                              ],
                            ),
                            const Spacer(),

                            // Title
                            Text(
                              "Your Circle of Trust",
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
                              "Keep your loved ones informed. Your selected contacts receive instant updates when you're on the move or in need of assistance.",
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
                                onPressed: () {
                                  context.push(AppRoutes.onboardingStep3);
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
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNodeAvatar(String url, {required double size}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        border: Border.all(color: AppTheme.primaryContainer, width: 2.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
        image: DecorationImage(
          image: NetworkImage(url),
          fit: BoxFit.cover,
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
        color: isActive ? AppTheme.primary : AppTheme.outlineVariant,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

// Custom Painter to draw SVG Connecting Line network nodes beautifully
class NetworkLinesPainter extends CustomPainter {
  final double progress;
  NetworkLinesPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFF06292).withOpacity(0.6)
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    // Define coordinates based on stack sizing
    Offset topNode = Offset(size.width * 0.5, size.height * 0.22);
    Offset rightNode = Offset(size.width * 0.72, size.height * 0.72);
    Offset leftNode = Offset(size.width * 0.28, size.height * 0.72);

    // Draw background concentric circle
    canvas.drawCircle(Offset(size.width * 0.5, size.height * 0.5), size.width * 0.35, Paint()
      ..color = const Color(0xFFF06292).withOpacity(0.2)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke);

    // Connecting lines
    _drawFlowLine(canvas, topNode, rightNode, paint);
    _drawFlowLine(canvas, topNode, leftNode, paint);
    _drawFlowLine(canvas, rightNode, leftNode, paint);
  }

  void _drawFlowLine(Canvas canvas, Offset p1, Offset p2, Paint paint) {
    // 1. Calculate vector mathematics for spacing segments
    double dx = p2.dx - p1.dx;
    double dy = p2.dy - p1.dy;
    double distance = math.sqrt(dx * dx + dy * dy);
    double angle = math.atan2(dy, dx);

    const double dashLength = 8.0;
    const double spaceLength = 8.0;
    const double totalLength = dashLength + spaceLength; // 16.0

    // 2. Dash offset flows based on controller progress
    double offset = progress * totalLength;

    // 3. Draw segmented dashes sequentially
    for (double i = -offset; i < distance; i += totalLength) {
      double startDist = i;
      double endDist = i + dashLength;

      // Clamp segments to lie precisely inside [0, distance]
      if (endDist < 0.0) continue;
      if (startDist > distance) break;

      double clampedStart = math.max(0.0, startDist);
      double clampedEnd = math.min(distance, endDist);

      double x1 = p1.dx + math.cos(angle) * clampedStart;
      double y1 = p1.dy + math.sin(angle) * clampedStart;
      double x2 = p1.dx + math.cos(angle) * clampedEnd;
      double y2 = p1.dy + math.sin(angle) * clampedEnd;

      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
