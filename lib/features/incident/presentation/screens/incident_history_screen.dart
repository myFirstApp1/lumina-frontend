import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/lumina_bottom_navigation.dart';
import '../../data/models/incident_model.dart';
import '../cubit/incident_cubit.dart';
import '../cubit/incident_state.dart';

class IncidentHistoryScreen extends StatefulWidget {
  const IncidentHistoryScreen({super.key});

  @override
  State<IncidentHistoryScreen> createState() =>
      _IncidentHistoryScreenState();
}

class _IncidentHistoryScreenState
    extends State<IncidentHistoryScreen> {

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      context.read<IncidentCubit>().loadIncidentHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [

          // Background
          Container(
            color: AppTheme.background,
          ),

          // Content
          SafeArea(
            child: BlocBuilder<IncidentCubit, IncidentState>(
              builder: (context, state) {

                if (state.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppTheme.primary,
                    ),
                  );
                }

                if (state.error != null) {
                  return _ErrorView(
                    message: state.error!,
                    onRetry: () {
                      context.read<IncidentCubit>().loadIncidentHistory();
                    },
                  );
                }

                if (state.incidents.isEmpty) {
                  return const _EmptyIncidentView();
                }

                return SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(
                    20,
                    28,
                    20,
                    120,
                  ),
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.stretch,
                    children: [

                      /// Header
                      _buildHeader(state.incidents.length),

                      const SizedBox(height: 32),

                      /// Cards
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: state.incidents.length,
                        separatorBuilder: (_, __) =>
                        const SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          return _buildIncidentCard(
                            state.incidents[index],
                          );
                        },
                      ),

                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),

      bottomNavigationBar:
      const LuminaBottomNavigation(
        currentIndex: 3, // We'll verify the index later
      ),
    );
  }

  Widget _buildHeader(int totalIncidents) {
    return Center(
      child: Column(
        children: [

          Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.primary.withOpacity(.08),
            ),
            child: const Icon(
              Icons.history_rounded,
              size: 42,
              color: AppTheme.primary,
            ),
          ),

          const SizedBox(height: 24),

          Text(
            "Incident History",
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
              fontSize: 32,
              fontWeight: FontWeight.w600,
              color: AppTheme.textSecondary,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            "$totalIncidents Emergency Incident${totalIncidents == 1 ? "" : "s"}",
            textAlign: TextAlign.center,
            style: GoogleFonts.beVietnamPro(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: AppTheme.textSecondary,
            ),
          ),

        ],
      ),
    );
  }

  Widget _buildIncidentCard(IncidentModel incident) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.9),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withOpacity(.5),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            context.push(
              AppRoutes.emergencyDetails,
              extra: incident.incidentId,
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 16,
            ),
            child: Row(
              children: [

                _buildStatusIcon(incident.status),

                const SizedBox(width: 16),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [

                      Text(
                        _triggerTitle(
                          incident.triggerType,
                        ),
                        style: GoogleFonts.montserrat(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text(
                        _formatDate(
                          incident.createdAt,
                        ),
                        style: GoogleFonts.beVietnamPro(
                          color: AppTheme.textSecondary,
                          fontSize: 15,
                        ),
                      ),

                      const SizedBox(height: 12),

                      Row(
                        children: [

                          _buildStatusBadge(
                            incident.status,
                          ),

                          const SizedBox(width: 10),

                          _buildRiskBadge(
                            incident.riskScore,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppTheme.primary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusIcon(String status) {

    Color color;

    IconData icon;

    switch (status.toUpperCase()) {

      case "ACTIVE":
        color = AppTheme.error;
        icon = Icons.warning_rounded;
        break;

      case "RESOLVED":
        color = AppTheme.success;
        icon = Icons.check_circle;
        break;

      default:
        color = Colors.grey;
        icon = Icons.history;
    }

    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: color.withOpacity(.10),
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        color: color,
        size: 26,
      ),
    );
  }

  Widget _buildStatusBadge(String status) {

    Color color;

    switch (status.toUpperCase()) {

      case "ACTIVE":
        color = AppTheme.error;
        break;

      case "RESOLVED":
        color = AppTheme.success;
        break;

      default:
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(.12),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        status,
        style: GoogleFonts.beVietnamPro(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildRiskBadge(int riskScore) {

    String text;
    Color color;

    if (riskScore >= 61) {
      text = "HIGH";
      color = AppTheme.error;
    } else if (riskScore >= 31) {
      text = "MEDIUM";
      color = AppTheme.warning;
    } else {
      text = "LOW";
      color = AppTheme.success;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(.12),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        text,
        style: GoogleFonts.beVietnamPro(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }

  String _triggerTitle(String trigger) {

    switch (trigger.toUpperCase()) {

      case "MANUAL":
        return "Manual SOS";

      case "HEART_RATE":
        return "Heart Rate Detection";

      case "OFF_BODY":
        return "Device Removed";

      case "BLUETOOTH":
        return "Bluetooth Disconnected";

      default:
        return trigger;
    }
  }
}

class _EmptyIncidentView extends StatelessWidget {
  const _EmptyIncidentView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Icon(
              Icons.shield_outlined,
              size: 80,
              color: AppTheme.primary,
            ),

            const SizedBox(height: 24),

            Text(
              "No Incidents",
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall,
            ),

            const SizedBox(height: 8),

            Text(
              "Great! You haven't experienced any emergency incidents.",
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            const Icon(
              Icons.error_outline,
              size: 72,
              color: Colors.red,
            ),

            const SizedBox(height: 20),

            Text(
              message,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: onRetry,
              child: const Text("Retry"),
            )
          ],
        ),
      ),
    );
  }
}

String _formatDate(DateTime dateTime) {

  final now = DateTime.now();

  final difference =
  now.difference(dateTime);

  if (difference.inMinutes < 1) {
    return "Just now";
  }

  if (difference.inHours < 1) {
    return "${difference.inMinutes} min ago";
  }

  if (difference.inDays < 1) {
    return "${difference.inHours} hrs ago";
  }

  if (difference.inDays == 1) {
    return "Yesterday";
  }

  return "${dateTime.day}/${dateTime.month}/${dateTime.year}";
}