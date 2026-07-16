import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _biometricAuth = true;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          context.go(AppRoutes.login);
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            // Background soft canvas
            Container(color: AppTheme.background),

            // Main Scrollable Content
            SafeArea(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20.0, 72.0, 20.0, 48.0),
                children: [
                  // Account Security Section
                  _buildSectionHeader("Account Security"),
                  const SizedBox(height: 8),
                  _buildSectionCard([
                    _buildInteractiveRow(
                      icon: Icons.lock_outline,
                      title: "Change Password",
                      subtitle: "Last updated 3 months ago",
                      onTap: () {},
                    ),
                    const Divider(height: 1, color: AppTheme.outlineVariant),
                    _buildToggleRow(
                      icon: Icons.fingerprint,
                      title: "Biometric Authentication",
                      subtitle: "Face ID enabled",
                      value: _biometricAuth,
                      onChanged: (val) {
                        setState(() {
                          _biometricAuth = val;
                        });
                      },
                    ),
                  ]),

                  const SizedBox(height: 24),

                  // Safety Preferences Section
                  _buildSectionHeader("Safety Preferences"),
                  const SizedBox(height: 8),
                  _buildSectionCard([
                    _buildInteractiveRow(
                      icon: Icons.timer_outlined,
                      title: "SOS Countdown Timer",
                      subtitle: "Currently set to 5 seconds",
                      onTap: () {},
                    ),
                    const Divider(height: 1, color: AppTheme.outlineVariant),
                    _buildInteractiveRow(
                      icon: Icons.sms_outlined,
                      title: "Emergency Message",
                      subtitle: "Edit default SOS text",
                      onTap: () {},
                    ),
                    const Divider(height: 1, color: AppTheme.outlineVariant),
                    _buildInteractiveRow(
                      icon: Icons.do_not_disturb_on_outlined,
                      title: "Quiet Hours",
                      subtitle: "Suppress non-critical alerts",
                      onTap: () {},
                    ),
                  ]),

                  const SizedBox(height: 24),

                  // Connected Devices Section
                  _buildSectionHeader("Connected Devices"),
                  const SizedBox(height: 8),
                  _buildSectionCard([
                    _buildWearableDeviceRow(
                      icon: Icons.watch_outlined,
                      title: "Apple Watch",
                      status: "Connected & Synced",
                      onTap: () => context.push(AppRoutes.wearableSync),
                    ),
                  ]),

                  const SizedBox(height: 24),

                  // Legal & Support Section
                  _buildSectionHeader("Legal & Support"),
                  const SizedBox(height: 8),
                  _buildSectionCard([
                    _buildInteractiveRow(
                      icon: Icons.help_outline,
                      title: "Help Center",
                      onTap: () => context.push(AppRoutes.helpCenter),
                    ),
                    const Divider(height: 1, color: AppTheme.outlineVariant),
                    _buildInteractiveRow(
                      icon: Icons.policy_outlined,
                      title: "Privacy Policy",
                      onTap: () => context.push(AppRoutes.privacyPolicy),
                    ),
                    const Divider(height: 1, color: AppTheme.outlineVariant),
                    _buildInteractiveRow(
                      icon: Icons.description_outlined,
                      title: "Terms of Service",
                      onTap: () => context.push(AppRoutes.termsOfService),
                    ),
                  ]),

                  const SizedBox(height: 32),

                  // Log Out Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        context.read<AuthCubit>().logout();

                      },
                      icon: const Icon(
                        Icons.logout,
                        color: AppTheme.error,
                        size: 20,
                      ),
                      label: Text(
                        "Log Out",
                        style: GoogleFonts.beVietnamPro(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.error,
                        backgroundColor: Colors.white,
                        side: BorderSide(
                          color: AppTheme.error.withOpacity(0.2),
                          width: 1.0,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Custom TopAppBar matching specs exactly
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
                          icon: const Icon(
                            Icons.arrow_back,
                            color: AppTheme.textSecondary,
                          ),
                          onPressed: () => context.pop(),
                        ),
                        // Title
                        Text(
                          "Settings",
                          style: GoogleFonts.montserrat(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primary,
                          ),
                        ),
                        // Balancing hidden trailing element
                        const SizedBox(width: 48),
                      ],
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

  Widget _buildSectionHeader(String label) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
      child: Text(
        label.toUpperCase(),
        style: GoogleFonts.beVietnamPro(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: AppTheme.primary,
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  Widget _buildSectionCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(24.0),
        border: Border.all(color: Colors.white.withOpacity(0.5), width: 1.0),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryContainer.withOpacity(0.08),
            blurRadius: 24,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(children: children),
    );
  }

  Widget _buildInteractiveRow({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.primaryContainer.withOpacity(0.2),
                ),
                child: Icon(icon, color: AppTheme.primary, size: 20),
              ),
              const SizedBox(width: 16),
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
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: GoogleFonts.beVietnamPro(
                          fontSize: 12,
                          color: AppTheme.textSecondary.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: AppTheme.textSecondary,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToggleRow({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.primaryContainer.withOpacity(0.2),
            ),
            child: Icon(icon, color: AppTheme.primary, size: 20),
          ),
          const SizedBox(width: 16),
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
                    color: AppTheme.textSecondary.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            activeColor: AppTheme.primary,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildWearableDeviceRow({
    required IconData icon,
    required String title,
    required String status,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.outlineVariant.withOpacity(0.3),
                ),
                child: Icon(icon, color: AppTheme.textPrimary, size: 20),
              ),
              const SizedBox(width: 16),
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
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          status,
                          style: GoogleFonts.beVietnamPro(
                            fontSize: 12,
                            color: AppTheme.textSecondary.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.settings_outlined,
                color: AppTheme.textSecondary,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
