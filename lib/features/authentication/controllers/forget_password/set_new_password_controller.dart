import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../data/repositories/authentication/authentication_repository.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/helpers/network_manager.dart';
import '../../../../utils/popups/full_screen_loader.dart';
import '../../../../utils/popups/loaders.dart';
import '../login/login_controller.dart';
import '../../views/login/login.dart';

class SetNewPasswordController extends GetxController {
  static SetNewPasswordController get instance => Get.find();

  final String email;
  SetNewPasswordController({this.email = ''});

  /// Variables
  final otp = TextEditingController();
  final newPassword = TextEditingController();
  final confirmPassword = TextEditingController();
  final hidePassword = true.obs;
  final hideConfirmPassword = true.obs;
  GlobalKey<FormState> setNewPasswordFormKey = GlobalKey<FormState>();

  /// Reset user's password using 6-digit OTP code (or active session if deep linked)
  Future<void> resetPassword() async {
    try {
      // 1. Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TLoaders.warningSnackBar(
          title: 'No Internet Connection',
          message: 'Please check your internet connection and try again.',
        );
        return;
      }

      // 2. Form Validation
      if (!setNewPasswordFormKey.currentState!.validate()) {
        return;
      }

      // 3. Check passwords match
      if (newPassword.text.trim() != confirmPassword.text.trim()) {
        TLoaders.warningSnackBar(
          title: 'Passwords Mismatch',
          message: 'Password and confirm password do not match.',
        );
        return;
      }

      // 4. Start Loading
      TFullScreenLoader.openLoadingDialog(
        'Updating your password...',
        SImages.docerAnimation,
      );

      final otpCode = otp.text.trim();
      final newPass = newPassword.text.trim();

      if (otpCode.isNotEmpty && email.isNotEmpty) {
        // Option 1: Verify OTP and update password
        await AuthenticationRepository.instance.resetPasswordWithOtp(
          email: email,
          otp: otpCode,
          newPassword: newPass,
        );
      } else {
        // Fallback: If user was redirected via deep link and already authenticated
        await AuthenticationRepository.instance.updatePassword(newPass);
      }

      // Sync new credentials with Remember Me / Local Storage so login works automatically
      final localStorage = GetStorage();
      if (email.isNotEmpty) {
        localStorage.write('REMEMBER_ME_EMAIL', email);
      }
      localStorage.write('REMEMBER_ME_PASSWORD', newPass);

      if (Get.isRegistered<LoginController>()) {
        final loginController = LoginController.instance;
        if (email.isNotEmpty) loginController.email.text = email;
        loginController.password.text = newPass;
        loginController.rememberMe.value = true;
      }

      // 5. Stop Loading
      TFullScreenLoader.stopLoading();

      // 6. Show success & navigate to login
      TLoaders.successSnackBar(
        title: 'Password Updated',
        message:
            'Your password has been changed successfully. Please login with your new password.',
      );

      Get.offAll(() => const LoginScreen());
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  /// Resend OTP code
  Future<void> resendOtp() async {
    if (email.isEmpty) return;
    try {
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TLoaders.warningSnackBar(
          title: 'No Internet Connection',
          message: 'Please check your internet connection and try again.',
        );
        return;
      }

      TFullScreenLoader.openLoadingDialog(
        'Sending code...',
        SImages.docerAnimation,
      );

      await AuthenticationRepository.instance.sendPasswordResetEmail(email);

      TFullScreenLoader.stopLoading();

      TLoaders.successSnackBar(
        title: 'Code Sent',
        message: 'A new 6-digit code has been sent to your email.',
      );
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  @override
  void onClose() {
    otp.dispose();
    newPassword.dispose();
    confirmPassword.dispose();
    super.onClose();
  }
}
