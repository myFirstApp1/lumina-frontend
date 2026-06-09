import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/profile_cubit.dart';
import '../cubit/profile_state.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authState = context.read<AuthCubit>().state;
      if (authState is AuthAuthenticated) {
        debugPrint(
          "PROFILE SCREEN USER ID = ${authState.user.authUserId}",
        );

        context.read<ProfileCubit>().loadProfile(
          authState.user.authUserId,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoading || state is ProfileInitial) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator(color: AppTheme.primary)),
          );
        }

        if (state is ProfileError) {
          return Scaffold(
            body: Center(child: Text("Error: ${state.message}", style: const TextStyle(color: Colors.red))),
          );
        }

        final profile = (state as ProfileLoaded).profile;

        return Scaffold(
          body: Stack(
            children: [
          // Background soft canvas
          Container(
            color: AppTheme.background,
          ),

          // Glowing background accent
          Positioned(
            top: -100,
            right: -100,
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

          // Main scrollable content
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24.0, 80.0, 24.0, 110.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Profile photo header
                  Center(
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            // Soft glow halo
                            Container(
                              width: 112,
                              height: 112,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppTheme.primary.withOpacity(0.15),
                                    blurRadius: 24,
                                    offset: const Offset(0, 8),
                                  )
                                ],
                              ),
                            ),
                            // Avatar image
                            Container(
                              width: 112,
                              height: 112,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 4.0),
                                  image: const DecorationImage(
                                    image: AssetImage(
                                      'assets/images/defaultProfile.jpg',
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                              ),
                            ),
                            // Camera Edit Icon overlay badge
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: () => context.push(AppRoutes.editProfile),
                                child: Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                    border: Border.all(color: AppTheme.outlineVariant.withOpacity(0.5), width: 1.0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.06),
                                        blurRadius: 6,
                                        offset: const Offset(0, 2),
                                      )
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt,
                                    color: AppTheme.primary,
                                    size: 18,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          profile.name.isNotEmpty ? profile.name : "No Name",
                          style: GoogleFonts.montserrat(
                            fontSize: 28,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textPrimary,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Personal Information Bento Card
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(24.0),
                      border: Border.all(color: Colors.white.withOpacity(0.6), width: 1.0),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primary.withOpacity(0.06),
                          blurRadius: 20,
                          offset: const Offset(0, 4),
                        )
                      ],
                    ),
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Card Header with Edit button
                        Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppTheme.primary.withOpacity(0.1),
                              ),
                              child: const Icon(
                                Icons.person,
                                color: AppTheme.primary,
                                size: 22,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              "Personal Information",
                              style: GoogleFonts.montserrat(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                            const Spacer(),
                            IconButton(
                              icon: const Icon(
                                Icons.edit,
                                color: AppTheme.primary,
                                size: 20,
                              ),
                              onPressed: () => context.push(AppRoutes.editProfile),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Divider(color: AppTheme.outlineVariant),
                        const SizedBox(height: 16),

                        // Details Items
                        _buildDetailItem("User Name", profile.name.isNotEmpty ? profile.name : "N/A"),
                        const SizedBox(height: 20),
                        _buildDetailItem("Email Address", profile.email.isNotEmpty ? profile.email : "N/A"),
                        const SizedBox(height: 20),
                        _buildDetailItem("Phone Number", profile.phone.isNotEmpty ? profile.phone : "N/A"),
                        const SizedBox(height: 20),
                        _buildDetailItem("Address", profile.address.isNotEmpty ? profile.address : "N/A"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Custom TopAppBar exactly matching HTML specs
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
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Top bar left profile photo placeholder
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppTheme.outlineVariant.withOpacity(0.3), width: 1.0),
                          image: const DecorationImage(
                            image: NetworkImage(
                              "https://lh3.googleusercontent.com/aida/ADBb0uheO2xz_B69a8socQuO_Qv_rqplousYU4BIcbgIWSHeM1imJHuX2ng-SMp84jevenTjgoqf32-BfKGp8gMntpPtPbO0Lbl2AUbiCHNjRmA9CTDC5kCsn7z6IHlPg5ou_ALvRJjnfdL40ZdyFHtReryQ0CR9wi3rk9MfdPKnXx6185mV-x1i4WPfANmVKV5Z_QChksYf6lIy2vkzDpfbecyxw52TQnzTkSlTPEVqyk_nAXUjnag5eI0orN4",
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      // Centered Title
                      Text(
                        "Lumina Guardian",
                        style: GoogleFonts.montserrat(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primary,
                          letterSpacing: -0.5,
                        ),
                      ),
                      // Settings Icon Trigger on right
                      GestureDetector(
                        onTap: () => context.push(AppRoutes.settings),
                        child: const Icon(
                          Icons.settings_outlined,
                          color: AppTheme.primary,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Custom Center-Floating Bottom Navigation Bar (Matching Home exactly)
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
                    _buildNavItem(context, Icons.health_and_safety_outlined, "Home", false, () {
                      context.go(AppRoutes.home);
                    }),
                    _buildNavItem(context, Icons.map_outlined, "Map", false, () {
                      context.push(AppRoutes.liveTracking);
                    }),

                    // Elevated Center SOS button overlapping top boundary
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
    },
    );
  }

  Widget _buildDetailItem(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.toUpperCase(),
          style: GoogleFonts.beVietnamPro(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppTheme.primaryContainer,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.beVietnamPro(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: AppTheme.textPrimary,
          ),
        ),
      ],
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
