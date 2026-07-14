import '../../data/models/emergency_contact_model.dart';

abstract class ContactsRepository {
  Future<List<EmergencyContactModel>> getContacts(String userId);
  Future<List<String>> getPublicContactNumbers(String userId);
  Future<EmergencyContactModel> addContact(String userId, EmergencyContactRequestModel req);
  Future<EmergencyContactModel> updateContact(String userId, String contactId, EmergencyContactRequestModel req);
  Future<void> deleteContact(String userId, String contactId);
}
