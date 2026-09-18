import 'dart:async';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../common/widgets/success_screen/succes_screen.dart';
import '../../../../data/repositories/authentication/authentication_repository.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/texts.dart';
import '../../../../utils/popups/loaders.dart';

class VerifyEmailController extends GetxController {
  static VerifyEmailController get instance => Get.find();

  Timer? _timer;

  /// Send Email Verification & Set Timer for auto redirect on screen load
  @override
  void onInit() {
    super.onInit();
    setTimerForAutoRedirect();
  }

  /// Send / Resend Email Verification Link
  Future<void> sendEmailVerification() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user != null && user.email != null) {
        await AuthenticationRepository.instance.sendEmailVerification(user.email!);
        TLoaders.successSnackBar(
          title: 'Email Sent',
          message: 'Please check your inbox and verify your email.',
        );
      } else {
        TLoaders.warningSnackBar(
          title: 'No User Found',
          message: 'Please try signing up or logging in again.',
        );
      }
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  /// Timer to automatically redirect on Email Verification
  void setTimerForAutoRedirect() {
    _timer = Timer.periodic(
      const Duration(seconds: 3),
      (timer) async {
        try {
          final response = await Supabase.instance.client.auth.getUser();
          final user = response.user;
          if (user != null && user.emailConfirmedAt != null) {
            timer.cancel();
            Get.off(
              () => SuccessScreen(
                image: SImages.staticSuccessIllustration,
                title: STexts.yourAccountCreatedTitle,
                subTitle: STexts.yourAccountCreatedSubTitle,
                onPressed: () => AuthenticationRepository.instance.screenRedirect(),
              ),
            );
          }
        } catch (_) {}
      },
    );
  }

  /// Manually Check if Email Verified
  Future<void> checkEmailVerificationStatus() async {
    try {
      final response = await Supabase.instance.client.auth.getUser();
      final user = response.user;
      if (user != null && user.emailConfirmedAt != null) {
        _timer?.cancel();
        Get.off(
          () => SuccessScreen(
            image: SImages.staticSuccessIllustration,
            title: STexts.yourAccountCreatedTitle,
            subTitle: STexts.yourAccountCreatedSubTitle,
            onPressed: () => AuthenticationRepository.instance.screenRedirect(),
          ),
        );
      } else {
        TLoaders.warningSnackBar(
          title: 'Not Verified',
          message: 'Your email has not been verified yet. Please check your inbox and click the verification link.',
        );
      }
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
