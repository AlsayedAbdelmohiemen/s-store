import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../utils/exceptions/format_exceptions.dart';
import '../../../utils/exceptions/platform_exceptions.dart';
import '../../../utils/exceptions/supabase_auth_exceptions.dart';

/// Service dedicated to handling third-party / social authentication (Google & Facebook Sign-In).
class AuthSocialService {
  final SupabaseClient _supabase;

  static const String _webClientId =
      '286411250998-16trpbtn5tplco84cp8vhoeviu46ipub.apps.googleusercontent.com';

  AuthSocialService({SupabaseClient? supabase})
      : _supabase = supabase ?? Supabase.instance.client;

  /// [GoogleSignIn] - Google authentication flow and Supabase federated sign-in
  Future<AuthResponse> signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(
        serverClientId: _webClientId,
      );
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        throw 'Google Sign In was cancelled.';
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final accessToken = googleAuth.accessToken;
      final idToken = googleAuth.idToken;

      if (idToken == null) {
        throw 'No ID Token found. Please ensure the Android OAuth client ID with SHA-1 is configured in Google Cloud.';
      }

      return await _supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );
    } on AuthException catch (e) {
      throw TSupabaseAuthException.fromMessage(e.message).message;
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } catch (e) {
      if (e is String) rethrow;
      throw 'Something went wrong. Please try again';
    }
  }

  /// [FacebookSignIn] - Facebook OAuth authentication flow via Supabase
  Future<bool> signInWithFacebook() async {
    try {
      return await _supabase.auth.signInWithOAuth(
        OAuthProvider.facebook,
        redirectTo: kIsWeb ? null : 'io.supabase.sstore://login-callback',
        authScreenLaunchMode: LaunchMode.externalApplication,
      );
    } on AuthException catch (e) {
      throw TSupabaseAuthException.fromMessage(e.message).message;
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      if (e is String) rethrow;
      throw 'Something went wrong with Facebook sign-in. Please try again.';
    }
  }

  /// Sign out from Google
  Future<void> signOutGoogle() async {
    try {
      await GoogleSignIn().signOut();
    } catch (_) {}
  }
}
