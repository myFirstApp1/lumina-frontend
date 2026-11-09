import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class WearableSyncScreen extends StatefulWidget {
  const WearableSyncScreen({Key? key}) : super(key: key);

  @override
  State<WearableSyncScreen> createState() => _WearableSyncScreenState();
}

class _WearableSyncScreenState extends State<WearableSyncScreen>
    with TickerProviderStateMixin {
  late final AnimationController _heartController;
  late final AnimationController _greenPulseController;

  bool _fallDetection = true;
  bool _offBodyAlert = true;
  bool _heartAnomaly = true;

  static const Color _pink = Color(0xFFD95791);
  static const Color _lavender = Color(0xFFAA91D8);
  static const Color _dark = Color(0xFF393044);
  static const Color _muted = Color(0xFF898193);
  static const Color _success = Color(0xFF36A66A);

  @override
  void initState() {
    super.initState();

    _heartController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _greenPulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _heartController.dispose();
    _greenPulseController.dispose();
    super.dispose();
  }

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
          Positioned(
            top: 150,
            right: -105,
            child: _glow(225, const Color(0xFFFFC6DD)),
          ),
          Positioned(
            top: 600,
            left: -110,
            child: _glow(230, const Color(0xFFDCCFFF)),
          ),
          Positioned(
            bottom: 30,
            right: -100,
            child: _glow(190, const Color(0xFFFFD9E9)),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 40),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 760),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildTopBar(context),
                      const SizedBox(height: 24),
                      Text(
                        'YOUR CONNECTED DEVICE',
                        style: GoogleFonts.montserrat(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.5,
                          color: _pink,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildDeviceCard(),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildStatusCard(
                              icon: Icons.battery_charging_full_rounded,
                              title: 'Battery',
                              value: '82%',
                              detail: 'Device power',
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildStatusCard(
                              icon: Icons.bluetooth_connected_rounded,
                              title: 'Connection',
                              value: 'Strong',
                              detail: 'Bluetooth signal',
                              trailing: const Icon(
                                Icons.signal_cellular_alt_rounded,
                                color: _success,
                                size: 17,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildVitalsCard(),
                      const SizedBox(height: 16),
                      _buildAiStatusCard(),
                      const SizedBox(height: 26),
                      _buildSectionHeader(
                        'DEVICE SAFETY FEATURES',
                        Icons.health_and_safety_outlined,
                      ),
                      const SizedBox(height: 12),
                      _buildSafetyTogglesCard(),
                      const SizedBox(height: 24),
                      _buildPrimaryButton(
                        icon: Icons.sync_rounded,
                        label: 'Sync Device Now',
                        onPressed: () {},
                      ),
                      const SizedBox(height: 12),
                      _buildSecondaryButton(
                        icon: Icons.settings_outlined,
                        label: 'Device Settings',
                        onPressed: () {},
                      ),
                      const SizedBox(height: 22),
                      Center(
                        child: Text(
                          'LUMINA GUARDIAN',
                          style: GoogleFonts.montserrat(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 2,
                            color: _muted,
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Center(
                        child: Text(
                          'Your safety, our priority.',
                          style: GoogleFonts.beVietnamPro(
                            fontSize: 11,
                            color: _muted,
                          ),
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

  Widget _glow(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withOpacity(.30),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return ClipRRect(
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
                onPressed: () {
                  if (context.canPop()) context.pop();
                },
                icon: const Icon(
                  Icons.arrow_back_rounded,
                  color: _dark,
                ),
              ),
              Expanded(
                child: Text(
                  'My Wearables',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: _pink,
                  ),
                ),
              ),
              const SizedBox(width: 48),
            ],
          ),
        ),
      ),
    );
  }

  Widget _glassCard({
    required Widget child,
    EdgeInsets padding = const EdgeInsets.all(18),
    double radius = 23,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(.72),
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(color: Colors.white.withOpacity(.95)),
            boxShadow: [
              BoxShadow(
                color: _lavender.withOpacity(.08),
                blurRadius: 22,
                offset: const Offset(0, 7),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }

  Widget _buildDeviceCard() {
    return _glassCard(
      padding: const EdgeInsets.all(17),
      child: Row(
        children: [
          Container(
            width: 92,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(19),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  _pink.withOpacity(.12),
                  _lavender.withOpacity(.18),
                ],
              ),
            ),
            clipBehavior: Clip.antiAlias,
            child: Image.network(
              'https://lh3.googleusercontent.com/aida-public/AB6AXuBtYdXQ5Hat-ldE57wRw-T_hhAJSZUHaNSAOHQvgxpui_gnYPLZWlEd5zzBEKDg_ncrSdU88MWfyE2LsHelP5ia39UunWHu3wFDNQWA5ZgZwzS0dtnbrMfr1eLsQYJnohqrnxkqzqX4YelnIyv9Jcn1E2mxhZCuhqwl3v64v-GJq-cewyXTNy-rZbCflTDb0PoPIGA7bcuD0_-ZDvRiMbXn8W4MUwx1pkwhnEPouJWdP0HDjL594iMJn_9VZXFkFxLkiVDS-MZm4iE',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.watch_rounded,
                color: _pink,
                size: 48,
              ),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _buildOnlineIndicator(),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        'LIVE & CONNECTED',
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.beVietnamPro(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          letterSpacing: .6,
                          color: _success,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 9),
                Text(
                  'Apple Watch Series 8',
                  style: GoogleFonts.montserrat(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: _dark,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Assigned to: Guardian AI Profile',
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 11,
                    color: _muted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOnlineIndicator() {
    return AnimatedBuilder(
      animation: _greenPulseController,
      builder: (context, child) {
        return SizedBox(
          width: 14,
          height: 14,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 14 * _greenPulseController.value,
                height: 14 * _greenPulseController.value,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _success.withOpacity(
                    .45 * (1 - _greenPulseController.value),
                  ),
                ),
              ),
              Container(
                width: 7,
                height: 7,
                decoration: const BoxDecoration(
                  color: _success,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatusCard({
    required IconData icon,
    required String title,
    required String value,
    required String detail,
    Widget? trailing,
  }) {
    return _glassCard(
      padding: const EdgeInsets.all(15),
      radius: 21,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _iconTile(icon, size: 37),
              if (trailing != null) trailing,
            ],
          ),
          const SizedBox(height: 14),
          Text(
            title,
            style: GoogleFonts.beVietnamPro(
              fontSize: 11,
              color: _muted,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            style: GoogleFonts.montserrat(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: _dark,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            detail,
            style: GoogleFonts.beVietnamPro(
              fontSize: 10,
              color: _muted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _iconTile(IconData icon, {double size = 42}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: LinearGradient(
          colors: [
            _pink.withOpacity(.14),
            _lavender.withOpacity(.18),
          ],
        ),
      ),
      child: Icon(icon, color: _pink, size: size * .48),
    );
  }

  Widget _buildVitalsCard() {
    return _glassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Live Heart Rate',
                      style: GoogleFonts.montserrat(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: _dark,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Continuous monitoring active',
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 11,
                        color: _muted,
                      ),
                    ),
                  ],
                ),
              ),
              ScaleTransition(
                scale: Tween<double>(begin: .9, end: 1.15).animate(
                  CurvedAnimation(
                    parent: _heartController,
                    curve: Curves.easeInOut,
                  ),
                ),
                child: Container(
                  width: 47,
                  height: 47,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        _pink.withOpacity(.15),
                        _lavender.withOpacity(.18),
                      ],
                    ),
                  ),
                  child: const Icon(
                    Icons.favorite_rounded,
                    color: _pink,
                    size: 25,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '72',
                style: GoogleFonts.montserrat(
                  fontSize: 45,
                  fontWeight: FontWeight.w800,
                  color: _pink,
                  height: 1,
                ),
              ),
              const SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Text(
                  'BPM',
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: _muted,
                  ),
                ),
              ),
              const Spacer(),
              const Icon(
                Icons.show_chart_rounded,
                color: _lavender,
                size: 30,
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 65,
            width: double.infinity,
            child: CustomPaint(
              painter: _HeartRateGraphPainter(),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.circle, color: _success, size: 8),
              const SizedBox(width: 6),
              Text(
                'Heart rate reading',
                style: GoogleFonts.beVietnamPro(
                  fontSize: 10,
                  color: _muted,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAiStatusCard() {
    return _glassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      _pink.withOpacity(.15),
                      _lavender.withOpacity(.20),
                    ],
                  ),
                ),
                child: const Icon(
                  Icons.smart_toy_rounded,
                  color: _pink,
                  size: 23,
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Text(
                  'Guardian AI Active',
                  style: GoogleFonts.montserrat(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: _dark,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _success.withOpacity(.10),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'ACTIVE',
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    color: _success,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 13),
          Text(
            'The Guardian AI is actively analyzing data from your Apple Watch. It continuously monitors for sudden movement anomalies, potential falls, and irregular heart rate patterns, ensuring preemptive safety alerts are ready if needed.',
            style: GoogleFonts.beVietnamPro(
              fontSize: 12,
              color: _muted,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(left: 5),
      child: Row(
        children: [
          Icon(icon, color: _pink, size: 18),
          const SizedBox(width: 9),
          Text(
            title,
            style: GoogleFonts.montserrat(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.1,
              color: _dark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSafetyTogglesCard() {
    return _glassCard(
      padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(2, 7, 2, 4),
            child: Text(
              'Protection options',
              style: GoogleFonts.montserrat(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: _dark,
              ),
            ),
          ),
          _buildToggleRow(
            icon: Icons.health_and_safety_outlined,
            title: 'Fall Detection',
            subtitle: 'Alerts emergency contacts if a hard fall is detected.',
            value: _fallDetection,
            onChanged: (value) => setState(() => _fallDetection = value),
          ),
          _buildDivider(),
          _buildToggleRow(
            icon: Icons.watch_off_outlined,
            title: 'Off-Body Alert',
            subtitle: 'Notify me if the watch is removed from the wrist.',
            value: _offBodyAlert,
            onChanged: (value) => setState(() => _offBodyAlert = value),
          ),
          _buildDivider(),
          _buildToggleRow(
            icon: Icons.favorite_border_rounded,
            title: 'Heart Rate Anomaly',
            subtitle: 'Guardian AI analyzes unusual heart rate patterns.',
            value: _heartAnomaly,
            onChanged: (value) => setState(() => _heartAnomaly = value),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleRow({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 13),
      child: Row(
        children: [
          _iconTile(icon, size: 39),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: _dark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 10.5,
                    color: _muted,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 7),
          Switch.adaptive(
            value: value,
            activeColor: Colors.white,
            activeTrackColor: _pink,
            inactiveTrackColor: Colors.white,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.only(left: 51),
      child: Divider(
        height: 1,
        thickness: 1,
        color: _lavender.withOpacity(.16),
      ),
    );
  }

  Widget _buildPrimaryButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [_pink, _lavender],
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: _pink.withOpacity(.20),
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ElevatedButton.icon(
          onPressed: onPressed,
          icon: Icon(icon, color: Colors.white, size: 20),
          label: Text(
            label,
            style: GoogleFonts.montserrat(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSecondaryButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: _pink, size: 19),
        label: Text(
          label,
          style: GoogleFonts.beVietnamPro(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: _pink,
          ),
        ),
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white.withOpacity(.65),
          side: BorderSide(color: _pink.withOpacity(.22)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
    );
  }
}

class _HeartRateGraphPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = const Color(0xFFD95791).withOpacity(.62)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    final fillPaint = Paint()
      ..shader = const LinearGradient(
        colors: [
          Color(0x33D95791),
          Color(0x00AA91D8),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Offset.zero & size)
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, size.height * .58)
      ..lineTo(size.width * .13, size.height * .58)
      ..lineTo(size.width * .19, size.height * .35)
      ..lineTo(size.width * .24, size.height * .78)
      ..lineTo(size.width * .31, size.height * .15)
      ..lineTo(size.width * .38, size.height * .88)
      ..lineTo(size.width * .44, size.height * .56)
      ..lineTo(size.width * .58, size.height * .58)
      ..lineTo(size.width * .66, size.height * .38)
      ..lineTo(size.width * .72, size.height * .77)
      ..lineTo(size.width * .80, size.height * .20)
      ..lineTo(size.width * .87, size.height * .85)
      ..lineTo(size.width * .93, size.height * .57)
      ..lineTo(size.width, size.height * .57);

    final fillPath = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}