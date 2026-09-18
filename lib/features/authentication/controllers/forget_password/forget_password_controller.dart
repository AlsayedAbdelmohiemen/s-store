import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../data/repositories/authentication/authentication_repository.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/helpers/network_manager.dart';
import '../../../../utils/popups/full_screen_loader.dart';
import '../../../../utils/popups/loaders.dart';
import '../../views/password_configration/reset_password.dart';

class ForgetPasswordController extends GetxController {
  static ForgetPasswordController get instance => Get.find();

  /// Variables
  final email = TextEditingController();
  GlobalKey<FormState> forgetPasswordFormKey = GlobalKey<FormState>();

  /// Send Reset Password Email
  Future<void> sendPasswordResetEmail() async {
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
      if (!forgetPasswordFormKey.currentState!.validate()) {
        return;
      }

      // 3. Start Loading Dialog
      TFullScreenLoader.openLoadingDialog('Processing your request...', SImages.docerAnimation);

      // 4. Send Password Reset Email via Supabase
      await AuthenticationRepository.instance.sendPasswordResetEmail(email.text.trim());

      // 5. Remove Loader
      TFullScreenLoader.stopLoading();

      // 6. Show Success Message
      TLoaders.successSnackBar(
        title: 'Email Sent',
        message: 'Email Link Sent to Reset your Password.',
      );

      // 7. Redirect to Reset Password Screen
      Get.to(() => ResetPassword(email: email.text.trim()));
    } catch (e) {
      // Remove Loader
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  /// Resend Reset Password Email
  Future<void> resendPasswordResetEmail(String email) async {
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

      // 2. Start Loading
      TFullScreenLoader.openLoadingDialog('Processing your request...', SImages.docerAnimation);

      // 3. Send Password Reset Email via Supabase
      await AuthenticationRepository.instance.sendPasswordResetEmail(email);

      // 4. Remove Loader
      TFullScreenLoader.stopLoading();

      // 5. Show Success Message
      TLoaders.successSnackBar(
        title: 'Email Sent',
        message: 'Email Link Sent to Reset your Password.',
      );
    } catch (e) {
      // Remove Loader
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  @override
  void onClose() {
    email.dispose();
    super.onClose();
  }
}
