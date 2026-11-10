import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/pill_button.dart';
import '../cubit/sos_cubit.dart';

class PreAlertScreen extends StatefulWidget {
  const PreAlertScreen({Key? key}) : super(key: key);

  @override
  State<PreAlertScreen> createState() => _PreAlertScreenState();
}

class _PreAlertScreenState extends State<PreAlertScreen> {
  static const int _initialSeconds = 15;

  int _secondsRemaining = _initialSeconds;
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
        if (!mounted) {
          timer.cancel();
          return;
        }

        debugPrint('COUNTDOWN = $_secondsRemaining');

        if (_secondsRemaining <= 1) {
          debugPrint('COUNTDOWN FINISHED');
          timer.cancel();

          setState(() {
            _secondsRemaining = 0;
            _isTriggeredText = true;
          });

          try {
            final sosCubit = context.read<SosCubit>();
            debugPrint('CALLING triggerSos()');
            await sosCubit.triggerSos();
            debugPrint('triggerSos() FINISHED');
          } catch (e, stackTrace) {
            debugPrint('PRE ALERT ERROR: $e');
            debugPrint(stackTrace.toString());
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
        content: Text('Pre-Alert disarmed. Status: Safe.'),
        backgroundColor: AppTheme.success,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final progress = _secondsRemaining / _initialSeconds;
    final isCritical = _secondsRemaining <= 5;
    final countdownColor =
    isCritical ? AppTheme.error : AppTheme.warning;

    return BlocListener<SosCubit, SosState>(
      listener: (context, state) {
        if (state is SosAlertActive) {
          context.pushReplacement(AppRoutes.sosActive);
        }

        // If the SOS request fails, leave the countdown screen and show
        // the backend error rather than implying that an alert was sent.
        if (state is SosError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppTheme.error,
              duration: const Duration(seconds: 6),
            ),
          );

          if (context.canPop()) {
            context.pop();
          } else {
            context.go(AppRoutes.home);
          }
        }
      },
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: AppTheme.backgroundGradient,
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height -
                      MediaQuery.of(context).padding.top -
                      MediaQuery.of(context).padding.bottom -
                      48,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.78),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                          child: Icon(
                            Icons.shield_outlined,
                            color: AppTheme.primary,
                            size: 23,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'LUMINA GUARDIAN',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge
                                    ?.copyWith(
                                  color: AppTheme.textPrimary,
                                  letterSpacing: 1.3,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Safety confirmation',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 11,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            color: countdownColor.withOpacity(0.10),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.circle,
                                size: 7,
                                color: countdownColor,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                _isTriggeredText ? 'SENDING' : 'PRE-ALERT',
                                style: TextStyle(
                                  color: countdownColor,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.7,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 34),
                    Text(
                      _isTriggeredText
                          ? 'Sending your alert'
                          : 'Are you safe?',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 9),
                    Text(
                      _isTriggeredText
                          ? 'Please wait while we process your emergency alert.'
                          : 'Your safety countdown has started. Confirm that you are safe before it reaches zero.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textSecondary,
                        height: 1.55,
                      ),
                    ),
                    const SizedBox(height: 34),
                    Center(
                      child: SizedBox(
                        width: 244,
                        height: 244,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 244,
                              height: 244,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: countdownColor.withOpacity(0.07),
                              ),
                            ),
                            SizedBox(
                              width: 210,
                              height: 210,
                              child: CircularProgressIndicator(
                                value: progress,
                                strokeWidth: 11,
                                strokeCap: StrokeCap.round,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  countdownColor,
                                ),
                                backgroundColor:
                                AppTheme.outlineVariant.withOpacity(0.45),
                              ),
                            ),
                            Container(
                              width: 178,
                              height: 178,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withOpacity(0.78),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.95),
                                  width: 1.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: countdownColor.withOpacity(0.10),
                                    blurRadius: 24,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '00:${_secondsRemaining.toString().padLeft(2, '0')}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayLarge
                                        ?.copyWith(
                                      color: countdownColor,
                                      fontSize: 48,
                                      fontWeight: FontWeight.w800,
                                      fontFeatures: const [],
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    'SECONDS LEFT',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall
                                        ?.copyWith(
                                      color: AppTheme.textSecondary,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 1.4,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    GlassCard(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.notifications_active_outlined,
                                color: countdownColor,
                                size: 22,
                              ),
                              const SizedBox(width: 9),
                              Flexible(
                                child: Text(
                                  'Emergency alert countdown',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                    color: AppTheme.textPrimary,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'If you do not confirm that you are safe before the timer ends, Lumina Guardian will trigger your SOS flow.',
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                              color: AppTheme.textSecondary,
                              height: 1.55,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 13,
                              vertical: 9,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.success.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.verified_user_outlined,
                                  color: AppTheme.success,
                                  size: 16,
                                ),
                                const SizedBox(width: 7),
                                Text(
                                  _isTriggeredText
                                      ? 'Processing emergency request'
                                      : 'You can still cancel this alert',
                                  style: TextStyle(
                                    color: AppTheme.success,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    PillButton(
                      text: "I'M SAFE — CANCEL ALERT",
                      icon: Icons.check_circle_outline_rounded,
                      isSecondary: true,
                      onPressed: _handleDisarm,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Only cancel if you are safe.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}