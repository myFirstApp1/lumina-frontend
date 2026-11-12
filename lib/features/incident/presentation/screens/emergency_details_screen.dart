
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

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

      final cubit = context.read<IncidentCubit>();

      cubit.loadIncidentDetails(
        widget.incidentId,
      );

      cubit.loadTimeline(
        widget.incidentId,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Container(
        decoration: const BoxDecoration(
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
        child: Stack(
          children: [
            Positioned(
              top: 145,
              right: -105,
              child: _softGlow(220, const Color(0xFFFFC6DD)),
            ),
            Positioned(
              top: 650,
              left: -110,
              child: _softGlow(230, const Color(0xFFDCCFFF)),
            ),
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
                        final cubit =
                        context.read<IncidentCubit>();

                        cubit.loadIncidentDetails(
                          widget.incidentId,
                        );

                        cubit.loadTimeline(
                          widget.incidentId,
                        );
                      },
                    );
                  }

                  if (state.selectedIncident == null) {
                    return const _NotFoundView();
                  }

                  final incident =
                  state.selectedIncident!;

                  return RefreshIndicator(
                    color: AppTheme.primary,

                    onRefresh: () async {
                      final cubit =
                      context.read<IncidentCubit>();

                      await cubit.loadIncidentDetails(
                        widget.incidentId,
                      );

                      await cubit.loadTimeline(
                        widget.incidentId,
                      );
                    },

                    child: SingleChildScrollView(
                      physics:
                      const AlwaysScrollableScrollPhysics(),

                      padding: const EdgeInsets.fromLTRB(
                        20,
                        18,
                        20,
                        40,
                      ),

                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.stretch,
                        children: [

                          // =================================================
                          // TOP BAR
                          // =================================================

                          _buildTopBar(),

                          const SizedBox(height: 25),

                          _buildPageIntro(),

                          const SizedBox(height: 22),

                          // =================================================
                          // EMERGENCY HEADER
                          // =================================================

                          _buildEmergencyHeader(
                            incident,
                          ),

                          const SizedBox(height: 20),

                          // =================================================
                          // INCIDENT INFORMATION
                          // =================================================

                          _buildIncidentSummary(
                            incident,
                          ),

                          const SizedBox(height: 20),

                          // =================================================
                          // TIMELINE
                          // =================================================

                          _buildTimelineSection(
                            state.timeline,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _softGlow(double size, Color color) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withOpacity(.30),
        ),
      ),
    );
  }

  // ================================================================
  // TOP BAR
  // ================================================================

  Widget _buildTopBar() {
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
                  color: Color(0xFF393044),
                ),
              ),
              Expanded(
                child: Text(
                  'Lumina Guardian',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFFD95791),
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

  Widget _buildPageIntro() {
    return Column(
      children: [
        Text(
          'SAFETY RECORD',
          textAlign: TextAlign.center,
          style: GoogleFonts.montserrat(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.8,
            color: const Color(0xFFD95791),
          ),
        ),
        const SizedBox(height: 9),
        Text(
          'Emergency Details',
          textAlign: TextAlign.center,
          style: GoogleFonts.montserrat(
            fontSize: 27,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF393044),
          ),
        ),
        const SizedBox(height: 7),
        Text(
          'A complete view of this emergency and its activity.',
          textAlign: TextAlign.center,
          style: GoogleFonts.beVietnamPro(
            fontSize: 13,
            height: 1.5,
            color: const Color(0xFF898193),
          ),
        ),
      ],
    );
  }

  // ================================================================
  // EMERGENCY HEADER
  // ================================================================

  Widget _buildEmergencyHeader(
      IncidentModel incident,
      ) {
    final statusColor =
    _statusColor(incident.status);

    final riskColor =
    _riskColor(incident.riskScore);

    return _settingsGlass(child: Container(
      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(.82),
            Colors.white.withOpacity(.62),
          ],
        ),
        borderRadius: BorderRadius.circular(24),

        border: Border.all(
          color: Colors.white.withOpacity(.92),
        ),

        boxShadow: [
          BoxShadow(
            color: const Color(0xFFD95791).withOpacity(.08),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [

          // ----------------------------------------------------------
          // Emergency icon + title
          // ----------------------------------------------------------

          Row(
            crossAxisAlignment:
            CrossAxisAlignment.start,

            children: [

              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    colors: [
                      statusColor.withOpacity(.15),
                      statusColor.withOpacity(.07),
                    ],
                  ),
                  border: Border.all(
                    color: statusColor.withOpacity(.10),
                  ),
                ),

                child: Icon(
                  _statusIcon(incident.status),
                  size: 31,
                  color: statusColor,
                ),
              ),

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

                      maxLines: 2,
                      overflow:
                      TextOverflow.ellipsis,

                      style: GoogleFonts.montserrat(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF393044),
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      _formatDate(
                        incident.createdAt,
                      ),

                      style:
                      GoogleFonts.beVietnamPro(
                        fontSize: 13,
                        color:
                        AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 22),

          // ----------------------------------------------------------
          // Status + Risk
          // ----------------------------------------------------------

          Row(
            children: [

              _buildBadge(
                text: incident.status,
                color: statusColor,
              ),

              const SizedBox(width: 10),

              _buildBadge(
                text: _riskText(
                  incident.riskScore,
                ),
                color: riskColor,
              ),
            ],
          ),
        ],
      ),
    ));  }

  // ================================================================
  // INCIDENT SUMMARY
  // ================================================================

  Widget _buildIncidentSummary(
      IncidentModel incident,
      ) {
    return _settingsGlass(child: Container(
      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.72),
        borderRadius: BorderRadius.circular(24),

        border: Border.all(
          color: Colors.white.withOpacity(.92),
        ),

        boxShadow: [
          BoxShadow(
            color: const Color(0xFFAA91D8).withOpacity(.07),
            blurRadius: 16,
            offset: const Offset(0, 5),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [

          Text(
            "Incident Information",
            style: GoogleFonts.montserrat(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF393044),
            ),
          ),

          const SizedBox(height: 20),

          _buildInfoRow(
            title: "Tracking ID",
            value: incident.trackingId.length > 12
                ? "${incident.trackingId.substring(0, 12)}..."
                : incident.trackingId,
          ),

          const Divider(height: 28),

          _buildInfoRow(
            title: "Status",
            value: incident.status,
          ),

          const Divider(height: 28),

          _buildInfoRow(
            title: "Trigger",
            value: _triggerTitle(
              incident.triggerType,
            ),
          ),

          const Divider(height: 28),

          _buildInfoRow(
            title: "Risk Score",
            value: incident.riskScore.toString(),
          ),

          if (incident.incidentSource.isNotEmpty) ...[
            const Divider(height: 28),

            _buildInfoRow(
              title: "Source",
              value: incident.incidentSource,
            ),
          ],
        ],
      ),
    ));  }

  // ================================================================
  // INFO ROW
  // ================================================================

  Widget _buildInfoRow({
    required String title,
    required String value,
  }) {
    return Row(
      crossAxisAlignment:
      CrossAxisAlignment.start,

      children: [

        Expanded(
          flex: 4,
          child: Text(
            title,
            style: GoogleFonts.beVietnamPro(
              fontSize: 12,
              color: const Color(0xFF898193),
            ),
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          flex: 6,
          child: Text(
            value,
            textAlign: TextAlign.right,

            style: GoogleFonts.montserrat(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF393044),
            ),
          ),
        ),
      ],
    );
  }

  // ================================================================
  // TIMELINE
  // ================================================================

  Widget _buildTimelineSection(
      List<TimelineEventModel> timeline,
      ) {
    return _settingsGlass(child: Container(
      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.72),
        borderRadius: BorderRadius.circular(24),

        border: Border.all(
          color: Colors.white.withOpacity(.92),
        ),

        boxShadow: [
          BoxShadow(
            color: const Color(0xFFAA91D8).withOpacity(.07),
            blurRadius: 16,
            offset: const Offset(0, 5),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [

          Row(
            children: [

              Container(
                width: 38,
                height: 38,

                decoration: BoxDecoration(
                  color: AppTheme.primary
                      .withOpacity(.08),
                  shape: BoxShape.circle,
                ),

                child: const Icon(
                  Icons.timeline_rounded,
                  size: 20,
                  color: AppTheme.primary,
                ),
              ),

              const SizedBox(width: 12),

              Text(
                "Emergency Timeline",
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF393044),
                ),
              ),
            ],
          ),

          const SizedBox(height: 22),

          if (timeline.isEmpty)

            _buildEmptyTimeline()

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
                  index == timeline.length - 1,
                );
              },
            ),
        ],
      ),
    ));  }

  // ================================================================
  // EMPTY TIMELINE
  // ================================================================

  Widget _buildEmptyTimeline() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 24,
      ),

      child: Center(
        child: Column(
          children: [

            Icon(
              Icons.event_note_rounded,
              size: 38,
              color: AppTheme.textSecondary
                  .withOpacity(.55),
            ),

            const SizedBox(height: 10),

            Text(
              "No timeline events available.",
              textAlign: TextAlign.center,
              style: GoogleFonts.beVietnamPro(
                fontSize: 14,
                color: const Color(0xFF898193),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================================================================
  // TIMELINE ITEM
  // ================================================================

  Widget _buildTimelineItem(
      TimelineEventModel event,
      bool isLast,
      ) {
    final color =
    _timelineColor(event.eventType);

    return Row(
      crossAxisAlignment:
      CrossAxisAlignment.start,

      children: [

        // ----------------------------------------------------------
        // Timeline line
        // ----------------------------------------------------------

        SizedBox(
          width: 28,

          child: Column(
            children: [

              Container(
                width: 18,
                height: 18,

                decoration: BoxDecoration(
                  color: color.withOpacity(.14),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: color,
                    width: 2,
                  ),
                ),

                child: Center(
                  child: Container(
                    width: 6,
                    height: 6,

                    decoration:
                    BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),

              if (!isLast)
                Container(
                  width: 2,
                  height: 58,
                  margin:
                  const EdgeInsets.only(
                    top: 4,
                  ),
                  color: AppTheme.outlineVariant.withOpacity(.65),
                ),
            ],
          ),
        ),

        const SizedBox(width: 14),

        // ----------------------------------------------------------
        // Event content
        // ----------------------------------------------------------

        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(
              bottom: 2,
            ),

            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [

                Text(
                  _timelineTitle(
                    event.eventType,
                  ),

                  style: GoogleFonts.montserrat(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF393044),
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  event.eventData,
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 11.5,
                    height: 1.5,
                    color: const Color(0xFF898193),
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  _formatDate(
                    event.createdAt,
                  ),

                  style: GoogleFonts.beVietnamPro(
                    fontSize: 10.5,
                    color: const Color(0xFF898193),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ================================================================
  // BADGE
  // ================================================================

  Widget _buildBadge({
    required String text,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 11,
        vertical: 6,
      ),

      decoration: BoxDecoration(
        color: color.withOpacity(.10),
        borderRadius: BorderRadius.circular(30),
      ),

      child: Text(
        text,
        style: GoogleFonts.beVietnamPro(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  // ================================================================
  // STATUS
  // ================================================================

  Color _statusColor(String status) {
    switch (status.toUpperCase()) {
      case "ACTIVE":
        return AppTheme.error;

      case "RESOLVED":
        return AppTheme.success;

      default:
        return Colors.grey;
    }
  }

  IconData _statusIcon(String status) {
    switch (status.toUpperCase()) {
      case "ACTIVE":
        return Icons.warning_rounded;

      case "RESOLVED":
        return Icons.check_circle_rounded;

      default:
        return Icons.history_rounded;
    }
  }

  // ================================================================
  // RISK
  // ================================================================

  Color _riskColor(int riskScore) {
    if (riskScore >= 61) {
      return AppTheme.error;
    }

    if (riskScore >= 31) {
      return AppTheme.warning;
    }

    return AppTheme.success;
  }

  String _riskText(int riskScore) {
    if (riskScore >= 61) {
      return "HIGH RISK";
    }

    if (riskScore >= 31) {
      return "MEDIUM RISK";
    }

    return "LOW RISK";
  }

  // ================================================================
  // TRIGGER
  // ================================================================

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

  // ================================================================
  // TIMELINE TITLE
  // ================================================================

  String _timelineTitle(String type) {
    switch (type.toUpperCase()) {
      case "PROTECTION_STARTED":
        return "Protection Started";

      case "WARNING":
        return "Warning Detected";

      case "SOS_TRIGGERED":
        return "SOS Triggered";

      case "FAMILY_SMS_SENT":
        return "Family Notification Sent";

      case "POLICE_NOTIFIED":
        return "Police Notified";

      case "INCIDENT_CLOSED":
        return "Incident Closed";

      case "STATUS_CHANGED":
        return "Status Updated";

      case "INCIDENT_CREATED":
        return "Emergency Recorded";

      case "HEARTBEAT_MISSED":
        return "Device Check Missed";

      case "LOCATION_UPDATED":
        return "Location Updated";

      default:
        return type;
    }
  }

  // ================================================================
  // TIMELINE COLOR
  // ================================================================

  Color _timelineColor(String type) {
    switch (type.toUpperCase()) {
      case "PROTECTION_STARTED":
        return AppTheme.success;

      case "WARNING":
        return AppTheme.warning;

      case "SOS_TRIGGERED":
        return AppTheme.error;

      case "FAMILY_SMS_SENT":
        return Colors.blue;

      case "POLICE_NOTIFIED":
        return Colors.indigo;

      case "INCIDENT_CLOSED":
        return AppTheme.success;

      default:
        return AppTheme.primary;
    }
  }
}

// ====================================================================
// NOT FOUND
// ====================================================================

class _NotFoundView extends StatelessWidget {
  const _NotFoundView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                color: Colors.grey
                    .withOpacity(.10),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.search_off_rounded,
                size: 38,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 18),

            Text(
              "Incident Not Found",
              style: GoogleFonts.montserrat(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              "The emergency incident could not be found.",
              textAlign: TextAlign.center,
              style: GoogleFonts.beVietnamPro(
                fontSize: 14,
                color: const Color(0xFF898193),
              ),
            ),

            const SizedBox(height: 20),

            TextButton.icon(
              onPressed: () {
                context.pop();
              },
              icon: const Icon(
                Icons.arrow_back_rounded,
              ),
              label: const Text(
                "Go Back",
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ====================================================================
// ERROR
// ====================================================================

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
        child: Container(
          padding: const EdgeInsets.all(26),

          decoration: BoxDecoration(
            color: Colors.white.withOpacity(.67),
            borderRadius: BorderRadius.circular(26),
          ),

          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: AppTheme.error
                      .withOpacity(.08),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.cloud_off_rounded,
                  size: 34,
                  color: AppTheme.error,
                ),
              ),

              const SizedBox(height: 18),

              Text(
                "Unable to Load Emergency",
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                message,
                textAlign: TextAlign.center,
                style: GoogleFonts.beVietnamPro(
                  fontSize: 14,
                  color: const Color(0xFF898193),
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(
                    Icons.refresh_rounded,
                  ),
                  label: Text(
                    "Try Again",
                    style: GoogleFonts.beVietnamPro(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                    AppTheme.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding:
                    const EdgeInsets.symmetric(
                      vertical: 14,
                    ),
                    shape:
                    RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ====================================================================
// DATE
// ====================================================================

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


/// Reuses the Settings screen's frosted-glass surface treatment.
Widget _settingsGlass({
  required Widget child,
  double radius = 23,
}) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(radius),
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
      child: child,
    ),
  );
}

