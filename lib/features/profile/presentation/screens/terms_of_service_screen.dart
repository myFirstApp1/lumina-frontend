import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({Key? key}) : super(key: key);

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
                  constraints: const BoxConstraints(maxWidth: 896), // max-w-4xl
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Header Section
                      const SizedBox(height: 16),
                      Text(
                        "Terms of Service",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Center(
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F3F3), // surface-container-low
                            borderRadius: BorderRadius.circular(20.0),
                            border: Border.all(color: Colors.white, width: 1.0),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                          child: Text(
                            "Last Updated: October 24, 2023",
                            style: GoogleFonts.beVietnamPro(
                              fontSize: 16,
                              color: AppTheme.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 32),

                      // Introduction Card
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.0),
                          border: Border.all(color: Colors.white.withOpacity(0.5), width: 1.0),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primaryContainer.withOpacity(0.08),
                              blurRadius: 30,
                              offset: const Offset(0, 8),
                            )
                          ],
                        ),
                        padding: const EdgeInsets.all(24.0),
                        child: Text(
                          "Welcome to Lumina Guardian. We provide a digital guardianship platform designed to enhance your personal safety and peace of mind. By accessing or using our application, you agree to be bound by these terms. We encourage you to read them carefully as they form a legal agreement between you and Lumina Guardian.",
                          style: GoogleFonts.beVietnamPro(
                            fontSize: 18,
                            color: AppTheme.textPrimary,
                            height: 1.6,
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Terms Sections
                      _buildSectionCard(
                        icon: Icons.handshake,
                        iconColor: AppTheme.primary,
                        bgColor: AppTheme.primaryContainer.withOpacity(0.1),
                        title: "Acceptance of Terms",
                        content: "By creating an account, downloading our application, or using our services, you signify your acceptance of these Terms. If you do not agree to these terms, please do not use Lumina Guardian. These terms may be updated periodically, and continued use constitutes acceptance of those changes.",
                      ),
                      const SizedBox(height: 16),

                      _buildSectionCard(
                        icon: Icons.how_to_reg,
                        iconColor: AppTheme.primary,
                        bgColor: AppTheme.primaryContainer.withOpacity(0.1),
                        title: "User Eligibility",
                        content: "You must be at least 18 years old to create an account. By using the app, you represent and warrant that you meet this age requirement. If you are under 18, you may only use the service with the involvement and consent of a parent or legal guardian who agrees to be bound by these terms.",
                      ),
                      const SizedBox(height: 16),

                      _buildProhibitedConductCard(),
                      const SizedBox(height: 16),

                      _buildSectionCard(
                        icon: Icons.shield,
                        iconColor: AppTheme.primary,
                        bgColor: AppTheme.primaryContainer.withOpacity(0.1),
                        title: "Limitation of Liability",
                        content: "While Lumina Guardian is designed to enhance safety, it is a supplementary tool and not a replacement for emergency services (e.g., 911). We do not guarantee that the service will prevent harm. To the maximum extent permitted by law, Lumina Guardian shall not be liable for any indirect, incidental, or consequential damages arising out of your use of the service.",
                      ),
                      const SizedBox(height: 16),

                      _buildSectionCard(
                        icon: Icons.credit_card,
                        iconColor: AppTheme.primary,
                        bgColor: AppTheme.primaryContainer.withOpacity(0.1),
                        title: "Subscription & Payments",
                        content: "Certain premium features of Lumina Guardian require a subscription. By choosing a paid plan, you agree to our pricing and payment terms. Subscriptions auto-renew unless canceled at least 24 hours before the end of the current period. Refunds are handled in accordance with our refund policy and the policies of the respective app stores.",
                      ),

                      const SizedBox(height: 32),

                      // Footer Card
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F3F3), // surface-container-low
                          borderRadius: BorderRadius.circular(16.0),
                          border: Border.all(color: AppTheme.outlineVariant.withOpacity(0.3), width: 1.0),
                        ),
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          children: [
                            Text(
                              "Have Questions?",
                              style: GoogleFonts.montserrat(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "If you need clarification on any of our terms or have specific legal inquiries, our team is here to help.",
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
                              child: ElevatedButton.icon(
                                onPressed: () {},
                                icon: const Icon(Icons.mail, color: Colors.white, size: 18),
                                label: Text(
                                  "Contact Legal Team",
                                  style: GoogleFonts.beVietnamPro(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  foregroundColor: Colors.white,
                                  shadowColor: Colors.transparent,
                                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
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
                      // Notifications button
                      IconButton(
                        icon: const Icon(Icons.notifications, color: AppTheme.primary),
                        onPressed: () {},
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

  Widget _buildSectionCard({
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required String title,
    required String content,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: Colors.white.withOpacity(0.4), width: 1.0),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryContainer.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          )
        ],
      ),
      padding: const EdgeInsets.all(24.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: bgColor,
            ),
            child: Icon(icon, color: iconColor, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.montserrat(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
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
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProhibitedConductCard() {
    final List<String> rules = [
      "Using the service for any illegal or unauthorized purpose.",
      "Attempting to interfere with or compromise the system integrity or security.",
      "Harassing, abusing, or harming another person through the platform.",
      "Submitting false safety alerts or misusing the SOS functionality."
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: Colors.white.withOpacity(0.4), width: 1.0),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryContainer.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          )
        ],
      ),
      padding: const EdgeInsets.all(24.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.error.withOpacity(0.15),
            ),
            child: const Icon(Icons.warning, color: AppTheme.error, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Prohibited Conduct",
                  style: GoogleFonts.montserrat(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "To maintain a safe community, you agree not to engage in any of the following:",
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 16,
                    color: AppTheme.textSecondary,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 12),
                Column(
                  children: rules.map((rule) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 8.0),
                            child: Icon(Icons.circle, size: 6, color: AppTheme.textSecondary),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              rule,
                              style: GoogleFonts.beVietnamPro(
                                fontSize: 16,
                                color: AppTheme.textSecondary,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
