import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/avatar_helper.dart';
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

        if (profileState is! ProfileLoaded) {
          return;
        }

        final profile = profileState.profile;

        final updatedProfile = UserProfileModel(
          id: profile.id,
          name: _usernameController.text,
          email: _emailController.text,
          phone: _phoneController.text,
          avatar: profile.avatar, // Always use the latest avatar
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

  static const Color _pink = Color(0xFFD95791);
  static const Color _lavender = Color(0xFFAA91D8);
  static const Color _dark = Color(0xFF393044);
  static const Color _muted = Color(0xFF898193);

  @override
  Widget build(BuildContext context) {
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
                _buildHeader(context),
                const SizedBox(height: 24),

                // Profile photo and name, styled to match the Settings welcome card.
                _buildProfileIdentity(),

                const SizedBox(height: 24),

                ClipRRect(
                  borderRadius: BorderRadius.circular(23),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(20, 22, 20, 22),
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
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              children: [
                                _buildIconContainer(Icons.person_outline_rounded),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    'Personal Information',
                                    style: GoogleFonts.montserrat(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w800,
                                      color: _dark,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            _buildFieldLabel('User Name'),
                            _buildTextFormField(
                              controller: _usernameController,
                              icon: Icons.person_outline,
                              hintText: 'Enter your full name',
                              readOnly: true,
                              validator: (val) => val == null || val.isEmpty
                                  ? 'Username cannot be empty'
                                  : null,
                            ),
                            const SizedBox(height: 18),
                            _buildFieldLabel('Email Address'),
                            _buildTextFormField(
                              controller: _emailController,
                              icon: Icons.mail_outline,
                              hintText: 'Enter your email address',
                              keyboardType: TextInputType.emailAddress,
                              readOnly: true,
                              validator: (val) {
                                if (val == null || val.isEmpty) {
                                  return 'Email address cannot be empty';
                                }
                                if (!val.contains('@')) {
                                  return 'Invalid email address';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 18),
                            _buildFieldLabel('Phone Number'),
                            _buildTextFormField(
                              controller: _phoneController,
                              icon: Icons.smartphone_outlined,
                              hintText: 'Enter your phone number',
                              keyboardType: TextInputType.phone,
                              readOnly: false,
                              validator: (val) {
                                if (val == null || val.trim().isEmpty) {
                                  return 'Phone number cannot be empty';
                                }
                                if (!RegExp(r'^[0-9]{10}$').hasMatch(val.trim())) {
                                  return 'Phone number must contain exactly 10 digits';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 18),
                            _buildFieldLabel('Home Address'),
                            _buildTextFormField(
                              controller: _addressController,
                              icon: Icons.home_outlined,
                              hintText: 'Enter your home address',
                              readOnly: false,
                              validator: (val) => val == null || val.isEmpty
                                  ? 'Address cannot be empty'
                                  : null,
                            ),
                            const SizedBox(height: 26),
                            SizedBox(
                              height: 55,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [_pink, _lavender],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),
                                  borderRadius: BorderRadius.circular(18),
                                  boxShadow: [
                                    BoxShadow(
                                      color: _pink.withOpacity(0.20),
                                      blurRadius: 15,
                                      offset: const Offset(0, 6),
                                    ),
                                  ],
                                ),
                                child: ElevatedButton(
                                  onPressed: loading ? null : _handleSaveChanges,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                  ),
                                  child: loading
                                      ? const SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                      : Text(
                                    'Save Changes',
                                    style: GoogleFonts.montserrat(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              height: 53,
                              child: OutlinedButton(
                                onPressed: () => context.pop(),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: _pink,
                                  backgroundColor: Colors.white.withOpacity(0.65),
                                  side: BorderSide(
                                    color: _pink.withOpacity(0.3),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                ),
                                child: Text(
                                  'Cancel',
                                  style: GoogleFonts.beVietnamPro(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: _pink,
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

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Material(
              color: Colors.white.withOpacity(0.55),
              child: InkWell(
                onTap: () {
                  if (context.canPop()) context.pop();
                },
                child: Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white.withOpacity(0.8)),
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
        ),
        const Expanded(
          child: Center(
            child: Text(
              'Edit Profile',
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

  Widget _buildProfileIdentity() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(26),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.82),
                Colors.white.withOpacity(0.48),
              ],
            ),
            borderRadius: BorderRadius.circular(26),
            border: Border.all(color: Colors.white.withOpacity(0.9)),
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
              GestureDetector(
                onTap: _openUpdatePhoto,
                child: Stack(
                  children: [
                    BlocBuilder<ProfileCubit, ProfileState>(
                      builder: (context, state) {
                        String avatar = 'avatar1';
                        if (state is ProfileLoaded && state.profile.avatar.isNotEmpty) {
                          avatar = state.profile.avatar;
                        }
                        return Container(
                          width: 76,
                          height: 76,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                            boxShadow: [
                              BoxShadow(
                                color: _pink.withOpacity(0.15),
                                blurRadius: 18,
                                offset: const Offset(0, 6),
                              ),
                            ],
                            image: DecorationImage(
                              image: AssetImage(AvatarHelper.getAvatarPath(avatar)),
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 27,
                        height: 27,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          border: Border.all(color: _pink.withOpacity(0.18)),
                        ),
                        child: const Icon(
                          Icons.camera_alt_rounded,
                          color: _pink,
                          size: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BlocBuilder<ProfileCubit, ProfileState>(
                      builder: (context, state) {
                        final name = state is ProfileLoaded
                            ? (state.profile.name.isNotEmpty ? state.profile.name : 'No Name')
                            : 'Your Profile';
                        return Text(
                          name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.montserrat(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            color: _dark,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Manage your personal information.',
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 11,
                        height: 1.5,
                        color: _muted,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Change profile photo',
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: _pink,
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

  Future<void> _openUpdatePhoto() async {
    await context.push(AppRoutes.updatePhoto);
    if (!mounted) return;
    final authState = context.read<AuthCubit>().state;
    if (authState is AuthAuthenticated) {
      await context.read<ProfileCubit>().loadProfile(authState.user.userId);
    }
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
      child: Icon(icon, color: _pink, size: 20),
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
          color: _pink,
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
        color: _dark,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: readOnly
            ? const Color(0xFFF8EFF5)
            : Colors.white.withOpacity(0.78),

        prefixIcon: Container(
          margin: const EdgeInsets.all(10),
          width: 35,
          height: 35,
          decoration: BoxDecoration(
            color: _pink.withOpacity(0.13),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(
            icon,
            size: 20,
            color: _pink,
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
        hintStyle: GoogleFonts.beVietnamPro(
          fontSize: 13,
          color: _muted.withOpacity(0.75),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 17, horizontal: 16),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: _lavender.withOpacity(0.18)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: _pink, width: 1.4),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Color(0xFFD95791)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Color(0xFFD95791), width: 1.4),
        ),
      ),
    );
  }
}