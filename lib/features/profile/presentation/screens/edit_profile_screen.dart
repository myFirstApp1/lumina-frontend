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
import 'package:flutter/services.dart';

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

  bool loading = false;

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
        _usernameController.text = profile.name;
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

  Future<void> _handleSaveChanges() async {

    if (!_formKey.currentState!.validate()) return;

    setState(() {
      loading = true;
    });

    try {

      final authState = context.read<AuthCubit>().state;

      if (authState is AuthAuthenticated) {

        final profileState = context.read<ProfileCubit>().state;

        String profileId = "";

        if (profileState is ProfileLoaded) {
          profileId = profileState.profile.id;
        }

        final updatedProfile = UserProfileModel(
          id: profileId,
          name: _usernameController.text,
          email: _emailController.text,
          phone: _phoneController.text,
          address: _addressController.text,
        );

        await context
            .read<ProfileCubit>()
            .updateProfile(
          authState.user.userId,
          updatedProfile,
        );

        if (mounted) {
          context.pop();

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: AppTheme.success,
              content: Text(
                "Profile updated successfully.",
                style: GoogleFonts.beVietnamPro(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        }
      }

    } finally {

      if (mounted) {
        setState(() {
          loading = false;
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
              padding: EdgeInsets.fromLTRB(
                24,
                MediaQuery.of(context).padding.top + 80,
                24,
                40,
              ),
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
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 4.0,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppTheme.primary.withOpacity(0.15),
                                      blurRadius: 24,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                  image: const DecorationImage(
                                    image: AssetImage(
                                      'assets/images/defaultProfile.jpg',
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
                                    Icons.camera_alt,
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
                                name = state.profile.name.isNotEmpty ? state.profile.name : "No Name";
                              }
                              return Text(
                                name,
                                style: GoogleFonts.beVietnamPro(
                                  fontSize: 20,
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
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(36),
                     //   border: Border.all(color: Colors.white.withOpacity(0.4), width: 1.0),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primary.withOpacity(0.06),
                            blurRadius: 32,
                            offset: const Offset(0, 8),
                          )
                        ],
                      ),
                      padding: const EdgeInsets.fromLTRB(
                        28,
                        30,
                        28,
                        30,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // User Name Field
                          _buildFieldLabel("User Name"),
                          _buildTextFormField(
                            controller: _usernameController,
                            icon: Icons.person_outline,
                            hintText: "Enter your full name",
                            readOnly: true,
                            validator: (val) =>
                            val == null || val.isEmpty ? "Username cannot be empty" : null,
                          ),
                          const SizedBox(height: 20),

                           // Email Address Field
                          _buildFieldLabel("Email Address"),
                          _buildTextFormField(
                            controller: _emailController,
                            icon: Icons.mail_outline,
                            hintText: "Enter your email address",
                            keyboardType: TextInputType.emailAddress,
                            readOnly: true,
                            validator: (val) {
                              if (val == null || val.isEmpty) {
                                return "Email address cannot be empty";
                              }
                              if (!val.contains("@")) {
                                return "Invalid email address";
                              }
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
                            readOnly: false,
                            validator: (val) {
                              if (val == null || val.trim().isEmpty) {
                                return "Phone number cannot be empty";
                              }

                              if (!RegExp(r'^[0-9]{10}$').hasMatch(val.trim())) {
                                return "Phone number must contain exactly 10 digits";
                              }

                              return null;
                            },
                          ),
                          const SizedBox(height: 20),

                          // Home Address Field
                          _buildFieldLabel("Home Address"),
                          _buildTextFormField(
                            controller: _addressController,
                            icon: Icons.home_outlined,
                            hintText: "Enter your home address",
                            readOnly: false,
                            validator: (val) =>
                            val == null || val.isEmpty ? "Address cannot be empty" : null,
                          ),
                          const SizedBox(height: 32),

                          // Action Buttons Layout
                          Column(
                            children: [
                            SizedBox(
                            height: 58,
                            child: ElevatedButton(
                              onPressed:loading ?  null:_handleSaveChanges,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: const StadiumBorder(),
                                padding: EdgeInsets.zero,
                              ),
                              child: Ink(
                                width: double.infinity,
                                height: 58,
                                decoration: const BoxDecoration(
                                  gradient: AppTheme.primaryGradient,
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(40),
                                  ),
                                ),
                                child: Center(
                                  child: loading
                                      ? const SizedBox(
                                    width: 22,
                                    height: 22,
                                    child:
                                    CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                      : Text(
                                    "Save Changes",
                                    style:
                                    GoogleFonts.montserrat(
                                      fontSize: 16,
                                      fontWeight:
                                      FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
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
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: AppTheme.error,
                                    side: BorderSide(
                                      color: Colors.red.withOpacity(0.8),
                                      width: 2.0,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(40.0),
                                    ),
                                  ),
                                  child: Text(
                                    "Cancel",
                                    style: GoogleFonts.beVietnamPro(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.red,
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
            right: 10,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 40, 12),
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
                        color: AppTheme.primary,
                        onPressed: () => context.pop(),
                      ),
                    ),

                    // Center Title
                    Expanded(
                      child: Center(
                        child: Text(
                          " Edit Profile",
                          style: GoogleFonts.montserrat(
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                            color: AppTheme.primary,
                          ),
                        ),
                      ),
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

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, bottom: 6.0),
      child: Text(
        label,
        style: GoogleFonts.beVietnamPro(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppTheme.primary,
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
    bool readOnly = false,
  }) {
    return TextFormField(
      controller: controller,
      // keyboardType: keyboardType,
      // inputFormatters: keyboardType == TextInputType.phone
      //     ? [
      //   FilteringTextInputFormatter.digitsOnly,
      //   LengthLimitingTextInputFormatter(10),
      // ]
      //     : null,
      validator: validator,
      readOnly: readOnly,
      enableInteractiveSelection: !readOnly,
      style: GoogleFonts.beVietnamPro(
        fontSize: 15,
        color: AppTheme.textSecondary,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: readOnly
            ? const Color(0xFFF8F8F8)
            : Colors.white,

        prefixIcon: Container(
          margin: const EdgeInsets.all(10),
          width: 35,
          height: 35,
          decoration: BoxDecoration(
            color: const Color(0xFFFFEEF4),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(
            icon,
            size: 20,
            color: AppTheme.primary,
          ),
        ),

        suffixIcon: readOnly
            ? const Padding(
          padding: EdgeInsets.only(right: 18),
          child: Icon(
            Icons.lock_outline_rounded,
            color: Colors.grey,
            size: 20,
          ),
        )
            : null,

        hintText: hintText,
      ),
    );
  }
}
