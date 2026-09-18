import 'dart:async';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../utils/exceptions/format_exceptions.dart';
import '../../../utils/exceptions/platform_exceptions.dart';
import '../../../utils/exceptions/supabase_auth_exceptions.dart';

/// Service dedicated to password recovery, password reset with OTP, and updating user passwords.
class AuthPasswordService {
  final SupabaseClient _supabase;

  AuthPasswordService({SupabaseClient? supabase})
      : _supabase = supabase ?? Supabase.instance.client;

  /// Listen for password recovery deep link event
  StreamSubscription<AuthState> listenPasswordRecovery({
    required void Function() onPasswordRecovery,
    required void Function(String errorMessage) onError,
  }) {
    return _supabase.auth.onAuthStateChange.listen(
      (data) {
        if (data.event == AuthChangeEvent.passwordRecovery) {
          onPasswordRecovery();
        }
      },
      onError: (error) {
        if (error is AuthException) {
          onError(
            'This reset link has expired or was already used. Please request a new one from the app.',
          );
        }
      },
    );
  }

  /// [EmailVerification] - Send Password Reset Email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _supabase.auth.resetPasswordForEmail(
        email,
        redirectTo: 'io.supabase.sstore://reset-password',
      );
    } on AuthException catch (e) {
      throw TSupabaseAuthException.fromMessage(e.message).message;
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } catch (_) {
      throw 'Something went wrong. Please try again';
    }
  }

  /// [ResetPasswordWithOtp] - Verify 6-digit OTP code and set new password directly
  Future<void> resetPasswordWithOtp({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    try {
      // 1. Verify OTP - verifies the 6-digit token and establishes session
      await _supabase.auth.verifyOTP(
        email: email,
        token: otp,
        type: OtpType.recovery,
      );

      // 2. Update password for the authenticated user
      await _supabase.auth.updateUser(
        UserAttributes(password: newPassword),
      );

      // 3. Sign out cleanly so the user logs in with new credentials
      await _supabase.auth.signOut();
    } on AuthException catch (e) {
      throw TSupabaseAuthException.fromMessage(e.message).message;
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } catch (_) {
      throw 'Something went wrong. Please try again';
    }
  }

  /// [UpdatePassword] - Save new password after recovery
  Future<void> updatePassword(String newPassword) async {
    try {
      await _supabase.auth.updateUser(
        UserAttributes(password: newPassword),
      );
    } on AuthException catch (e) {
      throw TSupabaseAuthException.fromMessage(e.message).message;
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } catch (_) {
      throw 'Something went wrong. Please try again';
    }
  }
}
