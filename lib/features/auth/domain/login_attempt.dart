class LoginAttempt {
  final String username;
  final String password;

  const LoginAttempt({
    required this.username,
    required this.password,
  });

  bool get isValid => username.isNotEmpty && password.isNotEmpty;
}
