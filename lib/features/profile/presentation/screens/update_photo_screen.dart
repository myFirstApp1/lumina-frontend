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
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
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
                                  ? AppTheme.primary
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
      body: Stack(
        children: [
          // Background soft canvas
          Container(
            color: const Color(0xFFFBF9F8), // AppTheme.background
          ),

          // Main content canvas scrollable to prevent bottom overflow
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24.0, 80.0, 24.0, 110.0),
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
                              width: 160,
                              height: 160,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 4,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppTheme.primary.withOpacity(.15),
                                    blurRadius: 24,
                                    offset: const Offset(0, 8),
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

                        const SizedBox(height: 22),

                        Text(
                          "Choose your profile picture",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.beVietnamPro(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 28),
                      ],
                    ),
                  ),



                  // Action items (bento grid / list)
                  Column(
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

                      const SizedBox(height: 24),

                    ],
                  ),
                ],
              ),
            ),
          ),

          // Custom transactional TopAppBar matching specs exactly
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [

                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primary.withOpacity(.08),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new_rounded),
                          color: AppTheme.primary,
                          onPressed: () => context.pop(),
                        ),
                      ),
                    ),

                    Text(
                      "Update Photo",
                      style: GoogleFonts.montserrat(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Bottom CTA Fixed button overlapping list with linear gradient
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    AppTheme.surface,
                    AppTheme.surface.withOpacity(0.96),
                    AppTheme.surface.withOpacity(0.70),
                    Colors.transparent,
                  ],
                ),
              ),
              child: SafeArea(
                top: false,
                child: SizedBox(
                  width: double.infinity,
                  height: 58,
                  child: ElevatedButton(
                    onPressed: loading ? null : _handleSaveChanges,
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      padding: EdgeInsets.zero,
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    child: Ink(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        gradient: const LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            AppTheme.primary,
                            Color(0xFFE95D96),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primary.withOpacity(0.30),
                            blurRadius: 24,
                            spreadRadius: 1,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Center(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 250),
                          child: loading
                              ? const SizedBox(
                            key: ValueKey("loading"),
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Colors.white,
                            ),
                          )
                              : Row(
                            key: const ValueKey("button"),
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.check_rounded,
                                color: Colors.white,
                                size: 22,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                "Save Changes",
                                style: GoogleFonts.beVietnamPro(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
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
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Ink(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primary.withOpacity(.05),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [

              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFEEF5),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(
                  icon,
                  color: AppTheme.primary,
                  size: 26,
                ),
              ),

              const SizedBox(width: 18),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text(
                      title,
                      style: GoogleFonts.montserrat(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      subtitle,
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 13,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F8F8),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: AppTheme.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
