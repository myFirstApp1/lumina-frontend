import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/contacts_cubit.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../data/models/emergency_contact_model.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_theme.dart';

class AddContactScreen extends StatefulWidget {
  const AddContactScreen({Key? key}) : super(key: key);

  @override
  State<AddContactScreen> createState() => _AddContactScreenState();
}

class _AddContactScreenState extends State<AddContactScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _relationController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _relationController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  String? _photoUrl;

  void _showPhotoPickerOptions() {
    final List<String> avatars = [
      "https://lh3.googleusercontent.com/aida-public/AB6AXuBCdvYsBkhd9PGVt2hFU9zhm0mnJOhEuxhYnIhpPeUedKxHt5FM78Rf7qM_eqwg8nA9qdmQXzUFN6esdjaMediaBlhX66RYmWhapRd6RlzN61RTfQHRFEjLMgw7r1E7ES1puTu0ceQiBx_DjXnr0pmr6nYn-K3bdWJBd2O8TNtkjZK75b1nnwDdaV5TgW8uDNvZ253Dc6IOLMRHsS17eM_CWPcqGxKv7J1dWMB6FrI7umLmggxqzq32ohKsywVGGTxvkRha6bCvPG8",
      "https://lh3.googleusercontent.com/aida-public/AB6AXuCTDylmOjPsGe4hVTugPTdT1pnyuqwH1aQ9EFmzm2Fq4Yrsif97vyw1J2pOzea8lSMDhAlleljutYISU52PTiAWZcytV_6EmT_eORS2F3r2Xvdw1cbqtrCQuuJu0cvaTLRq3TP3F7cSSAG3oKynAkFqBLIKfbtVtORDJMAS4FJGJrAfuQbLxvXqmZJJ7yffJnFPg1BVqoSzOyZCy23FfM_StMQLelin7ntCzuXFzCStsYhAYufQgh4e5hh9kq5daQJ1VLTZ0yU8bzI",
      "https://lh3.googleusercontent.com/aida-public/AB6AXuA1Zwf01TDFb2zq7bcVIu5vvFi4s5GDWQ3o5XxTo0djdJRn5mo8QhiAQ0NIm0UdnzkAOV4P439HAQXnbPvixBXxt9USAoIyGv801h5moMGAObchwDg1Hh0doaUcEWzxPYbVJPfm-3WEHYH0lzoOQW0du3VnXmQBAx3j5iSFCRL5FpHiAg8bvWKJFoy_Qp_I8qvJvmqpaQ5qlkwgLTgTMGe3Jt-P94sBplL6dZ6Uu05Q-Gv5GEDDP5aCYVvhpnKzpxcrkeK5o5_YsdA",
      "https://lh3.googleusercontent.com/aida-public/AB6AXuDrAAMB14DZkbs0qe6Q-toj5MY8E6fBKgd1loNapUh68QCYiVmhXDUnR5d9XKzAV15M_UIpOWT3WJbXcTJVy5pBJw4kb14tKR8ZQQ7jWcue-nyc1eRxZt4VtcqhBPxD8bHQho0TpQvx2Dni5EgbuWwBJ1h1q72wH43__WvBbiG9IG3CBlq5CHXnBMI0JiN_l7k5ZYAMuIP7IYWze3xCb6jeJeQjoeyD224zpXg2nFEQ9r82urHY_P8jT846lW03idEzMm9NmzBg4bk",
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "Choose Contact Photo",
                  style: GoogleFonts.montserrat(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Select a safety contact avatar template or upload a custom image.",
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 14,
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 90,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: avatars.length,
                    separatorBuilder: (context, index) => const SizedBox(width: 16),
                    itemBuilder: (context, index) {
                      final url = avatars[index];
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _photoUrl = url;
                          });
                          Navigator.pop(context);
                        },
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: _photoUrl == url ? AppTheme.primary : Colors.transparent,
                              width: 3,
                            ),
                            image: DecorationImage(
                              image: NetworkImage(url),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                OutlinedButton.icon(
                  onPressed: () {
                    setState(() {
                      _photoUrl = "https://lh3.googleusercontent.com/aida/ADBb0uheO2xz_B69a8socQuO_Qv_rqplousYU4BIcbgIWSHeM1imJHuX2ng-SMp84jevenTjgoqf32-BfKGp8gMntpPtPbO0Lbl2AUbiCHNjRmA9CTDC5kCsn7z6IHlPg5ou_ALvRJjnfdL40ZdyFHtReryQ0CR9wi3rk9MfdPKnXx6185mV-x1i4WPfANmVKV5Z_QChksYf6lIy2vkzDpfbecyxw52TQnzTkSlTPEVqyk_nAXUjnag5eI0orN4";
                    });
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "Custom photo uploaded successfully!",
                          style: GoogleFonts.beVietnamPro(fontWeight: FontWeight.w600),
                        ),
                        backgroundColor: AppTheme.success,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    );
                  },
                  icon: const Icon(Icons.photo_library),
                  label: const Text("Upload Custom Photo"),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.primary,
                    side: const BorderSide(color: AppTheme.primary),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _saveContact() async {
    final authState = context.read<AuthCubit>().state;
    if (authState is AuthAuthenticated) {
      final req = EmergencyContactRequestModel(
        name: _nameController.text,
        phoneNumber: _phoneController.text,
        relation: _relationController.text,
      );
      await context.read<ContactsCubit>().addContact(authState.user.id, req);
    }
  }

  void _handleContinue() async {
    if (_formKey.currentState!.validate()) {
      await _saveContact();
      if (mounted) {
        // Navigate to success screen passing contact details via route state
        context.push(
          AppRoutes.contactSuccess,
          extra: {
            'name': _nameController.text,
            'relationship': _relationController.text,
            'avatarUrl': _photoUrl ?? "https://lh3.googleusercontent.com/aida-public/AB6AXuCTDylmOjPsGe4hVTugPTdT1pnyuqwH1aQ9EFmzm2Fq4Yrsif97vyw1J2pOzea8lSMDhAlleljutYISU52PTiAWZcytV_6EmT_eORS2F3r2Xvdw1cbqtrCQuuJu0cvaTLRq3TP3F7cSSAG3oKynAkFqBLIKfbtVtORDJMAS4FJGJrAfuQbLxvXqmZJJ7yffJnFPg1BVqoSzOyZCy23FfM_StMQLelin7ntCzuXFzCStsYhAYufQgh4e5hh9kq5daQJ1VLTZ0yU8bzI",
          },
        );
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
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Profile Image Uploader
                    Center(
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: _showPhotoPickerOptions,
                            child: Stack(
                              children: [
                                Container(
                                  width: 112,
                                  height: 112,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white.withOpacity(0.8),
                                    border: Border.all(
                                      color: AppTheme.primaryContainer.withOpacity(0.3),
                                      width: 1.0,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppTheme.primary.withOpacity(0.06),
                                        blurRadius: 16,
                                      )
                                    ],
                                    image: _photoUrl != null
                                        ? DecorationImage(
                                            image: NetworkImage(_photoUrl!),
                                            fit: BoxFit.cover,
                                          )
                                        : null,
                                  ),
                                  child: _photoUrl == null
                                      ? const Icon(
                                          Icons.add_a_photo,
                                          color: AppTheme.primaryContainer,
                                          size: 32,
                                        )
                                      : null,
                                ),
                                // Dashed border simulator overlay
                                Positioned.fill(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: AppTheme.primaryContainer.withOpacity(0.4),
                                        width: 2,
                                        style: BorderStyle.solid, // solid fallback
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          GestureDetector(
                            onTap: _showPhotoPickerOptions,
                            child: Text(
                              "Tap to add photo",
                              style: GoogleFonts.beVietnamPro(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Input Form (Glass Card)
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(24.0),
                        border: Border.all(color: Colors.white.withOpacity(0.5), width: 1.0),
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
                          // Full Name
                          _buildFieldLabel("Full Name"),
                          _buildTextFormField(
                            controller: _nameController,
                            icon: Icons.person_outline,
                            hintText: "e.g. Jane Doe",
                            validator: (val) => val == null || val.isEmpty ? "Name cannot be empty" : null,
                          ),
                          const SizedBox(height: 20),

                          // Relationship
                          _buildFieldLabel("Relationship"),
                          _buildTextFormField(
                            controller: _relationController,
                            icon: Icons.family_restroom_outlined,
                            hintText: "e.g. Mom, Partner, Friend",
                            validator: (val) => val == null || val.isEmpty ? "Relationship cannot be empty" : null,
                          ),
                          const SizedBox(height: 20),

                          // Phone Number
                          _buildFieldLabel("Phone Number"),
                          _buildTextFormField(
                            controller: _phoneController,
                            icon: Icons.call_outlined,
                            hintText: "+1 (555) 000-0000",
                            keyboardType: TextInputType.phone,
                            validator: (val) => val == null || val.isEmpty ? "Phone number cannot be empty" : null,
                          ),
                          const SizedBox(height: 20),

                          // Email Address
                          _buildFieldLabel("Email Address (Optional)"),
                          _buildTextFormField(
                            controller: _emailController,
                            icon: Icons.mail_outline,
                            hintText: "jane@example.com",
                            keyboardType: TextInputType.emailAddress,
                            validator: null,
                          ),
                          const SizedBox(height: 32),

                          // Action Button
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: _handleContinue,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.primary,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(28.0),
                                ),
                                elevation: 8,
                                shadowColor: AppTheme.primary.withOpacity(0.3),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Continue",
                                    style: GoogleFonts.montserrat(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Icon(Icons.arrow_forward, size: 18),
                                ],
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
          ),

          // Custom TopAppBar matching HTML specifications exactly
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
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Back button
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: AppTheme.primary),
                        onPressed: () => context.pop(),
                      ),
                      // Title
                      Text(
                        "Add New Contact",
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
          fontWeight: FontWeight.bold,
          color: AppTheme.primaryContainer,
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
            color: AppTheme.textSecondary,
            size: 24,
          ),
        ),
        hintText: hintText,
      ),
    );
  }
}
