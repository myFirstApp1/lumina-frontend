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
    final foregroundColor =
    isSecondary ? AppTheme.primary : AppTheme.onPrimary;

    final buttonShape = const StadiumBorder();

    final buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: Colors.transparent,
      foregroundColor: foregroundColor,
      disabledBackgroundColor: Colors.transparent,
      disabledForegroundColor: foregroundColor.withOpacity(0.75),
      shadowColor: Colors.transparent,
      elevation: 0,
      padding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 28,
      ),
      shape: buttonShape,
      textStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
        color: foregroundColor,
        fontWeight: FontWeight.w700,
      ),
    );

    final content = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isLoading)
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(foregroundColor),
            ),
          )
        else ...[
          if (icon != null) ...[
            Icon(icon, size: 20),
            const SizedBox(width: 8),
          ],
          Text(
            text,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: foregroundColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ],
    );

    final decoration = isSecondary
        ? BoxDecoration(
      color: Colors.white.withOpacity(0.88),
      borderRadius: BorderRadius.circular(9999),
      border: Border.all(
        color: AppTheme.outlineVariant,
        width: 1.2,
      ),
      boxShadow: AppTheme.softShadow,
    )
        : BoxDecoration(
      gradient: gradient ?? AppTheme.primaryGradient,
      borderRadius: BorderRadius.circular(9999),
      boxShadow: [
        BoxShadow(
          color: AppTheme.primary.withOpacity(0.18),
          blurRadius: 16,
          spreadRadius: 0,
          offset: const Offset(0, 6),
        ),
      ],
    );

    return Container(
      decoration: decoration,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: buttonStyle,
        child: content,
      ),
    );
  }
}
