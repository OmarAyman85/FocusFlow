abstract class AuthEvent {}

class SignInRequested extends AuthEvent {
  final String email, password;
  SignInRequested({required this.email, required this.password});
}

class SignUpRequested extends AuthEvent {
  final String name, email, password;
  SignUpRequested({
    required this.name,
    required this.email,
    required this.password,
  });
}

class SignOutRequested extends AuthEvent {}

class AppStarted extends AuthEvent {}
