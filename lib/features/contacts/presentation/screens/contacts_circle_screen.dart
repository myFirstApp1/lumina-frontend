import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_theme.dart';

class ContactsCircleScreen extends StatefulWidget {
  const ContactsCircleScreen({Key? key}) : super(key: key);

  @override
  State<ContactsCircleScreen> createState() => _ContactsCircleScreenState();
}

class _ContactsCircleScreenState extends State<ContactsCircleScreen> {
  List<dynamic> _contacts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  Future<void> _loadContacts() async {
    final prefs = await SharedPreferences.getInstance();
    final contactsJson = prefs.getString('emergency_contacts');
    if (contactsJson == null || jsonDecode(contactsJson).isEmpty) {
      // Seed default contacts
      final defaultContacts = [
        {
          'name': "Mom",
          'relationship': "Primary Contact",
          'phone': "+1 555-9876",
          'email': "mom@guardian.com",
          'avatarUrl': "https://lh3.googleusercontent.com/aida-public/AB6AXuDrAAMB14DZkbs0qe6Q-toj5MY8E6fBKgd1loNapUh68QCYiVmhXDUnR5d9XKzAV15M_UIpOWT3WJbXcTJVy5pBJw4kb14tKR8ZQQ7jWcue-nyc1eRxZt4VtcqhBPxD8bHQho0TpQvx2Dni5EgbuWwBJ1h1q72wH43__WvBbiG9IG3CBlq5CHXnBMI0JiN_l7k5ZYAMuIP7IYWze3xCb6jeJeQjoeyD224zpXg2nFEQ9r82urHY_P8jT846lW03idEzMm9NmzBg4bk",
          'isPrimary': true,
        },
        {
          'name': "Alex Chen",
          'relationship': "Partner",
          'phone': "+1 555-0123",
          'email': "alex.chen@lumina.com",
          'avatarUrl': "https://lh3.googleusercontent.com/aida-public/AB6AXuA1Zwf01TDFb2zq7bcVIu5vvFi4s5GDWQ3o5XxTo0djdJRn5mo8QhiAQ0NIm0UdnzkAOV4P439HAQXnbPvixBXxt9USAoIyGv801h5moMGAObchwDg1Hh0doaUcEWzxPYbVJPfm-3WEHYH0lzoOQW0du3VnXmQBAx3j5iSFCRL5FpHiAg8bvWKJFoy_Qp_I8qvJvmqpaQ5qlkwgLTgTMGe3Jt-P94sBplL6dZ6Uu05Q-Gv5GEDDP5aCYVvhpnKzpxcrkeK5o5_YsdA",
          'isPrimary': false,
        }
      ];
      await prefs.setString('emergency_contacts', jsonEncode(defaultContacts));
      if (mounted) {
        setState(() {
          _contacts = defaultContacts;
          _isLoading = false;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          _contacts = jsonDecode(contactsJson);
          _isLoading = false;
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

          // Glowing background decorative ambient highlights
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

          // Main Scrollable Body
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24.0, 80.0, 24.0, 110.0), // Padding for floating nav bar
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header Title Section & Add New Button
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Emergency Contacts",
                                  style: GoogleFonts.montserrat(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFFF06292),
                                  ),
                                ),
                                const SizedBox(height: 6.0),
                                Text(
                                  "Manage your trusted safety contacts.",
                                  style: GoogleFonts.beVietnamPro(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: AppTheme.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Add New Contact Button (h-12 gradient)
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton.icon(
                          onPressed: () => context.push(AppRoutes.addContact).then((_) => _loadContacts()),
                          icon: const Icon(Icons.person_add, size: 20),
                          label: Text(
                            "Add New Contact",
                            style: GoogleFonts.beVietnamPro(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24.0),
                            ),
                            elevation: 4,
                            shadowColor: AppTheme.primary.withOpacity(0.3),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Search Bar Input
                  Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE4E2E2).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.search,
                          color: AppTheme.outline,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            style: GoogleFonts.beVietnamPro(
                              fontSize: 15,
                              color: AppTheme.textPrimary,
                            ),
                            decoration: InputDecoration(
                              hintText: "Search contacts...",
                              hintStyle: GoogleFonts.beVietnamPro(
                                color: AppTheme.outline.withOpacity(0.6),
                              ),
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                              filled: false,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Contacts List Grid
                  _isLoading
                      ? const Center(child: CircularProgressIndicator(color: AppTheme.primary))
                      : Column(
                          children: [
                            ..._contacts.map((contact) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16.0),
                                child: _buildPriorityContactCard(
                                  context,
                                  name: contact['name'] ?? "",
                                  subtitle: contact['relationship'] ?? "",
                                  avatarUrl: contact['avatarUrl'] ?? "https://lh3.googleusercontent.com/aida-public/AB6AXuCTDylmOjPsGe4hVTugPTdT1pnyuqwH1aQ9EFmzm2Fq4Yrsif97vyw1J2pOzea8lSMDhAlleljutYISU52PTiAWZcytV_6EmT_eORS2F3r2Xvdw1cbqtrCQuuJu0cvaTLRq3TP3F7cSSAG3oKynAkFqBLIKfbtVtORDJMAS4FJGJrAfuQbLxvXqmZJJ7yffJnFPg1BVqoSzOyZCy23FfM_StMQLelin7ntCzuXFzCStsYhAYufQgh4e5hh9kq5daQJ1VLTZ0yU8bzI",
                                  hasIndicatorStrip: contact['isPrimary'] ?? false,
                                  onTap: () {
                                    context.push(AppRoutes.contactDetail).then((_) => _loadContacts());
                                  },
                                ),
                              );
                            }).toList(),

                            const SizedBox(height: 4),

                            // Dotted Empty State Card: Expand Your Contacts
                            GestureDetector(
                              onTap: () => context.push(AppRoutes.addContact).then((_) => _loadContacts()),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(24.0),
                                  border: Border.all(
                                    color: AppTheme.outlineVariant.withOpacity(0.6),
                                    width: 2.0,
                                    style: BorderStyle.solid, // solid border fallback
                                  ),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 48,
                                      height: 48,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppTheme.primaryContainer.withOpacity(0.1),
                                      ),
                                      child: const Icon(
                                        Icons.group_add_outlined,
                                        color: AppTheme.primary,
                                        size: 24,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      "Expand Your Contacts",
                                      style: GoogleFonts.montserrat(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.textPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "Manage your trusted safety contacts.",
                                      style: GoogleFonts.beVietnamPro(
                                        fontSize: 12,
                                        color: AppTheme.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                ],
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
                      // User photo profile left
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white.withOpacity(0.5), width: 1.0),
                          image: const DecorationImage(
                            image: NetworkImage(
                              "https://lh3.googleusercontent.com/aida/ADBb0uheO2xz_B69a8socQuO_Qv_rqplousYU4BIcbgIWSHeM1imJHuX2ng-SMp84jevenTjgoqf32-BfKGp8gMntpPtPbO0Lbl2AUbiCHNjRmA9CTDC5kCsn7z6IHlPg5ou_ALvRJjnfdL40ZdyFHtReryQ0CR9wi3rk9MfdPKnXx6185mV-x1i4WPfANmVKV5Z_QChksYf6lIy2vkzDpfbecyxw52TQnzTkSlTPEVqyk_nAXUjnag5eI0orN4",
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      // Title
                      Text(
                        "Lumina Guardian",
                        style: GoogleFonts.montserrat(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primary,
                        ),
                      ),
                      // Settings Icon Button on right
                      IconButton(
                        icon: const Icon(Icons.settings_outlined, color: AppTheme.primary),
                        onPressed: () => context.push(AppRoutes.settings),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Custom Center-Floating Bottom Navigation Bar (Contacts active!)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 85,
              decoration: BoxDecoration(
                color: AppTheme.surface.withOpacity(0.9),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16.0),
                  topRight: Radius.circular(16.0),
                ),
                border: Border(
                  top: BorderSide(color: Colors.white.withOpacity(0.4), width: 1.0),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 40.0,
                    offset: const Offset(0, -10),
                  )
                ],
              ),
              child: SafeArea(
                top: false,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildNavItem(context, Icons.health_and_safety_outlined, "Home", false, () {
                      context.go(AppRoutes.home);
                    }),
                    _buildNavItem(context, Icons.map_outlined, "Map", false, () {
                      context.push(AppRoutes.liveTracking);
                    }),

                    // Elevated Center SOS button overlapping top boundary
                    Transform.translate(
                      offset: const Offset(0, -18),
                      child: GestureDetector(
                        onTap: () => context.push(AppRoutes.sosActive),
                        child: Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [Color(0xFFDC2626), Color(0xFFB91C1C)],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                            border: Border.all(color: Colors.white.withOpacity(0.2), width: 1.0),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFDC2626).withOpacity(0.6),
                                blurRadius: 20.0,
                                offset: const Offset(0, 8),
                              )
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.emergency,
                                color: Colors.white,
                                size: 28,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                "SOS",
                                style: GoogleFonts.beVietnamPro(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    _buildNavItem(context, Icons.group, "Contacts", true, () {}),
                    _buildNavItem(context, Icons.auto_awesome_outlined, "AI Chat", false, () {
                      context.push(AppRoutes.aiCompanion);
                    }),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriorityContactCard(
    BuildContext context, {
    required String name,
    required String subtitle,
    required String avatarUrl,
    required bool hasIndicatorStrip,
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
          )
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Left indicator solid stripe if Mom/Primary
          if (hasIndicatorStrip)
            Positioned(
              left: 0,
              top: 16,
              bottom: 16,
              width: 3.5,
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.primary,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),

          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    if (hasIndicatorStrip) const SizedBox(width: 4),

                    // Avatar
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 4,
                          )
                        ],
                        image: DecorationImage(
                          image: NetworkImage(avatarUrl),
                          fit: BoxFit.cover,
                        ),
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
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            subtitle,
                            style: GoogleFonts.beVietnamPro(
                              fontSize: 12,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Edit button on right
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: hasIndicatorStrip
                            ? AppTheme.primaryContainer.withOpacity(0.1)
                            : AppTheme.surface,
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.edit,
                          color: hasIndicatorStrip ? AppTheme.primary : AppTheme.textSecondary,
                          size: 20,
                        ),
                        onPressed: onTap,
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

  Widget _buildNavItem(BuildContext context, IconData icon, String label, bool isActive, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? AppTheme.primary : AppTheme.textSecondary.withOpacity(0.8),
              size: 24,
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: GoogleFonts.beVietnamPro(
                fontSize: 12,
                fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                color: isActive ? AppTheme.primary : AppTheme.textSecondary.withOpacity(0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
