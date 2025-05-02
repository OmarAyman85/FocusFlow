import 'package:focusflow/features/auth/data/models/user_model.dart';

abstract class AuthEvent {}

class SignUpRequested extends AuthEvent {
  final UserModel user;

  SignUpRequested(this.user);
}

class SignInRequested extends AuthEvent {
  final String email;
  final String password;

  SignInRequested({required this.email, required this.password});
}

class SignOutRequested extends AuthEvent {}

class GetCurrentUserRequested extends AuthEvent {}

class GetAllUsersRequested extends AuthEvent {}

class AppStarted extends AuthEvent {}
