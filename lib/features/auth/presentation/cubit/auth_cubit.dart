import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/secure_storage/secure_storage_manager.dart';
import '../../data/models/user_model.dart';
import '../../domain/repositories/auth_repository.dart';

abstract class AuthState {
  const AuthState();
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthAuthenticated extends AuthState {
  final UserModel user;
  const AuthAuthenticated(this.user);
}

class AuthOtpVerificationRequired extends AuthState {
  final String email;
  final String txnId;
  const AuthOtpVerificationRequired({required this.email, required this.txnId});
}

class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);
}

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;
  final SecureStorageManager _secureStorage;

  AuthCubit({
    required AuthRepository authRepository,
    required SecureStorageManager secureStorage,
  })  : _authRepository = authRepository,
        _secureStorage = secureStorage,
        super(const AuthInitial());

  Future<void> checkAuthStatus() async {

    emit(const AuthLoading());

    try {

      final hasSession =
      await _authRepository.hasValidSession();

      if (!hasSession) {

        emit(const AuthUnauthenticated());
        return;

      }

      final userId =
      await _secureStorage.getUserId();

      if (userId == null) {

        emit(const AuthUnauthenticated());
        return;

      }

      emit(
        AuthAuthenticated(
          UserModel(
            userId: userId,
            profileId: "",
            name: "",
            email: "",
            phone: null,
            emergencyContacts: const [],
          ),
        ),
      );

    } catch (_) {

      emit(const AuthUnauthenticated());

    }

  }

  Future<void> login(String email, String password) async {
    emit(const AuthLoading());

    try {
      final user = await _authRepository.login(
        email,
        password,
      );

      debugPrint("+++++++++\nAUTH CUBIT USER ID\n++++++++ = ${user.userId}");

      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> register(String username, String email, String password) async {
    emit(const AuthLoading());
    try {
      final txnId = await _authRepository.register(username, email, password);
      emit(AuthOtpVerificationRequired(email: email, txnId: txnId));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> verifyOtp(String txnId, String otp) async {
    emit(const AuthLoading());
    try {
      await _authRepository.verifyOtp(txnId, otp);
      emit(const AuthUnauthenticated()); // Redirects to login
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> logout() async {
    emit(const AuthLoading());
    try {
      await _authRepository.logout();
    } finally {
      emit(const AuthUnauthenticated());
    }
  }
}
