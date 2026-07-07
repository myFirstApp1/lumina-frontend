import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_theme.dart';
import '../cubit/auth_cubit.dart';

class RegisterVerifyScreen extends StatefulWidget {
  final String? email;
  final String? txnId;
  const RegisterVerifyScreen({Key? key, this.email, this.txnId}) : super(key: key);

  @override
  State<RegisterVerifyScreen> createState() => _RegisterVerifyScreenState();
}

class _RegisterVerifyScreenState extends State<RegisterVerifyScreen> {
  final List<TextEditingController> _controllers = List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());

  int _secondsRemaining = 299; // 4 minutes and 59 seconds (299s)
  Timer? _countdownTimer;

  @override
  void initState() {
    super.initState();
    _startTimer();
    // Auto-focus the first field on load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNodes[0].requestFocus();
    });
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _startTimer() {
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (_secondsRemaining > 0) {
            _secondsRemaining--;
          } else {
            _countdownTimer?.cancel();
          }
        });
      }
    });
  }

  String _formatTimer() {
    final int minutes = _secondsRemaining ~/ 60;
    final int seconds = _secondsRemaining % 60;
    final String minutesStr = minutes.toString().padLeft(2, '0');
    final String secondsStr = seconds.toString().padLeft(2, '0');
    return "$minutesStr:$secondsStr";
  }

  void _handleResendCode() {
    if (_secondsRemaining == 0) {
      setState(() {
        _secondsRemaining = 299;
      });
      _startTimer();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("A new secure code has been sent to your email."),
          backgroundColor: AppTheme.primary,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please wait until the countdown finishes before requesting a new code."),
          backgroundColor: AppTheme.primary,
        ),
      );
    }
  }

  void _handleVerify() {
    final String otp = _controllers.map((c) => c.text).join();
    if (otp.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter the full 6-digit code."),
          backgroundColor: AppTheme.primary,
        ),
      );
      return;
    }

    final txnId = widget.txnId ?? (context.read<AuthCubit>().state is AuthOtpVerificationRequired
        ? (context.read<AuthCubit>().state as AuthOtpVerificationRequired).txnId
        : '');

    if (txnId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Transaction ID not found. Please register again."),
          backgroundColor: AppTheme.error,
        ),
      );
      return;
    }

    context.read<AuthCubit>().verifyOtp(txnId, otp);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthUnauthenticated) {
            context.go(AppRoutes.login);
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
            color: AppTheme.background,
          ),
          child: Stack(
            children: [
            // Decorative background glowing circular blur orbs
            Positioned(
              top: -100,
              left: -100,
              width: 300,
              height: 300,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.primaryContainer.withOpacity(0.12),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 100.0, sigmaY: 100.0),
                  child: Container(color: Colors.transparent),
                ),
              ),
            ),
            Positioned(
              bottom: -80,
              right: -80,
              width: 260,
              height: 260,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.outlineVariant.withOpacity(0.15),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 100.0, sigmaY: 100.0),
                  child: Container(color: Colors.transparent),
                ),
              ),
            ),

            // Main body
            SafeArea(
              child: Column(
                children: [
                  // Header Bar
                  Expanded(
                   child: Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Glassmorphic Card Container
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(32.0),
                              border: Border.all(color: Colors.white.withOpacity(0.5), width: 1.0),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFFF06292).withOpacity(0.06),
                                  blurRadius: 32,
                                  spreadRadius: 2,
                                )
                              ],
                            ),
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
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

                                const SizedBox(height: 12.0),
                                Text(
                                  "Verify your identity",
                                  style: GoogleFonts.montserrat(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.textPrimary,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                                const SizedBox(height: 12.0),
                                Text(
                                  "We've sent a 6-digit secure code to your email address.",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.beVietnamPro(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    height: 1.5,
                                    color: AppTheme.textSecondary,
                                  ),
                                ),
                                const SizedBox(height: 36.0),

                                // OTP Inputs Row
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: List.generate(6, (index) {
                                    return SizedBox(
                                      width: 46,
                                      height: 56,
                                      child: TextFormField(
                                        controller: _controllers[index],
                                        focusNode: _focusNodes[index],
                                        keyboardType: TextInputType.number,
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.montserrat(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: AppTheme.textPrimary,
                                        ),
                                        inputFormatters: [
                                          LengthLimitingTextInputFormatter(1),
                                          FilteringTextInputFormatter.digitsOnly,
                                        ],
                                        decoration: InputDecoration(
                                          hintText: "•",
                                          hintStyle: GoogleFonts.montserrat(
                                            color: AppTheme.outlineVariant,
                                            fontSize: 22,
                                          ),
                                          filled: true,
                                          fillColor: Colors.white,
                                          contentPadding: EdgeInsets.zero,
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(16.0),
                                            borderSide: const BorderSide(color: AppTheme.primaryContainer, width: 2.0),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(16.0),
                                            borderSide: const BorderSide(color: AppTheme.outlineVariant, width: 1.0),
                                          ),
                                        ),
                                        onChanged: (value) {
                                          if (value.isNotEmpty) {
                                            if (index < 5) {
                                              _focusNodes[index + 1].requestFocus();
                                            } else {
                                              _focusNodes[index].unfocus();
                                            }
                                          } else {
                                            if (index > 0) {
                                              _focusNodes[index - 1].requestFocus();
                                            }
                                          }
                                        },
                                      ),
                                    );
                                  }),
                                ),
                                const SizedBox(height: 32.0),

                                // Verify and Complete Button
                                BlocBuilder<AuthCubit, AuthState>(
                                  builder: (context, state) {
                                    final isLoading = state is AuthLoading;
                                    return Container(
                                      height: 54,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(9999),
                                        gradient: const LinearGradient(
                                          colors: [Color(0xFFF06292), Color(0xFFAB2C5D)],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color(0xFFF06292).withOpacity(0.39),
                                            blurRadius: 14,
                                            spreadRadius: 0,
                                            offset: const Offset(0, 4),
                                          )
                                        ],
                                      ),
                                      child: ElevatedButton(
                                        onPressed: isLoading ? null : _handleVerify,
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
                                                    "Verify & Complete",
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

                                // Didn't receive code? Resend Code
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Didn't receive the code?",
                                      style: GoogleFonts.beVietnamPro(
                                        fontSize: 15,
                                        color: AppTheme.textSecondary,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    GestureDetector(
                                      onTap: _handleResendCode,
                                      child: Text(
                                        "Resend Code",
                                        style: GoogleFonts.beVietnamPro(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: AppTheme.primary,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16.0),

                                // Countdown Timer
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.timer_outlined, size: 16, color: AppTheme.outline),
                                    const SizedBox(width: 6),
                                    Text(
                                      _formatTimer(),
                                      style: GoogleFonts.beVietnamPro(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.outline,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
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
          ],
        ),
      ),
    ),
    );
  }
}
