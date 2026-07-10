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

                      // if no contacts means it's display
                      if (contacts.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [

                              Icon(
                                Icons.groups_rounded,
                                size: 72,
                                color: AppTheme.primary.withOpacity(.35),
                              ),

                              const SizedBox(height: 20),

                              Text(
                                "No Emergency Contacts",
                                style: GoogleFonts.montserrat(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),

                              const SizedBox(height: 8),

                              Text(
                                "Tap the button below to add your first trusted contact.",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.beVietnamPro(
                                  color: AppTheme.textSecondary,
                                ),
                              ),

                            ],
                          ),
                        );
                      }
                      return Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.stretch,
                        children: [

                          // Header
                          Row(
                            children: [

                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [

                                    Text(
                                      "Trusted Circle",
                                      style: GoogleFonts.montserrat(
                                        fontSize: 28,
                                        fontWeight: FontWeight.w700,
                                        color: AppTheme.primary,
                                      ),
                                    ),

                                    const SizedBox(height: 6),

                                    Text(
                                      "${contacts.length} Emergency Contact${contacts.length == 1 ? "" : "s"}",
                                      style: GoogleFonts.beVietnamPro(
                                        fontSize: 14,
                                        color: AppTheme.textSecondary,
                                      ),
                                    ),

                                  ],
                                ),
                              ),

                            ],
                          ),


                          const SizedBox(height: 20),

                          ListView.separated(
                            shrinkWrap: true,
                            physics:
                            const NeverScrollableScrollPhysics(),
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
                                  )
                                      .then((_) => _loadContacts());
                                },
                              );

                            },
                          ),

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
