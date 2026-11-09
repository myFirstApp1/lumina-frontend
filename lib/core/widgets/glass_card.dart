import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? borderRadius;
  final VoidCallback? onTap;

  const GlassCard({
    Key? key,
    required this.child,
    this.padding,
    this.borderRadius,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cardBorderRadius = BorderRadius.circular(borderRadius ?? 23.0);

    final cardContent = Container(
      decoration: BoxDecoration(
        // A soft translucent surface that matches the Edit Profile screen.
        color: AppTheme.cardSurface.withOpacity(0.72),
        borderRadius: cardBorderRadius,
        border: AppTheme.glassBorder,
        boxShadow: AppTheme.softShadow,
      ),
      padding: padding ?? const EdgeInsets.all(24.0),
      child: child,
    );

    if (onTap == null) {
      return cardContent;
    }

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        child: cardContent,
      ),
    );
  }
}