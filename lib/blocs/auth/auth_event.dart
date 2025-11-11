abstract class AuthEvent{}

class SignUpRequested extends AuthEvent {
  final String username;
  final String password;
  SignUpRequested(this.username, this.password);
}

class SignInRequested extends AuthEvent {
  final String username;
  final String password;
  SignInRequested(this.username, this.password);
}

class SignOutRequested extends AuthEvent {}

class getUserRequested extends AuthEvent{}