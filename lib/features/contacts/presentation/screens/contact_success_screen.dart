import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_theme.dart';

class ContactSuccessScreen extends StatefulWidget {
  final Map<String, dynamic>? contactData;

  const ContactSuccessScreen({Key? key, this.contactData}) : super(key: key);

  @override
  State<ContactSuccessScreen> createState() => _ContactSuccessScreenState();
}

class _ContactSuccessScreenState extends State<ContactSuccessScreen> with SingleTickerProviderStateMixin {
  late AnimationController _glowController;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Settle dynamic arguments or fall back to Alex Chen
    final String name = widget.contactData?['name'] ?? "Alex Chen";
    final String relationship = widget.contactData?['relationship'] ?? "Partner";
    final String avatarUrl = widget.contactData?['avatarUrl'] ?? "https://lh3.googleusercontent.com/aida-public/AB6AXuCTDylmOjPsGe4hVTugPTdT1pnyuqwH1aQ9EFmzm2Fq4Yrsif97vyw1J2pOzea8lSMDhAlleljutYISU52PTiAWZcytV_6EmT_eORS2F3r2Xvdw1cbqtrCQuuJu0cvaTLRq3TP3F7cSSAG3oKynAkFqBLIKfbtVtORDJMAS4FJGJrAfuQbLxvXqmZJJ7yffJnFPg1BVqoSzOyZCy23FfM_StMQLelin7ntCzuXFzCStsYhAYufQgh4e5hh9kq5daQJ1VLTZ0yU8bzI";

    return Scaffold(
      body: Stack(
        children: [
          // Background soft canvas
          Container(
            color: AppTheme.background,
          ),

          // Ambient Background Highlights
          Positioned(
            top: -100,
            left: -100,
            width: 400,
            height: 400,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.primaryContainer.withOpacity(0.12),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 120.0, sigmaY: 120.0),
                child: Container(color: Colors.transparent),
              ),
            ),
          ),

          // Main vertical container
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Verified Success Emblem
                    AnimatedBuilder(
                      animation: _glowController,
                      builder: (context, child) {
                        return Container(
                          width: 96,
                          height: 96,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [Color(0xFFF06292), Color(0xFFAB2C5D)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.primary.withOpacity(0.3 * _glowController.value),
                                blurRadius: 24.0,
                                spreadRadius: 4.0 * _glowController.value,
                              )
                            ],
                          ),
                          child: const Icon(
                            Icons.verified_user,
                            color: Colors.white,
                            size: 48,
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 32),

                    // Titles
                    Text(
                      "Contact Added!",
                      style: GoogleFonts.montserrat(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "$name is now part of your safety circle.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: AppTheme.textSecondary,
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Summary Glass Card
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(24.0),
                        border: Border.all(color: Colors.white, width: 1.0),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primary.withOpacity(0.06),
                            blurRadius: 30,
                            offset: const Offset(0, 8),
                          )
                        ],
                      ),
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          // Header Profile Info inside card
                          Row(
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppTheme.outlineVariant.withOpacity(0.3),
                                  image: DecorationImage(
                                    image: NetworkImage(avatarUrl),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      name,
                                      style: GoogleFonts.montserrat(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.textPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      relationship,
                                      style: GoogleFonts.beVietnamPro(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: AppTheme.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryContainer.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.shield_outlined, color: AppTheme.primary, size: 14),
                                    const SizedBox(width: 4),
                                    Text(
                                      "Active",
                                      style: GoogleFonts.beVietnamPro(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          const Divider(color: AppTheme.outlineVariant),
                          const SizedBox(height: 16),

                          // Location sharing row
                          _buildDetailRow(
                            icon: Icons.location_on,
                            title: "Location Sharing",
                            subtitle: "Continuous update active",
                          ),
                          const SizedBox(height: 16),

                          // Emergency alert row
                          _buildDetailRow(
                            icon: Icons.notifications_active,
                            title: "Emergency Alerts",
                            subtitle: "Will receive immediate SOS",
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 48),

                    // Actions
                    Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: () => context.go(AppRoutes.contactsCircle),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primary,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28.0),
                              ),
                              elevation: 4,
                            ),
                            child: Text(
                              "Done",
                              style: GoogleFonts.beVietnamPro(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: TextButton(
                            onPressed: () => context.pushReplacement(AppRoutes.addContact),
                            style: TextButton.styleFrom(
                              foregroundColor: AppTheme.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28.0),
                              ),
                            ),
                            child: Text(
                              "Add Another Contact",
                              style: GoogleFonts.beVietnamPro(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppTheme.surface,
          ),
          child: Icon(icon, color: AppTheme.primary, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.beVietnamPro(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: GoogleFonts.beVietnamPro(
                  fontSize: 12,
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
