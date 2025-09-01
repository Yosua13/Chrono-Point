part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

// Event saat user mencoba sign up
class AuthSignUpRequested extends AuthEvent {
  final String name;
  final String email;
  final String password;

  const AuthSignUpRequested(this.name, this.email, this.password);
}

// Event saat user mencoba sign in
class AuthSignInRequested extends AuthEvent {
  final String email;
  final String password;

  const AuthSignInRequested(this.email, this.password);
}

class AuthLoginAcknowledged extends AuthEvent {}

// Event saat user sign out
class AuthSignOutRequested extends AuthEvent {}
