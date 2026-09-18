import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../utils/exceptions/format_exceptions.dart';
import '../../../utils/exceptions/platform_exceptions.dart';
import '../../../utils/exceptions/supabase_auth_exceptions.dart';

/// Service dedicated to handling email and password authentication operations.
class AuthEmailService {
  final SupabaseClient _supabase;

  AuthEmailService({SupabaseClient? supabase})
      : _supabase = supabase ?? Supabase.instance.client;

  /// [EmailAuthentication] - Register new user with email and password
  Future<AuthResponse> registerWithEmailAndPassword(
    String email,
    String password, [
    Map<String, dynamic>? data,
  ]) async {
    try {
      return await _supabase.auth.signUp(
        email: email,
        password: password,
        data: data,
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

  /// [EmailAuthentication] - Sign In / Login with email and password
  Future<AuthResponse> loginWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      return await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
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

  /// [EmailVerification] - Send / Resend Email Verification
  Future<void> sendEmailVerification(String email) async {
    try {
      await _supabase.auth.resend(
        type: OtpType.signup,
        email: email,
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
