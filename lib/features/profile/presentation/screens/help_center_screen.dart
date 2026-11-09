import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class HelpCenterScreen extends StatefulWidget {
  const HelpCenterScreen({Key? key}) : super(key: key);

  @override
  State<HelpCenterScreen> createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<HelpCenterScreen> {
  final TextEditingController _searchController = TextEditingController();

  static const Color _pink = Color(0xFFD95791);
  static const Color _lavender = Color(0xFFAA91D8);
  static const Color _dark = Color(0xFF393044);
  static const Color _muted = Color(0xFF898193);

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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
          Positioned(top: 180, right: -105, child: _glow(220, const Color(0xFFFFC6DD))),
          Positioned(bottom: 170, left: -110, child: _glow(230, const Color(0xFFDCCFFF))),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _topBar(context),
                  const SizedBox(height: 28),
                  Text('Help Center', textAlign: TextAlign.center,
                      style: GoogleFonts.montserrat(fontSize: 27, fontWeight: FontWeight.w800, color: _dark)),
                  const SizedBox(height: 7),
                  Text("We're here to help you stay safe and connected.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.beVietnamPro(fontSize: 13, color: _muted)),
                  const SizedBox(height: 22),
                  _searchField(),
                  const SizedBox(height: 28),
                  _sectionHeader('TOPICS'),
                  const SizedBox(height: 13),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 13,
                    mainAxisSpacing: 13,
                    childAspectRatio: 1.12,
                    children: [
                      _topic(Icons.rocket_launch_rounded, 'Getting Started'),
                      _topic(Icons.notifications_active_outlined, 'SOS & Alerts'),
                      _topic(Icons.lock_outline_rounded, 'Privacy & Security'),
                      _topic(Icons.watch_outlined, 'Wearable Devices'),
                    ],
                  ),
                  const SizedBox(height: 28),
                  _sectionHeader('FREQUENTLY ASKED QUESTIONS'),
                  const SizedBox(height: 13),
                  _faq('How do I add a Trusted Contact?'),
                  const SizedBox(height: 9),
                  _faq('What happens when I trigger an SOS?'),
                  const SizedBox(height: 9),
                  _faq('How is my location data protected?'),
                  const SizedBox(height: 24),
                  _supportCard(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _glow(double size, Color color) => Container(
    width: size, height: size,
    decoration: BoxDecoration(shape: BoxShape.circle, color: color.withOpacity(.30)),
  );

  Widget _topBar(BuildContext context) => ClipRRect(
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
          const SizedBox(width: 48),
        ]),
      ),
    ),
  );

  Widget _searchField() => ClipRRect(
    borderRadius: BorderRadius.circular(22),
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
      child: Container(
        height: 54,
        padding: const EdgeInsets.symmetric(horizontal: 17),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(.76),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: Colors.white.withOpacity(.95)),
          boxShadow: [BoxShadow(color: _pink.withOpacity(.06), blurRadius: 16, offset: const Offset(0, 5))],
        ),
        child: Row(children: [
          const Icon(Icons.search_rounded, color: _muted, size: 21),
          const SizedBox(width: 12),
          Expanded(child: TextField(
            controller: _searchController,
            style: GoogleFonts.beVietnamPro(fontSize: 14, color: _dark),
            decoration: InputDecoration(
              hintText: 'How can we help you?',
              hintStyle: GoogleFonts.beVietnamPro(color: _muted.withOpacity(.7)),
              border: InputBorder.none, enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none, filled: false,
              contentPadding: EdgeInsets.zero,
            ),
          )),
        ]),
      ),
    ),
  );

  Widget _sectionHeader(String title) => Padding(
    padding: const EdgeInsets.only(left: 5),
    child: Text(title, style: GoogleFonts.montserrat(
      fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 1.2, color: _dark,
    )),
  );

  Widget _topic(IconData icon, String label) => ClipRRect(
    borderRadius: BorderRadius.circular(22),
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
      child: Material(
        color: Colors.white.withOpacity(.68),
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(22),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: Colors.white.withOpacity(.95)),
              boxShadow: [BoxShadow(color: _lavender.withOpacity(.06), blurRadius: 15, offset: const Offset(0, 5))],
            ),
            padding: const EdgeInsets.all(12),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                width: 56, height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(colors: [_pink.withOpacity(.13), _lavender.withOpacity(.17)]),
                ),
                child: Icon(icon, color: _pink, size: 25),
              ),
              const SizedBox(height: 12),
              Text(label, textAlign: TextAlign.center,
                  style: GoogleFonts.beVietnamPro(fontSize: 12, fontWeight: FontWeight.w800, color: _dark)),
            ]),
          ),
        ),
      ),
    ),
  );

  Widget _faq(String question) => ClipRRect(
    borderRadius: BorderRadius.circular(19),
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
      child: Material(
        color: Colors.white.withOpacity(.70),
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(19),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(19),
              border: Border.all(color: Colors.white.withOpacity(.95)),
              boxShadow: [BoxShadow(color: _pink.withOpacity(.05), blurRadius: 12, offset: const Offset(0, 4))],
            ),
            child: Row(children: [
              Expanded(child: Text(question,
                  style: GoogleFonts.beVietnamPro(fontSize: 13, fontWeight: FontWeight.w700, color: _dark))),
              const Icon(Icons.chevron_right_rounded, color: _muted, size: 22),
            ]),
          ),
        ),
      ),
    ),
  );

  Widget _supportCard() => Container(
    padding: const EdgeInsets.all(22),
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        begin: Alignment.topLeft, end: Alignment.bottomRight,
        colors: [_pink, _lavender],
      ),
      borderRadius: BorderRadius.circular(25),
      boxShadow: [BoxShadow(color: _pink.withOpacity(.20), blurRadius: 20, offset: const Offset(0, 8))],
    ),
    child: Column(children: [
      Container(
        width: 58, height: 58,
        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(.20)),
        child: const Icon(Icons.support_agent_rounded, color: Colors.white, size: 31),
      ),
      const SizedBox(height: 13),
      Text('Still need help?', style: GoogleFonts.montserrat(
        fontSize: 19, fontWeight: FontWeight.w800, color: Colors.white,
      )),
      const SizedBox(height: 8),
      Text(
        'Our team is here for you 24/7. Reach out to us anytime for personalized assistance.',
        textAlign: TextAlign.center,
        style: GoogleFonts.beVietnamPro(fontSize: 12.5, color: Colors.white.withOpacity(.92), height: 1.55),
      ),
      const SizedBox(height: 20),
      Row(children: [
        Expanded(child: SizedBox(
          height: 46,
          child: ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.chat_bubble_outline_rounded, size: 17),
            label: Text('Live Chat', style: GoogleFonts.beVietnamPro(fontSize: 12, fontWeight: FontWeight.w800)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white, foregroundColor: _pink,
              elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            ),
          ),
        )),
        const SizedBox(width: 10),
        Expanded(child: SizedBox(
          height: 46,
          child: OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.mail_outline_rounded, size: 17, color: Colors.white),
            label: Text('Email Us', style: GoogleFonts.beVietnamPro(fontSize: 12, fontWeight: FontWeight.w800, color: Colors.white)),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.white.withOpacity(.8)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            ),
          ),
        )),
      ]),
    ]),
  );
}
