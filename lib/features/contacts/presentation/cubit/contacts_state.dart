import 'package:equatable/equatable.dart';
import '../../data/models/emergency_contact_model.dart';

abstract class ContactsState extends Equatable {
  const ContactsState();

  @override
  List<Object?> get props => [];
}

class ContactsInitial extends ContactsState {}

class ContactsLoading extends ContactsState {}

class ContactsLoaded extends ContactsState {
  final List<EmergencyContactModel> contacts;

  const ContactsLoaded({required this.contacts});

  @override
  List<Object?> get props => [contacts];
}

class ContactsError extends ContactsState {
  final String message;

  const ContactsError({required this.message});

  @override
  List<Object?> get props => [message];
}
