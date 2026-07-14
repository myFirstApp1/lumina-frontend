import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/lumina_bottom_navigation.dart';
import '../cubit/contacts_cubit.dart';
import '../cubit/contacts_state.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_theme.dart';

class ContactsCircleScreen extends StatefulWidget {
  const ContactsCircleScreen({Key? key}) : super(key: key);

  @override
  State<ContactsCircleScreen> createState() => _ContactsCircleScreenState();
}

class _ContactsCircleScreenState extends State<ContactsCircleScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadContacts();
    });
  }

  void _loadContacts() {
    final authState = context.read<AuthCubit>().state;
    if (authState is AuthAuthenticated) {
      context.read<ContactsCubit>().loadContacts(authState.user.userId);
    }
  }

  // custom snack bar
  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.green.shade600,
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        content: Row(
          children: [
            const Icon(
              Icons.check_circle_outline,
              color: Colors.white,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background soft canvas
          Container(color: AppTheme.background),

          // Main Scrollable Body
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                20,
                28,
                20,
                120,
              ), // Padding for floating nav bar
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  BlocBuilder<ContactsCubit, ContactsState>(
                    builder: (context, state) {

                      if (state is ContactsLoading ||
                          state is ContactsInitial) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: AppTheme.primary,
                          ),
                        );
                      }

                      if (state is ContactsError) {
                        return Center(
                          child: Text(
                            "Error: ${state.message}",
                            style: const TextStyle(color: Colors.red),
                          ),
                        );
                      }

                      final contacts =
                          (state as ContactsLoaded).contacts;

                      return Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.stretch,
                        children: [

                          // Header
                          Center(
                            child: Column(
                              children: [

                                Container(
                                  width: 88,
                                  height: 88,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppTheme.primary.withOpacity(.08),
                                  ),
                                  child: Icon(
                                    Icons.groups_rounded,
                                    size: 42,
                                    color: AppTheme.primary,
                                  ),
                                ),

                                const SizedBox(height: 24),

                                Text(
                                  "Emergency Circle",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.montserrat(
                                    fontSize: 32,
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.textSecondary,
                                  ),
                                ),

                                const SizedBox(height: 8),

                                Text(
                                  contacts.isEmpty
                                      ? "No Emergency Contacts"
                                      : "${contacts.length} Emergency Contact${contacts.length == 1 ? "" : "s"}",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.beVietnamPro(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: AppTheme.textSecondary,
                                  ),
                                ),

                              ],
                            ),
                          ),

                          const SizedBox(height: 32),

                          if (contacts.isEmpty) ...[

                            const SizedBox(height: 60),

                            Center(
                              child: Column(
                                children: [

                                  Icon(
                                    Icons.groups_rounded,
                                    size: 72,
                                    color: AppTheme.primary.withOpacity(.35),
                                  ),

                                  const SizedBox(height: 18),

                                  Text(
                                    "No Emergency Contacts",
                                    style: GoogleFonts.montserrat(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(height: 10),

                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 24),
                                    child: Text(
                                      "Tap the Add Contact button below to build your trusted circle.",
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.beVietnamPro(
                                        fontSize: 15,
                                        color: AppTheme.textSecondary,
                                      ),
                                    ),
                                  ),

                                ],
                              ),
                            ),

                          ] else ...[

                            ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: contacts.length,
                              separatorBuilder: (_, __) =>
                              const SizedBox(height: 16),
                              itemBuilder: (context, index) {
                                final contact = contacts[index];
                                return _buildContactCard(

                                  context,

                                  name: contact.name.isNotEmpty
                                      ? contact.name
                                      : "Unknown",

                                  relation: contact.relation,
                                  phone: contact.phoneNumber,

                                  onTap: () {
                                    context.push(
                                      AppRoutes.addContact,
                                      extra: {
                                        "contact": contact,
                                        "contactCount": contacts.length,
                                      },
                                    ).then((result) {

                                      _loadContacts();

                                      if (!mounted) return;

                                      if (result == "deleted") {
                                        _showSuccessSnackBar("Contact deleted successfully");
                                      } else if (result == "updated") {
                                        _showSuccessSnackBar("Contact updated successfully");
                                      } else if (result == "added") {
                                        _showSuccessSnackBar("Contact added successfully");
                                      }

                                    });
                                  },
                                );
                              },
                            ),
                          ],
                        ],
                      );

                    },
                  ),

                const SizedBox(height: 16),

                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton:FloatingActionButton.extended(

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),

        heroTag: "add_contact",

        backgroundColor: AppTheme.primary,

        foregroundColor: Colors.white,

        elevation: 8,

        icon: const Icon(Icons.person_add),

        label: Text(
          "Add Contact",
          style: GoogleFonts.beVietnamPro(
            fontWeight: FontWeight.w600,
          ),
        ),

        onPressed: () {

          context
              .push(AppRoutes.addContact)
              .then((_) => _loadContacts());

        },

      ),

      floatingActionButtonLocation:
      FloatingActionButtonLocation.endFloat,

      bottomNavigationBar: const LuminaBottomNavigation(
        currentIndex: 2,
      ),
    );
  }

  Widget _buildContactCard(
    BuildContext context, {
    required String name,
    required String relation,
    required String phone,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(24.0),
        border: Border.all(color: Colors.white.withOpacity(0.5), width: 1.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 14,
                ),
                child: Row(
                  children: [
                    // Avatar
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppTheme.primary.withOpacity(.10),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.person,
                        color: AppTheme.primary,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),

                    // Content
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Text(
                            name,
                            style: GoogleFonts.montserrat(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          const SizedBox(height: 6),

                          Text(
                            relation,
                            style: GoogleFonts.beVietnamPro(
                              color: AppTheme.textSecondary,
                              fontSize: 15,
                            ),
                          ),

                        ],
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: AppTheme.primary,
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
}
