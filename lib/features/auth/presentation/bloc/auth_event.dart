abstract class AuthEvent {}

class SignInRequested extends AuthEvent {
  final String email, password;
  SignInRequested(this.email, this.password);
}

class SignUpRequested extends AuthEvent {
  final String name, email, password;
  SignUpRequested(this.name, this.email, this.password);
}

class SignOutRequested extends AuthEvent {}

class AppStarted extends AuthEvent {}
