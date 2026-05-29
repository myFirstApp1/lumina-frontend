import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_theme.dart';
import '../cubit/auth_cubit.dart';

class RegisterAccountScreen extends StatefulWidget {
  const RegisterAccountScreen({Key? key}) : super(key: key);

  @override
  State<RegisterAccountScreen> createState() => _RegisterAccountScreenState();
}

class _RegisterAccountScreenState extends State<RegisterAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreeToTerms = false;

  void _handleContinue() {
    if (_formKey.currentState!.validate()) {
      if (!_agreeToTerms) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("You must agree to the Terms of Service and Privacy Policy."),
            backgroundColor: AppTheme.primary,
          ),
        );
        return;
      }

      context.read<AuthCubit>().register(
        _usernameController.text.trim(),
        _emailController.text.trim(),
        _passwordController.text,
        _phoneController.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthOtpVerificationRequired) {
            context.push(AppRoutes.signupVerify, extra: state.email);
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
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFD9E1), Color(0xFFFBF9F8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Minimalist Back Navigation row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: AppTheme.textPrimary),
                      onPressed: () => context.pop(),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.5),
                      ),
                    ),
                    Text(
                      "Lumina Guardian",
                      style: GoogleFonts.montserrat(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primary,
                      ),
                    ),
                    const SizedBox(width: 48), // Spacer to balance back button
                  ],
                ),
                const SizedBox(height: 16.0),

                // Glassmorphic panel card matching Stitch HTML designs
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(32.0),
                    border: Border.all(color: Colors.white.withOpacity(0.5), width: 1.0),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFF06292).withOpacity(0.08),
                        blurRadius: 32,
                        spreadRadius: 2,
                      )
                    ],
                  ),
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Progress Bar Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Step 1 of 2",
                              style: GoogleFonts.montserrat(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                            Text(
                              "Account Details",
                              style: GoogleFonts.montserrat(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8.0),
                        // Half filled progress line
                        Container(
                          height: 4,
                          decoration: BoxDecoration(
                            color: AppTheme.outlineVariant.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(9999),
                          ),
                          alignment: Alignment.centerLeft,
                          child: FractionallySizedBox(
                            widthFactor: 0.5,
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppTheme.primaryContainer,
                                borderRadius: BorderRadius.circular(9999),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24.0),

                        // Title & subtitle
                        Text(
                          "Create Account",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.montserrat(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primary,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          "Join your safe space.",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.montserrat(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 24.0),

                        // Username input
                        _buildLabel("User name"),
                        _buildInputField(
                          controller: _usernameController,
                          hint: "User name",
                          icon: Icons.person_outline,
                          validator: (val) => val == null || val.isEmpty ? "Username is required" : null,
                        ),
                        const SizedBox(height: 16.0),

                        // Email input
                        _buildLabel("Email Address"),
                        _buildInputField(
                          controller: _emailController,
                          hint: "jane@example.com",
                          icon: Icons.mail_outline,
                          keyboardType: TextInputType.emailAddress,
                          validator: (val) {
                            if (val == null || val.isEmpty) return "Email is required";
                            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(val)) {
                              return "Enter a valid email address";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16.0),

                        // Phone Number input
                        _buildLabel("Phone Number"),
                        _buildInputField(
                          controller: _phoneController,
                          hint: "+91 1234567890",
                          icon: Icons.phone_outlined,
                          keyboardType: TextInputType.phone,
                          validator: (val) => val == null || val.isEmpty ? "Phone number is required" : null,
                        ),
                        const SizedBox(height: 16.0),

                        // Password input
                        _buildLabel("Password"),
                        _buildInputField(
                          controller: _passwordController,
                          hint: "••••••••",
                          icon: Icons.lock_outline,
                          isPassword: true,
                          obscureText: _obscurePassword,
                          togglePassword: () => setState(() => _obscurePassword = !_obscurePassword),
                          validator: (val) => val == null || val.length < 8 ? "Must be at least 8 characters." : null,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 6.0, left: 4.0),
                          child: Text(
                            "Must be at least 8 characters.",
                            style: GoogleFonts.montserrat(
                              fontSize: 12,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16.0),

                        // Confirm Password input
                        _buildLabel("Confirm Password"),
                        _buildInputField(
                          controller: _confirmPasswordController,
                          hint: "Confirm Password",
                          icon: Icons.lock_outline,
                          isPassword: true,
                          obscureText: _obscureConfirmPassword,
                          togglePassword: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                          validator: (val) {
                            if (val == null || val.isEmpty) return "Please confirm password";
                            if (val != _passwordController.text) return "Passwords do not match";
                            return null;
                          },
                        ),
                        const SizedBox(height: 16.0),

                        // Terms & Privacy Checkbox
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 24,
                              height: 24,
                              child: Checkbox(
                                value: _agreeToTerms,
                                activeColor: AppTheme.primaryContainer,
                                checkColor: Colors.white,
                                side: const BorderSide(color: AppTheme.outlineVariant, width: 1.5),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                onChanged: (val) => setState(() => _agreeToTerms = val ?? false),
                              ),
                            ),
                            const SizedBox(width: 10.0),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => setState(() => _agreeToTerms = !_agreeToTerms),
                                child: Text.rich(
                                  TextSpan(
                                    text: "I agree to the ",
                                    style: GoogleFonts.montserrat(
                                      fontSize: 13,
                                      color: AppTheme.textSecondary,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: "Terms of Service",
                                        style: const TextStyle(
                                          color: AppTheme.primary,
                                          fontWeight: FontWeight.w600,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                      const TextSpan(text: " and "),
                                      TextSpan(
                                        text: "Privacy Policy",
                                        style: const TextStyle(
                                          color: AppTheme.primary,
                                          fontWeight: FontWeight.w600,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                      const TextSpan(text: "."),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24.0),

                        // Gradient Submit Button
                        BlocBuilder<AuthCubit, AuthState>(
                          builder: (context, state) {
                            final isLoading = state is AuthLoading;
                            return Container(
                              height: 52,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(9999),
                                gradient: const LinearGradient(
                                  colors: [Color(0xFFF06292), Color(0xFFAB2C5D)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFFF06292).withOpacity(0.3),
                                    blurRadius: 15,
                                    spreadRadius: 1,
                                    offset: const Offset(0, 4),
                                  )
                                ],
                              ),
                              child: ElevatedButton(
                                onPressed: isLoading ? null : _handleContinue,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  foregroundColor: Colors.white,
                                  shadowColor: Colors.transparent,
                                  shape: const StadiumBorder(),
                                ),
                                child: isLoading
                                    ? const SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                      )
                                    : Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: const [
                                          Text(
                                            "Continue",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(width: 8.0),
                                          Icon(Icons.arrow_forward, size: 20),
                                        ],
                                      ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 24.0),

                        // Social Logins Divider
                        Row(
                          children: [
                            const Expanded(child: Divider(color: AppTheme.outlineVariant)),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12.0),
                              child: Text(
                                "Or sign up with",
                                style: GoogleFonts.montserrat(
                                  fontSize: 12,
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                            ),
                            const Expanded(child: Divider(color: AppTheme.outlineVariant)),
                          ],
                        ),
                        const SizedBox(height: 20.0),

                        // Google & Apple Buttons Grid
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

                        // Bottom Login redirect
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Already have an account? ",
                              style: GoogleFonts.montserrat(
                                fontSize: 14,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => context.go(AppRoutes.login),
                              child: Text(
                                "Log In",
                                style: GoogleFonts.montserrat(
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
              ],
            ),
          ),
        ),
      ),
    ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0, bottom: 4.0),
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
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(9999),
        border: Border.all(color: AppTheme.outlineVariant),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        validator: validator,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.montserrat(color: AppTheme.textSecondary.withOpacity(0.6)),
          prefixIcon: Icon(icon, color: AppTheme.textSecondary),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    obscureText ? Icons.visibility : Icons.visibility_off,
                    color: AppTheme.textSecondary,
                  ),
                  onPressed: togglePassword,
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 14.0),
        ),
        style: GoogleFonts.montserrat(
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
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(9999),
          border: Border.all(color: AppTheme.outlineVariant),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 4,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            iconSvg,
            const SizedBox(width: 8),
            Text(
              text,
              style: GoogleFonts.montserrat(
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
      width: 20,
      height: 20,
      child: CustomPaint(
        painter: GoogleIconPainter(),
      ),
    );
  }

  Widget _buildAppleSvg() {
    return const Icon(
      Icons.apple,
      color: Colors.black,
      size: 22,
    );
  }
}

// Custom Painter to draw Google Icon cleanly without files
class GoogleIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..style = PaintingStyle.fill;
    final double w = size.width;
    final double h = size.height;

    // Blue segment
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

    // Green segment
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

    // Yellow segment
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

    // Red segment
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
