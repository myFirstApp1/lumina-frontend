import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  bool _isLoading = false;
  bool _isSuccess = false;

  void _handleReset() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simulate a network request to send recovery link
      await Future.delayed(const Duration(milliseconds: 1500));

      setState(() {
        _isLoading = false;
        _isSuccess = true;
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
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
              top: 100,
              left: -50,
              width: 250,
              height: 250,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.primaryContainer.withOpacity(0.08),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 80.0, sigmaY: 80.0),
                  child: Container(color: Colors.transparent),
                ),
              ),
            ),
            Positioned(
              bottom: 100,
              right: -50,
              width: 300,
              height: 300,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.primary.withOpacity(0.05),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 100.0, sigmaY: 100.0),
                  child: Container(color: Colors.transparent),
                ),
              ),
            ),

            // Top Header Bar
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: AppTheme.primary),
                        onPressed: () => context.pop(),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.white.withOpacity(0.7),
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
                ),
              ),
            ),

            // Main Body Content
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24.0, 72.0, 24.0, 24.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(32.0),
                      border: Border.all(color: Colors.white.withOpacity(0.5), width: 1.0),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFF06292).withOpacity(0.08),
                          blurRadius: 32,
                          spreadRadius: 2,
                          offset: const Offset(0, 8),
                        )
                      ],
                    ),
                    padding: const EdgeInsets.all(32.0),
                    child: AnimatedCrossFade(
                      duration: const Duration(milliseconds: 300),
                      crossFadeState: !_isSuccess ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                      firstChild: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Key Reset Icon
                            Center(
                              child: Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: const Color(0xFFFFD9E1).withOpacity(0.3),
                                  border: Border.all(color: Colors.white, width: 2),
                                ),
                                child: const Icon(
                                  Icons.lock_reset,
                                  color: AppTheme.primary,
                                  size: 44,
                                ),
                              ),
                            ),
                            const SizedBox(height: 24.0),

                            // Header Typography
                            Text(
                              "Forgot Password",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.montserrat(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 12.0),
                            Text(
                              "Don't worry, it happens. Enter your email to receive a secure recovery link.",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.beVietnamPro(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                height: 1.5,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 32.0),

                            // Recovery Email Input Field
                            Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFFF5F3F3),
                                borderRadius: BorderRadius.circular(16.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.02),
                                    blurRadius: 4,
                                    spreadRadius: 0,
                                    offset: const Offset(0, 1),
                                  )
                                ],
                              ),
                              child: TextFormField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                validator: (val) {
                                  if (val == null || val.isEmpty) return "Email is required";
                                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(val)) {
                                    return "Enter a valid email address";
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  hintText: "Email Address",
                                  hintStyle: GoogleFonts.beVietnamPro(color: AppTheme.textSecondary.withOpacity(0.5)),
                                  prefixIcon: Icon(Icons.mail_outline, color: AppTheme.textSecondary.withOpacity(0.6)),
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                                ),
                                style: GoogleFonts.beVietnamPro(
                                  fontSize: 15,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                            ),
                            const SizedBox(height: 24.0),

                            // Submit Button
                            Container(
                              height: 52,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(9999),
                                color: const Color(0xFFF06292),
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
                                onPressed: _isLoading ? null : _handleReset,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  foregroundColor: Colors.white,
                                  shadowColor: Colors.transparent,
                                  shape: const StadiumBorder(),
                                ),
                                child: _isLoading
                                    ? const SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                      )
                                    : Text(
                                        "Send Link",
                                        style: GoogleFonts.beVietnamPro(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                              ),
                            ),
                            const SizedBox(height: 24.0),

                            // Back to Login redirect
                            GestureDetector(
                              onTap: () => context.pop(),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.arrow_back, size: 18, color: AppTheme.primary),
                                  const SizedBox(width: 6),
                                  Text(
                                    "Back to Login",
                                    style: GoogleFonts.beVietnamPro(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                       secondChild: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Center(
                            child: Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xFFE8F5E9),
                                border: Border.all(color: Colors.white, width: 2),
                              ),
                              child: const Icon(
                                Icons.mark_email_read_outlined,
                                color: AppTheme.success,
                                size: 44,
                              ),
                            ),
                          ),
                          const SizedBox(height: 24.0),

                          Text(
                            "Recovery Link Sent!",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.montserrat(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.success,
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          Text(
                            "We've sent an encrypted recovery link to ${_emailController.text}. Please click the link inside to restore access.",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.beVietnamPro(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              height: 1.5,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 36.0),

                          // Back to Login Button
                          Container(
                            height: 52,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(9999),
                              color: const Color(0xFFF06292),
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
                              onPressed: () => context.pop(),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                foregroundColor: Colors.white,
                                shadowColor: Colors.transparent,
                                shape: const StadiumBorder(),
                              ),
                              child: Text(
                                "Back to Login",
                                style: GoogleFonts.beVietnamPro(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
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
}
