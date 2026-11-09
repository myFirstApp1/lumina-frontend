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
        color: AppTheme.surface.withOpacity(0.94),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(23),
          topRight: Radius.circular(23),
        ),
        border: Border(
          top: BorderSide(
            color: Colors.white.withOpacity(0.85),
            width: 1.2,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withOpacity(0.07),
            blurRadius: 24,
            spreadRadius: -5,
            offset: const Offset(0, -4),
          ),
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
                label: 'Home',
                index: 0,
                route: AppRoutes.home,
              ),
            ),
            Expanded(
              child: _buildNavItem(
                context,
                label: 'Tracking',
                icon: Icons.location_searching_rounded,
                index: 1,
                route: AppRoutes.liveTracking,
              ),
            ),
            Expanded(
              child: _buildNavItem(
                context,
                icon: Icons.group_outlined,
                label: 'Contacts',
                index: 2,
                route: AppRoutes.contactsCircle,
              ),
            ),
            Expanded(
              child: _buildNavItem(
                context,
                icon: Icons.history_rounded,
                label: 'Incidents',
                index: 3,
                route: AppRoutes.incidentHistory,
              ),
            ),
            Expanded(
              child: _buildNavItem(
                context,
                icon: Icons.auto_awesome_outlined,
                label: 'AI',
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
              curve: Curves.easeInOut,
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: selected
                    ? AppTheme.primary.withOpacity(0.12)
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
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.beVietnamPro(
                fontSize: 12,
                fontWeight:
                selected ? FontWeight.w700 : FontWeight.w500,
                color: selected
                    ? AppTheme.primary
                    : AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}