import 'dart:async';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../features/authentication/views/password_configration/set_new_password.dart';
import '../../../features/personalization/controllers/user_controller.dart';
import '../../../features/personalization/models/user_model.dart';
import '../../../utils/popups/loaders.dart';
import '../../repositories/user/user_repository.dart';
import '../../services/authentication/auth_email_service.dart';
import '../../services/authentication/auth_password_service.dart';
import '../../services/authentication/auth_session_service.dart';
import '../../services/authentication/auth_social_service.dart';

/// Central Facade for Authentication Operations.
/// Delegates specialized tasks to dedicated single-responsibility services:
/// - [AuthEmailService]: Register, Login, Verification.
/// - [AuthSocialService]: Google & Facebook OAuth Sign-in.
/// - [AuthPasswordService]: Reset, Recovery & OTP.
/// - [AuthSessionService]: User state, Screen routing & Logout.
class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  /// Modular Services
  final AuthEmailService _emailService = AuthEmailService();
  final AuthSocialService _socialService = AuthSocialService();
  final AuthPasswordService _passwordService = AuthPasswordService();
  final AuthSessionService _sessionService = AuthSessionService();

  StreamSubscription<AuthState>? _passwordRecoverySubscription;
  StreamSubscription<AuthState>? _authStateSubscription;

  /// Exposed variables for backward compatibility
  GetStorage get deviceStorage => GetStorage();
  User? get authUser => _sessionService.authUser;

  @override
  void onInit() {
    super.onInit();
    _listenPasswordRecovery();
    _listenAuthStateChanges();
  }

  @override
  void onClose() {
    _passwordRecoverySubscription?.cancel();
    _authStateSubscription?.cancel();
    super.onClose();
  }

  /// Called from main.dart on app launch
  @override
  void onReady() {
    _sessionService.handleAppStartup();
  }

  /// Redirect to the appropriate screen
  void screenRedirect() => _sessionService.screenRedirect();

  /// Listen for OAuth state change events (Facebook, Google deep-links)
  void _listenAuthStateChanges() {
    _authStateSubscription =
        Supabase.instance.client.auth.onAuthStateChange.listen((data) async {
      if (data.event == AuthChangeEvent.signedIn) {
        final user = data.session?.user;
        if (user != null) {
          await _syncOAuthUserRecord(user);
          screenRedirect();
        }
      }
    });
  }

  /// Sync OAuth user details to Supabase Users table if first time
  Future<void> _syncOAuthUserRecord(User user) async {
    try {
      final userRepository = Get.isRegistered<UserRepository>()
          ? UserRepository.instance
          : Get.put(UserRepository());

      final existingUser = await userRepository.fetchUserDetails();
      if (existingUser.id.isEmpty) {
        final fullName = user.userMetadata?['full_name'] ??
            user.userMetadata?['name'] ??
            '';
        final nameParts = UserModel.nameParts(fullName.toString());
        final firstName = nameParts.isNotEmpty ? nameParts[0] : '';
        final lastName =
            nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';
        final username = UserModel.generateUsername('$firstName $lastName');

        final newUser = UserModel(
          id: user.id,
          firstName: firstName,
          lastName: lastName,
          username: username,
          email: user.email ?? '',
          phoneNumber: user.phone ?? '',
          profilePicture: user.userMetadata?['avatar_url'] ?? '',
        );

        await userRepository.saveUserRecord(newUser);

        if (Get.isRegistered<UserController>()) {
          await UserController.instance.fetchUserRecord();
        }
      }
    } catch (_) {}
  }

  /* ---------------------------- Email & Password sign in ---------------------------------*/

  /// [EmailAuthentication] - REGISTER
  Future<AuthResponse> registerWithEmailAndPassword(
    String email,
    String password, [
    Map<String, dynamic>? data,
  ]) =>
      _emailService.registerWithEmailAndPassword(email, password, data);

  /// [EmailAuthentication] - LOGIN
  Future<AuthResponse> loginWithEmailAndPassword(
    String email,
    String password,
  ) =>
      _emailService.loginWithEmailAndPassword(email, password);

  /// [EmailVerification] - RESEND EMAIL
  Future<void> sendEmailVerification([String? email]) =>
      _emailService.sendEmailVerification(email ?? authUser?.email ?? '');

  /// [EmailVerification] - Send Password Reset Email
  Future<void> sendPasswordResetEmail(String email) =>
      _passwordService.sendPasswordResetEmail(email);

  /* ---------------------------- Federated identity & social sign-in ---------------------------------*/

  /// [GoogleSignIn] - GOOGLE AUTHENTICATION
  Future<AuthResponse> signInWithGoogle() =>
      _socialService.signInWithGoogle();

  /// [FacebookSignIn] - FACEBOOK AUTHENTICATION
  Future<bool> signInWithFacebook() =>
      _socialService.signInWithFacebook();

  /* ---------------------------- Password Recovery ---------------------------------*/

  /// Listen for password recovery deep link event
  void _listenPasswordRecovery() {
    _passwordRecoverySubscription = _passwordService.listenPasswordRecovery(
      onPasswordRecovery: () => Get.offAll(() => const SetNewPasswordScreen()),
      onError: (errorMessage) => TLoaders.errorSnackBar(
        title: 'Link Expired or Invalid',
        message: errorMessage,
      ),
    );
  }

  /// [ResetPasswordWithOtp] - Verify 6-digit OTP code and set new password directly
  Future<void> resetPasswordWithOtp({
    required String email,
    required String otp,
    required String newPassword,
  }) =>
      _passwordService.resetPasswordWithOtp(
        email: email,
        otp: otp,
        newPassword: newPassword,
      );

  /// [UpdatePassword] - Save new password after recovery
  Future<void> updatePassword(String newPassword) =>
      _passwordService.updatePassword(newPassword);

  /* ---------------------------- Logout ---------------------------------*/

  /// [LogoutUser] - Valid for any authentication
  Future<void> logout() => _sessionService.logout();
}
