part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AuthGateEvent extends AuthEvent {}

class EmailSignInEvent extends AuthEvent {
  final String email;
  final String password;

  EmailSignInEvent({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [email, password];
}

class EmailSignUpEvent extends AuthEvent {
  final String email;
  final String password;
  final String confirmPassword;
  final String username;

  EmailSignUpEvent({
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.username,
  });

  @override
  List<Object> get props => [email, password, confirmPassword, username];
}

class GoogleSignInEvent extends AuthEvent {}

class SignOutEvent extends AuthEvent {}
