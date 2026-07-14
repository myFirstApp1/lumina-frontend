import 'package:dio/dio.dart';

import '../../../../core/network/dio_client.dart';
import '../../../../core/errors/failures.dart';

import '../../domain/repositories/incident_repository.dart';

import '../models/emergency_monitor_model.dart';
import '../models/incident_model.dart';
import '../models/timeline_event_model.dart';

class IncidentRepositoryImpl implements IncidentRepository {
  final DioClient _client;

  IncidentRepositoryImpl({
    required DioClient client,
  }) : _client = client;

  @override
  Future<List<IncidentModel>> getIncidentHistory(
      String userId,
      ) async {
    try {
      final response = await _client.dio.get(
        '/api/incidents/user/$userId',
      );

      final List data = response.data as List;

      return data
          .map(
            (e) => IncidentModel.fromJson(
          e as Map<String, dynamic>,
        ),
      )
          .toList();
    } on DioException catch (e) {
      throw ServerException(
        e.response?.data?['message'] ??
            'Failed to load incident history',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<IncidentModel> getIncidentDetails(
      String incidentId,
      ) async {
    try {
      final response = await _client.dio.get(
        '/api/incidents/$incidentId',
      );

      return IncidentModel.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw ServerException(
        e.response?.data?['message'] ??
            'Failed to load incident',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<List<TimelineEventModel>> getTimeline(
      String incidentId,
      ) async {
    try {
      final response = await _client.dio.get(
        '/api/incidents/$incidentId/timeline',
      );

      final List data = response.data as List;

      return data
          .map(
            (e) => TimelineEventModel.fromJson(
          e as Map<String, dynamic>,
        ),
      )
          .toList();
    } on DioException catch (e) {
      throw ServerException(
        e.response?.data?['message'] ??
            'Failed to load timeline',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<EmergencyMonitorModel> getEmergencyMonitor(
      String trackingId,
      ) async {
    try {
      final response = await _client.dio.get(
        '/api/family/$trackingId',
      );

      return EmergencyMonitorModel.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw ServerException(
        e.response?.data?['message'] ??
            'Failed to load emergency monitor',
        statusCode: e.response?.statusCode,
      );
    }
  }
}