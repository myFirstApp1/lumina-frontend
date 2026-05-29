import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';

class WearableSyncScreen extends StatefulWidget {
  const WearableSyncScreen({Key? key}) : super(key: key);

  @override
  State<WearableSyncScreen> createState() => _WearableSyncScreenState();
}

class _WearableSyncScreenState extends State<WearableSyncScreen> with TickerProviderStateMixin {
  late AnimationController _heartController;
  late AnimationController _greenPulseController;

  bool _fallDetection = true;
  bool _offBodyAlert = true;
  bool _heartAnomaly = true;

  @override
  void initState() {
    super.initState();
    // Heartbeat pulse animation
    _heartController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    // Green online indicator pulse animation
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
      body: Stack(
        children: [
          // Background soft canvas
          Container(
            color: AppTheme.background,
          ),

          // Main Scrollable Canvas
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20.0, 72.0, 20.0, 48.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Active Device Card
                  _buildDeviceCard(),

                  const SizedBox(height: 16),

                  // Status Indicator Bento Cards (Battery & Bluetooth side-by-side)
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatusCard(
                          icon: Icons.battery_charging_full,
                          title: "Battery",
                          value: "82%",
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildStatusCard(
                          icon: Icons.bluetooth_connected,
                          title: "Connection",
                          value: "Strong",
                          trailingWidget: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(Icons.signal_cellular_alt, color: AppTheme.primary, size: 14),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Real-time Vitals & AI Status (Bento Stack)
                  _buildVitalsCard(),

                  const SizedBox(height: 16),

                  _buildAiStatusCard(),

                  const SizedBox(height: 24),

                  // Safety Toggles Card
                  _buildSafetyTogglesCard(),

                  const SizedBox(height: 24),

                  // Actions Area
                  Column(
                    children: [
                      // Sync Device Now Gradient Button
                      Container(
                        width: double.infinity,
                        height: 56,
                        decoration: BoxDecoration(
                          gradient: AppTheme.primaryGradient,
                          borderRadius: BorderRadius.circular(28.0),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primary.withOpacity(0.25),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            )
                          ],
                        ),
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.sync, color: Colors.white, size: 20),
                          label: Text(
                            "Sync Device Now",
                            style: GoogleFonts.montserrat(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            foregroundColor: Colors.white,
                            shadowColor: Colors.transparent,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Device Settings Outlined Button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.settings, color: AppTheme.primary, size: 20),
                          label: Text(
                            "Device Settings",
                            style: GoogleFonts.beVietnamPro(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppTheme.primary,
                            backgroundColor: Colors.white,
                            side: BorderSide(color: AppTheme.primary.withOpacity(0.2), width: 1.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28.0),
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

          // Custom TopAppBar matching specs exactly
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  height: 64,
                  decoration: BoxDecoration(
                    color: AppTheme.surface.withOpacity(0.7),
                    border: Border(
                      bottom: BorderSide(
                        color: AppTheme.outlineVariant.withOpacity(0.3),
                        width: 1.0,
                      ),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Back button
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: AppTheme.primary),
                        onPressed: () => context.pop(),
                      ),
                      // Title
                      Text(
                        "My Wearables",
                        style: GoogleFonts.montserrat(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primary,
                        ),
                      ),
                      // Balancing hidden trailing element
                      const SizedBox(width: 48),
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

  Widget _buildDeviceCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.75),
        borderRadius: BorderRadius.circular(24.0),
        border: Border.all(color: Colors.white.withOpacity(0.5), width: 1.0),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryContainer.withOpacity(0.08),
            blurRadius: 24,
            offset: const Offset(0, 4),
          )
        ],
      ),
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          // Smartwatch product image shot
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              image: const DecorationImage(
                image: NetworkImage(
                  "https://lh3.googleusercontent.com/aida-public/AB6AXuBtYdXQ5Hat-ldE57wRw-T_hhAJSZUHaNSAOHQvgxpui_gnYPLZWlEd5zzBEKDg_ncrSdU88MWfyE2LsHelP5ia39UunWHu3wFDNQWA5ZgZwzS0dtnbrMfr1eLsQYJnohqrnxkqzqX4YelnIyv9Jcn1E2mxhZCuhqwl3v64v-GJq-cewyXTNy-rZbCflTDb0PoPIGA7bcuD0_-ZDvRiMbXn8W4MUwx1pkwhnEPouJWdP0HDjL594iMJn_9VZXFkFxLkiVDS-MZm4iE",
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Pulsing Green Live dot indicator row
                Row(
                  children: [
                    AnimatedBuilder(
                      animation: _greenPulseController,
                      builder: (context, child) {
                        return Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 14 * _greenPulseController.value,
                              height: 14 * _greenPulseController.value,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppTheme.success.withOpacity(0.5 * (1.0 - _greenPulseController.value)),
                              ),
                            ),
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppTheme.success,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Live & Connected",
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.success,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  "Apple Watch Series 8",
                  style: GoogleFonts.montserrat(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "Assigned to: Guardian AI Profile",
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard({
    required IconData icon,
    required String title,
    required String value,
    Widget? trailingWidget,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.75),
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(color: Colors.white.withOpacity(0.5), width: 1.0),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryContainer.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          )
        ],
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.primaryContainer.withOpacity(0.15),
                ),
                child: Icon(icon, color: AppTheme.primary, size: 18),
              ),
              if (trailingWidget != null) trailingWidget,
            ],
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: GoogleFonts.beVietnamPro(
              fontSize: 12,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: GoogleFonts.montserrat(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVitalsCard() {
    return Container(
      height: 280,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.75),
        borderRadius: BorderRadius.circular(24.0),
        border: Border.all(color: Colors.white.withOpacity(0.5), width: 1.0),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryContainer.withOpacity(0.08),
            blurRadius: 24,
            offset: const Offset(0, 4),
          )
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Simulated background graph lines painter
          Positioned.fill(
            child: CustomPaint(
              painter: HeartrateGraphPainter(),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Live Heart Rate",
                          style: GoogleFonts.montserrat(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "Continuous monitoring active",
                          style: GoogleFonts.beVietnamPro(
                            fontSize: 12,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    // Pulsing Heart Icon
                    ScaleTransition(
                      scale: Tween(begin: 0.9, end: 1.15).animate(
                        CurvedAnimation(parent: _heartController, curve: Curves.easeInOut),
                      ),
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppTheme.primary.withOpacity(0.1),
                        ),
                        child: const Icon(
                          Icons.favorite,
                          color: AppTheme.primary,
                          size: 26,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "72",
                      style: GoogleFonts.montserrat(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primary,
                        height: 1.0,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6.0),
                      child: Text(
                        "BPM",
                        style: GoogleFonts.beVietnamPro(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAiStatusCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.75),
        borderRadius: BorderRadius.circular(24.0),
        border: Border.all(color: AppTheme.primary.withOpacity(0.15), width: 1.0),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryContainer.withOpacity(0.08),
            blurRadius: 24,
            offset: const Offset(0, 4),
          )
        ],
      ),
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFFFDD8E5),
                      blurRadius: 10,
                      offset: Offset(0, 2),
                    )
                  ],
                ),
                child: const Icon(
                  Icons.smart_toy,
                  color: AppTheme.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Text(
                "Guardian AI Active",
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            "The Guardian AI is actively analyzing data from your Apple Watch. It continuously monitors for sudden movement anomalies, potential falls, and irregular heart rate patterns, ensuring preemptive safety alerts are ready if needed.",
            style: GoogleFonts.beVietnamPro(
              fontSize: 13,
              color: AppTheme.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSafetyTogglesCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.75),
        borderRadius: BorderRadius.circular(24.0),
        border: Border.all(color: Colors.white.withOpacity(0.5), width: 1.0),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryContainer.withOpacity(0.08),
            blurRadius: 24,
            offset: const Offset(0, 4),
          )
        ],
      ),
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "Device Safety Features",
            style: GoogleFonts.montserrat(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          _buildToggleRow(
            title: "Fall Detection",
            subtitle: "Alerts emergency contacts if a hard fall is detected.",
            value: _fallDetection,
            onChanged: (val) {
              setState(() {
                _fallDetection = val;
              });
            },
          ),
          const Divider(height: 1, color: AppTheme.outlineVariant),
          _buildToggleRow(
            title: "Off-Body Alert",
            subtitle: "Notify me if the watch is removed from the wrist.",
            value: _offBodyAlert,
            onChanged: (val) {
              setState(() {
                _offBodyAlert = val;
              });
            },
          ),
          const Divider(height: 1, color: AppTheme.outlineVariant),
          _buildToggleRow(
            title: "Heart Rate Anomaly",
            subtitle: "Guardian AI analyzes patterns for unusual spikes or drops.",
            value: _heartAnomaly,
            onChanged: (val) {
              setState(() {
                _heartAnomaly = val;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildToggleRow({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 12,
                    color: AppTheme.textSecondary.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Switch.adaptive(
            value: value,
            activeColor: AppTheme.primary,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

// Custom Painter to draw desaturated abstract graph pattern inside real-time vitals card
class HeartrateGraphPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = AppTheme.primary.withOpacity(0.18)
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final fillPaint = Paint()
      ..color = AppTheme.primaryContainer.withOpacity(0.04)
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height * 0.75);
    path.lineTo(size.width * 0.15, size.height * 0.75);
    path.lineTo(size.width * 0.20, size.height * 0.58);
    path.lineTo(size.width * 0.25, size.height * 0.88);
    path.lineTo(size.width * 0.32, size.height * 0.40);
    path.lineTo(size.width * 0.38, size.height * 0.95);
    path.lineTo(size.width * 0.43, size.height * 0.65);
    path.lineTo(size.width * 0.48, size.height * 0.75);
    path.lineTo(size.width * 0.65, size.height * 0.75);
    path.lineTo(size.width * 0.70, size.height * 0.52);
    path.lineTo(size.width * 0.75, size.height * 0.90);
    path.lineTo(size.width * 0.82, size.height * 0.32);
    path.lineTo(size.width * 0.88, size.height * 0.98);
    path.lineTo(size.width * 0.93, size.height * 0.68);
    path.lineTo(size.width, size.height * 0.75);

    final fillPath = Path.from(path);
    fillPath.lineTo(size.width, size.height);
    fillPath.lineTo(0, size.height);
    fillPath.close();

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
