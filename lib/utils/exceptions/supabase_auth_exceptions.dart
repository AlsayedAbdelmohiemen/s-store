/// Custom exception class to handle various Supabase authentication-related errors.
class TSupabaseAuthException implements Exception {
  /// The error code or message.
  final String message;

  /// Constructor that takes an error message.
  const TSupabaseAuthException([this.message = 'An unexpected authentication error occurred.']);

  /// Create an authentication exception from a message.
  factory TSupabaseAuthException.fromMessage(String message) {
    if (message.contains('Invalid login credentials')) {
      return const TSupabaseAuthException('Invalid email or password. Please double check and try again.');
    } else if (message.contains('User already registered')) {
      return const TSupabaseAuthException('An account with this email already exists.');
    } else if (message.contains('Email not confirmed')) {
      return const TSupabaseAuthException('Please verify your email before logging in.');
    } else if (message.contains('Password should be at least')) {
      return const TSupabaseAuthException('Password is too weak. Please use a stronger password.');
    } else if (message.contains('rate limit') || message.contains('over_email_send_rate_limit')) {
      return const TSupabaseAuthException('Email rate limit exceeded! Please disable "Confirm email" in your Supabase Auth settings or wait a while.');
    } else if (message.contains('email_address_invalid') || message.contains('is invalid')) {
      return const TSupabaseAuthException('Please enter a valid email address with a recognized domain (like @gmail.com).');
    } else if (message.contains('Signups not allowed') || message.contains('signup_disabled')) {
      return const TSupabaseAuthException('Signups are disabled in your Supabase project! Please enable "Allow new users to sign up" in Supabase Authentication settings.');
    } else {
      return TSupabaseAuthException(message);
    }
  }

  @override
  String toString() => message;
}
