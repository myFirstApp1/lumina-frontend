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
          "PROFILE SCREEN USER ID = ${authState.user.userId}",
        );

        context.read<ProfileCubit>().loadProfile(
          authState.user.userId,
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
                bottom: -120,
                left: -120,
                child: Container(
                  width: 260,
                  height: 260,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.primary.withOpacity(.05),
                  ),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: 120,
                      sigmaY: 120,
                    ),
                    child: const SizedBox(),
                  ),
                ),
              ),

          // Main scrollable content
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                24,
                MediaQuery.of(context).padding.top + 90,
                24,
                40,
              ),
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
                          ],
                        ),
                        const SizedBox(height: 18),

                        Text(
                          profile.name.isNotEmpty ? profile.name : "No Name",
                          style: GoogleFonts.montserrat(
                            fontSize: 30,
                            fontWeight: FontWeight.w500,
                            color: AppTheme.textPrimary,
                          ),
                        ),

                        const SizedBox(height: 6),

                        Text(
                          "Protected Account",
                          style: GoogleFonts.beVietnamPro(
                            fontSize: 15,
                            color: Colors.green,
                            fontWeight: FontWeight.w500,
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
                      borderRadius: BorderRadius.circular(36),
                      border: Border.all(color: Colors.white.withOpacity(0.6), width: 1.0),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primary.withOpacity(0.06),
                          blurRadius: 20,
                          offset: const Offset(0, 4),
                        )
                      ],
                    ),
                    padding: const EdgeInsets.all(28.0),
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
                  height: MediaQuery.of(context).padding.top + 70,
                  decoration: BoxDecoration(
                    color: AppTheme.surface.withOpacity(0.7),
                    border: Border(
                      bottom: BorderSide(
                        color: AppTheme.outlineVariant.withOpacity(0.3),
                        width: 1.0,
                      ),
                    ),
                  ),
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).padding.top + 12,
                      left: 24,
                      right: 24,
                      bottom: 18,
                    ),
                  child: Row(
                    children: [
                      // Back Button
                      Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
                          onPressed: () => context.pop(),
                        ),
                      ),

                      // Center Title
                      Expanded(
                        child: Center(
                          child: Text(
                            "Profile",
                            style: GoogleFonts.montserrat(
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                        ),
                      ),

                      // Settings Button
                      Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.settings_outlined,
                            color: AppTheme.primary,
                            size: 22,
                          ),
                          onPressed: () => context.push(AppRoutes.settings),
                        ),
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
