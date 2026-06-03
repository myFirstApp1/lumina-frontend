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
import '../../data/models/user_profile_model.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _addressController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final profileState = context.read<ProfileCubit>().state;
      if (profileState is ProfileLoaded) {
        final profile = profileState.profile;
        _usernameController.text = profile.fullName;
        _emailController.text = profile.email;
        _phoneController.text = profile.phone;
        _addressController.text = profile.address;
      }
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _handleSaveChanges() {
    if (_formKey.currentState!.validate()) {
      final authState = context.read<AuthCubit>().state;
      if (authState is AuthAuthenticated) {
        final profileState = context.read<ProfileCubit>().state;
        String profileId = '';
        if (profileState is ProfileLoaded) profileId = profileState.profile.id;

        final updatedProfile = UserProfileModel(
          id: profileId, // Assuming ID is not updatable or uses same ID
          fullName: _usernameController.text,
          email: _emailController.text,
          phone: _phoneController.text,
          address: _addressController.text,
        );

        context.read<ProfileCubit>().updateProfile(authState.user.id, updatedProfile).then((_) {
          if (mounted) {
            context.pop();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  "Profile details successfully updated.",
                  style: GoogleFonts.beVietnamPro(fontWeight: FontWeight.bold),
                ),
                backgroundColor: AppTheme.success,
              ),
            );
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background soft canvas
          Container(
            color: AppTheme.background,
          ),

          // Main scrollable content
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24.0, 80.0, 24.0, 48.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Profile Photo Header Section
                  Center(
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () => context.push(AppRoutes.updatePhoto),
                          child: Stack(
                            children: [
                              // Photo preview
                              Container(
                                width: 128,
                                height: 128,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 4.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppTheme.primary.withOpacity(0.15),
                                      blurRadius: 24,
                                      offset: const Offset(0, 8),
                                    )
                                  ],
                                  image: const DecorationImage(
                                    image: NetworkImage(
                                      "https://lh3.googleusercontent.com/aida/ADBb0uheO2xz_B69a8socQuO_Qv_rqplousYU4BIcbgIWSHeM1imJHuX2ng-SMp84jevenTjgoqf32-BfKGp8gMntpPtPbO0Lbl2AUbiCHNjRmA9CTDC5kCsn7z6IHlPg5ou_ALvRJjnfdL40ZdyFHtReryQ0CR9wi3rk9MfdPKnXx6185mV-x1i4WPfANmVKV5Z_QChksYf6lIy2vkzDpfbecyxw52TQnzTkSlTPEVqyk_nAXUjnag5eI0orN4",
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              // Hover camera icon overlay
                              Positioned.fill(
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.black.withOpacity(0.05),
                                  ),
                                ),
                              ),
                              // Edit badge bottom-right
                              Positioned(
                                bottom: 1,
                                right: 1,
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
                                    Icons.edit,
                                    color: AppTheme.primaryContainer,
                                    size: 18,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextButton(
                          onPressed: () => context.push(AppRoutes.updatePhoto),
                          child: BlocBuilder<ProfileCubit, ProfileState>(
                            builder: (context, state) {
                              String name = "Loading...";
                              if (state is ProfileLoaded) {
                                name = state.profile.fullName.isNotEmpty ? state.profile.fullName : "No Name";
                              }
                              return Text(
                                name,
                                style: GoogleFonts.beVietnamPro(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.primary,
                                ),
                              );
                            }
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Edit Form (Glass Card)
                  Form(
                    key: _formKey,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(24.0),
                        border: Border.all(color: Colors.white.withOpacity(0.4), width: 1.0),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primary.withOpacity(0.06),
                            blurRadius: 32,
                            offset: const Offset(0, 8),
                          )
                        ],
                      ),
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // User Name Field
                          _buildFieldLabel("User Name"),
                          _buildTextFormField(
                            controller: _usernameController,
                            icon: Icons.person_outline,
                            hintText: "Enter your full name",
                            validator: (val) => val == null || val.isEmpty ? "Username cannot be empty" : null,
                          ),
                          const SizedBox(height: 20),

                          // Email Address Field
                          _buildFieldLabel("Email Address"),
                          _buildTextFormField(
                            controller: _emailController,
                            icon: Icons.mail_outline,
                            hintText: "Enter your email address",
                            keyboardType: TextInputType.emailAddress,
                            validator: (val) {
                              if (val == null || val.isEmpty) return "Email address cannot be empty";
                              if (!val.contains("@")) return "Invalid email address";
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),

                          // Phone Number Field
                          _buildFieldLabel("Phone Number"),
                          _buildTextFormField(
                            controller: _phoneController,
                            icon: Icons.smartphone_outlined,
                            hintText: "Enter your phone number",
                            keyboardType: TextInputType.phone,
                            validator: (val) => val == null || val.isEmpty ? "Phone number cannot be empty" : null,
                          ),
                          const SizedBox(height: 20),

                          // Home Address Field
                          _buildFieldLabel("Home Address"),
                          _buildTextFormField(
                            controller: _addressController,
                            icon: Icons.home_outlined,
                            hintText: "Enter your home address",
                            validator: (val) => val == null || val.isEmpty ? "Address cannot be empty" : null,
                          ),
                          const SizedBox(height: 32),

                          // Action Buttons Layout
                          Column(
                            children: [
                              SizedBox(
                                width: double.infinity,
                                height: 56,
                                child: ElevatedButton(
                                  onPressed: _handleSaveChanges,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppTheme.primary,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(28.0),
                                    ),
                                    elevation: 4,
                                    shadowColor: AppTheme.primary.withOpacity(0.3),
                                  ),
                                  child: Text(
                                    "Save Changes",
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
                                  onPressed: () => context.pop(),
                                  style: TextButton.styleFrom(
                                    backgroundColor: AppTheme.surface.withOpacity(0.6),
                                    foregroundColor: AppTheme.textSecondary,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(28.0),
                                    ),
                                  ),
                                  child: Text(
                                    "Cancel",
                                    style: GoogleFonts.beVietnamPro(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
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
                ],
              ),
            ),
          ),

          // Custom Top App Bar matching HTML specifications exactly
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
                    color: AppTheme.surface.withOpacity(0.3),
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
                      // Back Button
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: AppTheme.primary),
                        onPressed: () => context.pop(),
                      ),
                      // Title
                      Text(
                        "Edit Profile",
                        style: GoogleFonts.montserrat(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
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
    );
  }

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, bottom: 6.0),
      child: Text(
        label,
        style: GoogleFonts.beVietnamPro(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: AppTheme.textSecondary,
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required IconData icon,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    required FormFieldValidator<String>? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      style: GoogleFonts.beVietnamPro(
        fontSize: 16,
        color: AppTheme.textPrimary,
      ),
      decoration: InputDecoration(
        prefixIcon: Container(
          width: 48,
          height: 48,
          alignment: Alignment.center,
          child: Icon(
            icon,
            color: AppTheme.primaryContainer,
            size: 24,
          ),
        ),
        hintText: hintText,
      ),
    );
  }
}
