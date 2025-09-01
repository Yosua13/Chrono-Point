import 'package:chrono_point/data/models/users.dart';
import 'package:chrono_point/data/repositories/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc({required AuthRepository authRepository})
    : _authRepository = authRepository,
      super(AuthUnauthenticated()) {
    // Listener ini HANYA untuk auto-login dan sign-out
    _authRepository.user.listen((user) {
      if (state is AuthUnauthenticated || state is AuthAuthenticated) {
        if (user != null) {
          emit(AuthAuthenticated(user));
        } else {
          emit(AuthUnauthenticated());
        }
      }
    });

    // Handler untuk event Sign Up
    on<AuthSignUpRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        await _authRepository.signUp(
          name: event.name,
          email: event.email,
          password: event.password,
        );
        emit(AuthSignUpSuccess());
      } catch (e) {
        emit(AuthFailure(e.toString()));
        // Kembali ke state Unauthenticated setelah error
        emit(AuthUnauthenticated());
      }
    });

    // Handler untuk event Sign In
    on<AuthSignInRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final UserCredential = await _authRepository.signIn(
          email: event.email,
          password: event.password,
        );

        if (UserCredential != null) {
          emit(AuthLoginSuccess(UserCredential.user!));
        } else {
          emit(const AuthFailure("Login Gagal: Data pengguna tidak ditemukan"));
          emit(AuthUnauthenticated());
        }
      } catch (e) {
        emit(AuthFailure(e.toString()));
        // Kembali ke state Unauthenticated setelah error
        emit(AuthUnauthenticated());
      }
    });

    // BARU: Handler untuk event setelah popup ditutup
    on<AuthLoginAcknowledged>((event, emit) {
      // Pastikan state saat ini adalah AuthLoginSuccess untuk mendapatkan data user
      if (state is AuthLoginSuccess) {
        final currentUser = (state as AuthLoginSuccess).user;
        // Pindahkan ke state AuthAuthenticated yang akan memicu navigasi oleh builder
        emit(AuthAuthenticated(currentUser));
      }
    });

    // Handler untuk event Sign Out
    on<AuthSignOutRequested>((event, emit) async {
      emit(AuthLoading());
      await _authRepository.signOut();
    });
  }
}
