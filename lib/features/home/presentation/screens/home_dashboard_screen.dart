//import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_theme.dart';

class HomeDashboardScreen extends StatefulWidget {
  const HomeDashboardScreen({Key? key}) : super(key: key);

  @override
  State<HomeDashboardScreen> createState() => _HomeDashboardScreenState();
}

class _HomeDashboardScreenState extends State<HomeDashboardScreen> with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _pingController;

  @override
  void initState() {
    super.initState();
    // Pulse animation controller for the inner ring (2s duration, repeats)
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    // Ping animation controller for the outer ring (3s duration, repeats)
    _pingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _pingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background soft pink canvas
          Container(
            color: AppTheme.background,
          ),

          // Decorative top glowing circular ambient highlights
          Positioned(
            top: -100,
            left: -100,
            width: 400,
            height: 400,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.primaryContainer.withOpacity(0.08),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 100.0, sigmaY: 100.0),
                child: Container(color: Colors.transparent),
              ),
            ),
          ),

          // Main Scrollable Body
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 110.0), // Extra bottom padding for floating nav bar
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // TopAppBar Row matching HTML exactly
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Avatar
                      GestureDetector(
                        onTap: () => context.push(AppRoutes.profile),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppTheme.primaryContainer.withOpacity(0.2),
                            border: Border.all(
                              color: AppTheme.primary.withOpacity(0.2),
                              width: 1.0,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 4,
                                offset: const Offset(0, 1),
                              )
                            ],
                          ),
                          child: ClipOval(
                            child: Image.network(
                              "https://lh3.googleusercontent.com/aida/ADBb0uheO2xz_B69a8socQuO_Qv_rqplousYU4BIcbgIWSHeM1imJHuX2ng-SMp84jevenTjgoqf32-BfKGp8gMntpPtPbO0Lbl2AUbiCHNjRmA9CTDC5kCsn7z6IHlPg5ou_ALvRJjnfdL40ZdyFHtReryQ0CR9wi3rk9MfdPKnXx6185mV-x1i4WPfANmVKV5Z_QChksYf6lIy2vkzDpfbecyxw52TQnzTkSlTPEVqyk_nAXUjnag5eI0orN4",
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => const Icon(
                                Icons.person_outline,
                                color: AppTheme.primary,
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Settings button
                      SizedBox(
                        width: 40,
                        height: 40,
                        child: IconButton(
                          icon: const Icon(Icons.settings_outlined, color: AppTheme.primary, size: 24),
                          onPressed: () => context.push(AppRoutes.settings),
                          style: IconButton.styleFrom(
                            backgroundColor: AppTheme.primaryContainer.withOpacity(0.2),
                            padding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24.0),

                  // Dashboard Welcome Card
                  Container(
                    decoration: BoxDecoration(
                      color: AppTheme.surface.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(16.0),
                      border: Border.all(color: Colors.white.withOpacity(0.4), width: 1.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 20.0,
                          offset: const Offset(0, 4),
                        )
                      ],
                    ),
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Good morning, Sarah.",
                          style: GoogleFonts.montserrat(
                            fontSize: 28,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          "Your personal safety network is active and monitoring.",
                          style: GoogleFonts.beVietnamPro(
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                            color: AppTheme.textSecondary,
                            height: 1.55,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32.0),

                  // Central SOS Action Area
                  Column(
                    children: [
                      Center(
                        child: SizedBox(
                          width: 280,
                          height: 280,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Ping Ring (Outer expanding ring)
                              AnimatedBuilder(
                                animation: _pingController,
                                builder: (context, child) {
                                  return Transform.scale(
                                    scale: 1.0 + (_pingController.value * 0.4),
                                    child: Opacity(
                                      opacity: 1.0 - _pingController.value,
                                      child: Container(
                                        width: 200,
                                        height: 200,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.red.withOpacity(0.2),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),

                              // Pulse Ring (Inner glowing ring)
                              AnimatedBuilder(
                                animation: _pulseController,
                                builder: (context, child) {
                                  return Transform.scale(
                                    scale: 1.0 + (_pulseController.value * 0.05),
                                    child: Container(
                                      width: 240,
                                      height: 240,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.red.withOpacity(0.3),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.red.withOpacity(0.3 * _pulseController.value),
                                            blurRadius: 40,
                                            spreadRadius: 5,
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),

                              // Main SOS Action Button
                              GestureDetector(
                                onTap: () => context.push(AppRoutes.sosActive),
                                child: Container(
                                  width: 200,
                                  height: 200,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: const LinearGradient(
                                      colors: [Color(0xFFDC2626), Color(0xFFB91C1C)],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    border: Border.all(color: Colors.white.withOpacity(0.2), width: 4.0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFFDC2626).withOpacity(0.8),
                                        blurRadius: 40,
                                        spreadRadius: -10,
                                        offset: const Offset(0, 10),
                                      )
                                    ],
                                  ),
                                  child: Center(
                                    child: Text(
                                      "SOS",
                                      style: GoogleFonts.montserrat(
                                        color: Colors.white,
                                        fontSize: 24,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 4.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 28.0),

                      // SOS Info banner
                      Container(
                        decoration: BoxDecoration(
                          color: AppTheme.surface.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(9999),
                          border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 8.0,
                              offset: const Offset(0, 1),
                            )
                          ],
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                        child: Text(
                          "PRESS & HOLD FOR 3 SECONDS",
                          style: GoogleFonts.beVietnamPro(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textPrimary,
                            letterSpacing: 0.7,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 36.0),

                  // Bento Grid: Wearable Connected Card
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(16.0),
                      border: Border.all(color: Colors.white.withOpacity(0.6), width: 1.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 30,
                          spreadRadius: -5,
                          offset: const Offset(0, 8),
                        )
                      ],
                    ),
                    padding: const EdgeInsets.all(24.0),
                    child: Row(
                      children: [
                        // Watch icon with glowing active emerald indicator dot
                        Stack(
                          children: [
                            Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppTheme.primaryContainer.withOpacity(0.2),
                              ),
                              child: const Icon(
                                Icons.watch_outlined,
                                color: AppTheme.primary,
                                size: 28,
                              ),
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: const Color(0xFF34D399),
                                  border: Border.all(color: Colors.white, width: 2),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 16.0),

                        // Wearable Info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Wearable Connected",
                                style: GoogleFonts.beVietnamPro(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 4.0),
                              Text(
                                "Apple Watch Series 8",
                                style: GoogleFonts.beVietnamPro(
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Heart Rate
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                AnimatedBuilder(
                                  animation: _pulseController,
                                  builder: (context, child) {
                                    return Transform.scale(
                                      scale: 1.0 + (_pulseController.value * 0.15),
                                      child: const Icon(
                                        Icons.favorite,
                                        color: AppTheme.primary,
                                        size: 20,
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  "72",
                                  style: GoogleFonts.montserrat(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              "BPM",
                              style: GoogleFonts.beVietnamPro(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: AppTheme.textSecondary,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Custom Center-Floating Bottom Navigation Bar (Matching HTML Specifications exactly)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 85,
              decoration: BoxDecoration(
                color: AppTheme.surface.withOpacity(0.9),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16.0),
                  topRight: Radius.circular(16.0),
                ),
                border: Border(
                  top: BorderSide(color: Colors.white.withOpacity(0.4), width: 1.0),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 40.0,
                    offset: const Offset(0, -10),
                  )
                ],
              ),
              child: SafeArea(
                top: false,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildNavItem(context, Icons.health_and_safety_outlined, "Home", true, () {}),
                    _buildNavItem(context, Icons.map_outlined, "Map", false, () {
                      context.push(AppRoutes.liveTracking);
                    }),

                    // Elevated Center SOS button overlapping top boundary with direct SOS text labels
                    Transform.translate(
                      offset: const Offset(0, -18),
                      child: GestureDetector(
                        onTap: () => context.push(AppRoutes.sosActive),
                        child: Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [Color(0xFFDC2626), Color(0xFFB91C1C)],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                            border: Border.all(color: Colors.white.withOpacity(0.2), width: 1.0),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFDC2626).withOpacity(0.6),
                                blurRadius: 20.0,
                                offset: const Offset(0, 8),
                              )
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.emergency,
                                color: Colors.white,
                                size: 28,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                "SOS",
                                style: GoogleFonts.beVietnamPro(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    _buildNavItem(context, Icons.group_outlined, "Contacts", false, () {
                      context.push(AppRoutes.contactsCircle);
                    }),
                    _buildNavItem(context, Icons.auto_awesome_outlined, "AI Chat", false, () {
                      context.push(AppRoutes.aiCompanion);
                    }),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, IconData icon, String label, bool isActive, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? AppTheme.primary : AppTheme.textSecondary.withOpacity(0.8),
              size: 24,
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: GoogleFonts.beVietnamPro(
                fontSize: 12,
                fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                color: isActive ? AppTheme.primary : AppTheme.textSecondary.withOpacity(0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
