//import 'dart:async';
import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/avatar_helper.dart';
import '../../../../core/widgets/lumina_bottom_navigation.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../profile/presentation/cubit/profile_cubit.dart';
import '../../../profile/presentation/cubit/profile_state.dart';
import '../../../protection/presentation/cubit/protection_cubit.dart';
import '../../../sos/presentation/cubit/sos_cubit.dart';
import '../../../tracking/presentation/cubit/tracking_cubit.dart';

class HomeDashboardScreen extends StatefulWidget {
  const HomeDashboardScreen({Key? key}) : super(key: key);

  @override
  State<HomeDashboardScreen> createState() => _HomeDashboardScreenState();
}

class _HomeDashboardScreenState extends State<HomeDashboardScreen>
    with TickerProviderStateMixin {
  // sos button
  late AnimationController _pulseController;
  late AnimationController _pingController;
  Timer? _holdTimer;
  bool _isHolding = false;

  // for greeting container
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _avatarScale;

  // while holding sos
  late AnimationController _rippleController;
  late Animation<double> _rippleAnimation;

  // connection for wearable devices
  late AnimationController _connectionController;
  late Animation<double> _connectionAnimation;

  @override
  void initState() {
    super.initState();
    // Pulse animation controller for the inner ring (2s duration, repeats)
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    // Ping animation controller for the outer ring (3s duration, repeats)
    _pingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final authState = context.read<AuthCubit>().state;

      if (authState is AuthAuthenticated) {
        await context.read<ProfileCubit>().loadProfile(authState.user.userId);

        context.read<ProtectionCubit>().startProtection(
            //authState.user.userId
        );
      }

      await context.read<SosCubit>().restoreActiveSos();
    });

    // greeting container
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, .15),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _avatarScale = Tween<double>(
      begin: .85,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _controller.forward();

    // while holding sos
    _rippleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _rippleAnimation = Tween<double>(begin: 1.0, end: 1.8).animate(
      CurvedAnimation(parent: _rippleController, curve: Curves.easeOut),
    );

    // wearable connection animation
    _connectionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _connectionAnimation = Tween<double>(begin: 1.0, end: 1.25).animate(
      CurvedAnimation(parent: _connectionController, curve: Curves.easeInOut),
    );

    _connectionController.repeat(reverse: true);
  }

  Future<bool> validateLocation() async {
    bool enabled = await Geolocator.isLocationServiceEnabled();

    if (!enabled) {
      await Geolocator.openLocationSettings();

      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      await Geolocator.openAppSettings();

      return false;
    }

    return true;
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _pingController.dispose();
    _holdTimer?.cancel();
    _controller.dispose();
    _rippleController.dispose();
    _connectionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SosCubit, SosState>(
      listener: (context, state) {
        if (state is SosAlertActive) {
          debugPrint("======================");
          debugPrint("ACTIVE SOS DETECTED");
          debugPrint("OPENING SOS SCREEN");
          debugPrint("======================");

          context.go(AppRoutes.sosActive);
        }
      },

      child: Scaffold(
        body: Stack(
          children: [
            // Background soft pink canvas
            Container(color: AppTheme.background),

            // Decorative top glowing circular ambient highlights
            Positioned(
              top: -100,
              left: -100,
              width: 400,
              height: 400,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.primaryContainer.withOpacity(0.08),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 100.0, sigmaY: 100.0),
                  child: Container(color: Colors.transparent),
                ),
              ),
            ),

            // Main Scrollable Body
            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 110.0),
                // Extra bottom padding for floating nav bar
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // TopAppBar Row matching HTML exactly
                    BlocBuilder<ProfileCubit, ProfileState>(
                      builder: (context, state) {
                        String avatar = "";
                        String username = "Loading...";

                        if (state is ProfileLoaded) {
                          avatar = state.profile.avatar;
                          username = state.profile.name;
                        }

                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () => context.push(AppRoutes.profile),
                              child: ScaleTransition(
                                scale: _avatarScale,
                                child: Container(
                                  width: 48,
                                  height: 48,

                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2,
                                    ),

                                    boxShadow: [
                                      BoxShadow(
                                        color: AppTheme.primary.withOpacity(
                                          .15,
                                        ),
                                        blurRadius: 16,
                                      ),
                                    ],
                                  ),

                                  child: ClipOval(
                                    child: Image.asset(
                                      AvatarHelper.getAvatarPath(avatar),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(
                              width: 46,
                              height: 46,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.settings_outlined,
                                  color: AppTheme.primary,
                                ),
                                onPressed: () =>
                                    context.push(AppRoutes.settings),
                                style: IconButton.styleFrom(
                                  backgroundColor: AppTheme.primaryContainer
                                      .withOpacity(.2),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 24.0),

                    // Dashboard Welcome Card
                    BlocBuilder<ProfileCubit, ProfileState>(
                      builder: (context, state) {
                        String username = "User";

                        if (state is ProfileLoaded) {
                          username = state.profile.name;
                        }

                        final hour = DateTime.now().hour;

                        String greeting;

                        if (hour < 12) {
                          greeting = "Good Morning";
                        } else if (hour < 17) {
                          greeting = "Good Afternoon";
                        } else if (hour < 21) {
                          greeting = "Good Evening";
                        } else {
                          greeting = "Stay Safe Tonight";
                        }

                        return FadeTransition(
                          opacity: _fadeAnimation,
                          child: SlideTransition(
                            position: _slideAnimation,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 700),
                              curve: Curves.easeOut,
                              padding: const EdgeInsets.all(24),

                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(24),

                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Colors.white.withOpacity(.95),
                                    Colors.white.withOpacity(.85),
                                  ],
                                ),

                                border: Border.all(
                                  color: Colors.white.withOpacity(.7),
                                ),

                                boxShadow: [
                                  BoxShadow(
                                    color: AppTheme.primary.withOpacity(.08),
                                    blurRadius: 30,
                                    offset: const Offset(0, 12),
                                  ),
                                ],
                              ),

                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Text(
                                        "👋🏻",
                                        style: TextStyle(fontSize: 20),
                                      ),

                                      const SizedBox(width: 8),

                                      Expanded(
                                        child: Text(
                                          "$greeting, $username",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.montserrat(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: AppTheme.primary,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 10),

                                  Text(
                                    "Your personal safety network is active and continuously monitoring.",

                                    style: GoogleFonts.beVietnamPro(
                                      fontSize: 15,
                                      color: AppTheme.textSecondary,
                                      height: 1.6,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 32.0),

                    // Central SOS Action Area
                    Column(
                      children: [
                        Center(
                          child: SizedBox(
                            width: 280,
                            height: 280,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // ==========================
                                // OUTER PING RING
                                // ==========================
                                AnimatedBuilder(
                                  animation: _pingController,
                                  builder: (context, child) {
                                    return Transform.scale(
                                      scale:
                                          1.0 + (_pingController.value * 0.4),
                                      child: Opacity(
                                        opacity: 1.0 - _pingController.value,
                                        child: Container(
                                          width: 200,
                                          height: 200,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.red.withOpacity(0.20),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),

                                // ==========================
                                // HOLD RIPPLE
                                // Only visible while holding
                                // ==========================
                                if (_isHolding)
                                  AnimatedBuilder(
                                    animation: _rippleController,
                                    builder: (context, child) {
                                      return Transform.scale(
                                        scale: _rippleAnimation.value,
                                        child: Opacity(
                                          opacity: 1 - _rippleController.value,
                                          child: Container(
                                            width: 210,
                                            height: 210,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: Colors.redAccent
                                                    .withOpacity(.8),
                                                width: 4,
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),

                                // ==========================
                                // PULSE RING
                                // ==========================
                                AnimatedBuilder(
                                  animation: _pulseController,
                                  builder: (context, child) {
                                    return Transform.scale(
                                      scale:
                                          1.0 + (_pulseController.value * 0.05),
                                      child: Container(
                                        width: 240,
                                        height: 240,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.red.withOpacity(0.30),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.red.withOpacity(
                                                0.30 * _pulseController.value,
                                              ),
                                              blurRadius: 40,
                                              spreadRadius: 5,
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),

                                // ==========================
                                // SOS BUTTON
                                // ==========================
                                GestureDetector(
                                  onTapDown: (_) {
                                    setState(() {
                                      _isHolding = true;
                                    });

                                    HapticFeedback.lightImpact();

                                    _rippleController.repeat();

                                    _holdTimer = Timer(
                                      const Duration(seconds: 3),
                                      () async {
                                        if (_isHolding) {
                                          bool canStart =
                                              await validateLocation();

                                          if (!canStart) return;

                                          _rippleController.stop();
                                          _rippleController.reset();

                                          await HapticFeedback.heavyImpact();

                                          if (!mounted) return;

                                          context.push(AppRoutes.preAlert);
                                        }
                                      },
                                    );
                                  },

                                  onTapUp: (_) {
                                    setState(() {
                                      _isHolding = false;
                                    });

                                    _holdTimer?.cancel();

                                    _rippleController.stop();
                                    _rippleController.reset();
                                  },

                                  onTapCancel: () {
                                    setState(() {
                                      _isHolding = false;
                                    });

                                    _holdTimer?.cancel();

                                    _rippleController.stop();
                                    _rippleController.reset();
                                  },

                                  child: AnimatedScale(
                                    duration: const Duration(milliseconds: 150),
                                    scale: _isHolding ? 0.95 : 1.0,
                                    child: Container(
                                      width: 200,
                                      height: 200,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: const LinearGradient(
                                          colors: [
                                            Color(0xFFDC2626),
                                            Color(0xFFB91C1C),
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        border: Border.all(
                                          color: Colors.white.withOpacity(.20),
                                          width: 4,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color(
                                              0xFFDC2626,
                                            ).withOpacity(.80),
                                            blurRadius: 40,
                                            spreadRadius: -10,
                                            offset: const Offset(0, 10),
                                          ),
                                        ],
                                      ),
                                      child: Center(
                                        child: Text(
                                          "SOS",
                                          style: GoogleFonts.montserrat(
                                            color: Colors.white,
                                            fontSize: 24,
                                            fontWeight: FontWeight.w700,
                                            letterSpacing: 4,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 28),

                        Container(
                          decoration: BoxDecoration(
                            color: AppTheme.surface.withOpacity(.8),
                            borderRadius: BorderRadius.circular(9999),
                            border: Border.all(
                              color: Colors.white.withOpacity(.3),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(.05),
                                blurRadius: 8,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 8,
                          ),
                          child: Text(
                            "PRESS & HOLD FOR 3 SECONDS",
                            style: GoogleFonts.beVietnamPro(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textPrimary,
                              letterSpacing: .7,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30.0),

                    // Bento Grid: Wearable Connected Card
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () {
                          context.push(AppRoutes.wearableSync);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(30.0),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.6),
                              width: 1.0,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 30,
                                spreadRadius: -5,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(24.0),
                          child: Row(
                            children: [
                              Container(
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(
                                  color: AppTheme.primary.withOpacity(.08),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: const Icon(
                                  Icons.watch_outlined,
                                  color: AppTheme.primary,
                                  size: 28,
                                ),
                              ),

                              const SizedBox(width: 18),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "Wearable",
                                      style: GoogleFonts.montserrat(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),

                                    const SizedBox(height: 4),

                                    Text(
                                      "Lumina Smart Band",
                                      style: GoogleFonts.beVietnamPro(
                                        color: AppTheme.textSecondary,
                                      ),
                                    ),

                                    const SizedBox(height: 12),

                                    Row(
                                      children: [
                                        AnimatedBuilder(
                                          animation: _connectionAnimation,
                                          builder: (context, child) {
                                            return Transform.scale(
                                              scale: _connectionAnimation.value,
                                              child: Container(
                                                width: 10,
                                                height: 10,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: const Color(
                                                    0xFF22C55E,
                                                  ),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: const Color(
                                                        0xFF22C55E,
                                                      ).withOpacity(0.45),
                                                      blurRadius: 8,
                                                      spreadRadius: 1,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),

                                        const SizedBox(width: 8),

                                        Text(
                                          "Connected",
                                          style: GoogleFonts.beVietnamPro(
                                            color: Colors.green,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "Manage",
                                    style: GoogleFonts.beVietnamPro(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: AppTheme.primary,
                                    ),
                                  ),
                                  const SizedBox(width: 2),
                                  const Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    size: 10,
                                    color: AppTheme.primary,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        // custom bottom navigation bar
        bottomNavigationBar: const LuminaBottomNavigation(currentIndex: 0),
      ),
    );
  }
}
