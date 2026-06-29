import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/pill_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/sos_cubit.dart';

class PreAlertScreen extends StatefulWidget {
  const PreAlertScreen({Key? key}) : super(key: key);

  @override
  State<PreAlertScreen> createState() => _PreAlertScreenState();
}

class _PreAlertScreenState extends State<PreAlertScreen> {
  int _secondsRemaining = 15;
  Timer? _timer;
  bool _isTriggeredText = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(
      const Duration(seconds: 1),
          (timer) async {

        debugPrint(
          "COUNTDOWN = $_secondsRemaining",
        );

        if (_secondsRemaining <= 1) {

          debugPrint(
            "COUNTDOWN FINISHED",
          );

          try {

            timer.cancel();

            setState(() {
              _secondsRemaining = 0;
              _isTriggeredText = true;
            });

            debugPrint(
              "GETTING SOS CUBIT",
            );

            final sosCubit =
            context.read<SosCubit>();

            debugPrint(
              "CALLING triggerSos()",
            );

            await sosCubit.triggerSos();

            debugPrint(
              "triggerSos() FINISHED",
            );

          } catch (e, s) {

            debugPrint(
              "PRE ALERT ERROR",
            );

            debugPrint(
              e.toString(),
            );

            debugPrint(
              s.toString(),
            );
          }

        } else {

          setState(() {
            _secondsRemaining--;
          });

        }
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _handleDisarm() {
    _timer?.cancel();
    context.pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Pre-Alert disarmed. Status: Safe."),
        backgroundColor: AppTheme.success,
      ),
    );
  }

  @override
  @override
  Widget build(BuildContext context) {

    double progress = _secondsRemaining / 15.0;

    return BlocListener<SosCubit, SosState>(

        listener: (context, state) {

          if (state is SosAlertActive) {

            context.pushReplacement(
              AppRoutes.sosActive,
            );

          }

        },

      child: Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.backgroundGradient,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 24),
                Text(
                  "PRE-ALERT GUARD ACTIVE",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: AppTheme.primary,
                        letterSpacing: 2.0,
                      ),
                ),
                const Spacer(),

                // Elegant Circular Countdown
                Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 200,
                        height: 200,
                        child: CircularProgressIndicator(
                          value: progress,
                          strokeWidth: 10,
                          valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primary),
                          backgroundColor: AppTheme.outlineVariant.withOpacity(0.3),
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "00:${_secondsRemaining.toString().padLeft(2, '0')}",
                            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.primary,
                                  fontSize: 44,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "SECONDS LEFT",
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                const Spacer(),

                // Reassure Card
                GlassCard(
                  child: Column(
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.warning_amber_rounded, color: AppTheme.primary, size: 24),
                          SizedBox(width: 8),
                          Text(
                            "Guard Alert Countdown",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        "If you do not disarm this timer within the limit, a priority SOS emergency alert will be dispatched to your circle.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          color: AppTheme.textSecondary,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        _isTriggeredText ? "ALERT DISPATCHED" : "AI Monitoring Active",
                        style: TextStyle(
                          color: _isTriggeredText ? AppTheme.error : AppTheme.success,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 40),
                
                PillButton(
                  text: "Cancel",
                  icon: Icons.check_circle_outline,
                  onPressed: _handleDisarm,
                  gradient: const LinearGradient(
                    colors: [
                      AppTheme.success,
                      Color(0xFFF10E0E),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    ),
    );
  }
}
