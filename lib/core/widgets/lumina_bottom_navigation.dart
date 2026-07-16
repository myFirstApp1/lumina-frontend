import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../routes/app_routes.dart';
import '../theme/app_theme.dart';

class LuminaBottomNavigation extends StatelessWidget {

  final int currentIndex;

  const LuminaBottomNavigation({
    super.key,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {

    return Container(
        height: 75,
        decoration: BoxDecoration(
          color: AppTheme.surface.withOpacity(.92),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          border: Border(
            top: BorderSide(
              color: Colors.white.withOpacity(.45),
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.08),
              blurRadius: 28,
              spreadRadius: -6,
              offset: const Offset(0, -4),
            )
          ],
        ),

        child: SafeArea(
          top: false,

          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [

              Expanded(
                child: _buildNavItem(
                  context,
                  icon: Icons.home_rounded,
                  label: "Home",
                  index: 0,
                  route: AppRoutes.home,
                ),
              ),

              Expanded(
                child: _buildNavItem(
                  context,
                  label: "Tracking",
                  icon: Icons.location_searching_rounded,
                  index: 1,
                  route: AppRoutes.liveTracking,
                ),
              ),

              Expanded(
                child: _buildNavItem(
                  context,
                  icon: Icons.group_outlined,
                  label: "Contacts",
                  index: 2,
                  route: AppRoutes.contactsCircle,
                ),
              ),

              Expanded(
                child: _buildNavItem(
                  context,
                  // icon: Icons.family_restroom,
                  icon:Icons.history_rounded,
                  label: "Incidents", // Family
                  index: 3,
                  route: AppRoutes.incidentHistory,
                ),
              ),

              Expanded(
                child: _buildNavItem(
                  context,
                  icon: Icons.auto_awesome_outlined,
                  label: "AI",
                  index: 4,
                  route: AppRoutes.aiCompanion,
                ),
              ),
            ],
          ),
        ),
    );
  }

  Widget _buildNavItem(
      BuildContext context, {
        required IconData icon,
        required String label,
        required int index,
        required String route,
      }) {

    final selected = currentIndex == index;

    return InkWell(
      onTap: () {

        if (!selected) {
          context.go(route);
        }

      },

      borderRadius: BorderRadius.circular(26),

      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 8,
        ),

        child: Column(
          mainAxisSize: MainAxisSize.min,

          children: [

            AnimatedContainer(
              duration: const Duration(milliseconds: 250),

              padding: const EdgeInsets.all(6),

              decoration: BoxDecoration(
                color: selected
                    ? AppTheme.primary.withOpacity(.12)
                    : Colors.transparent,

                borderRadius: BorderRadius.circular(16),
              ),

              child: Icon(
                icon,
                size: 24,
                color: selected
                    ? AppTheme.primary
                    : AppTheme.textSecondary,
              ),
            ),

            const SizedBox(height: 3),

            Text(
              label,

              style: GoogleFonts.beVietnamPro(
                fontSize: 12,
                fontWeight: selected
                    ? FontWeight.bold
                    : FontWeight.w500,

                color: selected
                    ? AppTheme.primary
                    : AppTheme.textSecondary,
              ),
            )
          ],
        ),
      ),
    );
  }
}