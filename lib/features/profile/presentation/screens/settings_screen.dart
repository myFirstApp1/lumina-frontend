
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

  static const Color _pink = Color(0xFFD95791);
  static const Color _lavender = Color(0xFFAA91D8);
  static const Color _dark = Color(0xFF393044);
  static const Color _muted = Color(0xFF898193);

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          context.go(AppRoutes.login);
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFFFF7FA),
        body: Stack(
          children: [
            // Soft gradient background
            const Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFFFE5EF),
                      Color(0xFFFFF5F6),
                      Color(0xFFF0EAFF),
                      Color(0xFFFFF9F3),
                    ],
                  ),
                ),
              ),
            ),

            // Decorative background circles
            Positioned(
              top: 100,
              right: -90,
              child: _glowCircle(210, const Color(0xFFFFC6DD)),
            ),
            Positioned(
              top: 430,
              left: -100,
              child: _glowCircle(220, const Color(0xFFDCCFFF)),
            ),
            Positioned(
              bottom: 30,
              right: -80,
              child: _glowCircle(180, const Color(0xFFFFD9E9)),
            ),

            SafeArea(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 40),
                children: [
                  _buildHeader(),

                  const SizedBox(height: 24),

                  _buildWelcomeCard(),

                  const SizedBox(height: 28),

                  _buildSectionHeader(
                    'ACCOUNT SECURITY',
                    Icons.shield_outlined,
                  ),
                  const SizedBox(height: 12),

                  _buildGlassCard([
                    _buildSettingsRow(
                      icon: Icons.lock_outline_rounded,
                      title: 'Change Password',
                      subtitle: 'Update your account password',
                      onTap: () {},
                    ),
                    _buildDivider(),
                    _buildToggleRow(
                      icon: Icons.fingerprint_rounded,
                      title: 'Biometric Authentication',
                      subtitle: 'Use biometrics for secure access',
                      value: _biometricAuth,
                      onChanged: (value) {
                        setState(() {
                          _biometricAuth = value;
                        });
                      },
                    ),
                  ]),

                  const SizedBox(height: 26),

                  _buildSectionHeader(
                    'SAFETY PREFERENCES',
                    Icons.health_and_safety_outlined,
                  ),
                  const SizedBox(height: 12),

                  _buildGlassCard([
                    _buildSettingsRow(
                      icon: Icons.timer_outlined,
                      title: 'SOS Countdown Timer',
                      subtitle: 'Currently set to 5 seconds',
                      onTap: () {},
                    ),
                    _buildDivider(),
                    _buildSettingsRow(
                      icon: Icons.message_outlined,
                      title: 'Emergency Message',
                      subtitle: 'Edit your default SOS message',
                      onTap: () {},
                    ),
                    _buildDivider(),
                    _buildSettingsRow(
                      icon: Icons.do_not_disturb_on_outlined,
                      title: 'Quiet Hours',
                      subtitle: 'Manage non-critical alerts',
                      onTap: () {},
                    ),
                  ]),

                  const SizedBox(height: 26),

                  _buildSectionHeader(
                    'CONNECTED DEVICES',
                    Icons.devices_outlined,
                  ),
                  const SizedBox(height: 12),

                  _buildGlassCard([
                    _buildDeviceRow(
                      icon: Icons.watch_outlined,
                      title: 'Apple Watch',
                      status: 'Connected & Synced',
                      onTap: () {
                        context.push(AppRoutes.wearableSync);
                      },
                    ),
                  ]),

                  const SizedBox(height: 26),

                  _buildSectionHeader(
                    'LEGAL & SUPPORT',
                    Icons.support_agent_outlined,
                  ),
                  const SizedBox(height: 12),

                  _buildGlassCard([
                    _buildSettingsRow(
                      icon: Icons.help_outline_rounded,
                      title: 'Help Center',
                      subtitle: 'Get help and support',
                      onTap: () {
                        context.push(AppRoutes.helpCenter);
                      },
                    ),
                    _buildDivider(),
                    _buildSettingsRow(
                      icon: Icons.privacy_tip_outlined,
                      title: 'Privacy Policy',
                      onTap: () {
                        context.push(AppRoutes.privacyPolicy);
                      },
                    ),
                    _buildDivider(),
                    _buildSettingsRow(
                      icon: Icons.description_outlined,
                      title: 'Terms of Service',
                      onTap: () {
                        context.push(AppRoutes.termsOfService);
                      },
                    ),
                  ]),

                  const SizedBox(height: 32),

                  _buildLogoutButton(),

                  const SizedBox(height: 24),

                  Center(
                    child: Text(
                      'LUMINA GUARDIAN',
                      style: GoogleFonts.montserrat(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2,
                        color: _muted,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Center(
                    child: Text(
                      'Your safety, our priority.',
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 11,
                        color: _muted,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _glowCircle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withOpacity(0.35),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        _glassIconButton(
          icon: Icons.arrow_back_rounded,
          onTap: () {
            if (context.canPop()) {
              context.pop();
            }
          },
        ),
        const Expanded(
          child: Center(
            child: Text(
              'Settings',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.w800,
                color: _dark,
                letterSpacing: -0.5,
              ),
            ),
          ),
        ),
        const SizedBox(width: 46),
      ],
    );
  }

  Widget _glassIconButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Material(
          color: Colors.white.withOpacity(0.55),
          child: InkWell(
            onTap: onTap,
            child: Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
              child: const Icon(
                Icons.arrow_back_rounded,
                color: _dark,
                size: 21,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(26),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.82),
                Colors.white.withOpacity(0.48),
              ],
            ),
            borderRadius: BorderRadius.circular(26),
            border: Border.all(
              color: Colors.white.withOpacity(0.9),
            ),
            boxShadow: [
              BoxShadow(
                color: _pink.withOpacity(0.08),
                blurRadius: 25,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [_pink, _lavender],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Icon(
                  Icons.settings_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your Settings',
                      style: GoogleFonts.montserrat(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: _dark,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Manage your account and safety preferences.',
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 12,
                        height: 1.5,
                        color: _muted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(left: 5),
      child: Row(
        children: [
          Icon(icon, size: 17, color: _pink),
          const SizedBox(width: 9),
          Text(
            title,
            style: GoogleFonts.montserrat(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.15,
              color: _dark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassCard(List<Widget> children) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(23),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.67),
            borderRadius: BorderRadius.circular(23),
            border: Border.all(
              color: Colors.white.withOpacity(0.9),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: _lavender.withOpacity(0.07),
                blurRadius: 20,
                offset: const Offset(0, 7),
              ),
            ],
          ),
          child: Column(children: children),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.only(left: 68),
      child: Divider(
        height: 1,
        thickness: 0.8,
        color: _lavender.withOpacity(0.16),
      ),
    );
  }

  Widget _buildSettingsRow({
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
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 15,
          ),
          child: Row(
            children: [
              _buildIconContainer(icon),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: _dark,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: GoogleFonts.beVietnamPro(
                          fontSize: 11,
                          color: _muted,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: _muted,
                size: 21,
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
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      child: Row(
        children: [
          _buildIconContainer(icon),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: _dark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 11,
                    color: _muted,
                  ),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            activeColor: Colors.white,
            activeTrackColor: _pink,
            inactiveTrackColor: Colors.white,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildIconContainer(IconData icon) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: LinearGradient(
          colors: [
            _pink.withOpacity(0.13),
            _lavender.withOpacity(0.16),
          ],
        ),
      ),
      child: Icon(
        icon,
        color: _pink,
        size: 20,
      ),
    );
  }

  Widget _buildDeviceRow({
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
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              _buildIconContainer(icon),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: _dark,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Container(
                          width: 7,
                          height: 7,
                          decoration: const BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 7),
                        Text(
                          status,
                          style: GoogleFonts.beVietnamPro(
                            fontSize: 11,
                            color: _muted,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.settings_outlined,
                color: _muted,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: OutlinedButton.icon(
        onPressed: () {
          context.read<AuthCubit>().logout();
        },
        icon: const Icon(
          Icons.logout_rounded,
          size: 19,
        ),
        label: Text(
          'Log Out',
          style: GoogleFonts.beVietnamPro(
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFFD94C78),
          backgroundColor: Colors.white.withOpacity(0.65),
          side: BorderSide(
            color: _pink.withOpacity(0.3),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
    );
  }
}
