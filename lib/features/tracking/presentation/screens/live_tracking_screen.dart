import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/lumina_bottom_navigation.dart';

class LiveTrackingScreen extends StatefulWidget {
  const LiveTrackingScreen({Key? key}) : super(key: key);

  @override
  State<LiveTrackingScreen> createState() => _LiveTrackingScreenState();
}

class _LiveTrackingScreenState extends State<LiveTrackingScreen>
    with TickerProviderStateMixin {

  late AnimationController _pulseController;
  final MapController _mapController = MapController();
  LatLng? _userLatLng;
  StreamSubscription<Position>? _positionStreamSubscription;
  bool _isLoadingLocation = true;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
    _initLocation();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _positionStreamSubscription?.cancel();
    super.dispose();
  }

  Future<void> _initLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    try {
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Location services are disabled. Please enable them.',
              ),
            ),
          );
        }
        setState(() {
          _isLoadingLocation = false;
          _userLatLng = const LatLng(
            37.4279613,
            -122.0857496,
          ); // default to Googleplex
        });
        return;
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Location permissions are denied.')),
            );
          }
          setState(() {
            _isLoadingLocation = false;
            _userLatLng = const LatLng(37.4279613, -122.0857496);
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Location permissions are permanently denied.'),
            ),
          );
        }
        setState(() {
          _isLoadingLocation = false;
          _userLatLng = const LatLng(37.4279613, -122.0857496);
        });
        return;
      }

      final Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      if (mounted) {
        setState(() {
          _userLatLng = LatLng(position.latitude, position.longitude);
          _isLoadingLocation = false;
        });
        // Delay slightly to allow MapController to attach properly
        Future.delayed(const Duration(milliseconds: 300), () {
          if (mounted && _userLatLng != null) {
            _mapController.move(_userLatLng!, 15.0);
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingLocation = false;
          _userLatLng = const LatLng(37.4279613, -122.0857496);
        });
      }
    }

    _positionStreamSubscription =
        Geolocator.getPositionStream(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
            distanceFilter: 5,
          ),
        ).listen((Position position) {
          if (mounted) {
            setState(() {
              _userLatLng = LatLng(position.latitude, position.longitude);
            });
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. Full Bleed Map Background using flutter_map
          Positioned.fill(
            child: _isLoadingLocation
                ? const Center(
                    child: CircularProgressIndicator(color: AppTheme.primary),
                  )
                : FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      initialCenter:
                          _userLatLng ?? const LatLng(37.4279613, -122.0857496),
                      initialZoom: 15.0,
                      minZoom: 3.0,
                      maxZoom: 18.0,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName:
                            'com.luminaguardian.lumina_guardian',
                      ),
                      // Marker Layer
                      MarkerLayer(
                        markers: [
                          // Pulse User Location Marker
                          if (_userLatLng != null)
                            Marker(
                              point: _userLatLng!,
                              width: 80,
                              height: 80,
                              child: AnimatedBuilder(
                                animation: _pulseController,
                                builder: (context, child) {
                                  return Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      // Concentric outer pulsing circle 1
                                      Container(
                                        width: 48 * _pulseController.value,
                                        height: 48 * _pulseController.value,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: AppTheme.primaryContainer
                                              .withOpacity(
                                                0.4 *
                                                    (1.0 -
                                                        _pulseController.value),
                                              ),
                                        ),
                                      ),
                                      // Concentric outer pulsing circle 2 (with delay phase)
                                      Container(
                                        width:
                                            72 *
                                            ((_pulseController.value + 0.5) %
                                                1.0),
                                        height:
                                            72 *
                                            ((_pulseController.value + 0.5) %
                                                1.0),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: AppTheme.primaryContainer
                                              .withOpacity(
                                                0.2 *
                                                    (1.0 -
                                                        ((_pulseController
                                                                    .value +
                                                                0.5) %
                                                            1.0)),
                                              ),
                                        ),
                                      ),
                                      // Core point circle
                                      Container(
                                        width: 24,
                                        height: 24,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: AppTheme.primary,
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 3.0,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(
                                                0.15,
                                              ),
                                              blurRadius: 4,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
          ),

          // 2. Map Controls (Right Side Stack)
          Positioned(
            top: 220,
            right: 20,
            child: Column(
              children: [
                // Zoom controls container
                ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.85),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.4),
                          width: 1.0,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primaryContainer.withOpacity(0.08),
                            blurRadius: 20.0,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.add,
                              color: AppTheme.textSecondary,
                            ),
                            onPressed: () {
                              _mapController.move(
                                _mapController.camera.center,
                                _mapController.camera.zoom + 1.0,
                              );
                            },
                          ),
                          Container(
                            width: 24,
                            height: 1,
                            color: const Color(0xFFDBD9D9),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.remove,
                              color: AppTheme.textSecondary,
                            ),
                            onPressed: () {
                              _mapController.move(
                                _mapController.camera.center,
                                _mapController.camera.zoom - 1.0,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // My Location floating button
                ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.85),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withOpacity(0.4),
                          width: 1.0,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primaryContainer.withOpacity(0.08),
                            blurRadius: 20.0,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.my_location,
                          color: AppTheme.primary,
                        ),
                        onPressed: () {
                          if (_userLatLng != null) {
                            _mapController.move(_userLatLng!, 15.0);
                          }
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),

          // 6. Bottom Monitoring Card
          DraggableScrollableSheet(
            initialChildSize: 0.18,
            minChildSize: 0.16,
            maxChildSize: 0.80,
            snap: true,
            snapSizes: const [0.32, 0.55, 0.78],
            builder: (context, scrollController) {
              return ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(
                      24,
                      12,
                      24,
                      16,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.85),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(32),
                        topRight: Radius.circular(32),),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.5),
                        width: 1.0,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primaryContainer.withOpacity(0.15),
                          blurRadius: 30,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: SingleChildScrollView(
                      controller: scrollController,
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [

                          Center(
                            child: Container(
                              width: 44,
                              height: 5,
                              margin: const EdgeInsets.only(
                                bottom: 18,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade400,
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                        // Status Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Stack(
                                  children: [
                                    Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppTheme.primaryContainer
                                            .withOpacity(0.2),
                                      ),
                                      child: const Icon(
                                        Icons.shield,
                                        color: AppTheme.primary,
                                        size: 20,
                                      ),
                                    ),
                                    // Green Active Indicator dot
                                    Positioned(
                                      top: 0,
                                      right: 0,
                                      child: Container(
                                        width: 12,
                                        height: 12,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.green,
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 2.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Live Tracking",
                                      style: GoogleFonts.montserrat(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.textPrimary,
                                      ),
                                    ),
                                    Text(
                                      "Tracking active • Updated just now",
                                      style: GoogleFonts.beVietnamPro(
                                        fontSize: 12,
                                        color: AppTheme.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                          const SizedBox(height: 24),

                          Divider(),

                          const SizedBox(height: 20),

                          Text(
                            "🚶🏻‍♀️ Journey",
                            style: GoogleFonts.montserrat(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),

                          const SizedBox(height: 18),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [

                              _buildJourneyItem(
                                "Started",
                                "7:45 PM",
                                Icons.schedule,
                              ),

                              _buildJourneyItem(
                                "Duration",
                                "18 min",
                                Icons.timelapse,
                              ),

                              _buildJourneyItem(
                                "Distance",
                                "4.2 km",
                                Icons.straighten,
                              ),

                            ],
                          ),

                          const SizedBox(height: 28),

                          Divider(),

                          const SizedBox(height: 20),

                          Text(
                            "🛡 Safety Status",
                            style: GoogleFonts.montserrat(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),

                          const SizedBox(height: 18),

                          _buildStatusRow(
                            Icons.favorite,
                            "Heartbeat",
                            "72 BPM",
                            Colors.red,
                          ),

                          _buildStatusRow(
                            Icons.watch,
                            "Wearable",
                            "Connected",
                            Colors.green,
                          ),

                          _buildStatusRow(
                            Icons.my_location,
                            "GPS Accuracy",
                            "±5 m",
                            Colors.blue,
                          ),

                          _buildStatusRow(
                            Icons.battery_full,
                            "Battery",
                            "92%",
                            Colors.orange,
                          ),

                          _buildStatusRow(
                            Icons.network_wifi,
                            "Network",
                            "Excellent",
                            Colors.green,
                          ),
                      ],
                     ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: const LuminaBottomNavigation(
        currentIndex: 1,
      ),
    );
  }

  Widget _buildJourneyItem(
      String title,
      String value,
      IconData icon,
      ) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 10,
        ),
        decoration: BoxDecoration(
          color: AppTheme.primaryContainer.withOpacity(.08),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: AppTheme.primaryContainer.withOpacity(.15),
          ),
        ),
        child: Column(
          children: [

            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: AppTheme.primary.withOpacity(.10),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: AppTheme.primary,
                size: 22,
              ),
            ),

            const SizedBox(height: 12),

            Text(
              value,
              style: GoogleFonts.montserrat(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              title,
              style: GoogleFonts.beVietnamPro(
                color: AppTheme.textSecondary,
                fontSize: 13,
              ),
            ),

          ],
        ),
      ),
    );
  }

  Widget _buildStatusRow(
      IconData icon,
      String title,
      String status,
      Color color,
      ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: Row(
        children: [

          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppTheme.primary.withOpacity(.10),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: AppTheme.primary,
              size: 20,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Text(
              title,
              style: GoogleFonts.beVietnamPro(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: color.withOpacity(.10),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              status,
              style: GoogleFonts.beVietnamPro(
                color: color,
                fontWeight: FontWeight.w500,
                fontSize: 13,
              ),
            ),
          ),

        ],
      ),
    );
  }
}
