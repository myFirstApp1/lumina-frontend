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

class LiveTrackingScreen extends StatefulWidget {
  const LiveTrackingScreen({Key? key}) : super(key: key);

  @override
  State<LiveTrackingScreen> createState() => _LiveTrackingScreenState();
}

class _LiveTrackingScreenState extends State<LiveTrackingScreen> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  final TextEditingController _searchController = TextEditingController();
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
    _searchController.dispose();
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
            const SnackBar(content: Text('Location services are disabled. Please enable them.')),
          );
        }
        setState(() {
          _isLoadingLocation = false;
          _userLatLng = const LatLng(37.4279613, -122.0857496); // default to Googleplex
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
            const SnackBar(content: Text('Location permissions are permanently denied.')),
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

    _positionStreamSubscription = Geolocator.getPositionStream(
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
                    child: CircularProgressIndicator(
                      color: AppTheme.primary,
                    ),
                  )
                : FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      initialCenter: _userLatLng ?? const LatLng(37.4279613, -122.0857496),
                      initialZoom: 15.0,
                      minZoom: 3.0,
                      maxZoom: 18.0,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.luminaguardian.lumina_guardian',
                      ),
                      // Marker Layer
                      MarkerLayer(
                        markers: [
                          // Safe Haven Map Marker (positioned slightly north-west of user)
                          Marker(
                            point: _userLatLng != null
                                ? LatLng(_userLatLng!.latitude + 0.003, _userLatLng!.longitude - 0.004)
                                : const LatLng(37.4309613, -122.0897496),
                            width: 130,
                            height: 40,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(color: AppTheme.primaryContainer.withOpacity(0.3), width: 1.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.06),
                                    blurRadius: 8.0,
                                  )
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.security,
                                    color: AppTheme.primary,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    "Safe Haven",
                                    style: GoogleFonts.beVietnamPro(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
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
                                          color: AppTheme.primaryContainer.withOpacity(0.4 * (1.0 - _pulseController.value)),
                                        ),
                                      ),
                                      // Concentric outer pulsing circle 2 (with delay phase)
                                      Container(
                                        width: 72 * ((_pulseController.value + 0.5) % 1.0),
                                        height: 72 * ((_pulseController.value + 0.5) % 1.0),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: AppTheme.primaryContainer.withOpacity(0.2 * (1.0 - ((_pulseController.value + 0.5) % 1.0))),
                                        ),
                                      ),
                                      // Core point circle
                                      Container(
                                        width: 24,
                                        height: 24,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: AppTheme.primary,
                                          border: Border.all(color: Colors.white, width: 3.0),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.15),
                                              blurRadius: 4,
                                              offset: const Offset(0, 2),
                                            )
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

          // 2. Floating Search Bar (Top)
          Positioned(
            top: 48,
            left: 20,
            right: 20,
            child: SafeArea(
              bottom: false,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.85),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.white.withOpacity(0.4), width: 1.0),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primaryContainer.withOpacity(0.12),
                          blurRadius: 20.0,
                          offset: const Offset(0, 4),
                        )
                      ],
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.search,
                          color: AppTheme.textSecondary,
                          size: 22,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            style: GoogleFonts.beVietnamPro(
                              fontSize: 15,
                              color: AppTheme.textPrimary,
                            ),
                            decoration: InputDecoration(
                              hintText: "Search Safe Havens",
                              hintStyle: GoogleFonts.beVietnamPro(
                                color: AppTheme.textSecondary.withOpacity(0.7),
                              ),
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              filled: false,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFFE4E2E2).withOpacity(0.5),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.mic, color: AppTheme.primary, size: 18),
                            padding: EdgeInsets.zero,
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // 3. Map Controls (Right Side Stack)
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
                        border: Border.all(color: Colors.white.withOpacity(0.4), width: 1.0),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primaryContainer.withOpacity(0.08),
                            blurRadius: 20.0,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      child: Column(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.add, color: AppTheme.textSecondary),
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
                            icon: const Icon(Icons.remove, color: AppTheme.textSecondary),
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
                        border: Border.all(color: Colors.white.withOpacity(0.4), width: 1.0),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primaryContainer.withOpacity(0.08),
                            blurRadius: 20.0,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.my_location, color: AppTheme.primary),
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

                // Layers button
                ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.85),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white.withOpacity(0.4), width: 1.0),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primaryContainer.withOpacity(0.08),
                            blurRadius: 20.0,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.layers_outlined, color: AppTheme.textSecondary),
                        onPressed: () {},
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 6. Bottom Monitoring Card
          Positioned(
            bottom: 95,
            left: 20,
            right: 20,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                child: Container(
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.85),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.white.withOpacity(0.5), width: 1.0),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryContainer.withOpacity(0.15),
                        blurRadius: 30,
                        offset: const Offset(0, 8),
                      )
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
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
                                      color: AppTheme.primaryContainer.withOpacity(0.2),
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
                                        border: Border.all(color: Colors.white, width: 2.0),
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
                                    "Active Monitoring",
                                    style: GoogleFonts.montserrat(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.textPrimary,
                                    ),
                                  ),
                                  Text(
                                    "Route shared with 2 contacts",
                                    style: GoogleFonts.beVietnamPro(
                                      fontSize: 12,
                                      color: AppTheme.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          IconButton(
                            icon: const Icon(Icons.more_vert, color: AppTheme.textSecondary),
                            onPressed: () {},
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Trusted Contacts Row
                      Container(
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE4E2E2).withOpacity(0.3),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            // Overlapping circular profile photos
                            SizedBox(
                              width: 80,
                              height: 40,
                              child: Stack(
                                children: [
                                  // Photo 1: Alex Chen
                                  Positioned(
                                    left: 0,
                                    child: Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(color: Colors.white, width: 2.0),
                                        image: const DecorationImage(
                                          image: NetworkImage(
                                            "https://lh3.googleusercontent.com/aida-public/AB6AXuBCdvYsBkhd9PGVt2hFU9zhm0mnJOhEuxhYnIhpPeUedKxHt5FM78Rf7qM_eqwg8nA9qdmQXzUFN6esdjaMediaBlhX66RYmWhapRd6RlzN61RTfQHRFEjLMgw7r1E7ES1puTu0ceQiBx_DjXnr0pmr6nYn-K3bdWJBd2O8TNtkjZK75b1nnwDdaV5TgW8uDNvZ253Dc6IOLMRHsS17eM_CWPcqGxKv7J1dWMB6FrI7umLmggxqzq32ohKsywVGGTxvkRha6bCvPG8",
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Photo 2: Sam (Mom)
                                  Positioned(
                                    left: 20,
                                    child: Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(color: Colors.white, width: 2.0),
                                        image: const DecorationImage(
                                          image: NetworkImage(
                                            "https://lh3.googleusercontent.com/aida-public/AB6AXuDrAAMB14DZkbs0qe6Q-toj5MY8E6fBKgd1loNapUh68QCYiVmhXDUnR5d9XKzAV15M_UIpOWT3WJbXcTJVy5pBJw4kb14tKR8ZQQ7jWcue-nyc1eRxZt4VtcqhBPxD8bHQho0TpQvx2Dni5EgbuWwBJ1h1q72wH43__WvBbiG9IG3CBlq5CHXnBMI0JiN_l7k5ZYAMuIP7IYWze3xCb6jeJeQjoeyD224zpXg2nFEQ9r82urHY_P8jT846lW03idEzMm9NmzBg4bk",
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Add button photo mock overlay
                                  Positioned(
                                    left: 40,
                                    child: Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(color: Colors.white, width: 2.0),
                                        color: AppTheme.surface,
                                      ),
                                      child: const Icon(Icons.add, color: AppTheme.textSecondary, size: 18),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Alex",
                                  style: GoogleFonts.beVietnamPro(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.textPrimary,
                                  ),
                                ),
                                Text(
                                  "0.2 miles away",
                                  style: GoogleFonts.beVietnamPro(
                                    fontSize: 11,
                                    color: AppTheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // CTA Actions Row
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 48,
                              decoration: BoxDecoration(
                                gradient: AppTheme.primaryGradient,
                                borderRadius: BorderRadius.circular(24.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppTheme.primary.withOpacity(0.3),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  )
                                ],
                              ),
                              child: ElevatedButton.icon(
                                onPressed: () {},
                                icon: const Icon(Icons.share_location, color: Colors.white, size: 18),
                                label: Text(
                                  "Share Live",
                                  style: GoogleFonts.beVietnamPro(
                                    fontSize: 14,
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
                          ),
                          const SizedBox(width: 12),
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFFE4E2E2).withOpacity(0.5),
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.call, color: AppTheme.textPrimary, size: 20),
                              onPressed: () {},
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // 7. Floating Overlapping SOS FAB
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.42,
            right: 20,
            child: FloatingActionButton(
              onPressed: () => context.push(AppRoutes.sosActive),
              backgroundColor: AppTheme.error,
              foregroundColor: Colors.white,
              shape: CircleBorder(
                side: BorderSide(color: Colors.white, width: 3.0),
              ),
              elevation: 8.0,
              child: Text(
                "SOS",
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),

          // 8. Custom Bottom Navigation Bar (Mobile Only - Contacts inactive, Map Active!)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 85,
              decoration: BoxDecoration(
                color: AppTheme.surface.withOpacity(0.9),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16.0),
                  topRight: Radius.circular(16.0),
                ),
                border: Border(
                  top: BorderSide(color: Colors.white.withOpacity(0.4), width: 1.0),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 40.0,
                    offset: const Offset(0, -10),
                  )
                ],
              ),
              child: SafeArea(
                top: false,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildNavItem(context, Icons.home, "Home", false, () {
                      context.go(AppRoutes.home);
                    }),
                    
                    // Map active pill styled
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryContainer.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.map_outlined, color: AppTheme.primary, size: 20, ),
                          const SizedBox(width: 4),
                          Text(
                            "Map",
                            style: GoogleFonts.beVietnamPro(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // SOS icon overlapping navigation area
                    Transform.translate(
                      offset: const Offset(0, -18),
                      child: GestureDetector(
                        onTap: () => context.push(AppRoutes.sosActive),
                        child: Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [Color(0xFFDC2626), Color(0xFFB91C1C)],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                            border: Border.all(color: Colors.white.withOpacity(0.2), width: 1.0),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFDC2626).withOpacity(0.6),
                                blurRadius: 20.0,
                                offset: const Offset(0, 8),
                              )
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.emergency_share,
                                color: Colors.white,
                                size: 28,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                "SOS",
                                style: GoogleFonts.beVietnamPro(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    _buildNavItem(context, Icons.group_work_outlined, "Circle", false, () {
                      context.go(AppRoutes.contactsCircle);
                    }),
                    _buildNavItem(context, Icons.settings_outlined, "Settings", false, () {
                      context.push(AppRoutes.settings);
                    }),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, IconData icon, String label, bool isActive, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? AppTheme.primary : AppTheme.textSecondary.withOpacity(0.8),
              size: 24,
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: GoogleFonts.beVietnamPro(
                fontSize: 12,
                fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                color: isActive ? AppTheme.primary : AppTheme.textSecondary.withOpacity(0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
