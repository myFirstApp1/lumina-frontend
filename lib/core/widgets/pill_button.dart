import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class PillButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final IconData? icon;
  final LinearGradient? gradient;
  final bool isSecondary;

  const PillButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
    this.gradient,
    this.isSecondary = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ButtonStyle baseStyle = ElevatedButton.styleFrom(
      backgroundColor: Colors.transparent,
      foregroundColor: isSecondary ? AppTheme.primary : AppTheme.onPrimary,
      shadowColor: Colors.transparent,
      elevation: 0,
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 28.0),
      shape: const StadiumBorder(),
    );

    Widget innerContent = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isLoading)
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2.0,
              valueColor: AlwaysStoppedAnimation<Color>(
                isSecondary ? AppTheme.primary : AppTheme.onPrimary,
              ),
            ),
          )
        else ...[
          if (icon != null) ...[
            Icon(icon, size: 20),
            const SizedBox(width: 8.0),
          ],
          Text(
            text,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: isSecondary ? AppTheme.primary : AppTheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ]
      ],
    );

    if (isSecondary) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(9999),
          border: Border.all(color: AppTheme.outlineVariant, width: 1.5),
          boxShadow: AppTheme.softShadow,
        ),
        child: ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: baseStyle,
          child: innerContent,
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        gradient: gradient ?? AppTheme.primaryGradient,
        borderRadius: BorderRadius.circular(9999),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withOpacity(0.3),
            blurRadius: 16.0,
            spreadRadius: 1.0,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: baseStyle,
        child: innerContent,
      ),
    );
  }
}
