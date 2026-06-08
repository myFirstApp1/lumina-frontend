import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  AuthCubit({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(const AuthInitial());

  Future<void> checkAuthStatus() async {
    emit(const AuthLoading());
    try {
      final user = await _authRepository.getCurrentUser();
      emit(AuthAuthenticated(user));
    } catch (_) {
      emit(const AuthUnauthenticated());
    }
  }

  Future<void> login(String username, String password) async {
    emit(const AuthLoading());

    try {
      final user = await _authRepository.login(
        username,
        password,
      );

      debugPrint("+++++++++\nAUTH CUBIT USER ID\n++++++++ = ${user.authUserId}");

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
