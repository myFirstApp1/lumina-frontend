import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_theme.dart';

class ContactDetailScreen extends StatefulWidget {
  const ContactDetailScreen({Key? key}) : super(key: key);

  @override
  State<ContactDetailScreen> createState() => _ContactDetailScreenState();
}

class _ContactDetailScreenState extends State<ContactDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  
  String _relationship = 'partner';


  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: "Alex Chen");
    _phoneController = TextEditingController(text: "+1 555-0123");
    _emailController = TextEditingController(text: "alex.chen@lumina.com");
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _handleSave() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Changes saved successfully",
            style: GoogleFonts.beVietnamPro(fontWeight: FontWeight.w600),
          ),
          backgroundColor: AppTheme.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      context.pop();
    }
  }

  void _handleRemoveContact() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
          child: AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            title: Text(
              "Remove Contact",
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            content: Text(
              "Are you sure you want to remove Alex Chen from your safety circle? They will no longer receive emergency alerts.",
              style: GoogleFonts.beVietnamPro(color: AppTheme.textSecondary),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "Cancel",
                  style: GoogleFonts.beVietnamPro(
                    color: AppTheme.textSecondary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "Alex Chen removed from shield circle",
                        style: GoogleFonts.beVietnamPro(fontWeight: FontWeight.w600),
                      ),
                      backgroundColor: AppTheme.error,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  );
                  this.context.go(AppRoutes.contactsCircle);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.error,
                  foregroundColor: Colors.white,
                ),
                child: Text(
                  "Remove",
                  style: GoogleFonts.beVietnamPro(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
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
            color: AppTheme.background,
          ),

          // Ambient Background Highlights
          Positioned(
            top: -100,
            left: -100,
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

          // Main Scrollable Content
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24.0, 80.0, 24.0, 48.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Profile Image Section with Studio Avatar and Edit Camera icon badge
                    Center(
                      child: GestureDetector(
                        onTap: () => context.push(
                          AppRoutes.contactUpdatePhoto,
                          extra: {
                            'name': _nameController.text,
                            'photoUrl': "https://lh3.googleusercontent.com/aida-public/AB6AXuBCdvYsBkhd9PGVt2hFU9zhm0mnJOhEuxhYnIhpPeUedKxHt5FM78Rf7qM_eqwg8nA9qdmQXzUFN6esdjaMediaBlhX66RYmWhapRd6RlzN61RTfQHRFEjLMgw7r1E7ES1puTu0ceQiBx_DjXnr0pmr6nYn-K3bdWJBd2O8TNtkjZK75b1nnwDdaV5TgW8uDNvZ253Dc6IOLMRHsS17eM_CWPcqGxKv7J1dWMB6FrI7umLmggxqzq32ohKsywVGGTxvkRha6bCvPG8",
                          },
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 128,
                              height: 128,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppTheme.primaryContainer.withOpacity(0.15),
                                    blurRadius: 24,
                                    offset: const Offset(0, 8),
                                  )
                                ],
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                                image: const DecorationImage(
                                  image: NetworkImage(
                                    "https://lh3.googleusercontent.com/aida-public/AB6AXuBCdvYsBkhd9PGVt2hFU9zhm0mnJOhEuxhYnIhpPeUedKxHt5FM78Rf7qM_eqwg8nA9qdmQXzUFN6esdjaMediaBlhX66RYmWhapRd6RlzN61RTfQHRFEjLMgw7r1E7ES1puTu0ceQiBx_DjXnr0pmr6nYn-K3bdWJBd2O8TNtkjZK75b1nnwDdaV5TgW8uDNvZ253Dc6IOLMRHsS17eM_CWPcqGxKv7J1dWMB6FrI7umLmggxqzq32ohKsywVGGTxvkRha6bCvPG8",
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            // Camera edit button badge overlapping
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Transform.translate(
                                offset: const Offset(-8, 4),
                                child: Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: const Color(0xFFF06292),
                                    border: Border.all(color: Colors.white, width: 2.0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      )
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.edit_square,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Form Fields Card (Glassmorphism styled bg)
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.85),
                        borderRadius: BorderRadius.circular(24.0),
                        border: Border.all(color: Colors.white.withOpacity(0.5), width: 1.0),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primaryContainer.withOpacity(0.08),
                            blurRadius: 20,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Full Name Field
                          _buildFieldLabel("Full Name"),
                          _buildTextFormField(
                            controller: _nameController,
                            icon: Icons.person_outline,
                            hintText: "Full Name",
                            validator: (val) => val == null || val.isEmpty ? "Name cannot be empty" : null,
                          ),
                          const SizedBox(height: 20),

                          // Relationship Dropdown Field
                          _buildFieldLabel("Relationship"),
                          _buildDropdownField(
                            value: _relationship,
                            icon: Icons.groups_outlined,
                            items: const [
                              DropdownMenuItem(value: 'partner', child: Text("Partner")),
                              DropdownMenuItem(value: 'family', child: Text("Family Member")),
                              DropdownMenuItem(value: 'friend', child: Text("Friend")),
                              DropdownMenuItem(value: 'colleague', child: Text("Colleague")),
                            ],
                            onChanged: (val) {
                              if (val != null) {
                                setState(() {
                                  _relationship = val;
                                });
                              }
                            },
                          ),
                          const SizedBox(height: 20),

                          // Phone Number Field
                          _buildFieldLabel("Phone Number"),
                          _buildTextFormField(
                            controller: _phoneController,
                            icon: Icons.call_outlined,
                            hintText: "Phone Number",
                            keyboardType: TextInputType.phone,
                            validator: (val) => val == null || val.isEmpty ? "Phone number cannot be empty" : null,
                          ),
                          const SizedBox(height: 20),

                          // Email Address Field
                          _buildFieldLabel("Email Address"),
                          _buildTextFormField(
                            controller: _emailController,
                            icon: Icons.mail_outline,
                            hintText: "Email Address",
                            keyboardType: TextInputType.emailAddress,
                            validator: null,
                          ),
                        ],
                      ),
                    ),



                    const SizedBox(height: 32),

                    // Action Buttons (Save Changes & Remove Contact)
                    Column(
                      children: [
                        // Save Changes Gradient Button
                        Container(
                          width: double.infinity,
                          height: 56,
                          decoration: BoxDecoration(
                            gradient: AppTheme.primaryGradient,
                            borderRadius: BorderRadius.circular(28.0),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.primary.withOpacity(0.25),
                                blurRadius: 16,
                                offset: const Offset(0, 6),
                              )
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: _handleSave,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              foregroundColor: Colors.white,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28.0),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Save Changes",
                                  style: GoogleFonts.montserrat(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Remove from Shield Circle button
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: TextButton(
                            onPressed: _handleRemoveContact,
                            style: TextButton.styleFrom(
                              foregroundColor: AppTheme.error,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28.0),
                              ),
                            ),
                            child: Text(
                              "Remove from Shield Circle",
                              style: GoogleFonts.beVietnamPro(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
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
                        "Edit Contact",
                        style: GoogleFonts.montserrat(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primary,
                        ),
                      ),
                      // Settings vertical dots options icon
                      PopupMenuButton<String>(
                        icon: const Icon(Icons.more_vert, color: AppTheme.primary),
                        onSelected: (val) {
                          if (val == 'remove') {
                            _handleRemoveContact();
                          }
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        color: Colors.white,
                        itemBuilder: (BuildContext context) => [
                          PopupMenuItem(
                            value: 'remove',
                            child: Row(
                              children: [
                                const Icon(Icons.delete_outline, color: AppTheme.error, size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  "Remove Contact",
                                  style: GoogleFonts.beVietnamPro(
                                    color: AppTheme.error,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
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
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: const BorderSide(color: AppTheme.outlineVariant, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: BorderSide(color: AppTheme.outlineVariant.withOpacity(0.5), width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: const BorderSide(color: AppTheme.primary, width: 2.0),
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String value,
    required IconData icon,
    required List<DropdownMenuItem<String>> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      items: items,
      onChanged: onChanged,
      style: GoogleFonts.beVietnamPro(
        fontSize: 16,
        color: AppTheme.textPrimary,
      ),
      icon: const Icon(Icons.expand_more, color: AppTheme.outline),
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
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: const BorderSide(color: AppTheme.outlineVariant, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: BorderSide(color: AppTheme.outlineVariant.withOpacity(0.5), width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: const BorderSide(color: AppTheme.primary, width: 2.0),
        ),
      ),
    );
  }


}
