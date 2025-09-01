part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

// State awal atau ketika user belum terautentikasi
class AuthUnauthenticated extends AuthState {}

// State ketika proses autentikasi sedang berjalan
class AuthLoading extends AuthState {}

// State untuk menandakan registrasi berhasil, sebelum login
class AuthSignUpSuccess extends AuthState {}

class AuthLoginSuccess extends AuthState {
  final User user;
  const AuthLoginSuccess(this.user);

  @override
  List<Object> get props => [user];
}

// State ketika user berhasil terautentikasi
class AuthAuthenticated extends AuthState {
  final User user;

  const AuthAuthenticated(this.user);

  @override
  List<Object> get props => [user];
}

// State ketika terjadi error saat autentikasi
class AuthFailure extends AuthState {
  final String message;

  const AuthFailure(this.message);

  @override
  List<Object> get props => [message];
}
