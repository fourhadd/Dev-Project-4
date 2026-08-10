sealed class AuthException implements Exception {
  final String message;
  const AuthException(this.message);

  @override
  String toString() => message;
}

class WrongCredentialsException extends AuthException {
  const WrongCredentialsException() : super('Incorrect email or password. Please try again.');
}

class EmailAlreadyInUseException extends AuthException {
  const EmailAlreadyInUseException() : super('An account with this email already exists.');
}

class NetworkException extends AuthException {
  const NetworkException() : super('Network error. Check your connection and try again.');
}

class UnknownAuthException extends AuthException {
  const UnknownAuthException([String msg = 'Something went wrong. Please try again.']) : super(msg);
}
