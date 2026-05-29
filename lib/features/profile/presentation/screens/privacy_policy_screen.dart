import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_theme.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background soft canvas
          Container(
            color: AppTheme.background,
          ),

          // Main Scrollable Canvas
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20.0, 72.0, 20.0, 48.0),
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 1140),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24.0),
                    border: Border.all(color: Colors.white.withOpacity(0.2), width: 1.0),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryContainer.withOpacity(0.08),
                        blurRadius: 30,
                        offset: const Offset(0, 8),
                      )
                    ],
                  ),
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Header metadata & title
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "LAST UPDATED: OCTOBER 26, 2023",
                            style: GoogleFonts.beVietnamPro(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textSecondary,
                              letterSpacing: 1.5,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "Privacy Policy",
                            style: GoogleFonts.montserrat(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryContainer,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "At Lumina Guardian, we believe that your safety should never compromise your privacy. This document outlines our unwavering commitment to protecting your personal data while providing you with a premium, reliable guardianship experience. We design our systems with a privacy-first approach, ensuring that you are always in control.",
                            style: GoogleFonts.beVietnamPro(
                              fontSize: 18,
                              color: AppTheme.textSecondary,
                              height: 1.6,
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 24),
                      const Divider(color: AppTheme.outlineVariant, height: 1),
                      const SizedBox(height: 24),

                      // Content Sections
                      _buildSection(
                        icon: Icons.storage, // representing database
                        title: "Data Collection",
                        content: "We only collect the information absolutely necessary to provide our core safety features. This includes account details (name, email), emergency contact information, and real-time location data—but only when you actively initiate a tracking session or an SOS alert. We do not passively track your location in the background without your explicit consent.",
                      ),
                      const SizedBox(height: 24),

                      _buildSection(
                        icon: Icons.query_stats,
                        title: "How We Use Your Data",
                        content: "Your data is exclusively used to facilitate your safety. We use it to notify your trusted contacts during an emergency, to provide accurate location routing for emergency services if needed, and to maintain your account. We categorically do not sell your personal data, location history, or usage patterns to third-party advertisers or data brokers.",
                      ),
                      const SizedBox(height: 24),

                      _buildSection(
                        icon: Icons.security,
                        title: "Data Security",
                        content: "We employ state-of-the-art encryption protocols (AES-256) for data both at rest and in transit. Our infrastructure is housed in secure, compliant data centers. We regularly undergo independent security audits to ensure our defenses remain robust against emerging threats, keeping your sensitive information shielded.",
                      ),
                      const SizedBox(height: 24),

                      _buildSection(
                        icon: Icons.gavel,
                        title: "Your Rights",
                        content: "You retain full ownership of your data. You have the right to access, modify, or permanently delete your personal information at any time directly through the app settings. If you choose to close your account, all associated data is wiped from our active servers within 30 days, leaving no trace behind.",
                      ),
                      
                      const SizedBox(height: 32),
                      const Divider(color: AppTheme.outlineVariant, height: 1),
                      const SizedBox(height: 32),

                      // Callout Card Footer
                      Container(
                        decoration: BoxDecoration(
                          color: AppTheme.primaryContainer.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          children: [
                            const Icon(
                              Icons.support_agent,
                              color: AppTheme.primary,
                              size: 40,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              "Have Questions?",
                              style: GoogleFonts.montserrat(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Our dedicated privacy team is here to help clarify any concerns you might have about how we handle your data.",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.beVietnamPro(
                                fontSize: 16,
                                color: AppTheme.textSecondary,
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Container(
                              height: 48,
                              decoration: BoxDecoration(
                                gradient: AppTheme.primaryGradient,
                                borderRadius: BorderRadius.circular(24.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppTheme.primary.withOpacity(0.25),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  )
                                ],
                              ),
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  foregroundColor: Colors.white,
                                  shadowColor: Colors.transparent,
                                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                                ),
                                child: Text(
                                  "Contact Privacy Team",
                                  style: GoogleFonts.beVietnamPro(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Custom TopAppBar matching spec exactly
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  height: 64,
                  decoration: BoxDecoration(
                    color: AppTheme.surface.withOpacity(0.7),
                    border: Border(
                      bottom: BorderSide(
                        color: AppTheme.outlineVariant.withOpacity(0.3),
                        width: 1.0,
                      ),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Back button
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: AppTheme.primary),
                        onPressed: () => context.pop(),
                      ),
                      // Title
                      Text(
                        "Lumina Guardian",
                        style: GoogleFonts.montserrat(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primary,
                        ),
                      ),
                      // Profile button
                      IconButton(
                        icon: const Icon(Icons.person, color: AppTheme.primary),
                        onPressed: () => context.push(AppRoutes.profile),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: AppTheme.primaryContainer,
              size: 26,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.montserrat(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: GoogleFonts.beVietnamPro(
            fontSize: 16,
            color: AppTheme.textSecondary,
            height: 1.6,
          ),
        ),
      ],
    );
  }
}
