import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_theme.dart';
import '../cubit/auth_cubit.dart';
import '../../../protection/presentation/cubit/protection_cubit.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true;

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthCubit>().login(
            _emailController.text.trim(),
            _passwordController.text,
          );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: AppTheme.background,
        ),
        child: Stack(
          children: [
            // Decorative background glowing circular blur orbs matching the HTML style
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 350,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFF06292).withOpacity(0.08),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 80.0, sigmaY: 80.0),
                  child: Container(color: Colors.transparent),
                ),
              ),
            ),
            Positioned(
              bottom: -50,
              right: -50,
              width: 300,
              height: 300,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFAB2C5D).withOpacity(0.05),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 70.0, sigmaY: 70.0),
                  child: Container(color: Colors.transparent),
                ),
              ),
            ),

            // Main body content
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
                  child: BlocListener<AuthCubit, AuthState>(
                    listener: (context, state) async {
                      if (state is AuthAuthenticated) {

                        await context
                            .read<ProtectionCubit>()
                            .startProtection(
                          state.user.userId,
                        );

                        context.go(
                          AppRoutes.locationInit,
                        );
                      } else if (state is AuthError) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(state.message),
                            backgroundColor: AppTheme.error,
                          ),
                        );
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(32.0),
                        border: Border.all(color: Colors.white.withOpacity(0.6), width: 1.0),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFF06292).withOpacity(0.08),
                            blurRadius: 40,
                            spreadRadius: 2,
                            offset: const Offset(0, 12),
                          )
                        ],
                      ),
                      padding: const EdgeInsets.all(28.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                          // Top header glowing heart icon
                          Center(
                            child: Container(
                              width: 64,
                              height: 64,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppTheme.primaryContainer.withOpacity(0.1),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppTheme.primaryContainer.withOpacity(0.05),
                                    blurRadius: 4,
                                    spreadRadius: 1,
                                  )
                                ],
                              ),
                              child: const Icon(
                                Icons.shield_moon_outlined,
                                color: AppTheme.primaryContainer,
                                size: 32,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16.0),

                          // Welcome back titles
                          Text(
                            "Welcome back",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.montserrat(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textPrimary,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 4.0),
                          Text(
                            "to your safe space.",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.montserrat(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 28.0),

                          // email input field
                          _buildLabel("Email"),
                          _buildInputField(
                            controller: _emailController,
                            hint: "Enter your email",
                            icon: Icons.person_outline,
                            validator: (val) {
                              if (val == null || val.isEmpty) return "email is required";
                              return null;
                            },
                          ),
                          const SizedBox(height: 16.0),

                          // Password input field
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildLabel("Password"),
                              GestureDetector(
                                onTap: () => context.push(AppRoutes.forgotPassword),
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 8.0, bottom: 4.0),
                                  child: Text(
                                    "Forgot?",
                                    style: GoogleFonts.montserrat(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.primary,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          _buildInputField(
                            controller: _passwordController,
                            hint: "••••••••",
                            icon: Icons.lock_outline,
                            isPassword: true,
                            obscureText: _obscurePassword,
                            togglePassword: () => setState(() => _obscurePassword = !_obscurePassword),
                            validator: (val) => val == null || val.isEmpty ? "Password is required" : null,
                          ),
                          const SizedBox(height: 24.0),

                          // Sign In Button (gradient/pill matched to primaryContainer)
                          Builder(
                            builder: (context) {
                              final isLoading = context.watch<AuthCubit>().state is AuthLoading;
                              return Container(
                                height: 52,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(9999),
                                  color: AppTheme.primaryContainer,
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppTheme.primaryContainer.withOpacity(0.2),
                                      blurRadius: 12,
                                      spreadRadius: 1,
                                      offset: const Offset(0, 4),
                                    )
                                  ],
                                ),
                                child: ElevatedButton(
                                  onPressed: isLoading ? null : _handleLogin,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    foregroundColor: AppTheme.onPrimaryContainer,
                                    shadowColor: Colors.transparent,
                                    shape: const StadiumBorder(),
                                  ),
                                  child: isLoading
                                      ? const SizedBox(
                                          width: 24,
                                          height: 24,
                                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                        )
                                      : Text(
                                          "Sign In",
                                          style: GoogleFonts.montserrat(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                ),
                              );
                            }
                          ),
                          const SizedBox(height: 24.0),

                          // Divider
                          Row(
                            children: [
                              const Expanded(child: Divider(color: AppTheme.outlineVariant)),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                child: Text(
                                  "Or continue with",
                                  style: GoogleFonts.montserrat(
                                    fontSize: 12,
                                    color: AppTheme.textSecondary.withOpacity(0.6),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              const Expanded(child: Divider(color: AppTheme.outlineVariant)),
                            ],
                          ),
                          const SizedBox(height: 20.0),

                          // Social Login Row
                          Row(
                            children: [
                              Expanded(
                                child: _buildSocialButton(
                                  text: "Google",
                                  iconSvg: _buildGoogleSvg(),
                                  onTap: () {},
                                ),
                              ),
                              const SizedBox(width: 12.0),
                              Expanded(
                                child: _buildSocialButton(
                                  text: "Apple",
                                  iconSvg: _buildAppleSvg(),
                                  onTap: () {},
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24.0),

                          // Create Account redirection link
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Don't have an account? ",
                                style: GoogleFonts.beVietnamPro(
                                  fontSize: 14,
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                              GestureDetector(
                                onTap: () => context.push(AppRoutes.signup),
                                child: Text(
                                  "Create one",
                                  style: GoogleFonts.beVietnamPro(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.primary,
                                    decoration: TextDecoration.underline,
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
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, bottom: 6.0),
      child: Text(
        text,
        style: GoogleFonts.montserrat(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppTheme.textSecondary,
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? togglePassword,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5F3F3),
        borderRadius: BorderRadius.circular(9999),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        validator: validator,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.beVietnamPro(color: AppTheme.textSecondary.withOpacity(0.4)),
          prefixIcon: Icon(icon, color: AppTheme.textSecondary.withOpacity(0.5)),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    obscureText ? Icons.visibility : Icons.visibility_off,
                    color: AppTheme.textSecondary.withOpacity(0.5),
                  ),
                  onPressed: togglePassword,
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 14.0),
        ),
        style: GoogleFonts.beVietnamPro(
          fontSize: 15,
          color: AppTheme.textPrimary,
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    required String text,
    required Widget iconSvg,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(9999),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F3F3),
          borderRadius: BorderRadius.circular(9999),
          border: Border.all(color: Colors.transparent),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            iconSvg,
            const SizedBox(width: 8),
            Text(
              text,
              style: GoogleFonts.beVietnamPro(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoogleSvg() {
    return SizedBox(
      width: 18,
      height: 18,
      child: CustomPaint(
        painter: GoogleIconPainter(),
      ),
    );
  }

  Widget _buildAppleSvg() {
    return const Icon(
      Icons.apple,
      color: Colors.black,
      size: 20,
    );
  }
}

class GoogleIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..style = PaintingStyle.fill;
    final double w = size.width;
    final double h = size.height;

    paint.color = const Color(0xFF4285F4);
    final Path bluePath = Path()
      ..moveTo(w * 0.98, h * 0.51)
      ..cubicTo(w * 0.98, h * 0.47, w * 0.97, h * 0.44, w * 0.97, h * 0.40)
      ..lineTo(w * 0.50, h * 0.40)
      ..lineTo(w * 0.50, h * 0.59)
      ..lineTo(w * 0.77, h * 0.59)
      ..cubicTo(w * 0.76, h * 0.67, w * 0.71, h * 0.73, w * 0.65, h * 0.77)
      ..lineTo(w * 0.65, h * 0.77)
      ..lineTo(w * 0.80, h * 0.89)
      ..cubicTo(w * 0.89, h * 0.81, w * 0.98, h * 0.67, w * 0.98, h * 0.51)
      ..close();
    canvas.drawPath(bluePath, paint);

    paint.color = const Color(0xFF34A853);
    final Path greenPath = Path()
      ..moveTo(w * 0.50, h * 0.98)
      ..cubicTo(w * 0.63, h * 0.98, w * 0.75, h * 0.93, w * 0.80, h * 0.89)
      ..lineTo(w * 0.65, h * 0.77)
      ..cubicTo(w * 0.61, h * 0.80, w * 0.56, h * 0.82, w * 0.50, h * 0.82)
      ..cubicTo(w * 0.37, h * 0.82, w * 0.26, h * 0.74, w * 0.22, h * 0.62)
      ..lineTo(w * 0.07, h * 0.74)
      ..cubicTo(w * 0.16, h * 0.92, w * 0.31, h * 0.98, w * 0.50, h * 0.98)
      ..close();
    canvas.drawPath(greenPath, paint);

    paint.color = const Color(0xFFFBBC05);
    final Path yellowPath = Path()
      ..moveTo(w * 0.22, h * 0.62)
      ..cubicTo(w * 0.20, h * 0.56, w * 0.19, h * 0.50, w * 0.19, h * 0.44)
      ..cubicTo(w * 0.19, h * 0.38, w * 0.20, h * 0.32, w * 0.22, h * 0.26)
      ..lineTo(w * 0.07, h * 0.14)
      ..cubicTo(w * 0.03, h * 0.23, w * 0.00, h * 0.33, w * 0.00, h * 0.44)
      ..cubicTo(w * 0.00, h * 0.55, w * 0.03, h * 0.65, w * 0.07, h * 0.74)
      ..lineTo(w * 0.22, h * 0.62)
      ..close();
    canvas.drawPath(yellowPath, paint);

    paint.color = const Color(0xFFEA4335);
    final Path redPath = Path()
      ..moveTo(w * 0.50, h * 0.02)
      ..cubicTo(w * 0.63, h * 0.02, w * 0.75, h * 0.07, w * 0.84, h * 0.15)
      ..lineTo(w * 0.69, h * 0.30)
      ..cubicTo(w * 0.64, h * 0.25, w * 0.57, h * 0.22, w * 0.50, h * 0.22)
      ..cubicTo(w * 0.37, h * 0.22, w * 0.26, h * 0.30, w * 0.22, h * 0.42)
      ..lineTo(w * 0.07, h * 0.30)
      ..cubicTo(w * 0.16, h * 0.12, w * 0.31, h * 0.02, w * 0.50, h * 0.02)
      ..close();
    canvas.drawPath(redPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
