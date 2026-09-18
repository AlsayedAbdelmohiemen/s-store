import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../features/authentication/views/login/login.dart';
import '../../../features/authentication/views/onboarding_screen/onboarding.dart';
import '../../../features/authentication/views/signup/verify_email.dart';
import '../../../navigation_menu.dart';
import '../../../utils/exceptions/platform_exceptions.dart';
import '../../../utils/exceptions/supabase_auth_exceptions.dart';

/// Service dedicated to user session management, screen routing, and logout operations.
class AuthSessionService {
  final SupabaseClient _supabase;
  final GetStorage _deviceStorage;

  AuthSessionService({
    SupabaseClient? supabase,
    GetStorage? deviceStorage,
  })  : _supabase = supabase ?? Supabase.instance.client,
        _deviceStorage = deviceStorage ?? GetStorage();

  /// Current authenticated user
  User? get authUser => _supabase.auth.currentUser;

  /// Function to remove Native Splash Screen and show relevant screen
  void handleAppStartup() {
    FlutterNativeSplash.remove();
    screenRedirect();
  }

  /// Function to show relevant screen based on auth state and onboarding status
  void screenRedirect() {
    final user = _supabase.auth.currentUser;

    if (user != null) {
      // Check if email is verified
      if (user.emailConfirmedAt != null) {
        Get.offAll(() => const NavigationMenu());
      } else {
        Get.offAll(() => VerifyEmailScreen(email: user.email));
      }
    } else {
      // Local Storage for onboarding state
      _deviceStorage.writeIfNull('IsFirstTime', true);

      _deviceStorage.read('IsFirstTime') != true
          ? Get.offAll(() => const LoginScreen())
          : Get.offAll(() => OnBoardingScreen());
    }
  }

  /// [LogoutUser] - Signs out from Supabase & Google, cleans up and routes to Login
  Future<void> logout() async {
    try {
      await GoogleSignIn().signOut();
      await _supabase.auth.signOut();
      Get.offAll(() => const LoginScreen());
    } on AuthException catch (e) {
      Get.offAll(() => const LoginScreen());
      throw TSupabaseAuthException.fromMessage(e.message).message;
    } on PlatformException catch (e) {
      Get.offAll(() => const LoginScreen());
      throw TPlatformException(e.code).message;
    } catch (_) {
      Get.offAll(() => const LoginScreen());
      throw 'Something went wrong. Please try again';
    }
  }
}
