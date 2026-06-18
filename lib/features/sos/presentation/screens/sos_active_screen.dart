import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/services/location_service.dart';
import '../../../../core/theme/app_theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/sos_cubit.dart';

class SosActiveScreen extends StatefulWidget {
  const SosActiveScreen({Key? key}) : super(key: key);

  @override
  State<SosActiveScreen> createState() => _SosActiveScreenState();
}

class _SosActiveScreenState extends State<SosActiveScreen> with SingleTickerProviderStateMixin {
  late AnimationController _bgPulseController;

  final LocationService _locationService =
  LocationService();
  final TextEditingController _pinController = TextEditingController();
  String _pinError = "";
  String _currentLocation = "Fetching location...";

  @override
  void initState() {
    super.initState();
    _bgPulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
    _loadCurrentLocation();
  }

  Future<void> _loadCurrentLocation() async {

    try {

      final position =
      await _locationService.getCurrentLocation();

      final placemarks =
      await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      final place =
          placemarks.first;

      setState(() {

        _currentLocation =
        "${place.locality}, "
            "${place.administrativeArea}";

      });

    } catch (e) {

      setState(() {

        _currentLocation =
        "Location unavailable";

      });

    }
  }

  @override
  void dispose() {
    _bgPulseController.dispose();
    _pinController.dispose();
    super.dispose();
  }

  void _handleCancelTap() {
    _showDisarmDialog();
  }

  void _showDisarmDialog() {
    _pinController.clear();
    setState(() {
      _pinError = "";
    });

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 16.0, sigmaY: 16.0),
                  child: Container(
                    color: Colors.white.withOpacity(0.95),
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Center(
                          child: Container(
                            width: 48,
                            height: 6,
                            decoration: BoxDecoration(
                              color: AppTheme.outlineVariant,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          "Disarm Emergency Guard",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.montserrat(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          "Enter your 4-digit safety PIN to disarm SOS and notify contacts you are safe.",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.beVietnamPro(
                            fontSize: 13,
                            color: AppTheme.textSecondary,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 24),
                        TextField(
                          controller: _pinController,
                          keyboardType: TextInputType.number,
                          obscureText: true,
                          maxLength: 4,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 20,
                          ),
                          decoration: InputDecoration(
                            counterText: "",
                            hintText: "••••",
                            hintStyle: TextStyle(
                              color: AppTheme.outlineVariant.withOpacity(0.6),
                              letterSpacing: 20,
                            ),
                          ),
                          onChanged: (val) {
                            if (val.length == 4) {
                              if (val == "1234") {
                                Navigator.pop(context); // close bottom sheet
                                context.pop(); // exit active SOS screen
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Emergency guard successfully disarmed. Circle alerted."),
                                    backgroundColor: AppTheme.success,
                                  ),
                                );
                              } else {
                                setModalState(() {
                                  _pinError = "Incorrect PIN code. Try again.";
                                  _pinController.clear();
                                });
                              }
                            }
                          },
                        ),
                        if (_pinError.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          Text(
                            _pinError,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.beVietnamPro(
                              color: AppTheme.error,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                        const SizedBox(height: 24),
                        Center(
                          child: Text(
                            "Pro-Tip: Default PIN is 1234",
                            style: GoogleFonts.beVietnamPro(
                              fontSize: 11,
                              fontStyle: FontStyle.italic,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    ).whenComplete(() {});
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFFFFDAD6), // bg-error-container (#ffdad6)
      body: Stack(
        children: [
          // Pulsing Background Elements
          Positioned.fill(
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Outer ring 1
                AnimatedBuilder(
                  animation: _bgPulseController,
                  builder: (context, child) {
                    double scale = 0.8 + (_bgPulseController.value * 1.7); // 0.8 to 2.5
                    double opacity = (1.0 - _bgPulseController.value) * 0.2;
                    return Opacity(
                      opacity: opacity.clamp(0.0, 1.0),
                      child: Transform.scale(
                        scale: scale,
                        child: Container(
                          width: 256,
                          height: 256,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppTheme.error,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                // Delayed outer ring 2
                AnimatedBuilder(
                  animation: _bgPulseController,
                  builder: (context, child) {
                    double val = (_bgPulseController.value + 0.25) % 1.0;
                    double scale = 0.8 + (val * 1.7);
                    double opacity = (1.0 - val) * 0.2;
                    return Opacity(
                      opacity: opacity.clamp(0.0, 1.0),
                      child: Transform.scale(
                        scale: scale,
                        child: Container(
                          width: 256,
                          height: 256,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppTheme.error,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          // Main Screen layout scrollable canvas to prevent overflow
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24.0,
                        vertical: 32.0,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Header Section
                          Column(
                            children: [
                              // Active Badge
                              Container(
                                decoration: BoxDecoration(
                                  color: AppTheme.error,
                                  borderRadius: BorderRadius.circular(9999),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppTheme.error.withOpacity(0.3),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    )
                                  ],
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0,
                                  vertical: 8.0,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.emergency,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      "SOS ACTIVE",
                                      style: GoogleFonts.beVietnamPro(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 1.5,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                "Alerting your 5 Guardians & Police",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.montserrat(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF93000A), // on-error-container
                                  height: 1.25,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Broadcasting exact location",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.beVietnamPro(
                                  fontSize: 18,
                                  fontWeight: FontWeight.normal,
                                  color: AppTheme.error,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 32),

                          // Live Map Window (Glass Panel)
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(16.0),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.5),
                                width: 1.0,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFFBA1A1A).withOpacity(0.15),
                                  blurRadius: 32,
                                  offset: const Offset(0, 8),
                                )
                              ],
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: Column(
                              children: [
                                // Map viewport
                                SizedBox(
                                  height: 192,
                                  width: double.infinity,
                                  child: Stack(
                                    children: [
                                      Positioned.fill(
                                        child: ColorFiltered(
                                          colorFilter: const ColorFilter.matrix([
                                            0.2126, 0.7152, 0.0722, 0, 0,
                                            0.2126, 0.7152, 0.0722, 0, 0,
                                            0.2126, 0.7152, 0.0722, 0, 0,
                                            0,      0,      0,      1, 0,
                                          ]),
                                          child: Image.asset(
                                            "assets/images/map_placeholder.png",
                                            fit: BoxFit.cover,
                                            opacity: const AlwaysStoppedAnimation(0.8),
                                          ),
                                        ),
                                      ),

                                      // Center Marker
                                      Center(
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            AnimatedBuilder(
                                              animation: _bgPulseController,
                                              builder: (context, child) {
                                                return Transform.scale(
                                                  scale: 1.0 + (_bgPulseController.value * 1.5),
                                                  child: Opacity(
                                                    opacity: 1.0 - _bgPulseController.value,
                                                    child: Container(
                                                      width: 48,
                                                      height: 48,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: AppTheme.primary.withOpacity(0.3),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                            Container(
                                              width: 24,
                                              height: 24,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: AppTheme.primary,
                                                border: Border.all(
                                                  color: Colors.white,
                                                  width: 2.0,
                                                ),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black.withOpacity(0.2),
                                                    blurRadius: 4,
                                                    offset: const Offset(0, 2),
                                                  )
                                                ],
                                              ),
                                              child: Center(
                                                child: Container(
                                                  width: 8,
                                                  height: 8,
                                                  decoration: const BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.white,
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

                                // Map address footer bar
                                Container(
                                  padding: const EdgeInsets.all(16.0),
                                  color: Colors.white.withOpacity(0.8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Live Location",
                                            style: GoogleFonts.beVietnamPro(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: AppTheme.textSecondary,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            _currentLocation,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          )
                                        ],
                                      ),
                                      const Icon(
                                        Icons.my_location,
                                        color: AppTheme.primary,
                                        size: 24,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 48),

                          // Footer Cancel / Action Area
                          Column(
                            children: [
                              // Pulsing Trigger Immediately button

                              const SizedBox(height: 60),

                              // Cancel Timer button
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
