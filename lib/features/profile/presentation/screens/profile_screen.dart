import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/avatar_helper.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../cubit/profile_cubit.dart';
import '../cubit/profile_state.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  static const Color _pink = Color(0xFFD95791);
  static const Color _lavender = Color(0xFFAA91D8);
  static const Color _dark = Color(0xFF393044);
  static const Color _muted = Color(0xFF898193);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authState = context.read<AuthCubit>().state;
      if (authState is AuthAuthenticated) {
        debugPrint("PROFILE SCREEN USER ID = ${authState.user.userId}");
        context.read<ProfileCubit>().loadProfile(authState.user.userId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoading || state is ProfileInitial) {
          return const Scaffold(
            backgroundColor: Color(0xFFFFF7FA),
            body: Center(child: CircularProgressIndicator(color: _pink)),
          );
        }

        if (state is ProfileError) {
          return Scaffold(
            backgroundColor: const Color(0xFFFFF7FA),
            body: Center(
              child: Text(
                "Error: ${state.message}",
                style: const TextStyle(color: _pink),
              ),
            ),
          );
        }

        final profile = (state as ProfileLoaded).profile;

        return Scaffold(
          backgroundColor: const Color(0xFFFFF7FA),
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
              Positioned(top: 100, right: -90,
                  child: _glowCircle(210, const Color(0xFFFFC6DD))),
              Positioned(top: 430, left: -100,
                  child: _glowCircle(220, const Color(0xFFDCCFFF))),
              Positioned(bottom: 30, right: -80,
                  child: _glowCircle(180, const Color(0xFFFFD9E9))),
              SafeArea(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 40),
                  children: [
                    _buildHeader(context),
                    const SizedBox(height: 24),
                    _buildProfileHero(profile),
                    const SizedBox(height: 26),
                    _buildSectionHeader(
                      'PERSONAL INFORMATION',
                      Icons.person_outline_rounded,
                    ),
                    const SizedBox(height: 12),
                    _buildGlassCard(
                      child: Column(
                        children: [
                          _buildDetailRow(
                            Icons.person_outline_rounded,
                            'User Name',
                            profile.name.isNotEmpty ? profile.name : 'N/A',
                          ),
                          _buildDivider(),
                          _buildDetailRow(
                            Icons.email_outlined,
                            'Email Address',
                            profile.email.isNotEmpty ? profile.email : 'N/A',
                          ),
                          _buildDivider(),
                          _buildDetailRow(
                            Icons.phone_iphone_rounded,
                            'Phone Number',
                            profile.phone.isNotEmpty ? profile.phone : 'N/A',
                          ),
                          _buildDivider(),
                          _buildDetailRow(
                            Icons.home_outlined,
                            'Home Address',
                            profile.address.isNotEmpty ? profile.address : 'N/A',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildActionCard(
                      icon: Icons.edit_outlined,
                      title: 'Edit Profile',
                      subtitle: 'Update your personal information',
                      onTap: () => context.push(AppRoutes.editProfile),
                    ),
                    const SizedBox(height: 12),
                    _buildActionCard(
                      icon: Icons.photo_camera_outlined,
                      title: 'Update Profile Photo',
                      subtitle: 'Choose an avatar or upload a photo',
                      onTap: () => context.push(AppRoutes.updatePhoto),
                    ),
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
        );
      },
    );
  }

  Widget _glowCircle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withOpacity(.35),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
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
              'Profile',
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
          icon: Icons.settings_outlined,
          onTap: () => context.push(AppRoutes.settings),
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
                border: Border.all(color: Colors.white.withOpacity(.8)),
              ),
              child: Icon(icon, color: _dark, size: 21),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHero(dynamic profile) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(26),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(.82),
                Colors.white.withOpacity(.48),
              ],
            ),
            borderRadius: BorderRadius.circular(26),
            border: Border.all(color: Colors.white.withOpacity(.9)),
            boxShadow: [
              BoxShadow(
                color: _pink.withOpacity(.08),
                blurRadius: 25,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 82,
                height: 82,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: _pink.withOpacity(.16),
                      blurRadius: 18,
                      offset: const Offset(0, 6),
                    ),
                  ],
                  image: DecorationImage(
                    image: AssetImage(AvatarHelper.getAvatarPath(profile.avatar)),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile.name.isNotEmpty ? profile.name : 'No Name',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.montserrat(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: _dark,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Row(
                      children: [
                        const Icon(Icons.verified_user_rounded,
                            size: 15, color: Color(0xFF36A66A)),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            'Protected Account',
                            style: GoogleFonts.beVietnamPro(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF36A66A),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () => context.push(AppRoutes.updatePhoto),
                      child: Text(
                        'Change profile photo',
                        style: GoogleFonts.beVietnamPro(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: _pink,
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

  Widget _buildGlassCard({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(23),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(.67),
            borderRadius: BorderRadius.circular(23),
            border: Border.all(color: Colors.white.withOpacity(.9), width: 1.2),
            boxShadow: [
              BoxShadow(
                color: _lavender.withOpacity(.07),
                blurRadius: 20,
                offset: const Offset(0, 7),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
                    fontSize: 11,
                    color: _muted,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: _dark,
                  ),
                ),
              ],
            ),
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
          colors: [_pink.withOpacity(.13), _lavender.withOpacity(.16)],
        ),
      ),
      child: Icon(icon, color: _pink, size: 20),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.only(left: 72),
      child: Divider(
        height: 1,
        thickness: .8,
        color: _lavender.withOpacity(.16),
      ),
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(23),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Material(
          color: Colors.white.withOpacity(.67),
          child: InkWell(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(23),
                border: Border.all(color: Colors.white.withOpacity(.9)),
              ),
              child: Row(
                children: [
                  _buildIconContainer(icon),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, style: GoogleFonts.beVietnamPro(
                            fontSize: 13, fontWeight: FontWeight.w700, color: _dark)),
                        const SizedBox(height: 4),
                        Text(subtitle, style: GoogleFonts.beVietnamPro(
                            fontSize: 11, color: _muted)),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right_rounded, color: _muted),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}