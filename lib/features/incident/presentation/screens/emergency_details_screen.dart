import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/incident_model.dart';
import '../../data/models/timeline_event_model.dart';
import '../cubit/incident_cubit.dart';
import '../cubit/incident_state.dart';

class EmergencyDetailsScreen extends StatefulWidget {

  final String incidentId;

  const EmergencyDetailsScreen({
    super.key,
    required this.incidentId,
  });

  @override
  State<EmergencyDetailsScreen> createState() =>
      _EmergencyDetailsScreenState();
}

class _EmergencyDetailsScreenState
    extends State<EmergencyDetailsScreen> {

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      context.read<IncidentCubit>().loadIncidentDetails(
        widget.incidentId,
      );

      context.read<IncidentCubit>().loadTimeline(
        widget.incidentId,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
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
              return Center(
                child: Text(
                  state.error!,
                  style: const TextStyle(
                    color: Colors.red,
                  ),
                ),
              );
            }

            if (state.selectedIncident == null) {
              return const Center(
                child: Text(
                  "Incident not found",
                ),
              );
            }

            final incident = state.selectedIncident!;

            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                20,
                28,
                20,
                40,
              ),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.stretch,
                children: [

                  /// Header
                  _buildEmergencyHeader(incident),
                  const SizedBox(height: 24),

                  /// Incident Information
                  _buildIncidentSummary(incident),
                  const SizedBox(height: 24),

                  /// Timeline
                  _buildTimelineSection(state.timeline),
                  const SizedBox(height: 24),

                  _buildTimelineSection(state.timeline),

                  const SizedBox(height: 24),

// -----------------------------------------------------------------
// TODO (Phase 5.8)
// Emergency Notifications
//
// Backend integration pending.
//
// Future backend response should expose:
//
// - Family notification delivered
// - Family acknowledgement
// - Police notification delivered
// - Police acknowledgement
//
// Once the backend provides these fields,
// replace this placeholder with:
//
// _buildEmergencyNotifications(...)
// -----------------------------------------------------------------

// _buildEmergencyNotifications(),

                  const SizedBox(height: 24),

// -----------------------------------------------------------------
// TODO (Phase 5.8)
// Evidence Section
//
// Backend already supports Evidence APIs.
//
// Waiting for Flutter integration.
//
// Future:
//
// - Audio recordings
// - Photos
// - Videos
// - Attachments
//
// _buildEvidenceSection(...)
// -----------------------------------------------------------------

// _buildEvidenceSection(),

                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildEmergencyHeader(IncidentModel incident) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.9),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withOpacity(.5),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            children: [

              GestureDetector(
                onTap: () {
                  context.push(
                    AppRoutes.emergencyDetails,
                    extra: incident.incidentId,
                  );
                },
                child: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withOpacity(.08),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_back,
                    color: AppTheme.primary,
                  ),
                ),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Text(
                  "Emergency Details",
                  style: GoogleFonts.montserrat(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 28),

          Row(
            children: [

              _buildStatusIcon(incident.status),

              const SizedBox(width: 18),

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
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      _formatDate(
                        incident.createdAt,
                      ),
                      style: GoogleFonts.beVietnamPro(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

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
    );
  }

  Widget _buildIncidentSummary(IncidentModel incident) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.9),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withOpacity(.5),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text(
            "Incident Summary",
            style: GoogleFonts.montserrat(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 20),

          _buildInfoRow(
            "Tracking ID",
            incident.trackingId.length > 8
                ? "${incident.trackingId.substring(0, 8)}..."
                : incident.trackingId,
          ),

          const Divider(height: 28),

          _buildInfoRow(
            "Incident Status",
            incident.status,
          ),

          const Divider(height: 28),

          _buildInfoRow(
            "Trigger",
            _triggerTitle(
              incident.triggerType,
            ),
          ),

          const Divider(height: 28),

          _buildInfoRow(
            "Risk Score",
            incident.riskScore.toString(),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
      String title,
      String value,
      ) {
    return Row(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [

        Expanded(
          flex: 3,
          child: Text(
            title,
            style: GoogleFonts.beVietnamPro(
              fontSize: 15,
              color: AppTheme.textSecondary,
            ),
          ),
        ),

        Expanded(
          flex: 5,
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: GoogleFonts.montserrat(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
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
  Widget _buildTimelineSection(
      List<TimelineEventModel> timeline,
      ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.9),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withOpacity(.5),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [

          Text(
            "Timeline",
            style: GoogleFonts.montserrat(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 20),

          if (timeline.isEmpty)

            Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  "No timeline events available.",
                  style: GoogleFonts.beVietnamPro(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ),
            )

          else

            ListView.separated(
              shrinkWrap: true,
              physics:
              const NeverScrollableScrollPhysics(),
              itemCount: timeline.length,
              separatorBuilder: (_, __) =>
              const SizedBox(height: 20),
              itemBuilder: (context, index) {
                return _buildTimelineItem(
                  timeline[index],
                  index ==
                      timeline.length - 1,
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(
      TimelineEventModel event,
      bool isLast,
      ) {
    return Row(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [

        Column(
          children: [

            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: _timelineColor(
                  event.eventType,
                ),
                shape: BoxShape.circle,
              ),
            ),

            if (!isLast)
              Container(
                width: 2,
                height: 55,
                color: Colors.grey.shade300,
              ),
          ],
        ),

        const SizedBox(width: 16),

        Expanded(
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [

              Text(
                event.eventType,
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                event.eventData,
                style: GoogleFonts.beVietnamPro(
                  color:
                  AppTheme.textSecondary,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                _formatDate(
                  event.createdAt,
                ),
                style: GoogleFonts.beVietnamPro(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Color _timelineColor(String type) {

    switch (type.toUpperCase()) {

      case "PROTECTION_STARTED":
        return Colors.green;

      case "WARNING":
        return Colors.orange;

      case "SOS_TRIGGERED":
        return Colors.red;

      case "FAMILY_SMS_SENT":
        return Colors.blue;

      case "POLICE_NOTIFIED":
        return Colors.indigo;

      case "INCIDENT_CLOSED":
        return Colors.green;

      default:
        return AppTheme.primary;
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