import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../../domain/repositories/contacts_repository.dart';
import '../models/emergency_contact_model.dart';

class ContactsRepositoryImpl implements ContactsRepository {
  final DioClient client;

  ContactsRepositoryImpl({required this.client});

  @override
  Future<List<EmergencyContactModel>> getContacts(String userId) async {
    try {
      final response = await client.dio.get('/api/users/contacts/$userId');
      final data = response.data as List;
      return data.map((json) => EmergencyContactModel.fromJson(json)).toList();
    } catch (e) {
      if (e is DioException) {
        throw Exception(e.response?.data?['message'] ?? 'Failed to load contacts');
      }
      throw Exception('An unexpected error occurred');
    }
  }

  @override
  Future<List<String>> getPublicContactNumbers(String userId) async {
    try {
      final response = await client.dio.get('/api/users/contacts/public/$userId/numbers');
      final data = response.data as List;
      return data.map((e) => e.toString()).toList();
    } catch (e) {
      if (e is DioException) {
        throw Exception(e.response?.data?['message'] ?? 'Failed to load public numbers');
      }
      throw Exception('An unexpected error occurred');
    }
  }

  @override
  Future<EmergencyContactModel> addContact(String userId, EmergencyContactRequestModel req) async {
    try {
      final response = await client.dio.post(
        '/api/users/contacts/$userId',
        data: req.toJson(),
      );
      return EmergencyContactModel.fromJson(response.data);
    } catch (e) {
      if (e is DioException) {
        throw Exception(e.response?.data?['message'] ?? 'Failed to add contact');
      }
      throw Exception('An unexpected error occurred');
    }
  }

  @override
  Future<EmergencyContactModel> updateContact(String userId, String contactId, EmergencyContactRequestModel req) async {
    try {
      final response = await client.dio.put(
        '/api/users/contacts/$userId/$contactId',
        data: req.toJson(),
      );
      return EmergencyContactModel.fromJson(response.data);
    } catch (e) {
      if (e is DioException) {
        throw Exception(e.response?.data?['message'] ?? 'Failed to update contact');
      }
      throw Exception('An unexpected error occurred');
    }
  }

  @override
  Future<void> deleteContact(String userId, String contactId) async {
    try {
      await client.dio.delete('/api/users/contacts/$userId/$contactId');
    } catch (e) {
      if (e is DioException) {
        throw Exception(e.response?.data?['message'] ?? 'Failed to delete contact');
      }
      throw Exception('An unexpected error occurred');
    }
  }
}
