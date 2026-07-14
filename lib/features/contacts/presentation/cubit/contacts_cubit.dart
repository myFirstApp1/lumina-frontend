import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/contacts_repository.dart';
import '../../data/models/emergency_contact_model.dart';
import 'contacts_state.dart';

class ContactsCubit extends Cubit<ContactsState> {
  final ContactsRepository repository;

  ContactsCubit({required this.repository}) : super(ContactsInitial());

  Future<void> loadContacts(String userId) async {
    emit(ContactsLoading());
    try {
      final contacts = await repository.getContacts(userId);
      emit(ContactsLoaded(contacts: contacts));
    } catch (e) {
      emit(ContactsError(message: e.toString()));
    }
  }

  Future<void> addContact(String userId, EmergencyContactRequestModel req) async {
    final currentState = state;
    List<EmergencyContactModel> currentContacts = [];
    if (currentState is ContactsLoaded) {
      currentContacts = currentState.contacts;
    }
    
    emit(ContactsLoading());
    try {
      final newContact = await repository.addContact(userId, req);
      emit(ContactsLoaded(contacts: [...currentContacts, newContact]));
    } catch(e){

      emit(ContactsError(message: e.toString()));

      if(currentContacts.isNotEmpty){
        emit(ContactsLoaded(
          contacts: currentContacts,
        ));
      }

      rethrow;

    }
  }

  Future<void> updateContact(String userId, String contactId, EmergencyContactRequestModel req) async {
    final currentState = state;
    List<EmergencyContactModel> currentContacts = [];
    if (currentState is ContactsLoaded) {
      currentContacts = currentState.contacts;
    }
    
    emit(ContactsLoading());
    try {
      final updatedContact = await repository.updateContact(userId, contactId, req);
      final updatedList = currentContacts.map((c) => c.id == contactId ? updatedContact : c).toList();
      emit(ContactsLoaded(contacts: updatedList));
    } catch(e){

      emit(ContactsError(message: e.toString()));

      if(currentContacts.isNotEmpty){
        emit(ContactsLoaded(
          contacts: currentContacts,
        ));
      }

      rethrow;

    }
  }

  Future<void> deleteContact(String userId, String contactId) async {
    final currentState = state;
    List<EmergencyContactModel> currentContacts = [];
    if (currentState is ContactsLoaded) {
      currentContacts = currentState.contacts;
    }
    
    emit(ContactsLoading());
    try {
      await repository.deleteContact(userId, contactId);
      final updatedList = currentContacts.where((c) => c.id != contactId).toList();
      emit(ContactsLoaded(contacts: updatedList));
    }catch(e){

      emit(ContactsError(message: e.toString()));

      if(currentContacts.isNotEmpty){
        emit(ContactsLoaded(
          contacts: currentContacts,
        ));
      }

      rethrow;

    }
  }
}
