class AuthState {
  final bool isAuthenticated;
  final String username;

  const AuthState({
    required this.isAuthenticated,
    required this.username
  });

  factory AuthState.initial() => const AuthState(isAuthenticated: false, username: '');

  AuthState copyWith({bool? isAuthenticated, String? username}) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      username: username ?? this.username
    );
  }
}
