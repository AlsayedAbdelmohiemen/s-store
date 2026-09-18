/// Custom exception class to handle various platform-related errors.
class TPlatformException implements Exception {
  final String code;

  const TPlatformException(this.code);

  String get message {
    switch (code) {
      case 'INVALID_LOGIN_CREDENTIALS':
        return 'Invalid login credentials. Please double-check your information.';
      case 'too-many-requests':
        return 'Too many requests. Please try again later.';
      case 'invalid-argument':
        return 'Invalid argument provided to the authentication method.';
      case 'network-request-failed':
        return 'Network request failed. Please check your internet connection.';
      case 'user-disabled':
        return 'This user account has been disabled. Please contact support.';
      default:
        return 'An unexpected platform error occurred. Please try again.';
    }
  }

  @override
  String toString() => message;
}
