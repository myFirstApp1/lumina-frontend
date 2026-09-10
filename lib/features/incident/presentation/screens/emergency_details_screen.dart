// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';
// import 'package:google_fonts/google_fonts.dart';
//
// import '../../../../core/routes/app_routes.dart';
// import '../../../../core/theme/app_theme.dart';
// import '../../data/models/incident_model.dart';
// import '../../data/models/timeline_event_model.dart';
// import '../cubit/incident_cubit.dart';
// import '../cubit/incident_state.dart';
//
// class EmergencyDetailsScreen extends StatefulWidget {
//
//   final String incidentId;
//
//   const EmergencyDetailsScreen({
//     super.key,
//     required this.incidentId,
//   });
//
//   @override
//   State<EmergencyDetailsScreen> createState() =>
//       _EmergencyDetailsScreenState();
// }
//
// class _EmergencyDetailsScreenState
//     extends State<EmergencyDetailsScreen> {
//
//   @override
//   void initState() {
//     super.initState();
//
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (!mounted) return;
//
//       context.read<IncidentCubit>().loadIncidentDetails(
//         widget.incidentId,
//       );
//
//       context.read<IncidentCubit>().loadTimeline(
//         widget.incidentId,
//       );
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppTheme.background,
//       body: SafeArea(
//         child: BlocBuilder<IncidentCubit, IncidentState>(
//           builder: (context, state) {
//
//             if (state.isLoading) {
//               return const Center(
//                 child: CircularProgressIndicator(
//                   color: AppTheme.primary,
//                 ),
//               );
//             }
//
//             if (state.error != null) {
//               return Center(
//                 child: Text(
//                   state.error!,
//                   style: const TextStyle(
//                     color: Colors.red,
//                   ),
//                 ),
//               );
//             }
//
//             if (state.selectedIncident == null) {
//               return const Center(
//                 child: Text(
//                   "Incident not found",
//                 ),
//               );
//             }
//
//             final incident = state.selectedIncident!;
//
//             return SingleChildScrollView(
//               padding: const EdgeInsets.fromLTRB(
//                 20,
//                 28,
//                 20,
//                 40,
//               ),
//               child: Column(
//                 crossAxisAlignment:
//                 CrossAxisAlignment.stretch,
//                 children: [
//
//                   /// Header
//                   _buildEmergencyHeader(incident),
//                   const SizedBox(height: 24),
//
//                   /// Incident Information
//                   _buildIncidentSummary(incident),
//                   const SizedBox(height: 24),
//
//                   /// Timeline
//                   _buildTimelineSection(state.timeline),
//                   const SizedBox(height: 24),
//
//                   _buildTimelineSection(state.timeline),
//
//                   const SizedBox(height: 24),
//
// // -----------------------------------------------------------------
// // TODO (Phase 5.8)
// // Emergency Notifications
// //
// // Backend integration pending.
// //
// // Future backend response should expose:
// //
// // - Family notification delivered
// // - Family acknowledgement
// // - Police notification delivered
// // - Police acknowledgement
// //
// // Once the backend provides these fields,
// // replace this placeholder with:
// //
// // _buildEmergencyNotifications(...)
// // -----------------------------------------------------------------
//
// // _buildEmergencyNotifications(),
//
//                   const SizedBox(height: 24),
//
// // -----------------------------------------------------------------
// // TODO (Phase 5.8)
// // Evidence Section
// //
// // Backend already supports Evidence APIs.
// //
// // Waiting for Flutter integration.
// //
// // Future:
// //
// // - Audio recordings
// // - Photos
// // - Videos
// // - Attachments
// //
// // _buildEvidenceSection(...)
// // -----------------------------------------------------------------
//
// // _buildEvidenceSection(),
//
//                 ],
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
//
//   Widget _buildEmergencyHeader(IncidentModel incident) {
//     return Container(
//       padding: const EdgeInsets.all(24),
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(.9),
//         borderRadius: BorderRadius.circular(24),
//         border: Border.all(
//           color: Colors.white.withOpacity(.5),
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(.04),
//             blurRadius: 12,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//
//           Row(
//             children: [
//
//               GestureDetector(
//                 onTap: () {
//                   context.push(
//                     AppRoutes.emergencyDetails,
//                     extra: incident.incidentId,
//                   );
//                 },
//                 child: Container(
//                   width: 42,
//                   height: 42,
//                   decoration: BoxDecoration(
//                     color: AppTheme.primary.withOpacity(.08),
//                     shape: BoxShape.circle,
//                   ),
//                   child: const Icon(
//                     Icons.arrow_back,
//                     color: AppTheme.primary,
//                   ),
//                 ),
//               ),
//
//               const SizedBox(width: 16),
//
//               Expanded(
//                 child: Text(
//                   "Emergency Details",
//                   style: GoogleFonts.montserrat(
//                     fontSize: 24,
//                     fontWeight: FontWeight.w700,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//
//           const SizedBox(height: 28),
//
//           Row(
//             children: [
//
//               _buildStatusIcon(incident.status),
//
//               const SizedBox(width: 18),
//
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment:
//                   CrossAxisAlignment.start,
//                   children: [
//
//                     Text(
//                       _triggerTitle(
//                         incident.triggerType,
//                       ),
//                       style: GoogleFonts.montserrat(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//
//                     const SizedBox(height: 6),
//
//                     Text(
//                       _formatDate(
//                         incident.createdAt,
//                       ),
//                       style: GoogleFonts.beVietnamPro(
//                         color: AppTheme.textSecondary,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//
//           const SizedBox(height: 24),
//
//           Row(
//             children: [
//
//               _buildStatusBadge(
//                 incident.status,
//               ),
//
//               const SizedBox(width: 10),
//
//               _buildRiskBadge(
//                 incident.riskScore,
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildIncidentSummary(IncidentModel incident) {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(.9),
//         borderRadius: BorderRadius.circular(24),
//         border: Border.all(
//           color: Colors.white.withOpacity(.5),
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(.04),
//             blurRadius: 12,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//
//           Text(
//             "Incident Summary",
//             style: GoogleFonts.montserrat(
//               fontSize: 18,
//               fontWeight: FontWeight.w700,
//             ),
//           ),
//
//           const SizedBox(height: 20),
//
//           _buildInfoRow(
//             "Tracking ID",
//             incident.trackingId.length > 8
//                 ? "${incident.trackingId.substring(0, 8)}..."
//                 : incident.trackingId,
//           ),
//
//           const Divider(height: 28),
//
//           _buildInfoRow(
//             "Incident Status",
//             incident.status,
//           ),
//
//           const Divider(height: 28),
//
//           _buildInfoRow(
//             "Trigger",
//             _triggerTitle(
//               incident.triggerType,
//             ),
//           ),
//
//           const Divider(height: 28),
//
//           _buildInfoRow(
//             "Risk Score",
//             incident.riskScore.toString(),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildInfoRow(
//       String title,
//       String value,
//       ) {
//     return Row(
//       crossAxisAlignment:
//       CrossAxisAlignment.start,
//       children: [
//
//         Expanded(
//           flex: 3,
//           child: Text(
//             title,
//             style: GoogleFonts.beVietnamPro(
//               fontSize: 15,
//               color: AppTheme.textSecondary,
//             ),
//           ),
//         ),
//
//         Expanded(
//           flex: 5,
//           child: Text(
//             value,
//             textAlign: TextAlign.right,
//             style: GoogleFonts.montserrat(
//               fontSize: 15,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildStatusIcon(String status) {
//
//     Color color;
//
//     IconData icon;
//
//     switch (status.toUpperCase()) {
//
//       case "ACTIVE":
//         color = AppTheme.error;
//         icon = Icons.warning_rounded;
//         break;
//
//       case "RESOLVED":
//         color = AppTheme.success;
//         icon = Icons.check_circle;
//         break;
//
//       default:
//         color = Colors.grey;
//         icon = Icons.history;
//     }
//
//     return Container(
//       width: 52,
//       height: 52,
//       decoration: BoxDecoration(
//         color: color.withOpacity(.10),
//         shape: BoxShape.circle,
//       ),
//       child: Icon(
//         icon,
//         color: color,
//         size: 26,
//       ),
//     );
//   }
//
//
//   Widget _buildStatusBadge(String status) {
//
//     Color color;
//
//     switch (status.toUpperCase()) {
//
//       case "ACTIVE":
//         color = AppTheme.error;
//         break;
//
//       case "RESOLVED":
//         color = AppTheme.success;
//         break;
//
//       default:
//         color = Colors.grey;
//     }
//
//     return Container(
//       padding: const EdgeInsets.symmetric(
//         horizontal: 10,
//         vertical: 4,
//       ),
//       decoration: BoxDecoration(
//         color: color.withOpacity(.12),
//         borderRadius: BorderRadius.circular(30),
//       ),
//       child: Text(
//         status,
//         style: GoogleFonts.beVietnamPro(
//           color: color,
//           fontWeight: FontWeight.w600,
//           fontSize: 12,
//         ),
//       ),
//     );
//   }
//
//   Widget _buildRiskBadge(int riskScore) {
//
//     String text;
//     Color color;
//
//     if (riskScore >= 61) {
//       text = "HIGH";
//       color = AppTheme.error;
//     } else if (riskScore >= 31) {
//       text = "MEDIUM";
//       color = AppTheme.warning;
//     } else {
//       text = "LOW";
//       color = AppTheme.success;
//     }
//
//     return Container(
//       padding: const EdgeInsets.symmetric(
//         horizontal: 10,
//         vertical: 4,
//       ),
//       decoration: BoxDecoration(
//         color: color.withOpacity(.12),
//         borderRadius: BorderRadius.circular(30),
//       ),
//       child: Text(
//         text,
//         style: GoogleFonts.beVietnamPro(
//           color: color,
//           fontWeight: FontWeight.w600,
//           fontSize: 12,
//         ),
//       ),
//     );
//   }
//
//   String _triggerTitle(String trigger) {
//
//     switch (trigger.toUpperCase()) {
//
//       case "MANUAL":
//         return "Manual SOS";
//
//       case "HEART_RATE":
//         return "Heart Rate Detection";
//
//       case "OFF_BODY":
//         return "Device Removed";
//
//       case "BLUETOOTH":
//         return "Bluetooth Disconnected";
//
//       default:
//         return trigger;
//     }
//   }
// }
//   Widget _buildTimelineSection(
//       List<TimelineEventModel> timeline,
//       ) {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(.9),
//         borderRadius: BorderRadius.circular(24),
//         border: Border.all(
//           color: Colors.white.withOpacity(.5),
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(.04),
//             blurRadius: 12,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment:
//         CrossAxisAlignment.start,
//         children: [
//
//           Text(
//             "Timeline",
//             style: GoogleFonts.montserrat(
//               fontSize: 18,
//               fontWeight: FontWeight.w700,
//             ),
//           ),
//
//           const SizedBox(height: 20),
//
//           if (timeline.isEmpty)
//
//             Center(
//               child: Padding(
//                 padding: const EdgeInsets.all(24),
//                 child: Text(
//                   "No timeline events available.",
//                   style: GoogleFonts.beVietnamPro(
//                     color: AppTheme.textSecondary,
//                   ),
//                 ),
//               ),
//             )
//
//           else
//
//             ListView.separated(
//               shrinkWrap: true,
//               physics:
//               const NeverScrollableScrollPhysics(),
//               itemCount: timeline.length,
//               separatorBuilder: (_, __) =>
//               const SizedBox(height: 20),
//               itemBuilder: (context, index) {
//                 return _buildTimelineItem(
//                   timeline[index],
//                   index ==
//                       timeline.length - 1,
//                 );
//               },
//             ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildTimelineItem(
//       TimelineEventModel event,
//       bool isLast,
//       ) {
//     return Row(
//       crossAxisAlignment:
//       CrossAxisAlignment.start,
//       children: [
//
//         Column(
//           children: [
//
//             Container(
//               width: 18,
//               height: 18,
//               decoration: BoxDecoration(
//                 color: _timelineColor(
//                   event.eventType,
//                 ),
//                 shape: BoxShape.circle,
//               ),
//             ),
//
//             if (!isLast)
//               Container(
//                 width: 2,
//                 height: 55,
//                 color: Colors.grey.shade300,
//               ),
//           ],
//         ),
//
//         const SizedBox(width: 16),
//
//         Expanded(
//           child: Column(
//             crossAxisAlignment:
//             CrossAxisAlignment.start,
//             children: [
//
//               Text(
//                 event.eventType,
//                 style: GoogleFonts.montserrat(
//                   fontWeight: FontWeight.w600,
//                   fontSize: 15,
//                 ),
//               ),
//
//               const SizedBox(height: 4),
//
//               Text(
//                 event.eventData,
//                 style: GoogleFonts.beVietnamPro(
//                   color:
//                   AppTheme.textSecondary,
//                 ),
//               ),
//
//               const SizedBox(height: 6),
//
//               Text(
//                 _formatDate(
//                   event.createdAt,
//                 ),
//                 style: GoogleFonts.beVietnamPro(
//                   fontSize: 12,
//                   color: Colors.grey,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
//
//   Color _timelineColor(String type) {
//
//     switch (type.toUpperCase()) {
//
//       case "PROTECTION_STARTED":
//         return Colors.green;
//
//       case "WARNING":
//         return Colors.orange;
//
//       case "SOS_TRIGGERED":
//         return Colors.red;
//
//       case "FAMILY_SMS_SENT":
//         return Colors.blue;
//
//       case "POLICE_NOTIFIED":
//         return Colors.indigo;
//
//       case "INCIDENT_CLOSED":
//         return Colors.green;
//
//       default:
//         return AppTheme.primary;
//     }
//   }
//
// String _formatDate(DateTime dateTime) {
//
//   final now = DateTime.now();
//
//   final difference =
//   now.difference(dateTime);
//
//   if (difference.inMinutes < 1) {
//     return "Just now";
//   }
//
//   if (difference.inHours < 1) {
//     return "${difference.inMinutes} min ago";
//   }
//
//   if (difference.inDays < 1) {
//     return "${difference.inHours} hrs ago";
//   }
//
//   if (difference.inDays == 1) {
//     return "Yesterday";
//   }
//
//   return "${dateTime.day}/${dateTime.month}/${dateTime.year}";
// }

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

                    const SizedBox(height: 18),

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
    );
  }

  // ================================================================
  // TOP BAR
  // ================================================================

  Widget _buildTopBar() {
    return Row(
      children: [

        GestureDetector(
          onTap: () {
            context.pop();
          },
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.92),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.04),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: const Icon(
              Icons.arrow_back_rounded,
              color: AppTheme.primary,
            ),
          ),
        ),

        const SizedBox(width: 14),

        Expanded(
          child: Text(
            "Emergency Details",
            style: GoogleFonts.montserrat(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
            ),
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

    return Container(
      padding: const EdgeInsets.all(24),

      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.94),
        borderRadius: BorderRadius.circular(28),

        border: Border.all(
          color: Colors.white.withOpacity(.65),
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.045),
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
                width: 62,
                height: 62,

                decoration: BoxDecoration(
                  color: statusColor.withOpacity(.10),
                  shape: BoxShape.circle,
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
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
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
    );
  }

  // ================================================================
  // INCIDENT SUMMARY
  // ================================================================

  Widget _buildIncidentSummary(
      IncidentModel incident,
      ) {
    return Container(
      padding: const EdgeInsets.all(22),

      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.94),
        borderRadius: BorderRadius.circular(26),

        border: Border.all(
          color: Colors.white.withOpacity(.65),
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.035),
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
              fontSize: 18,
              fontWeight: FontWeight.w700,
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
    );
  }

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
              fontSize: 14,
              color: AppTheme.textSecondary,
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
              fontSize: 14,
              fontWeight: FontWeight.w600,
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
    return Container(
      padding: const EdgeInsets.all(22),

      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.94),
        borderRadius: BorderRadius.circular(26),

        border: Border.all(
          color: Colors.white.withOpacity(.65),
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.035),
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
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
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
    );
  }

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
                color: AppTheme.textSecondary,
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
                  color: Colors.grey.shade200,
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
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  event.eventData,
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 13,
                    height: 1.4,
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
                    fontSize: 11,
                    color: Colors.grey,
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
                color: AppTheme.textSecondary,
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
            color: Colors.white.withOpacity(.94),
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
                  color: AppTheme.textSecondary,
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