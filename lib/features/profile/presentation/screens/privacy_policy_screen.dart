import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/routes/app_routes.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);

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
          const Positioned.fill(child: DecoratedBox(
            decoration: BoxDecoration(gradient: LinearGradient(
              begin: Alignment.topLeft, end: Alignment.bottomRight,
              colors: [Color(0xFFFFE5EF), Color(0xFFFFF5F6), Color(0xFFF0EAFF), Color(0xFFFFF9F3)],
            )),
          )),
          Positioned(top: 150, right: -105, child: _glow(225, const Color(0xFFFFC6DD))),
          Positioned(top: 680, left: -110, child: _glow(230, const Color(0xFFDCCFFF))),
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
                      _glassCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('LAST UPDATED: OCTOBER 26, 2023',
                                style: GoogleFonts.beVietnamPro(
                                  fontSize: 10.5, fontWeight: FontWeight.w800,
                                  letterSpacing: 1.5, color: _pink,
                                )),
                            const SizedBox(height: 12),
                            Text('Privacy Policy', style: GoogleFonts.montserrat(
                              fontSize: 27, fontWeight: FontWeight.w800, color: _dark,
                            )),
                            const SizedBox(height: 14),
                            Text(
                              'At Lumina Guardian, we believe that your safety should never compromise your privacy. This document outlines our unwavering commitment to protecting your personal data while providing you with a premium, reliable guardianship experience. We design our systems with a privacy-first approach, ensuring that you are always in control.',
                              style: _bodyStyle(fontSize: 15, height: 1.75),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      _section(
                        Icons.storage_rounded,
                        'Data Collection',
                        'We only collect the information absolutely necessary to provide our core safety features. This includes account details (name, email), emergency contact information, and real-time location data—but only when you actively initiate a tracking session or an SOS alert. We do not passively track your location in the background without your explicit consent.',
                      ),
                      const SizedBox(height: 14),
                      _section(
                        Icons.query_stats_rounded,
                        'How We Use Your Data',
                        'Your data is exclusively used to facilitate your safety. We use it to notify your trusted contacts during an emergency, to provide accurate location routing for emergency services if needed, and to maintain your account. We categorically do not sell your personal data, location history, or usage patterns to third-party advertisers or data brokers.',
                      ),
                      const SizedBox(height: 14),
                      _section(
                        Icons.security_rounded,
                        'Data Security',
                        'We employ state-of-the-art encryption protocols (AES-256) for data both at rest and in transit. Our infrastructure is housed in secure, compliant data centers. We regularly undergo independent security audits to ensure our defenses remain robust against emerging threats, keeping your sensitive information shielded.',
                      ),
                      const SizedBox(height: 14),
                      _section(
                        Icons.gavel_rounded,
                        'Your Rights',
                        'You retain full ownership of your data. You have the right to access, modify, or permanently delete your personal information at any time directly through the app settings. If you choose to close your account, all associated data is wiped from our active servers within 30 days, leaving no trace behind.',
                      ),
                      const SizedBox(height: 16),
                      _glassCard(
                        child: Column(
                          children: [
                            Container(
                              width: 54, height: 54,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(colors: [_pink.withOpacity(.16), _lavender.withOpacity(.20)]),
                              ),
                              child: const Icon(Icons.support_agent_rounded, color: _pink, size: 28),
                            ),
                            const SizedBox(height: 12),
                            Text('Have Questions?', style: GoogleFonts.montserrat(
                              fontSize: 19, fontWeight: FontWeight.w800, color: _dark,
                            )),
                            const SizedBox(height: 8),
                            Text(
                              'Our dedicated privacy team is here to help clarify any concerns you might have about how we handle your data.',
                              textAlign: TextAlign.center,
                              style: _bodyStyle(fontSize: 13.5),
                            ),
                            const SizedBox(height: 16),
                            _gradientAction(
                              label: 'Contact Privacy Team',
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
        height: 54, padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(.48),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(.8)),
        ),
        child: Row(children: [
          IconButton(
            onPressed: () { if (context.canPop()) context.pop(); },
            icon: const Icon(Icons.arrow_back_rounded, color: _dark),
          ),
          Expanded(child: Text('Lumina Guardian', textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(fontSize: 16, fontWeight: FontWeight.w800, color: _pink))),
          IconButton(
            onPressed: () => context.push(AppRoutes.profile),
            icon: const Icon(Icons.person_outline_rounded, color: _pink),
          ),
        ]),
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

  static Widget _section(IconData icon, String title, String content) => _glassCard(
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Container(
          width: 42, height: 42,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            gradient: LinearGradient(colors: [_pink.withOpacity(.13), _lavender.withOpacity(.17)]),
          ),
          child: Icon(icon, color: _pink, size: 20),
        ),
        const SizedBox(width: 13),
        Expanded(child: Text(title, style: GoogleFonts.montserrat(
          fontSize: 16, fontWeight: FontWeight.w800, color: _dark,
        ))),
      ]),
      const SizedBox(height: 13),
      Text(content, style: _bodyStyle()),
    ]),
  );

  static Widget _gradientAction({required String label, required VoidCallback onPressed}) => SizedBox(
    width: double.infinity, height: 50,
    child: DecoratedBox(
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [_pink, _lavender]),
        borderRadius: BorderRadius.circular(17),
        boxShadow: [BoxShadow(color: _pink.withOpacity(.20), blurRadius: 14, offset: const Offset(0, 5))],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent, foregroundColor: Colors.white,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(17)),
        ),
        child: Text(label, style: GoogleFonts.beVietnamPro(fontWeight: FontWeight.w700)),
      ),
    ),
  );
}