import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/profile_repository.dart';
import '../../data/models/user_profile_model.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository repository;

  ProfileCubit({required this.repository}) : super(ProfileInitial());

  Future<void> loadProfile(String userId) async {
    emit(ProfileLoading());
    try {
      final profile = await repository.getUserProfile(userId);
      emit(ProfileLoaded(profile: profile));
    } catch (e) {
      emit(ProfileError(message: e.toString()));
    }
  }

  Future<void> updateProfile(String userId, UserProfileModel profile) async {
    emit(ProfileLoading());
    try {
      final updatedProfile = await repository.updateProfile(userId, profile);
      emit(ProfileLoaded(profile: updatedProfile));
    } catch (e) {
      emit(ProfileError(message: e.toString()));
    }
  }
}
