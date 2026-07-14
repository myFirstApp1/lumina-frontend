import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/contacts_cubit.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../data/models/emergency_contact_model.dart';
import '../../../../core/theme/app_theme.dart';

class AddContactScreen extends StatefulWidget {

  final EmergencyContactModel? contact;
  final int contactCount;

  const AddContactScreen({

    super.key,

    this.contact,

    this.contactCount = 0,

  });

  @override
  State<AddContactScreen> createState() =>
      _AddContactScreenState();
}

class _AddContactScreenState extends State<AddContactScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  // relationship
  String _selectedRelation = "Father";
  final List<String> _relations = [
    "Father",
    "Mother",
    "Brother",
    "Sister",
    "Husband",
    "Wife",
    "Friend",
    "Guardian",
    "Other",
  ];

  bool get isEditMode =>
      widget.contact != null;

  @override
  void initState() {
    super.initState();

    if (widget.contact != null) {

      _nameController.text =
          widget.contact!.name;

      _phoneController.text =
          widget.contact!.phoneNumber.replaceFirst("+91", "");

      _selectedRelation =
          widget.contact!.relation;

    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _saveContact() async {

    final authState =
        context.read<AuthCubit>().state;

    if (authState is! AuthAuthenticated) {
      return;
    }

    final request =
    EmergencyContactRequestModel(
      name: _nameController.text.trim(),
      phoneNumber: "+91${_phoneController.text.trim()}",
      relation: _selectedRelation,
    );

    if (isEditMode) {

      await context.read<ContactsCubit>().updateContact(
        authState.user.userId,
        widget.contact!.id,
        request,
      );

    } else {

      await context.read<ContactsCubit>().addContact(
        authState.user.userId,
        request,
      );

    }
  }

  /// emergency contact save
  void _handleContinue() async {
    if (_formKey.currentState!.validate()) {
      try {

        await _saveContact();

        if(!mounted) return;

        ScaffoldMessenger.of(context).hideCurrentSnackBar();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.green.shade600,
            elevation: 8,
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            duration: const Duration(seconds: 2),
            content: Row(
              children: [

                const Icon(
                  Icons.check_circle_outline,
                  color: Colors.white,
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Text(
                    isEditMode
                        ? "Contact updated successfully"
                        : "Contact added successfully",
                    style: GoogleFonts.beVietnamPro(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

              ],
            ),
          ),
        );

        context.pop(true);

      } catch (e) {

        if (!mounted) return;

        final message = e
            .toString()
            .replaceFirst("Exception: ", "")
            .trim();

        ScaffoldMessenger.of(context).hideCurrentSnackBar();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red.shade600,
            elevation: 8,
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            duration: const Duration(seconds: 3),
            content: Row(
              children: [

                const Icon(
                  Icons.error_outline_rounded,
                  color: Colors.white,
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Text(
                    message,
                    style: GoogleFonts.beVietnamPro(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),

              ],
            ),
          ),
        );

      }
    }
  }

  // relationshipPicker feature
  void _showRelationshipPicker() {

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      builder: (context) {

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(
              top: 12,
              bottom: 24,
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.70,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),

                const SizedBox(height: 20),

                Text(
                  "Select Relationship",
                  style: GoogleFonts.montserrat(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

              Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _relations.length,
                    itemBuilder: (context, index) {

                      final relation = _relations[index];

                      return ListTile(

                    leading: _relationshipIcon(relation),

                    title: Text(
                      relation,
                      style: GoogleFonts.beVietnamPro(),
                    ),

                    trailing: relation == _selectedRelation
                        ? const Icon(
                      Icons.check_circle,
                      color: AppTheme.primary,
                    )
                        : null,

                    onTap: () {

                      setState(() {
                        _selectedRelation = relation;
                      });

                      Navigator.pop(context);

                    },

                  );

                }),
              ),
              ],
             ),
            ),
          ),
        );

      },
    );

  }

  // delete feature
  Future<void> _confirmDelete() async {

    if (widget.contactCount <= 1) {

      _showCannotDeleteDialog();

      return;

    }

    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) {

        return AlertDialog(

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),

          title: Text(
            "Delete Contact?",
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.bold,
              color: AppTheme.primary,
            ),
          ),

          content: Text(
            "This contact will no longer receive emergency alerts.",
            style: GoogleFonts.beVietnamPro(),
          ),

          actions: [

            TextButton(

              onPressed: () {
                Navigator.pop(context, false);
              },

              child: const Text("Cancel"),

            ),

            ElevatedButton(

              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),

              onPressed: () {
                Navigator.pop(context, true);
              },

              child: const Text(
                "Delete",
              ),

            ),

          ],

        );

      },
    );

    if (confirm == true) {

      _deleteContact();

    }

  }

  void _showCannotDeleteDialog() {

    showDialog(

      context: context,

      builder: (_) {

        return AlertDialog(

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),

          title: Text(
            "Cannot Delete",
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.bold,
            ),
          ),

          content: Text(
            "Lumina Guardian requires at least one emergency contact.\n\nAdd another trusted contact before deleting this one.",
            style: GoogleFonts.beVietnamPro(),
          ),

          actions: [

            ElevatedButton(

              onPressed: () {
                Navigator.pop(context);
              },

              child: const Text("OK"),

            ),

          ],

        );

      },

    );

  }

  Future<void> _deleteContact() async {

    final authState =
        context.read<AuthCubit>().state;

    if (authState is! AuthAuthenticated) {
      return;
    }

    await context.read<ContactsCubit>().deleteContact(
      authState.user.userId,
      widget.contact!.id,
    );

    if (!mounted) return;

    Navigator.pop(context, "deleted");

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
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 40,),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [

                        InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () => context.pop(),
                          child: Container(
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
                            child: const Icon(
                              Icons.arrow_back_ios_new,
                              size: 18,
                              color: AppTheme.primary,
                            ),
                          ),
                        ),

                      ],
                    ),

                    const SizedBox(height: 28),

                    Center(
                      child: Container(
                        width: 84,
                        height: 84,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppTheme.primary.withOpacity(.08),
                        ),
                        child: const Icon(
                          Icons.person_add_alt_1,
                          size: 40,
                          color: AppTheme.primary,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    Text(
                      isEditMode
                          ? "Edit Contact"
                          : "Add Emergency Contact",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.montserrat(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      "Trusted people will receive\nSOS alerts immediately.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 15,
                        color: AppTheme.textSecondary,
                      ),
                    ),

                    const SizedBox(height: 36),
                    // Input Form (Glass Card)
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 25,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
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
                          const SizedBox(height: 24),

                          // Relationship
                          _buildFieldLabel("Relationship"),

                          GestureDetector(
                            onTap: _showRelationshipPicker,
                            child: Container(
                              height: 60,
                              padding: const EdgeInsets.symmetric(horizontal: 18),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              child: Row(
                                children: [

                                  const Icon(
                                    Icons.family_restroom_outlined,
                                    color: AppTheme.primary,
                                  ),

                                  const SizedBox(width: 14),

                                  Expanded(
                                    child: Text(
                                      _selectedRelation,
                                      style: GoogleFonts.beVietnamPro(
                                        fontSize: 16,
                                        color: AppTheme.textPrimary,
                                      ),
                                    ),
                                  ),

                                  const Icon(
                                    Icons.keyboard_arrow_right,
                                    color: AppTheme.textSecondary,
                                  ),

                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Phone Number
                          _buildFieldLabel("Phone Number"),
                          _buildTextFormField(
                            controller: _phoneController,
                            icon: Icons.call_outlined,
                            hintText: "9876543210",
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return "Enter phone number";
                              }

                              if (!RegExp(r'^[0-9]{10}$').hasMatch(value.trim())) {
                                return "Enter a valid 10-digit mobile number";
                              }

                              return null;
                            },
                          ),

                          const SizedBox(height: 24),
                          // Action Button
                          SizedBox(
                            width: double.infinity,
                            height: 58,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                    Color(0xFFC2185B),
                                    Color(0xFFFF5C93),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppTheme.primary.withOpacity(.30),
                                    blurRadius: 18,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: ElevatedButton(
                                onPressed: _handleContinue,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                child: Text(
                                  isEditMode
                                      ? "Update Contact"
                                      : "Save Contact",
                                  style: GoogleFonts.montserrat(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          if (isEditMode) ...[

                            const SizedBox(height: 18),

                            OutlinedButton.icon(

                              onPressed: _confirmDelete,

                              icon: const Icon(
                                Icons.delete_outline_rounded,
                                color: Colors.red,
                              ),

                              label: Text(
                                "Delete Contact",
                                style: GoogleFonts.montserrat(
                                  color: Colors.red,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),

                              style: OutlinedButton.styleFrom(
                                minimumSize: const Size(
                                  double.infinity,
                                  56,
                                ),
                                side: const BorderSide(
                                  color: Colors.red,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),

                            ),

                          ],
                        ],
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
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: AppTheme.primary,
        ),
      ),
    );
  }

  Widget _relationshipIcon(String relation) {

    switch (relation) {

      case "Father":
        return const Icon(
          Icons.man,
          color: AppTheme.primary,
        );

      case "Mother":
        return const Icon(
          Icons.woman,
          color: AppTheme.primary,
        );

      case "Brother":
        return const Icon(
          Icons.boy,
          color: AppTheme.primary,
        );

      case "Sister":
        return const Icon(
          Icons.girl,
          color: AppTheme.primary,
        );

      case "Husband":
        return const Icon(
          Icons.favorite,
          color: AppTheme.primary,
        );

      case "Wife":
        return const Icon(
          Icons.favorite_sharp,
          color: AppTheme.primary,
        );

      case "Friend":
        return const Icon(
          Icons.people,
          color: AppTheme.primary,
        );

      case "Guardian":
        return const Icon(
          Icons.shield,
          color: AppTheme.primary,
        );

      default:
        return const Icon(
          Icons.person,
          color: AppTheme.primary,
        );

    }

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
            color: AppTheme.primary,
            size: 24,
          ),
        ),
        hintText: hintText,
      ),
    );
  }
}
