import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({Key? key}) : super(key: key);

  static const Color _pink = Color(0xFFD95791);
  static const Color _lavender = Color(0xFFAA91D8);
  static const Color _dark = Color(0xFF393044);
  static const Color _muted = Color(0xFF898193);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF7FA),
      body: Stack(
        children: [
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFFFE5EF),
                    Color(0xFFFFF5F6),
                    Color(0xFFF0EAFF),
                    Color(0xFFFFF9F3),
                  ],
                ),
              ),
            ),
          ),
          Positioned(top: 130, right: -100, child: _glow(220, const Color(0xFFFFC6DD))),
          Positioned(top: 620, left: -110, child: _glow(230, const Color(0xFFDCCFFF))),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 40),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 760),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _topBar(context),
                      const SizedBox(height: 28),
                      Text(
                        'TERMS & CONDITIONS',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(
                          fontSize: 11, fontWeight: FontWeight.w800,
                          letterSpacing: 1.8, color: _pink,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Terms of Service',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(
                          fontSize: 30, fontWeight: FontWeight.w800, color: _dark,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: _glassPill('Last Updated: October 24, 2023'),
                      ),
                      const SizedBox(height: 26),
                      _glassCard(
                        child: Text(
                          'Welcome to Lumina Guardian. We provide a digital guardianship platform designed to enhance your personal safety and peace of mind. By accessing or using our application, you agree to be bound by these terms. We encourage you to read them carefully as they form a legal agreement between you and Lumina Guardian.',
                          style: _bodyStyle(fontSize: 15.5, height: 1.75),
                        ),
                      ),
                      const SizedBox(height: 18),
                      _section(
                        Icons.handshake_rounded,
                        'Acceptance of Terms',
                        'By creating an account, downloading our application, or using our services, you signify your acceptance of these Terms. If you do not agree to these terms, please do not use Lumina Guardian. These terms may be updated periodically, and continued use constitutes acceptance of those changes.',
                      ),
                      const SizedBox(height: 14),
                      _section(
                        Icons.verified_user_outlined,
                        'User Eligibility',
                        'You must be at least 18 years old to create an account. By using the app, you represent and warrant that you meet this age requirement. If you are under 18, you may only use the service with the involvement and consent of a parent or legal guardian who agrees to be bound by these terms.',
                      ),
                      const SizedBox(height: 14),
                      _glassCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _sectionHeading(Icons.warning_amber_rounded, 'Prohibited Conduct', danger: true),
                            const SizedBox(height: 10),
                            Text(
                              'To maintain a safe community, you agree not to engage in any of the following:',
                              style: _bodyStyle(),
                            ),
                            const SizedBox(height: 12),
                            ...[
                              'Using the service for any illegal or unauthorized purpose.',
                              'Attempting to interfere with or compromise the system integrity or security.',
                              'Harassing, abusing, or harming another person through the platform.',
                              'Submitting false safety alerts or misusing the SOS functionality.',
                            ].map((rule) => Padding(
                              padding: const EdgeInsets.only(bottom: 9),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(top: 8),
                                    child: Icon(Icons.circle, size: 6, color: _pink),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(child: Text(rule, style: _bodyStyle(fontSize: 14.5))),
                                ],
                              ),
                            )),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),
                      _section(
                        Icons.shield_outlined,
                        'Limitation of Liability',
                        'While Lumina Guardian is designed to enhance safety, it is a supplementary tool and not a replacement for emergency services (e.g., 911). We do not guarantee that the service will prevent harm. To the maximum extent permitted by law, Lumina Guardian shall not be liable for any indirect, incidental, or consequential damages arising out of your use of the service.',
                      ),
                      const SizedBox(height: 14),
                      _section(
                        Icons.credit_card_rounded,
                        'Subscription & Payments',
                        'Certain premium features of Lumina Guardian require a subscription. By choosing a paid plan, you agree to our pricing and payment terms. Subscriptions auto-renew unless canceled at least 24 hours before the end of the current period. Refunds are handled in accordance with our refund policy and the policies of the respective app stores.',
                      ),
                      const SizedBox(height: 18),
                      _glassCard(
                        child: Column(
                          children: [
                            const Icon(Icons.mail_outline_rounded, color: _pink, size: 30),
                            const SizedBox(height: 10),
                            Text('Have Questions?', style: GoogleFonts.montserrat(
                              fontSize: 19, fontWeight: FontWeight.w800, color: _dark,
                            )),
                            const SizedBox(height: 8),
                            Text(
                              'If you need clarification on any of our terms or have specific legal inquiries, our team is here to help.',
                              textAlign: TextAlign.center,
                              style: _bodyStyle(fontSize: 13.5),
                            ),
                            const SizedBox(height: 16),
                            _gradientAction(
                              label: 'Contact Legal Team',
                              icon: Icons.mail_outline_rounded,
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _glow(double size, Color color) => Container(
    width: size, height: size,
    decoration: BoxDecoration(shape: BoxShape.circle, color: color.withOpacity(.30)),
  );

  static Widget _topBar(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(20),
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
      child: Container(
        height: 54,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(.48),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(.8)),
        ),
        child: Row(
          children: [
            IconButton(
              onPressed: () { if (context.canPop()) context.pop(); },
              icon: const Icon(Icons.arrow_back_rounded, color: _dark),
            ),
            Expanded(child: Text('Lumina Guardian', textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(fontSize: 16, fontWeight: FontWeight.w800, color: _pink))),
            const SizedBox(width: 48),
          ],
        ),
      ),
    ),
  );

  static Widget _glassPill(String text) => ClipRRect(
    borderRadius: BorderRadius.circular(30),
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(.55),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.white.withOpacity(.9)),
        ),
        child: Text(text, style: GoogleFonts.beVietnamPro(fontSize: 12, color: _muted, fontWeight: FontWeight.w600)),
      ),
    ),
  );

  static Widget _glassCard({required Widget child}) => ClipRRect(
    borderRadius: BorderRadius.circular(24),
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(.72),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withOpacity(.95)),
          boxShadow: [BoxShadow(color: _lavender.withOpacity(.08), blurRadius: 22, offset: const Offset(0, 7))],
        ),
        child: child,
      ),
    ),
  );

  static TextStyle _bodyStyle({double fontSize = 14.5, double height = 1.65}) =>
      GoogleFonts.beVietnamPro(fontSize: fontSize, color: _muted, height: height);

  static Widget _sectionHeading(IconData icon, String title, {bool danger = false}) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        width: 42, height: 42,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: LinearGradient(colors: danger
              ? [const Color(0xFFFFE2E7), const Color(0xFFFFEEF0)]
              : [const Color(0xFFFCE4EE), const Color(0xFFEDE5FA)]),
        ),
        child: Icon(icon, color: danger ? const Color(0xFFD65A70) : _pink, size: 20),
      ),
      const SizedBox(width: 13),
      Expanded(child: Padding(
        padding: const EdgeInsets.only(top: 7),
        child: Text(title, style: GoogleFonts.montserrat(
          fontSize: 16, fontWeight: FontWeight.w800, color: _dark,
        )),
      )),
    ],
  );

  static Widget _section(IconData icon, String title, String content) => _glassCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeading(icon, title),
        const SizedBox(height: 13),
        Text(content, style: _bodyStyle()),
      ],
    ),
  );

  static Widget _gradientAction({
    required String label, required IconData icon, required VoidCallback onPressed,
  }) => SizedBox(
    width: double.infinity, height: 50,
    child: DecoratedBox(
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [_pink, _lavender]),
        borderRadius: BorderRadius.circular(17),
        boxShadow: [BoxShadow(color: _pink.withOpacity(.20), blurRadius: 14, offset: const Offset(0, 5))],
      ),
      child: ElevatedButton.icon(
        onPressed: onPressed, icon: Icon(icon, size: 18, color: Colors.white),
        label: Text(label, style: GoogleFonts.beVietnamPro(fontWeight: FontWeight.w700, color: Colors.white)),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent, shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(17)),
        ),
      ),
    ),
  );
}