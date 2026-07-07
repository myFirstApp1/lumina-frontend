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
            content: Text(
                "You must agree to the Terms of Service and Privacy Policy."),
            backgroundColor: AppTheme.primary,
          ),
        );
        return;
      }

      context.read<AuthCubit>().register(
        _usernameController.text.trim(),
        _emailController.text.trim(),
        _passwordController.text,
      );
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();

    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthOtpVerificationRequired) {
            context.push(
              AppRoutes.signupVerify,
              extra: {
                'email': state.email,
                'txnId': state.txnId,
              },
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
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFFFF3F6),
                Color(0xFFFBF9F8),
              ],
            ),
          ),
          child: SafeArea(
            child: Stack(
              children: [
              Positioned(
              top: -80,
              right: -60,
              child: Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFF06292).withOpacity(.10),
                ),
              ),
            ),
            Positioned(
              bottom: -120,
              left: -80,
              child: Container(
                width: 260,
                height: 260,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFF8BBD0).withOpacity(.12),
                ),
              ),
            ),
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 18,
              ),
              child: Column(
                children: [
              //   Align(
              //   alignment: Alignment.centerLeft,
              //   child: IconButton(
              //     onPressed: () => context.pop(),
              //     style: IconButton.styleFrom(
              //       backgroundColor: Colors.white,
              //       elevation: 0,
              //       fixedSize: const Size(48, 48),
              //     ),
              //     icon: const Icon(
              //       Icons.arrow_back_ios_new_rounded,
              //       color: AppTheme.textPrimary,
              //     ),
              //   ),
              // ),


               // const SizedBox(height: 5),

                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(top: 20),
                    padding: const EdgeInsets.fromLTRB(
                      24,
                      30,
                      24,
                      28,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(36),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.pink.withOpacity(.08),
                          blurRadius: 35,
                          offset: const Offset(0, 12),
                        ),
                      ],
                    ),

                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.stretch,
                    children: [

                      Center(
                        child: SizedBox(
                          width: 75,
                          height: 75,
                          child: Image.asset(
                            "assets/icon/app_icon.png",
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),

                      const SizedBox(height: 25),
                      Text(
                        "Create Account",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(
                          fontSize: 28 ,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                          height: 1.0,
                        ),
                      ),

                  const SizedBox(height: 8),

                      Text(
                        "Join your safe space.",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(
                          fontSize: 16,
                          color: AppTheme.textSecondary,
                          fontWeight: FontWeight.w400,
                          height: 1.4,
                        ),
                      ),

                  const SizedBox(height: 30),

                  // ===== FORM START =====

                  _buildLabel("Username"),
                  _buildInputField(
                    controller: _usernameController,
                    hint: "Enter your username",
                    icon: Icons.person_outline_rounded,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Username is required";
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 15),

                  _buildLabel("Email Address"),
                  _buildInputField(
                    controller: _emailController,
                    hint: "example@email.com",
                    icon: Icons.mail_outline_rounded,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Email is required";
                      }

                      if (!RegExp(
                        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                      ).hasMatch(value)) {
                        return "Enter a valid email";
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 15),

                  _buildLabel("Password"),
                  _buildInputField(
                    controller: _passwordController,
                    hint: "Enter password",
                    icon: Icons.lock_outline_rounded,
                    isPassword: true,
                    obscureText: _obscurePassword,
                    togglePassword: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.length < 6) {
                        return "Minimum 6 characters";
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 8),

                  Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: Text(
                      "Minimum 6 characters",
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 12,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  _buildLabel("Confirm Password"),
                  _buildInputField(
                    controller: _confirmPasswordController,
                    hint: "Confirm password",
                    icon: Icons.lock_outline_rounded,
                    isPassword: true,
                    obscureText: _obscureConfirmPassword,
                    togglePassword: () {
                      setState(() {
                        _obscureConfirmPassword =
                        !_obscureConfirmPassword;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Confirm your password";
                      }

                      if (value != _passwordController.text) {
                        return "Passwords do not match";
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  InkWell(
                    onTap: () {
                      setState(() {
                        _agreeToTerms = !_agreeToTerms;
                      });
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Checkbox(
                            value: _agreeToTerms,
                            activeColor: AppTheme.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                            onChanged: (value) {
                              setState(() {
                                _agreeToTerms = value ?? false;
                              });
                            },
                          ),

                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text.rich(
                                TextSpan(
                                  text: "I agree to the ",
                                  style: GoogleFonts.beVietnamPro(
                                    fontSize: 14,
                                    color: AppTheme.textSecondary,
                                  ),
                                  children: [

                                    TextSpan(
                                      text: "Terms of Service",
                                      style: GoogleFonts.beVietnamPro(
                                        color: AppTheme.primary,
                                        fontWeight: FontWeight.w700,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),

                                    const TextSpan(
                                      text: " and ",
                                    ),

                                    TextSpan(
                                      text: "Privacy Policy",
                                      style: GoogleFonts.beVietnamPro(
                                        color: AppTheme.primary,
                                        fontWeight: FontWeight.w700,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, state) {
                      final loading = state is AuthLoading;

                      return SizedBox(
                        height: 58,
                        child: ElevatedButton(
                          onPressed: loading ? null : _handleContinue,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: const StadiumBorder(),
                            padding: EdgeInsets.zero,
                          ),
                          child: Ink(
                            decoration: const BoxDecoration(
                              gradient: AppTheme.primaryGradient,
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.all(
                                Radius.circular(40),
                              ),
                            ),
                            child: Center(
                              child: loading
                                  ? const SizedBox(
                                width: 22,
                                height: 22,
                                child:
                                CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                                  : Text(
                                "Create Account",
                                style:
                                GoogleFonts.montserrat(
                                  fontSize: 16,
                                  fontWeight:
                                  FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 30),

                  Row(
                    children: [

                      const Expanded(
                        child: Divider(),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0),
                        child: Text(
                          "Or continue with",
                          style: GoogleFonts.montserrat(
                            fontSize: 12,
                            color: AppTheme.textSecondary.withOpacity(0.6),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),

                      const Expanded(
                        child: Divider(color: AppTheme.outlineVariant)),
                    ],
                  ),

                  const SizedBox(height: 20),

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

                      const SizedBox(width: 14.0),

                      Expanded(
                        child: _buildSocialButton(
                          text: "Apple",
                          iconSvg: _buildAppleSvg(),
                          onTap: () {},
                        ),
                      ),
                    ],
                  ),

                      const SizedBox(height: 30),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have an account?",
                            style: GoogleFonts.beVietnamPro(
                              color: AppTheme.textSecondary,
                              fontSize: 14,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => context.go(AppRoutes.login),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 6),
                              child: Text(
                                "Sign In",
                                style: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.primary,
                                  fontSize: 15,
                                  decoration: TextDecoration.underline,
                                ),
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
        ],
      ),
    ),
    ),
    ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 6,
        bottom: 8,
      ),
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
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
      style: GoogleFonts.beVietnamPro(
        fontSize: 15,
        color: AppTheme.textPrimary,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(

        filled: true,
        fillColor: Colors.white,

        hintText: hint,

        hintStyle: GoogleFonts.beVietnamPro(
          color: AppTheme.textPrimary.withOpacity(.6),
          fontSize: 15,
        ),

        contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 14.0),

        prefixIcon: Container(
          margin: const EdgeInsets.all(10),
          width: 35,
          height: 35,
          decoration: BoxDecoration(
            color: const Color(0xFFFFEEF4),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(
            icon,
            size: 20,
            color: AppTheme.primary,
          ),
        ),

        suffixIcon: isPassword
            ? IconButton(
          onPressed: togglePassword,
          icon: Icon(
            obscureText
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            color: AppTheme.primary,
          ),
        )
            : null,

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: AppTheme.outlineVariant.withOpacity(.6),
          ),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: AppTheme.primary,
            width: 2,
          ),
        ),

        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: AppTheme.error,
          ),
        ),

        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: AppTheme.error,
            width: 2,
          ),
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
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: AppTheme.outlineVariant.withOpacity(.6),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
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
                fontWeight: FontWeight.w600,
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
    final Paint paint = Paint()
      ..style = PaintingStyle.fill;
    final double w = size.width;
    final double h = size.height;

    // Blue segment
    paint.color = const Color(0xFF4285F4);
    final Path bluePath = Path()
      ..moveTo(w * 0.98, h * 0.51)
      ..cubicTo(w * 0.98, h * 0.47, w * 0.97, h * 0.44, w * 0.97, h * 0.40)
      ..lineTo(w * 0.50, h * 0.40)..lineTo(w * 0.50, h * 0.59)..lineTo(
          w * 0.77, h * 0.59)
      ..cubicTo(w * 0.76, h * 0.67, w * 0.71, h * 0.73, w * 0.65, h * 0.77)
      ..lineTo(w * 0.65, h * 0.77)..lineTo(w * 0.80, h * 0.89)
      ..cubicTo(w * 0.89, h * 0.81, w * 0.98, h * 0.67, w * 0.98, h * 0.51)
      ..close();
    canvas.drawPath(bluePath, paint);

    // Green segment
    paint.color = const Color(0xFF34A853);
    final Path greenPath = Path()
      ..moveTo(w * 0.50, h * 0.98)
      ..cubicTo(w * 0.63, h * 0.98, w * 0.75, h * 0.93, w * 0.80, h * 0.89)
      ..lineTo(w * 0.65, h * 0.77)
      ..cubicTo(
          w * 0.61, h * 0.80, w * 0.56, h * 0.82, w * 0.50, h * 0.82)..cubicTo(
          w * 0.37, h * 0.82, w * 0.26, h * 0.74, w * 0.22, h * 0.62)
      ..lineTo(w * 0.07, h * 0.74)
      ..cubicTo(w * 0.16, h * 0.92, w * 0.31, h * 0.98, w * 0.50, h * 0.98)
      ..close();
    canvas.drawPath(greenPath, paint);

    // Yellow segment
    paint.color = const Color(0xFFFBBC05);
    final Path yellowPath = Path()
      ..moveTo(w * 0.22, h * 0.62)
      ..cubicTo(
          w * 0.20, h * 0.56, w * 0.19, h * 0.50, w * 0.19, h * 0.44)..cubicTo(
          w * 0.19, h * 0.38, w * 0.20, h * 0.32, w * 0.22, h * 0.26)
      ..lineTo(w * 0.07, h * 0.14)
      ..cubicTo(
          w * 0.03, h * 0.23, w * 0.00, h * 0.33, w * 0.00, h * 0.44)..cubicTo(
          w * 0.00, h * 0.55, w * 0.03, h * 0.65, w * 0.07, h * 0.74)
      ..lineTo(w * 0.22, h * 0.62)
      ..close();
    canvas.drawPath(yellowPath, paint);

    // Red segment
    paint.color = const Color(0xFFEA4335);
    final Path redPath = Path()
      ..moveTo(w * 0.50, h * 0.02)
      ..cubicTo(w * 0.63, h * 0.02, w * 0.75, h * 0.07, w * 0.84, h * 0.15)
      ..lineTo(w * 0.69, h * 0.30)
      ..cubicTo(
          w * 0.64, h * 0.25, w * 0.57, h * 0.22, w * 0.50, h * 0.22)..cubicTo(
          w * 0.37, h * 0.22, w * 0.26, h * 0.30, w * 0.22, h * 0.42)
      ..lineTo(w * 0.07, h * 0.30)
      ..cubicTo(w * 0.16, h * 0.12, w * 0.31, h * 0.02, w * 0.50, h * 0.02)
      ..close();
    canvas.drawPath(redPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
