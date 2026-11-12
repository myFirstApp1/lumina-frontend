import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  static const Color _pink = Color(0xFFD95791);
  static const Color _lavender = Color(0xFFAA91D8);
  static const Color _dark = Color(0xFF393044);
  static const Color _muted = Color(0xFF898193);
  static const Color _page = Color(0xFFFFF7FA);

  bool _biometricAuth = true;
  bool _safetyNotifications = true;
  bool _deviceNotifications = true;
  bool _quietHours = false;
  int _sosCountdown = 15;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          context.go(AppRoutes.login);
        }
      },
      child: Scaffold(
        backgroundColor: _page,
        body: Stack(
          children: [
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
            Positioned(top: 90, right: -95,
                child: _glowCircle(230, const Color(0xFFFFC6DD))),
            Positioned(top: 480, left: -115,
                child: _glowCircle(240, const Color(0xFFDCCFFF))),
            Positioned(bottom: 40, right: -85,
                child: _glowCircle(190, const Color(0xFFFFD9E9))),
            SafeArea(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 42),
                children: [
                  _buildHeader(),
                  const SizedBox(height: 24),
                  _buildHeroCard(),
                  const SizedBox(height: 22),
                  _buildQuickPanel(),
                  const SizedBox(height: 28),

                  _section('ACCOUNT & ACCESS', Icons.person_outline_rounded),
                  const SizedBox(height: 11),
                  _glassGroup([
                    _settingRow(
                      icon: Icons.lock_outline_rounded,
                      title: 'Change Password',
                      subtitle: 'Keep your account access secure',
                      onTap: () => _showInfo(
                        'Change Password',
                        'Password management will be available here when the password update flow is connected.',
                      ),
                    ),
                    _divider(),
                    _toggleRow(
                      icon: Icons.fingerprint_rounded,
                      title: 'Biometric Authentication',
                      subtitle: 'Use your device biometrics to unlock',
                      value: _biometricAuth,
                      onChanged: (value) =>
                          setState(() => _biometricAuth = value),
                    ),
                    _divider(),
                    _settingRow(
                      icon: Icons.devices_rounded,
                      title: 'Active Sessions',
                      subtitle: 'Review devices signed in to your account',
                      onTap: () => _showInfo(
                        'Active Sessions',
                        'Session management is not connected yet.',
                      ),
                    ),
                  ]),
                  const SizedBox(height: 25),

                  _section('EMERGENCY RESPONSE', Icons.health_and_safety_outlined),
                  const SizedBox(height: 11),
                  _glassGroup([
                    _settingRow(
                      icon: Icons.timer_outlined,
                      title: 'SOS Countdown Timer',
                      subtitle: '$_sosCountdown seconds before SOS is triggered',
                      trailingLabel: 'EDIT',
                      onTap: _chooseCountdown,
                    ),
                    _divider(),
                    _settingRow(
                      icon: Icons.message_outlined,
                      title: 'Emergency Message',
                      subtitle: 'Customize the message shared during SOS',
                      onTap: () => _showInfo(
                        'Emergency Message',
                        'Your emergency message editor can be connected here.',
                      ),
                    ),
                    _divider(),
                    _settingRow(
                      icon: Icons.groups_2_outlined,
                      title: 'Trusted Contacts',
                      subtitle: 'Manage the people in your safety circle',
                      onTap: () => context.push(AppRoutes.contactsCircle),
                    ),
                    _divider(),
                    _toggleRow(
                      icon: Icons.nights_stay_outlined,
                      title: 'Quiet Hours',
                      subtitle: 'Silence non-critical reminders',
                      value: _quietHours,
                      onChanged: (value) =>
                          setState(() => _quietHours = value),
                    ),
                  ]),
                  const SizedBox(height: 25),

                  _section('CONNECTED DEVICES', Icons.watch_outlined),
                  const SizedBox(height: 11),
                  _glassGroup([
                    _deviceRow(
                      icon: Icons.watch_rounded,
                      title: 'Wearable Device',
                      subtitle: 'Manage pairing and synchronization',
                      onTap: () => context.push(AppRoutes.wearableSync),
                    ),
                    _divider(),
                    _settingRow(
                      icon: Icons.battery_charging_full_rounded,
                      title: 'Device Diagnostics',
                      subtitle: 'Connection, battery and sync information',
                      onTap: () => context.push(AppRoutes.wearableSync),
                    ),
                  ]),
                  const SizedBox(height: 25),

                  _section('NOTIFICATIONS', Icons.notifications_none_rounded),
                  const SizedBox(height: 11),
                  _glassGroup([
                    _toggleRow(
                      icon: Icons.notifications_active_outlined,
                      title: 'Safety Notifications',
                      subtitle: 'Receive important safety updates',
                      value: _safetyNotifications,
                      onChanged: (value) =>
                          setState(() => _safetyNotifications = value),
                    ),
                    _divider(),
                    _toggleRow(
                      icon: Icons.watch_later_outlined,
                      title: 'Device Notifications',
                      subtitle: 'Receive wearable connection reminders',
                      value: _deviceNotifications,
                      onChanged: (value) =>
                          setState(() => _deviceNotifications = value),
                    ),
                    _divider(),
                    _settingRow(
                      icon: Icons.tune_rounded,
                      title: 'Notification Preferences',
                      subtitle: 'Choose how updates are presented',
                      onTap: () => _showInfo(
                        'Notification Preferences',
                        'Detailed notification channels and delivery preferences can be connected here.',
                      ),
                    ),
                  ]),
                  const SizedBox(height: 25),

                  _section('PRIVACY & PERMISSIONS', Icons.shield_outlined),
                  const SizedBox(height: 11),
                  _glassGroup([
                    _settingRow(
                      icon: Icons.location_on_outlined,
                      title: 'Location Permissions',
                      subtitle: 'Review location access for safety tracking',
                      onTap: () => _showInfo(
                        'Location Permissions',
                        'Manage location permission in your device Settings. Live safety tracking depends on the permissions granted to Lumina Guardian.',
                      ),
                    ),
                    _divider(),
                    _settingRow(
                      icon: Icons.privacy_tip_outlined,
                      title: 'Privacy Policy',
                      subtitle: 'Understand how your information is handled',
                      onTap: () => context.push(AppRoutes.privacyPolicy),
                    ),
                    _divider(),
                    _settingRow(
                      icon: Icons.delete_outline_rounded,
                      title: 'Data & Account',
                      subtitle: 'Learn about your data and account options',
                      onTap: () => _showInfo(
                        'Data & Account',
                        'Account and data-management actions will be available here when those flows are connected.',
                      ),
                    ),
                  ]),
                  const SizedBox(height: 25),

                  _section('HELP & ABOUT', Icons.support_agent_rounded),
                  const SizedBox(height: 11),
                  _glassGroup([
                    _settingRow(
                      icon: Icons.help_outline_rounded,
                      title: 'Help Center',
                      subtitle: 'Find guidance and get support',
                      onTap: () => context.push(AppRoutes.helpCenter),
                    ),
                    _divider(),
                    _settingRow(
                      icon: Icons.description_outlined,
                      title: 'Terms of Service',
                      subtitle: 'Review the terms of using Lumina Guardian',
                      onTap: () => context.push(AppRoutes.termsOfService),
                    ),
                    _divider(),
                    _settingRow(
                      icon: Icons.info_outline_rounded,
                      title: 'App Version',
                      subtitle: 'Lumina Guardian · Safety companion',
                      trailingLabel: 'V1',
                      onTap: () => _showInfo(
                        'Lumina Guardian',
                        'Your safety, our priority.',
                      ),
                    ),
                  ]),
                  const SizedBox(height: 28),
                  _buildLogoutButton(),
                  const SizedBox(height: 25),
                  Center(
                    child: Column(
                      children: [
                        Text(
                          'LUMINA GUARDIAN',
                          style: GoogleFonts.montserrat(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 2.2,
                            color: _muted,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Your safety, our priority.',
                          style: GoogleFonts.beVietnamPro(
                            fontSize: 11,
                            color: _muted,
                          ),
                        ),
                      ],
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

  Widget _glowCircle(double size, Color color) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: color.withOpacity(.32),
    ),
  );

  Widget _buildHeader() {
    return Row(
      children: [
        _glassIconButton(
          icon: Icons.arrow_back_rounded,
          onTap: () {
            if (context.canPop()) context.pop();
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
                letterSpacing: -.5,
              ),
            ),
          ),
        ),
        _glassIconButton(
          icon: Icons.more_horiz_rounded,
          onTap: () => _showInfo(
            'Settings',
            'Your account, safety and device preferences are organized below.',
          ),
        ),
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
          color: Colors.white.withOpacity(.55),
          child: InkWell(
            onTap: onTap,
            child: Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(.85)),
              ),
              child: Icon(icon, color: _dark, size: 21),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeroCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.all(21),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(.84),
                Colors.white.withOpacity(.48),
              ],
            ),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: Colors.white.withOpacity(.92)),
            boxShadow: [
              BoxShadow(
                color: _pink.withOpacity(.10),
                blurRadius: 28,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 54,
                    height: 54,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [_pink, _lavender],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: const Icon(
                      Icons.tune_rounded,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Your safety, your settings',
                          style: GoogleFonts.montserrat(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            color: _dark,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Personalize your Lumina Guardian experience.',
                          style: GoogleFonts.beVietnamPro(
                            fontSize: 11,
                            height: 1.45,
                            color: _muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 19),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 13,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: _pink.withOpacity(.075),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.shield_moon_outlined,
                      color: _pink,
                      size: 18,
                    ),
                    const SizedBox(width: 9),
                    Expanded(
                      child: Text(
                        'Keep your account and emergency preferences up to date.',
                        style: GoogleFonts.beVietnamPro(
                          fontSize: 11,
                          height: 1.4,
                          fontWeight: FontWeight.w600,
                          color: _dark,
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
    );
  }

  Widget _buildQuickPanel() {
    return Row(
      children: [
        Expanded(
          child: _quickTile(
            icon: Icons.fingerprint_rounded,
            title: 'Biometric',
            value: _biometricAuth ? 'Enabled' : 'Disabled',
            tint: _pink,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _quickTile(
            icon: Icons.timer_outlined,
            title: 'SOS timer',
            value: '$_sosCountdown sec',
            tint: _lavender,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _quickTile(
            icon: Icons.notifications_active_outlined,
            title: 'Alerts',
            value: _safetyNotifications ? 'On' : 'Off',
            tint: _pink,
          ),
        ),
      ],
    );
  }

  Widget _quickTile({
    required IconData icon,
    required String title,
    required String value,
    required Color tint,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(19),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 13),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(.58),
            borderRadius: BorderRadius.circular(19),
            border: Border.all(color: Colors.white.withOpacity(.86)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: tint, size: 20),
              const SizedBox(height: 9),
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.beVietnamPro(
                  fontSize: 10,
                  color: _muted,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.montserrat(
                  fontSize: 12,
                  color: _dark,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _section(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Row(
        children: [
          Container(
            width: 29,
            height: 29,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(
                colors: [
                  _pink.withOpacity(.14),
                  _lavender.withOpacity(.18),
                ],
              ),
            ),
            child: Icon(icon, color: _pink, size: 16),
          ),
          const SizedBox(width: 9),
          Text(
            title,
            style: GoogleFonts.montserrat(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.15,
              color: _dark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _glassGroup(List<Widget> children) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(23),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(.66),
            borderRadius: BorderRadius.circular(23),
            border: Border.all(
              color: Colors.white.withOpacity(.91),
              width: 1.1,
            ),
            boxShadow: [
              BoxShadow(
                color: _lavender.withOpacity(.075),
                blurRadius: 22,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(children: children),
        ),
      ),
    );
  }

  Widget _divider() {
    return Padding(
      padding: const EdgeInsets.only(left: 70),
      child: Divider(
        height: 1,
        thickness: .8,
        color: _lavender.withOpacity(.17),
      ),
    );
  }

  Widget _settingRow({
    required IconData icon,
    required String title,
    String? subtitle,
    String? trailingLabel,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
          child: Row(
            children: [
              _iconTile(icon),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: _dark,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: GoogleFonts.beVietnamPro(
                          fontSize: 10,
                          height: 1.35,
                          color: _muted,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (trailingLabel != null)
                Text(
                  trailingLabel,
                  style: GoogleFonts.montserrat(
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    letterSpacing: .7,
                    color: _pink,
                  ),
                )
              else
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

  Widget _toggleRow({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 9),
      child: Row(
        children: [
          _iconTile(icon),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: _dark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 10,
                    height: 1.35,
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

  Widget _deviceRow({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              _iconTile(icon),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: _dark,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 10,
                        color: _muted,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: _muted),
            ],
          ),
        ),
      ),
    );
  }

  Widget _iconTile(IconData icon) {
    return Container(
      width: 41,
      height: 41,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: LinearGradient(
          colors: [
            _pink.withOpacity(.13),
            _lavender.withOpacity(.17),
          ],
        ),
      ),
      child: Icon(icon, color: _pink, size: 19),
    );
  }

  Future<void> _chooseCountdown() async {
    final selected = await showModalBottomSheet<int>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Container(
            padding: const EdgeInsets.fromLTRB(22, 22, 22, 30),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF9FC).withOpacity(.97),
              borderRadius:
              const BorderRadius.vertical(top: Radius.circular(28)),
            ),
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'SOS Countdown',
                    style: GoogleFonts.montserrat(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: _dark,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    'Choose a countdown duration. This selection is currently a screen preference; connect it to the SOS flow before relying on it.',
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 11,
                      height: 1.5,
                      color: _muted,
                    ),
                  ),
                  const SizedBox(height: 17),
                  Wrap(
                    spacing: 9,
                    runSpacing: 9,
                    children: [5, 10, 15, 20, 30].map((seconds) {
                      final isSelected = seconds == _sosCountdown;
                      return ChoiceChip(
                        label: Text('$seconds seconds'),
                        selected: isSelected,
                        selectedColor: _pink.withOpacity(.16),
                        labelStyle: TextStyle(
                          color: isSelected ? _pink : _dark,
                          fontWeight: FontWeight.w700,
                        ),
                        side: BorderSide(
                          color: isSelected
                              ? _pink.withOpacity(.45)
                              : _lavender.withOpacity(.25),
                        ),
                        onSelected: (_) =>
                            Navigator.of(sheetContext).pop(seconds),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    if (selected != null && mounted) {
      setState(() => _sosCountdown = selected);
    }
  }

  void _showInfo(String title, String message) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => Dialog(
        backgroundColor: Colors.transparent,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF9FC).withOpacity(.97),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.montserrat(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: _dark,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    message,
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 12,
                      height: 1.55,
                      color: _muted,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => Navigator.pop(dialogContext),
                      child: const Text(
                        'GOT IT',
                        style: TextStyle(
                          color: _pink,
                          fontWeight: FontWeight.w800,
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
    );
  }

  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: OutlinedButton.icon(
        onPressed: () => context.read<AuthCubit>().logout(),
        icon: const Icon(Icons.logout_rounded, size: 18),
        label: Text(
          'Log Out',
          style: GoogleFonts.beVietnamPro(
            fontSize: 13,
            fontWeight: FontWeight.w800,
          ),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: _pink,
          backgroundColor: Colors.white.withOpacity(.58),
          side: BorderSide(color: _pink.withOpacity(.28)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
    );
  }
}



// import 'dart:ui';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';
// import 'package:google_fonts/google_fonts.dart';
//
// import '../../../../core/routes/app_routes.dart';
// import '../../../../core/theme/app_theme.dart';
// import '../../../auth/presentation/cubit/auth_cubit.dart';
//
// class SettingsScreen extends StatefulWidget {
//   const SettingsScreen({Key? key}) : super(key: key);
//
//   @override
//   State<SettingsScreen> createState() => _SettingsScreenState();
// }
//
// class _SettingsScreenState extends State<SettingsScreen> {
//   bool _biometricAuth = true;
//
//   static const Color _pink = Color(0xFFD95791);
//   static const Color _lavender = Color(0xFFAA91D8);
//   static const Color _dark = Color(0xFF393044);
//   static const Color _muted = Color(0xFF898193);
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocListener<AuthCubit, AuthState>(
//       listener: (context, state) {
//         if (state is AuthUnauthenticated) {
//           context.go(AppRoutes.login);
//         }
//       },
//       child: Scaffold(
//         backgroundColor: const Color(0xFFFFF7FA),
//         body: Stack(
//           children: [
//             // Soft gradient background
//             const Positioned.fill(
//               child: DecoratedBox(
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                     colors: [
//                       Color(0xFFFFE5EF),
//                       Color(0xFFFFF5F6),
//                       Color(0xFFF0EAFF),
//                       Color(0xFFFFF9F3),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//
//             // Decorative background circles
//             Positioned(
//               top: 100,
//               right: -90,
//               child: _glowCircle(210, const Color(0xFFFFC6DD)),
//             ),
//             Positioned(
//               top: 430,
//               left: -100,
//               child: _glowCircle(220, const Color(0xFFDCCFFF)),
//             ),
//             Positioned(
//               bottom: 30,
//               right: -80,
//               child: _glowCircle(180, const Color(0xFFFFD9E9)),
//             ),
//
//             SafeArea(
//               child: ListView(
//                 padding: const EdgeInsets.fromLTRB(20, 12, 20, 40),
//                 children: [
//                   _buildHeader(),
//
//                   const SizedBox(height: 24),
//
//                   _buildWelcomeCard(),
//
//                   const SizedBox(height: 28),
//
//                   _buildSectionHeader(
//                     'ACCOUNT SECURITY',
//                     Icons.shield_outlined,
//                   ),
//                   const SizedBox(height: 12),
//
//                   _buildGlassCard([
//                     _buildSettingsRow(
//                       icon: Icons.lock_outline_rounded,
//                       title: 'Change Password',
//                       subtitle: 'Update your account password',
//                       onTap: () {},
//                     ),
//                     _buildDivider(),
//                     _buildToggleRow(
//                       icon: Icons.fingerprint_rounded,
//                       title: 'Biometric Authentication',
//                       subtitle: 'Use biometrics for secure access',
//                       value: _biometricAuth,
//                       onChanged: (value) {
//                         setState(() {
//                           _biometricAuth = value;
//                         });
//                       },
//                     ),
//                   ]),
//
//                   const SizedBox(height: 26),
//
//                   _buildSectionHeader(
//                     'SAFETY PREFERENCES',
//                     Icons.health_and_safety_outlined,
//                   ),
//                   const SizedBox(height: 12),
//
//                   _buildGlassCard([
//                     _buildSettingsRow(
//                       icon: Icons.timer_outlined,
//                       title: 'SOS Countdown Timer',
//                       subtitle: 'Currently set to 5 seconds',
//                       onTap: () {},
//                     ),
//                     _buildDivider(),
//                     _buildSettingsRow(
//                       icon: Icons.message_outlined,
//                       title: 'Emergency Message',
//                       subtitle: 'Edit your default SOS message',
//                       onTap: () {},
//                     ),
//                     _buildDivider(),
//                     _buildSettingsRow(
//                       icon: Icons.do_not_disturb_on_outlined,
//                       title: 'Quiet Hours',
//                       subtitle: 'Manage non-critical alerts',
//                       onTap: () {},
//                     ),
//                   ]),
//
//                   const SizedBox(height: 26),
//
//                   _buildSectionHeader(
//                     'CONNECTED DEVICES',
//                     Icons.devices_outlined,
//                   ),
//                   const SizedBox(height: 12),
//
//                   _buildGlassCard([
//                     _buildDeviceRow(
//                       icon: Icons.watch_outlined,
//                       title: 'Apple Watch',
//                       status: 'Connected & Synced',
//                       onTap: () {
//                         context.push(AppRoutes.wearableSync);
//                       },
//                     ),
//                   ]),
//
//                   const SizedBox(height: 26),
//
//                   _buildSectionHeader(
//                     'LEGAL & SUPPORT',
//                     Icons.support_agent_outlined,
//                   ),
//                   const SizedBox(height: 12),
//
//                   _buildGlassCard([
//                     _buildSettingsRow(
//                       icon: Icons.help_outline_rounded,
//                       title: 'Help Center',
//                       subtitle: 'Get help and support',
//                       onTap: () {
//                         context.push(AppRoutes.helpCenter);
//                       },
//                     ),
//                     _buildDivider(),
//                     _buildSettingsRow(
//                       icon: Icons.privacy_tip_outlined,
//                       title: 'Privacy Policy',
//                       onTap: () {
//                         context.push(AppRoutes.privacyPolicy);
//                       },
//                     ),
//                     _buildDivider(),
//                     _buildSettingsRow(
//                       icon: Icons.description_outlined,
//                       title: 'Terms of Service',
//                       onTap: () {
//                         context.push(AppRoutes.termsOfService);
//                       },
//                     ),
//                   ]),
//
//                   const SizedBox(height: 32),
//
//                   _buildLogoutButton(),
//
//                   const SizedBox(height: 24),
//
//                   Center(
//                     child: Text(
//                       'LUMINA GUARDIAN',
//                       style: GoogleFonts.montserrat(
//                         fontSize: 11,
//                         fontWeight: FontWeight.w700,
//                         letterSpacing: 2,
//                         color: _muted,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 6),
//                   Center(
//                     child: Text(
//                       'Your safety, our priority.',
//                       style: GoogleFonts.beVietnamPro(
//                         fontSize: 11,
//                         color: _muted,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _glowCircle(double size, Color color) {
//     return Container(
//       width: size,
//       height: size,
//       decoration: BoxDecoration(
//         shape: BoxShape.circle,
//         color: color.withOpacity(0.35),
//       ),
//     );
//   }
//
//   Widget _buildHeader() {
//     return Row(
//       children: [
//         _glassIconButton(
//           icon: Icons.arrow_back_rounded,
//           onTap: () {
//             if (context.canPop()) {
//               context.pop();
//             }
//           },
//         ),
//         const Expanded(
//           child: Center(
//             child: Text(
//               'Settings',
//               style: TextStyle(
//                 fontSize: 21,
//                 fontWeight: FontWeight.w800,
//                 color: _dark,
//                 letterSpacing: -0.5,
//               ),
//             ),
//           ),
//         ),
//         const SizedBox(width: 46),
//       ],
//     );
//   }
//
//   Widget _glassIconButton({
//     required IconData icon,
//     required VoidCallback onTap,
//   }) {
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(16),
//       child: BackdropFilter(
//         filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
//         child: Material(
//           color: Colors.white.withOpacity(0.55),
//           child: InkWell(
//             onTap: onTap,
//             child: Container(
//               width: 46,
//               height: 46,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(16),
//                 border: Border.all(
//                   color: Colors.white.withOpacity(0.8),
//                 ),
//               ),
//               child: const Icon(
//                 Icons.arrow_back_rounded,
//                 color: _dark,
//                 size: 21,
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildWelcomeCard() {
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(26),
//       child: BackdropFilter(
//         filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
//         child: Container(
//           padding: const EdgeInsets.all(20),
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [
//                 Colors.white.withOpacity(0.82),
//                 Colors.white.withOpacity(0.48),
//               ],
//             ),
//             borderRadius: BorderRadius.circular(26),
//             border: Border.all(
//               color: Colors.white.withOpacity(0.9),
//             ),
//             boxShadow: [
//               BoxShadow(
//                 color: _pink.withOpacity(0.08),
//                 blurRadius: 25,
//                 offset: const Offset(0, 10),
//               ),
//             ],
//           ),
//           child: Row(
//             children: [
//               Container(
//                 width: 58,
//                 height: 58,
//                 decoration: const BoxDecoration(
//                   shape: BoxShape.circle,
//                   gradient: LinearGradient(
//                     colors: [_pink, _lavender],
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                   ),
//                 ),
//                 child: const Icon(
//                   Icons.settings_rounded,
//                   color: Colors.white,
//                   size: 28,
//                 ),
//               ),
//               const SizedBox(width: 16),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Your Settings',
//                       style: GoogleFonts.montserrat(
//                         fontSize: 17,
//                         fontWeight: FontWeight.w800,
//                         color: _dark,
//                       ),
//                     ),
//                     const SizedBox(height: 5),
//                     Text(
//                       'Manage your account and safety preferences.',
//                       style: GoogleFonts.beVietnamPro(
//                         fontSize: 12,
//                         height: 1.5,
//                         color: _muted,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildSectionHeader(String title, IconData icon) {
//     return Padding(
//       padding: const EdgeInsets.only(left: 5),
//       child: Row(
//         children: [
//           Icon(icon, size: 17, color: _pink),
//           const SizedBox(width: 9),
//           Text(
//             title,
//             style: GoogleFonts.montserrat(
//               fontSize: 11,
//               fontWeight: FontWeight.w800,
//               letterSpacing: 1.15,
//               color: _dark,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildGlassCard(List<Widget> children) {
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(23),
//       child: BackdropFilter(
//         filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
//         child: Container(
//           decoration: BoxDecoration(
//             color: Colors.white.withOpacity(0.67),
//             borderRadius: BorderRadius.circular(23),
//             border: Border.all(
//               color: Colors.white.withOpacity(0.9),
//               width: 1.2,
//             ),
//             boxShadow: [
//               BoxShadow(
//                 color: _lavender.withOpacity(0.07),
//                 blurRadius: 20,
//                 offset: const Offset(0, 7),
//               ),
//             ],
//           ),
//           child: Column(children: children),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildDivider() {
//     return Padding(
//       padding: const EdgeInsets.only(left: 68),
//       child: Divider(
//         height: 1,
//         thickness: 0.8,
//         color: _lavender.withOpacity(0.16),
//       ),
//     );
//   }
//
//   Widget _buildSettingsRow({
//     required IconData icon,
//     required String title,
//     String? subtitle,
//     required VoidCallback onTap,
//   }) {
//     return Material(
//       color: Colors.transparent,
//       child: InkWell(
//         onTap: onTap,
//         child: Padding(
//           padding: const EdgeInsets.symmetric(
//             horizontal: 16,
//             vertical: 15,
//           ),
//           child: Row(
//             children: [
//               _buildIconContainer(icon),
//               const SizedBox(width: 14),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       title,
//                       style: GoogleFonts.beVietnamPro(
//                         fontSize: 13,
//                         fontWeight: FontWeight.w700,
//                         color: _dark,
//                       ),
//                     ),
//                     if (subtitle != null) ...[
//                       const SizedBox(height: 4),
//                       Text(
//                         subtitle,
//                         style: GoogleFonts.beVietnamPro(
//                           fontSize: 11,
//                           color: _muted,
//                         ),
//                       ),
//                     ],
//                   ],
//                 ),
//               ),
//               const Icon(
//                 Icons.chevron_right_rounded,
//                 color: _muted,
//                 size: 21,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildToggleRow({
//     required IconData icon,
//     required String title,
//     required String subtitle,
//     required bool value,
//     required ValueChanged<bool> onChanged,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(
//         horizontal: 16,
//         vertical: 12,
//       ),
//       child: Row(
//         children: [
//           _buildIconContainer(icon),
//           const SizedBox(width: 14),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   title,
//                   style: GoogleFonts.beVietnamPro(
//                     fontSize: 13,
//                     fontWeight: FontWeight.w700,
//                     color: _dark,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   subtitle,
//                   style: GoogleFonts.beVietnamPro(
//                     fontSize: 11,
//                     color: _muted,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Switch.adaptive(
//             value: value,
//             activeColor: Colors.white,
//             activeTrackColor: _pink,
//             inactiveTrackColor: Colors.white,
//             onChanged: onChanged,
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildIconContainer(IconData icon) {
//     return Container(
//       width: 42,
//       height: 42,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(14),
//         gradient: LinearGradient(
//           colors: [
//             _pink.withOpacity(0.13),
//             _lavender.withOpacity(0.16),
//           ],
//         ),
//       ),
//       child: Icon(
//         icon,
//         color: _pink,
//         size: 20,
//       ),
//     );
//   }
//
//   Widget _buildDeviceRow({
//     required IconData icon,
//     required String title,
//     required String status,
//     required VoidCallback onTap,
//   }) {
//     return Material(
//       color: Colors.transparent,
//       child: InkWell(
//         onTap: onTap,
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Row(
//             children: [
//               _buildIconContainer(icon),
//               const SizedBox(width: 14),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       title,
//                       style: GoogleFonts.beVietnamPro(
//                         fontSize: 13,
//                         fontWeight: FontWeight.w700,
//                         color: _dark,
//                       ),
//                     ),
//                     const SizedBox(height: 5),
//                     Row(
//                       children: [
//                         Container(
//                           width: 7,
//                           height: 7,
//                           decoration: const BoxDecoration(
//                             color: Colors.green,
//                             shape: BoxShape.circle,
//                           ),
//                         ),
//                         const SizedBox(width: 7),
//                         Text(
//                           status,
//                           style: GoogleFonts.beVietnamPro(
//                             fontSize: 11,
//                             color: _muted,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               const Icon(
//                 Icons.settings_outlined,
//                 color: _muted,
//                 size: 20,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildLogoutButton() {
//     return SizedBox(
//       width: double.infinity,
//       height: 55,
//       child: OutlinedButton.icon(
//         onPressed: () {
//           context.read<AuthCubit>().logout();
//         },
//         icon: const Icon(
//           Icons.logout_rounded,
//           size: 19,
//         ),
//         label: Text(
//           'Log Out',
//           style: GoogleFonts.beVietnamPro(
//             fontSize: 14,
//             fontWeight: FontWeight.w700,
//           ),
//         ),
//         style: OutlinedButton.styleFrom(
//           foregroundColor: const Color(0xFFD94C78),
//           backgroundColor: Colors.white.withOpacity(0.65),
//           side: BorderSide(
//             color: _pink.withOpacity(0.3),
//           ),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(18),
//           ),
//         ),
//       ),
//     );
//   }
// }
