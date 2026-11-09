import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../cubit/profile_cubit.dart';
import '../cubit/profile_state.dart';

class UpdatePhotoScreen extends StatefulWidget {
  const UpdatePhotoScreen({Key? key}) : super(key: key);

  @override
  State<UpdatePhotoScreen> createState() => _UpdatePhotoScreenState();
}

class _UpdatePhotoScreenState extends State<UpdatePhotoScreen> {
  static const Color _pink = Color(0xFFD95791);
  static const Color _lavender = Color(0xFFAA91D8);
  static const Color _dark = Color(0xFF393044);
  static const Color _muted = Color(0xFF898193);

  final ImagePicker _picker = ImagePicker();
  File? selectedImage;

  int selectedAvatar = 0;
  String selectedAvatarId = "avatar1";
  bool loading = false;
  final List<String> avatars = [
    "assets/avatars/avatar1.png",
    "assets/avatars/avatar2.png",
    "assets/avatars/avatar3.png",
    "assets/avatars/avatar4.png",
    "assets/avatars/avatar5.png",
    "assets/avatars/avatar6.png",
    "assets/avatars/avatar7.png",
    "assets/avatars/avatar8.png",
    "assets/avatars/avatar9.png",
    "assets/avatars/avatar10.png",
  ];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final profileState = context.read<ProfileCubit>().state;

      if (profileState is ProfileLoaded) {
        final profile = profileState.profile;

        if (profile.avatar.isNotEmpty) {
          selectedAvatarId = profile.avatar;

          final index = avatars.indexWhere(
                (path) => path.contains(profile.avatar),
          );

          if (index != -1) {
            setState(() {
              selectedAvatar = index;
            });
          }
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _handleSaveChanges() async {
    debugPrint("========== UPDATE PROFILE ==========");
    debugPrint("Avatar = $selectedAvatarId");

    setState(() {
      loading = true;
    });

    try {
      final authState = context
          .read<AuthCubit>()
          .state;

      if (authState is! AuthAuthenticated) {
        return;
      }

      final profileState = context
          .read<ProfileCubit>()
          .state;

      if (profileState is! ProfileLoaded) {
        return;
      }

      final profile = profileState.profile;

      debugPrint("=================================");
      debugPrint("SELECTED AVATAR ID = $selectedAvatarId");
      debugPrint("PROFILE AVATAR = ${profile.avatar}");

      final updatedProfile = profile.copyWith(
        avatar: selectedAvatarId,
      );

      debugPrint("==================================");
      debugPrint("SELECTED AVATAR = $selectedAvatarId");
      debugPrint("PROFILE AVATAR = ${profile.avatar}");
      debugPrint(updatedProfile.toJson().toString());
      debugPrint("==================================");

      await context.read<ProfileCubit>().updateProfile(
        authState.user.userId,
        updatedProfile,
      );

      if (!mounted) return;

      context.pop(true);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppTheme.success,
          content: Text(
            "Profile photo updated successfully.",
            style: GoogleFonts.beVietnamPro(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }
    finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  Future<void> pickFromGallery() async {
    debugPrint("IMAGE_SELECTED");
    final XFile? file = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (file == null) return;

    setState(() {
      selectedImage = File(file.path);
    });

    debugPrint("IMAGE PATH:");
    debugPrint(file.path);
  }

  Future<void> takePhoto() async {
    debugPrint("OPENING_PICKER");
    final XFile? file = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );

    if (file == null) return;

    setState(() {
      selectedImage = File(file.path);
    });
  }

  void _showAvatarPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFFFFF7FA),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(26),
        ),
      ),
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  Text(
                    "Choose an Avatar",
                    style: GoogleFonts.montserrat(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 24),

                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: avatars.length,
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemBuilder: (context, index) {
                      final selected = selectedAvatar == index;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedAvatar = index;
                            selectedAvatarId = "avatar${index + 1}";
                            selectedImage = null;

                            debugPrint("SELECTED AVATAR = $selectedAvatarId");
                          });

                          Navigator.pop(context);
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: selected
                                  ? const Color(0xFFD95791)
                                  : Colors.transparent,
                              width: 3,
                            ),
                          ),
                          child: CircleAvatar(
                            backgroundImage: AssetImage(avatars[index]),
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
    );
  }

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
            top: 110,
            right: -90,
            child: _glowCircle(210, const Color(0xFFFFC6DD)),
          ),
          Positioned(
            top: 430,
            left: -100,
            child: _glowCircle(220, const Color(0xFFDCCFFF)),
          ),

          // Main content canvas scrollable to prevent bottom overflow
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20.0, 78.0, 20.0, 36.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Photo Preview Section
                  Center(
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            // Photo preview
                            Container(
                              width: 132,
                              height: 132,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 4,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: _pink.withOpacity(0.15),
                                    blurRadius: 18,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: ClipOval(
                                child: selectedImage != null
                                    ? Image.file(
                                  selectedImage!,
                                  fit: BoxFit.cover,
                                )
                                    : Image.asset(
                                  avatars[selectedAvatar],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 18),

                        Text(
                          "Choose your profile picture",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.montserrat(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: _dark,
                          ),
                        ),
                        const SizedBox(height: 7),
                        Text(
                          "Personalize your Lumina Guardian profile",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.beVietnamPro(
                            fontSize: 11,
                            color: _muted,
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),



                  // One shared glass content card, matching Edit Profile
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
                        child: Column(
                          children: [
                            // Choose an Avatar
                            _buildActionItem(
                              icon: Icons.face_retouching_natural,
                              title: "Avatar Collection",
                              subtitle: "Choose from 10 premium avatars",
                              onTap: _showAvatarPicker,
                            ),
                            const SizedBox(height: 12),

                            // Choose from gallery
                            _buildActionItem(
                              icon: Icons.photo_library_outlined,
                              title: "Choose from Gallery",
                              subtitle: "Select a photo from your device",
                              onTap: pickFromGallery,
                            ),
                            const SizedBox(height: 12),

                            // Take photo
                            _buildActionItem(
                              icon: Icons.photo_camera_outlined,
                              title: "Take Photo",
                              subtitle: "Capture a new profile picture",
                              onTap: takePhoto,
                            ),

                            const SizedBox(height: 12),

                            // Save button - same style as Edit Profile
                            SizedBox(
                              width: double.infinity,
                              height: 55,
                              child: ElevatedButton(
                                onPressed: loading ? null : _handleSaveChanges,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  elevation: 0,
                                  padding: EdgeInsets.zero,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                ),
                                child: Ink(
                                  width: double.infinity,
                                  height: 55,
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [_pink, _lavender],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(18),
                                    ),
                                  ),
                                  child: Center(
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
                                      "Save Changes",
                                      style: GoogleFonts.montserrat(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),

                            // Cancel button - same style as Edit Profile
                            SizedBox(
                              width: double.infinity,
                              height: 53,
                              child: TextButton(
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
                                  "Cancel",
                                  style: GoogleFonts.beVietnamPro(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: _pink,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 98),
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
          ),

          // Header styled to match Edit Profile.
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                        child: Material(
                          color: Colors.white.withOpacity(0.55),
                          child: InkWell(
                            onTap: () => context.pop(),
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
                    ),
                    const Expanded(
                      child: Center(
                        child: Text(
                          'Update Photo',
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
                ),
              ),
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
        color: color.withOpacity(.35),
      ),
    );
  }

  Widget _buildActionItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          decoration: BoxDecoration(
            color: const Color(0xFFF8EFF5),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: _lavender.withOpacity(0.18)),
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: _pink.withOpacity(0.13),
                ),
                child: Icon(
                  icon,
                  color: _pink,
                  size: 20,
                ),
              ),
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
              const Icon(
                Icons.chevron_right_rounded,
                color: Color(0xFF898193),
                size: 21,
              ),
            ],
          ),
        ),
      ),
    );
  }
}